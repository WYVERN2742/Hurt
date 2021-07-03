scriptname hrt_SpellEffect extends ActiveMagicEffect
{Hurt effect spell}

hrt_Quest Property hrtQuest Auto
{Management and configuration quest for Hurt effects}

function OnEffectEnd()
	; Remove effects
	int index = 0
	While (index < hrtQuest.config.hrtImagespaces.Length)
		ImageSpaceModifier item = hrtQuest.config.hrtImagespaces[index]
		item.Remove()
		index += 1
	EndWhile
endFunction

function OnEffectStart(actor Target, actor Caster)
	OnUpdate()
endFunction

; Set imagespace modifier
function setMad(Float attributeValue, Float threshold, Float intensity, imagespacemodifier imad)
	If (attributeValue > threshold)
		imad.PopTo(imad, 0)
		return
	EndIf

	; Swap to same imagespace modifier with new attribute
	imad.PopTo(imad, (threshold - attributeValue) / threshold * intensity)
endFunction

function OnUpdate()
	; Update screenspace effects
	; Effect 0 is no effect
	If (hrtQuest.config.hrtHealthEffect != 0)
		setMad(GetTargetActor().GetActorValuePercentage("Health"),  hrtQuest.config.hrtHealthThreshold,  hrtQuest.config.hrtHealthIntensity,  hrtQuest.config.hrtImagespaces[hrtQuest.config.hrtHealthEffect ])
	EndIf
	If (hrtQuest.config.hrtMagickaEffect != 0)
		setMad(GetTargetActor().GetActorValuePercentage("Magicka"), hrtQuest.config.hrtMagickaThreshold, hrtQuest.config.hrtMagickaIntensity, hrtQuest.config.hrtImagespaces[hrtQuest.config.hrtMagickaEffect])
	EndIf
	If (hrtQuest.config.hrtStaminaEffect != 0)
		setMad(GetTargetActor().GetActorValuePercentage("Stamina"), hrtQuest.config.hrtStaminaThreshold, hrtQuest.config.hrtStaminaIntensity, hrtQuest.config.hrtImagespaces[hrtQuest.config.hrtStaminaEffect])
	EndIf
	RegisterForSingleUpdate(0.25)
endFunction
