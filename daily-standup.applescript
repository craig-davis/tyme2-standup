#!/usr/bin/osascript

################################################################################
# Tyme2 Daily Standup
# 
# Read daily task items from Tyme2 application and print them to stdout for a
# morning report of the previous days activities. On Monday, this will scan for
# work accomplished over the weekend.
#
# This is intented to be run with `| pbcopy` so that the content is placed into
# the clipboard, but it could also be run quietly and piped to a text file.
#
# Author: Craig Davis <craig@there4.io>
# License: MIT
# Copyright: Craig Davis 2016
#
################################################################################


##########################################################################
# Variables
##########################################################################

# string Newline for formatting
set nl to "
"

# string Program output
set standup to ""

# string Name of day
set today to (weekday of (current date))

# integer Seconds since midnight
set secondsToday to (time of (current date))

# integer Timestamp of last second of yesterday
set yesterdayNight to (current date) - secondsToday

# integer Timestamp of first second of yesterday
set yesterdayMorning to yesterdayNight - (24 * 60 * 60)

##########################################################################
# Weekend Reporting
##########################################################################

# integer Timestamp of last second of Friday
set fridayNight to 0

# integer Timestamp of first seconf of Friday
set fridayMorning to 0

# Calculate the weekend timestamps if needed
if today is Monday then
	set fridayNight to (current date) - secondsToday - (48 * 60 * 60)
	set fridayMorning to fridayNight - (24 * 60 * 60)
end if

##########################################################################
# Methods
##########################################################################

##
# Fetch the tasks for a time perdiod
#
# @param integer startTime Epoch timestamp for start of period
# @param integer endTime   Epoch timestamp for end of period
# @param string  nl        Newline character for each line item
#
# @return string Tasks for time period
on FetchTasks(startTime, endTime, nl)
	tell application "Tyme2"
		GetTaskRecordIDs startDate startTime endDate endTime
		
		set standup to ""
		set fetchedRecords to fetchedTaskRecordIDs as list
		repeat with recordID in fetchedRecords
			GetRecordWithID recordID
			set tskDuration to timedDuration of lastFetchedTaskRecord
			set tskNote to note of lastFetchedTaskRecord
			
			if tskNote is not "" then
				log "- " & tskNote
				set standup to standup & "- " & tskNote & nl
			end if
		end repeat
		if standup is "" then
			log "- None"
			set standup to standup & "- None" & nl
		end if
	end tell
end FetchTasks


##########################################################################
# Application Procedural
##########################################################################

# Record Tasks from the preceeding time period
if today is Monday then
	# Fetch tasks from Friday during the day
	log "*Friday*"
	set standup to standup & "*Friday*" & nl
	set standup to standup & FetchTasks(yesterdayMorning, yesterdayNight, nl)
	
	# Fetch tasks from last second of Friday until last night
	set weekend to FetchTasks(fridayNight, yesterdayNight, nl)
	if weekend is not "" then
		log "*Weekend*"
		set standup to standup & "*Weekend*" & nl & weekend
	end if
else
	# Simple poll of yesterdays tasks
	log "*Yesterday*"
	set standup to standup & "*Yesterday*" & nl
	set standup to standup & FetchTasks(yesterdayMorning, yesterdayNight, nl)
end if

# Collect the tasks for today
log "*Today*"
set standup to standup & "*Today*" & nl

# Prompt the user for anything they want to accomplish today
set tskToday to the text returned of (display dialog "What are your goals today? (empty to exit):" default answer "")
set hasDailyTask to false
repeat while tskToday is not ""
	log "- " & tskToday
	set standup to standup & "- " & tskToday & nl
	set tskToday to the text returned of (display dialog "What are your goals today?:" default answer "")
	set hasDailyTask to true
end repeat

# Account for taking a day off today
if hasDailyTask is not true then
	log "- No tasks today"
	set standup to standup & "- No tasks today" & nl
end if

# Record any blockers
log "*Blockers*"
set standup to standup & "*Blockers*" & nl
set tskBlockers to the text returned of (display dialog "What are you blocked by?:" default answer "")

# No newlines on this end of the text
if tskBlockers is not "" then
	log "- " & tskBlockers
	set standup to standup & "- " & tskBlockers
else
	log "- None"
	set standup to standup & "- None"
end if
