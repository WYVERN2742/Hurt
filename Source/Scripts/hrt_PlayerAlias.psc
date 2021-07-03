Scriptname hrt_PlayerAlias extends ReferenceAlias

hrt_Quest Property hrtQuest  Auto

Event OnPlayerLoadGame()
	hrtQuest.maintenance()
EndEvent
