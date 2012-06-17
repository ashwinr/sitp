# Automated virtual ticketing for Shakespeare in the Park
# Description
[Shakespeare in the Park](http://www.shakespeareinthepark.org/) is an annual New York tradition. Tickets are always free, however, notoriously tedious to obtain. There is also an online lottery where winners are selected on the afternoon of the show. This is an attempt to automate the lottery registration process.
# Installation
* Download and install [phantomjs](http://phantomjs.org) and [casperjs](http://casperjs.org/), in that order
* Save sitp.coffee locally somewhere
* Create an [account](https://www.shakespeareinthepark.org/signin) if you haven't done so already
* Run `casperjs sitp.coffee --user=<username> --password=<password> --fullname=<your full name> --address=<residential address>`

# Notes
* sitp.coffee is smart -- it'll return immediately on no-show days or if it's too late to enter the lottery (so you easily schedule it to run daily and it'll register you for that day's drawing if there is one).
* The **General** seating category is always selected. Modify the script if you prefer a different seating category.
* Lastly, please refrain from creating more than one account for yourself. Give everyone a chance :)
