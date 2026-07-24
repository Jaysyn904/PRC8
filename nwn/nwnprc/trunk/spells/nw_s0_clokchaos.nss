//:://////////////////////////////////////////////
//:: Name Cloak of Chaos
//:: FileName nw_s0_clokchaos.nss
//:://////////////////////////////////////////////
/** @file Cloak of Chaos
Abjuration [Chaotic]
Level: 	Chaos 8, Clr 8
Components: 	V, S, F
Casting Time: 	1 standard action
Range: 	20 ft.
Targets: 	One creature/level in a 20-ft.-radius 
			burst centered on you
Duration: 	1 round/level (D)
Saving Throw: 	See text
Spell Resistance: 	Yes (harmless)

A random pattern of color surrounds the subjects, 
protecting them from attacks, granting them 
resistance to spells cast by lawful creatures, and 
causing lawful creatures that strike the subjects 
to become confused. This abjuration has four effects.

First, each warded creature gains a +4 deflection 
bonus to AC and a +4 resistance bonus on saves. 
Unlike protection from law, the benefit of this 
spell applies against all attacks, not just 
against attacks by lawful creatures.

Second, each warded creature gains spell 
resistance 25 against lawful spells and spells 
cast by lawful creatures.

Third, the abjuration blocks possession and 
mental influence, just as protection from law does.

Finally, if a lawful creature succeeds on a melee 
attack against a warded creature, the offending 
attacker is confused for 1 round (Will save 
negates, as with the confusion spell, but against 
the save DC of cloak of chaos).

Focus
A tiny reliquary containing some sacred relic, 
such as a scrap of parchment from a chaotic text. 
The reliquary costs at least 500 gp.  

**/
////////////////////////////////////////////////////
// Author: Tenjac
// Date : 7.10.06
// Modified By: Jaysyn - PnP accuracy pass
////////////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_inc_skin"
#include "inc_eventhook"
#include "prc_add_spell_dc"

const string CHAOTIC_AURA_TAG 		= "PRC_CHAOTIC_AURA";
const string CHAOTIC_AURA_ONHIT		= "PRC_CHAOTIC_AURA_OH";
const string CHAOTIC_AURA_ARMOR 	= "PRC_CHAOTIC_AURA_ARMOR";
const string CHAOTIC_AURA_CASTER 	= "PRC_CHAOTIC_AURA_CASTER";

// -------------------------------------------------------------------
// Remove on-hit property from whichever item it's on
// -------------------------------------------------------------------
void RemoveOnHitPropFromItem(object oItem)
{
	itemproperty ip = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ip))
	{
		itemproperty ipNext = GetNextItemProperty(oItem);
		if(GetItemPropertyType(ip) == ITEM_PROPERTY_ONHITCASTSPELL &&
		GetItemPropertySubType(ip) == IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER)
		RemoveItemProperty(oItem, ip);
		ip = ipNext;
	}
}

void RemoveOnHitFromSkin(object oTarget)
{
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;
	
	if(DEBUG) DoDebug("Cloak of Chaos: RemoveOnHitFromSkin() running on " + GetName(oTarget));
 
    RemoveEventScript(oTarget, EVENT_ONHIT,               "nw_s0_clokchaos", TRUE, FALSE);
    RemoveEventScript(oTarget, EVENT_ONPLAYEREQUIPITEM,   "nw_s0_clokchaos", TRUE, FALSE);
    RemoveEventScript(oTarget, EVENT_ONPLAYERUNEQUIPITEM, "nw_s0_clokchaos", TRUE, FALSE);
 
    object oArmor = GetLocalObject(oTarget, CHAOTIC_AURA_ARMOR);
    if(GetIsObjectValid(oArmor))
        RemoveOnHitPropFromItem(oArmor);
 
    RemoveOnHitPropFromItem(GetPCSkin(oTarget));
 
    DeleteLocalObject(oTarget, CHAOTIC_AURA_ARMOR);
    DeleteLocalString(oTarget, CHAOTIC_AURA_ONHIT);
    DeleteLocalObject(oTarget, CHAOTIC_AURA_CASTER);
}

void DispelMonitor(object oTarget, object oCaster, int nSpellID, int nBeatsRemaining)  
{  
    // Check if spell has expired or been dispelled  
    if((--nBeatsRemaining == 0) ||  
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster))  
    {  
        if(DEBUG) DoDebug("Cloak of Chaos: Spell expired/dispelled, cleaning up");  
        RemoveOnHitFromSkin(oTarget);  
        PRCRemoveSpellEffects(nSpellID, oCaster, oTarget);  
    }  
    else  
        DelayCommand(6.0f, DispelMonitor(oTarget, oCaster, nSpellID, nBeatsRemaining));  
}

// -------------------------------------------------------------------
// Add on-hit property — armor first, fall back to skin
// -------------------------------------------------------------------
void AddOnHitToSkin(object oTarget, object oCaster)
{
	if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;
	
	if(DEBUG) DoDebug("Cloak of Chaos: AddOnHitToSkin() running on " + GetName(oTarget));

	object oSkin  = GetPCSkin(oTarget);
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);

	itemproperty ip = TagItemProperty(
		ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
		CHAOTIC_AURA_ONHIT);

	if(GetIsObjectValid(oArmor))
	{
		RemoveOnHitPropFromItem(oArmor);
		AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oArmor, 9999.0f);
		SetLocalObject(oTarget, CHAOTIC_AURA_ARMOR, oArmor);
	}
	else
	{
		RemoveOnHitPropFromItem(oSkin);
		AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oSkin);
		DeleteLocalObject(oTarget, CHAOTIC_AURA_ARMOR);
	}

	AddEventScript(oTarget, EVENT_ONHIT,                "nw_s0_clokchaos", TRUE, FALSE);
	AddEventScript(oTarget, EVENT_ONPLAYEREQUIPITEM,    "nw_s0_clokchaos", TRUE, FALSE);
	AddEventScript(oTarget, EVENT_ONPLAYERUNEQUIPITEM,  "nw_s0_clokchaos", TRUE, FALSE);
	SetLocalString(oTarget, CHAOTIC_AURA_ONHIT, "nw_s0_clokchaos");
	SetLocalObject(oTarget, CHAOTIC_AURA_CASTER, oCaster);

}

// -------------------------------------------------------------------
// Handle armor swap while spell is active
// -------------------------------------------------------------------
void OnArmorEquip(object oTarget)
{
	if(GetLocalString(oTarget, CHAOTIC_AURA_ONHIT) != "nw_s0_clokchaos") return;
	
	if(DEBUG) DoDebug("Cloak of Chaos: OnArmorEquip() running on " + GetName(oTarget));

	object oNewArmor = GetPCItemLastEquipped();
	if(GetBaseItemType(oNewArmor) != BASE_ITEM_ARMOR) return;

	object oOldArmor = GetLocalObject(oTarget, CHAOTIC_AURA_ARMOR);
	if(GetIsObjectValid(oOldArmor))
		RemoveOnHitPropFromItem(oOldArmor);
	else
		RemoveOnHitPropFromItem(GetPCSkin(oTarget));

	itemproperty ip = TagItemProperty(
		ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
		CHAOTIC_AURA_ONHIT);
	AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oNewArmor, 9999.0f);
	SetLocalObject(oTarget, CHAOTIC_AURA_ARMOR, oNewArmor);

}

void OnArmorUnequip(object oTarget)
{
    if(DEBUG) DoDebug("Cloak of Chaos: OnArmorUnequip fired for " + GetName(oTarget));
 
    if(GetLocalString(oTarget, CHAOTIC_AURA_ONHIT) != "nw_s0_clokchaos") return;
 
    object oItem = GetPCItemLastUnequipped();
    if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR) return;
 
    RemoveOnHitPropFromItem(oItem);
    DeleteLocalObject(oTarget, CHAOTIC_AURA_ARMOR);
 
    object oCaster = GetLocalObject(oTarget, CHAOTIC_AURA_CASTER);
    DelayCommand(0.1f, AddOnHitToSkin(oTarget, oCaster));
}

// -------------------------------------------------------------------
// On-hit confusion handler
// -------------------------------------------------------------------
void OnHitChaoticAura(object oTarget)
{
	object oItem = PRCGetSpellCastItem();
	object oAttacker = PRCGetSpellTargetObject();
	
	if(DEBUG) DoDebug("Cloak of Chaos: OnHitChaoticAura() running on " + GetName(oAttacker));

	if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR &&
	   GetBaseItemType(oItem) != BASE_ITEM_CREATUREITEM) return;

	if(!GetIsObjectValid(oAttacker))                       return;
	if(GetAlignmentLawChaos(oAttacker) != ALIGNMENT_LAWFUL) return;

	object oCaster = GetLocalObject(oTarget, CHAOTIC_AURA_CASTER);
	if(DEBUG) DoDebug("Cloak of Chaos: OnHitChaoticAura() oCaster is: " + GetName(oCaster));
	//int nDC = 10 + 8 + GetAbilityModifier(ABILITY_WISDOM, oCaster);
	
	//int nDC = PRCGetSpellSaveDC(SPELL_CLOAK_OF_CHAOS, SPELL_SCHOOL_ABJURATION, oCaster);
	int nDC = PRCGetSaveDC(oTarget, oCaster, SPELL_CLOAK_OF_CHAOS);
	if(DEBUG) DoDebug("Cloak of Chaos: OnHitChaoticAura() DC is: " + IntToString(nDC));
	
	float fDur = RoundsToSeconds(PRCGetCasterLevel(oCaster));

	if(!PRCMySavingThrow(SAVING_THROW_WILL, oAttacker, nDC, SAVING_THROW_TYPE_SPELL, oCaster))
	{
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectConfused()), oAttacker, fDur);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CONFUSION_S), oAttacker);
	}

}

// -------------------------------------------------------------------
// Main spell application
// -------------------------------------------------------------------
void PRCDoChaoticAura(object oTarget, float fDur, object oCaster)
{
	if(DEBUG) DoDebug("Cloak of Chaos: PRCDoChaoticAura() running on " + GetName(oTarget));
	
	effect eDur = EffectLinkEffects(
	EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
	EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));

	effect eLink = EffectLinkEffects(
		VersusAlignmentEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), ALIGNMENT_ALL, ALIGNMENT_LAWFUL),
		EffectACIncrease(4, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSpellResistanceIncrease(25), ALIGNMENT_ALL, ALIGNMENT_LAWFUL));
	eLink = EffectLinkEffects(eLink, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
	DelayCommand(0.3f, AddOnHitToSkin(oTarget, oCaster));
	DelayCommand(fDur, RemoveOnHitFromSkin(oTarget));
	
	// Start the dispel monitor - checks every 6 seconds  
	int nSpellID = PRCGetSpellId();
    DelayCommand(6.0f, DispelMonitor(oTarget, oCaster, nSpellID, FloatToInt(fDur) / 6));  
}

// -------------------------------------------------------------------
// main()
// -------------------------------------------------------------------
void main()
{
	int nEvent = GetRunningEvent();

	if(DEBUG) DoDebug("Cloak of Chaos: cast by " + GetName(OBJECT_SELF));

	switch(nEvent)
	{
		case EVENT_ONHIT:
			if(DEBUG) DoDebug("Cloak of Chaos: EVENT_ONHIT fired for " + GetName(OBJECT_SELF));
			OnHitChaoticAura(OBJECT_SELF);
			return;

		case EVENT_ONPLAYEREQUIPITEM:
			if(DEBUG) DoDebug("Cloak of Chaos: EVENT_ONPLAYEREQUIPITEM fired for " + GetName(OBJECT_SELF));
			OnArmorEquip(GetPCItemLastEquippedBy());
			return;

		case EVENT_ONPLAYERUNEQUIPITEM:
			if(DEBUG) DoDebug("Cloak of Chaos: EVENT_ONPLAYERUNEQUIPITEM fired for " + GetName(OBJECT_SELF));
			OnArmorUnequip(GetPCItemLastUnequippedBy());
			return;
			
		case EVENT_ONPLAYERREST_FINISHED:  
		if(DEBUG) DoDebug("Cloak of Chaos: EVENT_ONPLAYERREST_FINISHED fired for " + GetName(OBJECT_SELF));  
		if(GetLocalString(OBJECT_SELF, CHAOTIC_AURA_ONHIT) == "nw_s0_clokchaos")  
			RemoveOnHitFromSkin(OBJECT_SELF);  
		return;
	}

	if(!X2PreSpellCastCode()) return;

	PRCSetSchool(SPELL_SCHOOL_ABJURATION);

	object oPC     = OBJECT_SELF;
	location lLoc  = GetLocation(oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nCounter   = nCasterLvl;
	float fDur     = RoundsToSeconds(nCasterLvl);

	if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
		fDur += fDur;

	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0f), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget) && nCounter > 0)
	{
		if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && GetIsFriend(oTarget, oPC))
		{
			nCounter--;
			PRCDoChaoticAura(oTarget, fDur, oPC);
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0f), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}

	PRCSetSchool();

}


