#!/usr/bin/osascript

# Number of seconds since midnight
set today to (weekday of (current date))
set secondsToday to (time of (current date))
set yesterdayNight to (current date) - secondsToday
set yesterdayMorning to yesterdayNight - (24 * 60 * 60)
set nl to "
"
set standup to ""

if today is Monday then
	log "*Friday*"
	set standup to standup & "*Friday*" & nl
	set fridayNight to (current date) - secondsToday - (48 * 60 * 60)
	set fridayMorning to fridayNight - (24 * 60 * 60)
	set standup to standup & FetchTasks(yesterdayMorning, yesterdayNight, nl)
	
	log "*Weekend*"
	set weekend to FetchTasks(fridayNight, yesterdayNight, nl)
	if weekend is not "" then
		set standup to standup & "*Weekend*" & nl & weekend
	end if
else
	log "*Yesterday*"
	set standup to standup & FetchTasks(yesterdayMorning, yesterdayNight, nl)
end if

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
	end tell
end FetchTasks

log "*Today*"
set standup to standup & "*Today*" & nl

set tskToday to the text returned of (display dialog "What are your goals today? (empty to exit):" default answer "")
set hasDailyTask to false
repeat while tskToday is not ""
	log "- " & tskToday
	set standup to standup & "- " & tskToday & nl
	set tskToday to the text returned of (display dialog "What are your goals today?:" default answer "")
	set hasDailyTask to true
end repeat

if hasDailyTask is not true then
	log "- No tasks today"
	set standup to standup & "- Not tasks today" & nl
end if

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

