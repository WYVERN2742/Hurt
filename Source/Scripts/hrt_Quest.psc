Scriptname hrt_Quest extends Quest
{Management and configuration quest for Hurt effects}

SPELL Property hrtSpell Auto
{Hurt Spell}

MagicEffect Property hrtMgef Auto
{Hurt Magic Effects}

hrt_Config Property config Auto
{Configuration}

hrt_MCM Property mcm Auto
{MCM}

bool Property BrokenInstallation Auto Hidden

bool _refreshing = false
bool _removing = false

; ------------------------------------------------------------------------------

Event OnInit()
	maintenance()
EndEvent

; Run mod maintenance
Function maintenance()
	If (BrokenInstallation == true)
		Debug.Trace("[Hurt] Installation is marked as broken. Notify user for reinstall.")
		Debug.MessageBox("Your Hurt installation is broken. Effects may work, but the MCM has been disabled. Please remove the mod and clean your save before reinstalling.")
		return
	EndIf
	OnUpdate()
	If (mcm == None)
		Debug.Trace("[Hurt] MCM not installed! Defaulting to pre-set values")
	EndIf
EndFunction

Function integrityCheck()
	; Unlike the mcm check in onUpdate(), integrityCheck() is only called by the MCM menu.
	; This means, that a mcm exists and works, so we try to get the reference back.
	If (config == None || mcm == None)
		; Main state has no config (how??), or has no mcm
		Debug.Trace("[Hurt] Broken quest property on hrt_Quest detected. Please report this!",2)
		Debug.Trace("[Hurt] Attempting to recover state by obtaining mcm and config from current quest")
		mcm = ((self as Quest) as hrt_MCM)
		config = ((self as Quest) as hrt_Config)
		If (mcm == None || config == None)
			Debug.Trace("[Hurt] Recovery failed, marking installation as broken and forcing the player out of any open menus.", 2)
			BrokenInstallation = true
			Game.DisablePlayerControls(true,true,true,true,true,true,true,true)
			Game.EnablePlayerControls()
		Else
			Debug.Trace("[Hurt] Reattached config and mcm quests. Hopefully installation is now fixed.")
		EndIf
	EndIf
EndFunction

Function ResetQuest()
	; Quickly try to disable all of the current effects
	removeEffects()
	Reset()
EndFunction

Event OnUpdate()
	Debug.Trace("[Hurt] Adding Effect to player")

	Game.GetPlayer().AddSpell(hrtSpell, false)
EndEvent

; Refresh Hurt effects on the player. Note: Can only remove effects present
; in config.hrtImagespaces. If previous effects were removed from this list,
; they will not be removed.
Function refreshEffect()
	; Papyrus can stop executing functions midway, and allow other threads to
	; start executing the same function before a previous instance finishes.
	; This causes concurrency issues. We solve this by using a variable for
	; signalling.
	If (_refreshing)
		; If already refreshing effects, cancel.
		return
	EndIf
	_refreshing = true

	RemoveEffects()
	Utility.Wait(0.1)
	OnUpdate()

	; Allow refreshing.
	_refreshing = false
EndFunction


; Remove Hurt effects on the player. Note: Can only remove effects present
; in config.hrtImagespaces. If previous effects were removed from this list,
; they will not be removed.
Function removeEffects()
	; Papyrus can stop executing functions midway, and allow other threads to
	; start executing the same function before a previous instance finishes.
	; This causes concurrency issues. We solve this by using a variable for
	; signalling.
	If (_removing)
		; If already removing effects, cancel.
		return
	EndIf
	_removing = true

	; Remove effect spell from player.
	Debug.Trace("[Hurt] Removing Effects from player")
	Game.GetPlayer().RemoveSpell(hrtSpell)

	Utility.Wait(0.1)

	; Remove all effects from player.
	int index = 0
	While (index < config.hrtImagespaces.Length)
		ImageSpaceModifier item = config.hrtImagespaces[index]
		item.Remove()
		index += 1
	EndWhile


	; Allow refreshing.
	_removing = false
EndFunction
