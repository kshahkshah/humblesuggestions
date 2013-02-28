# Roadmap #

## alpha ##

### daily email ###
* write basic logic
* design email
* add contexts
* track suggested_on
* add feedback buttons from email
* user model time adjustment

### setup production server ###
* register domain name
* private beta setup

### scheduled tasks ###
* setup whenever (ruby managed cron)
* write logic for enqueuing daily queue updates
* setup job for determining if an email was opened
* add logic to the queue update to determine if an item was removed / when it was removed
* setup time adjusted delivery
* install cron jobs into production server

### scrapers ###
* instapaper scraper
* rss scraper

## suggestions ##
* integrate feedback
* split testing

## beta ##
* setup process monitoring
* setup newrelic
* connect mandrill
* admin dashboard for viewing contexts vs email statistics
* daily admin email
