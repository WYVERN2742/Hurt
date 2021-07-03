Scriptname hrt_MCM extends SKI_ConfigBase

hrt_Quest Property hrtQuest Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------
; 0 - Broken State
; 1 - Initial version
int Function GetVersion()
	return 1
EndFunction

; PRIVATE VARIABLES -------------------------------------------------------------------------------

bool _broken ; Something has broken. Disable the menu and display an error page.

bool _locked ; Menu locked, require it to be closed.

string _lockReason ; Lock reason

bool _changed ; If settings were modified this menu session.

; OIDs (T:Text B:Toggle S:Slider M:Menu, C:Color, K:Key)
; --- Version 1 ---
int _hI_S ; Health Intensity Slider
int _hT_S ; Health Threshold Slider
int _mI_S ; Magicka Intensity Slider
int _mT_S ; Magicka Threshold Slider
int _sI_S ; Stamina Intensity Slider
int _sT_S ; Stamina Threshold Slider

int _hE_M ; Health Effect Menu
int _mE_M ; Magicka Effect Menu
int _sE_M ; Stamina Effect Menu

int _reset_T ; Reset Settings

int _info_T ; Version and state text

; INITIALIZATION ----------------------------------------------------------------------------------

Event OnConfigInit()
	; Pages = new string[0]
	; Pages[0] = "Settings"
	integrityCheck()
EndEvent

Function integrityCheck()
	If (hrtQuest == None)
		; How on earth have we gotten into this state?
		Debug.Trace("[Hurt] Broken quest property on hrt_MCM detected. Please report this!", 2)
		Debug.Trace("[Hurt] Attempting to recover state by obtaining hrtQuest from current quest")
		hrtQuest = ((self as Quest) as hrt_Quest)
		If (hrtQuest == None)
			Debug.Trace("[Hurt] Recovery failed, disabling MCM as something catastrophic has broken", 2)
			_broken = true
			Game.DisablePlayerControls(true,true,true,true,true,true,true,true)
			Game.EnablePlayerControls()
		Else
			Debug.Trace("[Hurt] Current attached quest is now library quest. Unless something was changed, configuration should now be fixed.")
		EndIf
	EndIf

	If (CurrentVersion == 0)
		; How did we get a version of 0?
		Debug.Trace("[Hurt] The current version was detected to be 0. (Somehow)")
		Debug.Trace("[Hurt] This is normally when a SKYUI installation changes / breaks mutiple times in one save.")
		Debug.Trace("[Hurt] Uninstall Hurt and clean your save, then try again.")
		_broken = true
		return
	EndIf

	; Quest integrity failed.
	hrtQuest.integrityCheck()
	_broken = hrtQuest.BrokenInstallation
EndFunction

Event OnVersionUpdate(int a_version)
	; Version 1
EndEvent

Function disableAllControls()
	SetOptionFlags(_hI_S, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_hT_S, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_mI_S, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_mT_S, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_sI_S, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_sT_S, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_hE_M, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_mE_M, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_sE_M, OPTION_FLAG_DISABLED, false)
	SetOptionFlags(_reset_T, OPTION_FLAG_DISABLED)
EndFunction

; Immediately lock all controls on the menu with a displayed reason.
; Menu must be closed and reopened after unlockMenu() is called.
function lockMenu(string msg)
	disableAllControls()
	_locked = true
	_lockReason = msg
	SetTextOptionValue(_info_T, _lockReason)
EndFunction

; Unlock the menu, requires the menu to be reopened.
function unlockMenu()
	_locked = false
	_lockReason = ""
EndFunction

function resetSettings()
	lockMenu("$LockReset")

	; --- Version 1 ---

	hrtQuest.config.hrtHealthIntensity  = hrtQuest.config.d_hrtHealthIntensity
	hrtQuest.config.hrtHealthThreshold  = hrtQuest.config.d_hrtHealthThreshold
	hrtQuest.config.hrtMagickaIntensity = hrtQuest.config.d_hrtMagickaIntensity
	hrtQuest.config.hrtMagickaThreshold = hrtQuest.config.d_hrtMagickaThreshold
	hrtQuest.config.hrtStaminaIntensity = hrtQuest.config.d_hrtStaminaIntensity
	hrtQuest.config.hrtStaminaThreshold = hrtQuest.config.d_hrtStaminaThreshold
	hrtQuest.config.hrtHealthEffect     = hrtQuest.config.d_hrtHealthEffect
	hrtQuest.config.hrtMagickaEffect    = hrtQuest.config.d_hrtMagickaEffect
	hrtQuest.config.hrtStaminaEffect    = hrtQuest.config.d_hrtStaminaEffect

	; ---------------
	hrtQuest.refreshEffect()
	unlockMenu()
endfunction

; EVENTS ------------------------------------------------------------------------------------------
Event OnPageReset(string a_page)
	integrityCheck()
	; MCM errored?
	If (_broken)
		SetCursorFillMode(LEFT_TO_RIGHT)
		AddHeaderOption("Broken Installation")
		AddEmptyOption()
		AddTextOption("Somehow, your installation of Hurt","",OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddTextOption("has become corrupted and cannot be fixed.","",OPTION_FLAG_DISABLED)
		AddTextOption("If you can reproduce this state,","",OPTION_FLAG_DISABLED)
		AddTextOption("(We tried to fix it, but that didn't work).","",OPTION_FLAG_DISABLED)
		AddTextOption("please contact us with your papyrus logs.", "", OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddEmptyOption()
		AddTextOption("The effects will continue to work (or not)","",OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddTextOption("but the MCM is broken, and we really suggest","",OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddTextOption("a clean reinstall of this mod. ","",OPTION_FLAG_DISABLED)
		return
	EndIf

	; Page locked
	int flg = OPTION_FLAG_NONE
	If (_locked)
		flg = OPTION_FLAG_DISABLED
	EndIf

	; Useful if a custom icon is ever created
	; Load custom logo in DDS format
	; if (a_page == "")
	;   ; Image size 256x256
	;   ; X offset = 376 - (height / 2) = 258
	;   ; Y offset = 223 - (width / 2) = 95
	;   LoadCustomContent("skyui/res/mcm_logo.dds", 258, 95)
	;   return
	; else
	;   UnloadCustomContent()
	; endIf

	; If (a_page == "Settings")
	If (a_page == "") ; Display menu on root level
		SetCursorFillMode(LEFT_TO_RIGHT)

		; Health
		AddHeaderOption("$HealthOptions")
		AddHeaderOption("")
		_hI_S = AddSliderOption("$EffectIntensity", hrtQuest.config.hrtHealthIntensity * 100, "{0}%", flg)
		_hE_M = AddMenuOption("$EffectType", hrtQuest.config.hrtImagespaceNames[hrtQuest.config.hrtHealthEffect], flg)
		_hT_S = AddSliderOption("Effect Threshold", hrtQuest.config.hrtHealthThreshold * 100, "{0}%", flg)
		AddEmptyOption()

		; Magicka
		AddHeaderOption("$MagickaOptions")
		AddHeaderOption("")
		_mI_S = AddSliderOption("$EffectIntensity", hrtQuest.config.hrtMagickaIntensity * 100, "{0}%", flg)
		_mE_M = AddMenuOption("$EffectType", hrtQuest.config.hrtImagespaceNames[hrtQuest.config.hrtMagickaEffect], flg)
		_mT_S = AddSliderOption("Effect Threshold", hrtQuest.config.hrtMagickaThreshold * 100, "{0}%", flg)
		AddEmptyOption()

		; Stamina
		AddHeaderOption("$StaminaOptions")
		AddHeaderOption("")
		_sI_S = AddSliderOption("$EffectIntensity", hrtQuest.config.hrtStaminaIntensity * 100, "{0}%", flg)
		_sE_M = AddMenuOption("$EffectType", hrtQuest.config.hrtImagespaceNames[hrtQuest.config.hrtStaminaEffect], flg)
		_sT_S = AddSliderOption("Effect Threshold", hrtQuest.config.hrtStaminaThreshold * 100, "{0}%", flg)
		AddEmptyOption()


		AddHeaderOption("")
		AddHeaderOption("")

		; Reset values
		_reset_T = AddTextOption("", "$ResetSettings", flg)
		; Version and message display
		_info_T = AddTextOption("v1.0.0 - WYVERN", _lockReason, OPTION_FLAG_DISABLED)
	EndIf
EndEvent

Event OnOptionSelect(int a_option)
	If (a_option == _reset_T)
		bool accepted = ShowMessage("$ResetSettings_Confirm")
		If (accepted)
			resetSettings()
		EndIf
	EndIf
EndEvent

Event OnOptionMenuOpen(int a_option)
	If (a_option == _hE_M || a_option == _mE_M || a_option == _sE_M)
		SetMenuDialogOptions(hrtQuest.config.hrtImagespaceNames)
		If (a_option == _hE_M)
			; Health Effect Select
			SetMenuDialogDefaultIndex(hrtQuest.config.d_hrtHealthEffect)
			SetMenuDialogStartIndex(hrtQuest.config.hrtHealthEffect)
		ElseIf (a_option == _mE_M)
			; Magicka Effect Select
			SetMenuDialogDefaultIndex(hrtQuest.config.d_hrtMagickaEffect)
			SetMenuDialogStartIndex(hrtQuest.config.hrtMagickaEffect)

		ElseIf (a_option == _sE_M)
			; Stamina Effect Select
			SetMenuDialogDefaultIndex(hrtQuest.config.d_hrtStaminaEffect)
			SetMenuDialogStartIndex(hrtQuest.config.hrtStaminaEffect)
		EndIf
	EndIf
EndEvent

Event OnOptionMenuAccept(int a_option, int a_index)
	_changed = true
	If (a_option == _hE_M)
		hrtQuest.config.hrtHealthEffect = a_index
		SetMenuOptionValue(a_option, hrtQuest.config.hrtImagespaceNames[a_index])
	ElseIf (a_option == _mE_M)
		hrtQuest.config.hrtMagickaEffect = a_index
		SetMenuOptionValue(a_option, hrtQuest.config.hrtImagespaceNames[a_index])
	ElseIf (a_option == _sE_M)
		hrtQuest.config.hrtStaminaEffect = a_index
		SetMenuOptionValue(a_option, hrtQuest.config.hrtImagespaceNames[a_index])
	EndIf
EndEvent

Event OnOptionSliderOpen(int a_option)
	SetSliderDialogRange(0, 100)
	SetSliderDialogInterval(2)

	If (a_option == _hI_S)
		; Health Intensity Slider
		SetSliderDialogStartValue(hrtQuest.config.hrtHealthIntensity * 100)
		SetSliderDialogDefaultValue(hrtQuest.config.d_hrtHealthIntensity * 100)
	ElseIf (a_option == _hT_S)
		; Health Threshold Slider
		SetSliderDialogStartValue(hrtQuest.config.hrtHealthThreshold * 100)
		SetSliderDialogDefaultValue(hrtQuest.config.d_hrtHealthThreshold * 100)
	ElseIf (a_option == _mI_S)
		; Magicka Intensity Slider
		SetSliderDialogStartValue(hrtQuest.config.hrtMagickaIntensity * 100)
		SetSliderDialogDefaultValue(hrtQuest.config.d_hrtMagickaIntensity * 100)
	ElseIf (a_option == _mT_S)
		; Magicka Threshold Slider
		SetSliderDialogStartValue(hrtQuest.config.hrtMagickaThreshold * 100)
		SetSliderDialogDefaultValue(hrtQuest.config.d_hrtMagickaThreshold * 100)
	ElseIf (a_option == _sI_S)
		; Stamina Intensity Slider
		SetSliderDialogStartValue(hrtQuest.config.hrtStaminaIntensity * 100)
		SetSliderDialogDefaultValue(hrtQuest.config.d_hrtStaminaIntensity * 100)
	ElseIf (a_option == _sT_S)
		; Stamina Threshold Slider
		SetSliderDialogStartValue(hrtQuest.config.hrtStaminaThreshold * 100)
		SetSliderDialogDefaultValue(hrtQuest.config.d_hrtStaminaThreshold * 100)
	EndIf
EndEvent

Event OnOptionSliderAccept(int a_option, float a_value)
	SetSliderOptionValue(a_option, a_value, "{0}%")

	if (a_option == _hI_S)
		hrtQuest.config.hrtHealthIntensity = a_value / 100
	ElseIf (a_option == _hT_S)
		hrtQuest.config.hrtHealthThreshold = a_value / 100
	ElseIf (a_option == _mI_S)
		hrtQuest.config.hrtMagickaIntensity = a_value / 100
	ElseIf (a_option == _mT_S)
		hrtQuest.config.hrtMagickaThreshold = a_value / 100
	ElseIf (a_option == _sI_S)
		hrtQuest.config.hrtStaminaIntensity = a_value / 100
	ElseIf (a_option == _hT_S)
		hrtQuest.config.hrtStaminaThreshold = a_value / 100
	endIf
EndEvent

Event OnOptionHighlight(int a_option)
	integrityCheck()
	if (a_option == _hI_S)
		; Health Intensity Slider
		SetInfoText("$HealthIntensity_Desc")
	elseIf (a_option == _hT_S)
		; Health Threshold Slider
		SetInfoText("$HealthPercentage_Desc")
	elseif (a_option == _mI_S)
		; Magicka Intensity Slider
		SetInfoText("$MagickaIntensity_Desc")
	elseIf (a_option == _mT_S)
		; Magicka Threshold Slider
		SetInfoText("$MagickaPercentage_Desc")
	elseif (a_option == _sI_S)
		; Stamina Intensity Slider
		SetInfoText("$StaminaIntensity_Desc")
	elseIf (a_option == _sT_S)
		; Stamina Threshold Slider
		SetInfoText("$StaminaPercentage_Desc")
	ElseIf (a_option == _hE_M)
		; Health Effect Menu
		SetInfoText("$HealthEffect_Desc")
	ElseIf (a_option == _mE_M)
		; Magicka Effect Menu
		SetInfoText("$MagickaEffect_Desc")
	ElseIf (a_option == _sE_M)
		; Stamina Effect Menu
		SetInfoText("$StaminaEffect_Desc")
	ElseIf (a_option == _reset_T)
		; Reset Settings
		SetInfoText("$ResetSettings_Desc")
	endIf
EndEvent

Event OnConfigClose()
	If (_changed)
		_changed = false

		lockMenu("$LockApply")

		hrtQuest.refreshEffect()

		unlockMenu()
	EndIf
EndEvent
