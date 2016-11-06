#!/usr/bin/osascript

# Number of seconds since midnight
set today to (weekday of (current date))
set secondsToday to (time of (current date))
set yesterdayNight to (current date) - secondsToday
set yesterdayMorning to yesterdayNight - (24 * 60 * 60)
set standup to ""

if today is Monday then
	log "Handling Monday by including weekend work"
	set yesterdayNight to (current date) - secondsToday - (48 * 60 * 60)
	set yesterdayMorning to yesterdayNight - (24 * 60 * 60)
end if

log "*Yesterday*"
set standup to standup & "*Yesterday*
"
tell application "Tyme2"
	GetTaskRecordIDs startDate yesterdayMorning endDate yesterdayNight
	
	set fetchedRecords to fetchedTaskRecordIDs as list
	repeat with recordID in fetchedRecords
		GetRecordWithID recordID
		set tskDuration to timedDuration of lastFetchedTaskRecord
		set tskNote to note of lastFetchedTaskRecord
		
		if tskNote is not "" then
			log "- " & tskNote
			set standup to standup & "- " & tskNote & "
"
		end if
	end repeat
end tell


log "*Today*"
set standup to standup & "*Today*

"

set tskToday to the text returned of (display dialog "What are your goals today? (empty to exit):" default answer "")
set hasDailyTask to false
repeat while tskToday is not ""
	log "- " & tskToday
	set standup to standup & "- " & tskToday & "
"
	set tskToday to the text returned of (display dialog "What are your goals today?:" default answer "")
	set hasDailyTask to true
end repeat

if hasDailyTask is not true then
	log "- No tasks today"
	set standup to standup & "- Not tasks today
"
end if

log "*Blockers*"
set standup to standup & "*Blockers*
"
set tskBlockers to the text returned of (display dialog "What are you blocked by?:" default answer "")

# No newlines on this end of the text
if tskBlockers is not "" then
	log "- " & tskBlockers
	set standup to standup & "- " & tskBlockers
else
	log "- None"
	set standup to standup & "- None"
end if

