system = require 'system'
casper = require('casper').create()

BASE_URL = 'http://www.shakespeareinthepark.org/'
PAGE_VTIX = 'vtix'
TICKET_END_HOUR = 13
SHOW_BEGIN_DAY = new Date(2012, 5, 17) # the day this script was born :-)
SHOW_END_DAY = new Date(2012, 7, 25)
NO_SHOW_DAYS = [ '6/18', '6/19', '6/24', '7/1-7/22', '7/26', '8/4', '8/12', '8/16' ]

inRange = (date, from, to) ->
  mm = date.getMonth() + 1
  dd = date.getDate()
  fromMM = parseInt(from.split('/')[0])
  fromDD = parseInt(from.split('/')[1])
  toMM = parseInt(to.split('/')[0])
  toDD = parseInt(to.split('/')[1])

  return (mm >= fromMM and mm <= toMM and dd >= fromDD and dd <= toDD)

noShowToday = ->
  today = new Date
  for drng in NO_SHOW_DAYS
    range = drng.split('-')
    start = range[0]
    end = if range.length is 2 then range[1] else range[0]
    return true if inRange today, start, end

  return (today < SHOW_BEGIN_DAY or today > SHOW_END_DAY)

tooLate = ->
  now = new Date
  return (now.getHours() >= TICKET_END_HOUR)

fillForm = (fn, ad) ->
  $('#VtixFormStep1_FullName').val fn
  $('#VtixFormStep1_StreetAddress').val ad
  $('#VtixFormStep1_SeatingPref').empty().append('<option value="1">General</option>').val '1'
#  $('form').submit()

incorrectArgs = ->
  return !(casper.cli.has('user') && casper.cli.has('password') && casper.cli.has('fullname') && casper.cli.has('address'))

casper.start BASE_URL + PAGE_VTIX, ->
  if incorrectArgs()
    @echo 'Usage: casperjs <script> --user=<username> --password=<password> --fullname=<fullname> --address=<address>'
    phantom.exit()

  if noShowToday()
    @echo 'There is no show for today'
    phantom.exit()

  if tooLate()
    @echo 'It is too late to enter today\'s drawing. The deadline was 1pm'
    phantom.exit()

  @echo casper.cli.get('user')
  @echo casper.cli.get('password')
  @fill 'form', { 'LoginForm.Username': casper.cli.get('user'), 'LoginForm.Password': casper.cli.get('password') }, true

casper.then ->
  @evaluate fillForm, {fn: casper.cli.get('fullname'), ad: casper.cli.get('address')}

casper.then ->
  @evaluate ->
    $('#VtixFormStep2_Agree').prop('checked', true)
    $('form').submit()

casper.then ->
  @echo 'Successfully registered'

casper.run -> casper.exit()
