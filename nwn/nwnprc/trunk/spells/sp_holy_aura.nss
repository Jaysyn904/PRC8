//:://////////////////////////////////////////////
//:: Name Holy Aura
//:: FileName sp_holy_aura.nss
//:://////////////////////////////////////////////
/** @file Holy Aura
Abjuration [Good]
Level: Clr 8, Good 8, Hlr 8
Components: V, S, F
Casting Time: 1 standard action
Range: 20 ft.
Targets: One creature/level in a 20-ft.-radius 
		 burst centered on you 
Duration: 1 round/level (D)
Saving Throw: See text
Spell Resistance: Yes (harmless)

A brilliant divine radiance surrounds the subjects,
protecting them from attacks, granting them resistance
to spells cast by evil creatures, and causing evil
creatures to become blinded when they strike the
subjects. This abjuration has four effects.

First, each warded creature gains a +4 deflection bonus
to AC and a +4 resistance bonus on saves. Unlike
protection from evil, this benefit applies against all
attacks, not just against attacks by evil creatures.

Second, each warded creature gains spell resistance 25
against evil spells and spells cast by evil creatures.

Third, the abjuration blocks possession and mental
influence, just as protection from evil does.

Finally, if an evil creature succeeds on a melee
attack against a warded creature, the offending
attacker is blinded (Fortitude save negates, as
blindness/deafness, but against holy aura’s save DC).

Focus: A tiny reliquary containing some sacred relic.
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

const string HOLY_AURA_TAG = "PRC_HOLY_AURA";
const string HOLY_AURA_ONHIT = "PRC_HOLY_AURA_OH";
const string HOLY_AURA_ARMOR = "PRC_HOLY_AURA_ARMOR";
const string HOLY_AURA_CASTER = "PRC_HOLY_AURA_CASTER";

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
	
	if(DEBUG) DoDebug("HolyAura: RemoveOnHitFromSkin() running on " + GetName(oTarget));
 
    RemoveEventScript(oTarget, EVENT_ONHIT,               "sp_holy_aura", TRUE, FALSE);
    RemoveEventScript(oTarget, EVENT_ONPLAYEREQUIPITEM,   "sp_holy_aura", TRUE, FALSE);
    RemoveEventScript(oTarget, EVENT_ONPLAYERUNEQUIPITEM, "sp_holy_aura", TRUE, FALSE);
 
    object oArmor = GetLocalObject(oTarget, HOLY_AURA_ARMOR);
    if(GetIsObjectValid(oArmor))
        RemoveOnHitPropFromItem(oArmor);
 
    RemoveOnHitPropFromItem(GetPCSkin(oTarget));
 
    DeleteLocalObject(oTarget, HOLY_AURA_ARMOR);
    DeleteLocalString(oTarget, HOLY_AURA_ONHIT);
    DeleteLocalObject(oTarget, HOLY_AURA_CASTER);
}

void DispelMonitor(object oTarget, object oCaster, int nSpellID, int nBeatsRemaining)  
{  
    // Check if spell has expired or been dispelled  
    if((--nBeatsRemaining == 0) ||  
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster))  
    {  
        if(DEBUG) DoDebug("HolyAura: Spell expired/dispelled, cleaning up");  
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
	
	if(DEBUG) DoDebug("HolyAura: AddOnHitToSkin() running on " + GetName(oTarget));

	object oSkin  = GetPCSkin(oTarget);
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);

	itemproperty ip = TagItemProperty(
		ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
		HOLY_AURA_ONHIT);

	if(GetIsObjectValid(oArmor))
	{
		RemoveOnHitPropFromItem(oArmor);
		AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oArmor, 9999.0f);
		SetLocalObject(oTarget, HOLY_AURA_ARMOR, oArmor);
	}
	else
	{
		RemoveOnHitPropFromItem(oSkin);
		AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oSkin);
		DeleteLocalObject(oTarget, HOLY_AURA_ARMOR);
	}

	AddEventScript(oTarget, EVENT_ONHIT,                "sp_holy_aura", TRUE, FALSE);
	AddEventScript(oTarget, EVENT_ONPLAYEREQUIPITEM,    "sp_holy_aura", TRUE, FALSE);
	AddEventScript(oTarget, EVENT_ONPLAYERUNEQUIPITEM,  "sp_holy_aura", TRUE, FALSE);
	SetLocalString(oTarget, HOLY_AURA_ONHIT, "sp_holy_aura");
	SetLocalObject(oTarget, HOLY_AURA_CASTER, oCaster);

}

// -------------------------------------------------------------------
// Handle armor swap while spell is active
// -------------------------------------------------------------------
void OnArmorEquip(object oTarget)
{
	if(GetLocalString(oTarget, HOLY_AURA_ONHIT) != "sp_holy_aura") return;
	
	if(DEBUG) DoDebug("HolyAura: OnArmorEquip() running on " + GetName(oTarget));

	object oNewArmor = GetPCItemLastEquipped();
	if(GetBaseItemType(oNewArmor) != BASE_ITEM_ARMOR) return;

	object oOldArmor = GetLocalObject(oTarget, HOLY_AURA_ARMOR);
	if(GetIsObjectValid(oOldArmor))
		RemoveOnHitPropFromItem(oOldArmor);
	else
		RemoveOnHitPropFromItem(GetPCSkin(oTarget));

	itemproperty ip = TagItemProperty(
		ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
		HOLY_AURA_ONHIT);
	AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oNewArmor, 9999.0f);
	SetLocalObject(oTarget, HOLY_AURA_ARMOR, oNewArmor);

}

void OnArmorUnequip(object oTarget)
{
    if(DEBUG) DoDebug("HolyAura: OnArmorUnequip fired for " + GetName(oTarget));
 
    if(GetLocalString(oTarget, HOLY_AURA_ONHIT) != "sp_holy_aura") return;
 
    object oItem = GetPCItemLastUnequipped();
    if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR) return;
 
    RemoveOnHitPropFromItem(oItem);
    DeleteLocalObject(oTarget, HOLY_AURA_ARMOR);
 
    object oCaster = GetLocalObject(oTarget, HOLY_AURA_CASTER);
    DelayCommand(0.1f, AddOnHitToSkin(oTarget, oCaster));
}

// -------------------------------------------------------------------
// On-hit blindness handler
// -------------------------------------------------------------------
void OnHitHolyAura(object oTarget)
{
	object oItem = PRCGetSpellCastItem();
	object oAttacker = PRCGetSpellTargetObject();
	
	if(DEBUG) DoDebug("HolyAura: OnHitHolyAura() running on " + GetName(oAttacker));

	if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR &&
	   GetBaseItemType(oItem) != BASE_ITEM_CREATUREITEM) return;

	if(!GetIsObjectValid(oAttacker))                       return;
	if(GetAlignmentGoodEvil(oAttacker) != ALIGNMENT_EVIL) return;

	object oCaster = GetLocalObject(oTarget, HOLY_AURA_CASTER);
	int nDC = 10 + 8 + GetAbilityModifier(ABILITY_WISDOM, oCaster);

	if(!PRCMySavingThrow(SAVING_THROW_FORT, oAttacker, nDC,
			SAVING_THROW_TYPE_SPELL, oCaster))
	{
		ApplyEffectToObject(DURATION_TYPE_PERMANENT,
			SupernaturalEffect(EffectBlindness()), oAttacker);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,
			EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oAttacker);
	}

}

// -------------------------------------------------------------------
// Main spell application
// -------------------------------------------------------------------
void PRCDoHolyAura(object oTarget, float fDur, object oCaster)
{
	if(DEBUG) DoDebug("HolyAura: PRCDoHolyAura() running on " + GetName(oTarget));
	
	effect eDur = EffectLinkEffects(
	EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
	EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));

	effect eLink = EffectLinkEffects(
		VersusAlignmentEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), ALIGNMENT_ALL, ALIGNMENT_EVIL),
		EffectACIncrease(4, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSpellResistanceIncrease(25), ALIGNMENT_ALL, ALIGNMENT_EVIL));
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

	if(DEBUG) DoDebug("HolyAura: cast by " + GetName(OBJECT_SELF));

	switch(nEvent)
	{
		case EVENT_ONHIT:
			if(DEBUG) DoDebug("HolyAura: EVENT_ONHIT fired for " + GetName(OBJECT_SELF));
			OnHitHolyAura(OBJECT_SELF);
			return;

		case EVENT_ONPLAYEREQUIPITEM:
			if(DEBUG) DoDebug("HolyAura: EVENT_ONPLAYEREQUIPITEM fired for " + GetName(OBJECT_SELF));
			OnArmorEquip(GetPCItemLastEquippedBy());
			return;

		case EVENT_ONPLAYERUNEQUIPITEM:
			if(DEBUG) DoDebug("HolyAura: EVENT_ONPLAYERUNEQUIPITEM fired for " + GetName(OBJECT_SELF));
			OnArmorUnequip(GetPCItemLastUnequippedBy());
			return;
			
		case EVENT_ONPLAYERREST_FINISHED:  
		if(DEBUG) DoDebug("HolyAura: EVENT_ONPLAYERREST_FINISHED fired for " + GetName(OBJECT_SELF));  
		if(GetLocalString(OBJECT_SELF, HOLY_AURA_ONHIT) == "sp_holy_aura")  
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
			PRCDoHolyAura(oTarget, fDur, oPC);
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0f), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}

	PRCSetSchool();

}

/* void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetLocation(oPC);
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0f), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nCounter = nCasterLvl;
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = RoundsToSeconds(nCasterLvl);
	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
	eDur = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eDur);
	
	if(nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	effect eLink = EffectLinkEffects(VersusAlignmentEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), ALIGNMENT_ALL, ALIGNMENT_EVIL), EffectACIncrease(4, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSpellResistanceIncrease(25), ALIGNMENT_ALL, ALIGNMENT_EVIL));
	eLink = EffectLinkEffects(eLink, eDur);
	
	while(GetIsObjectValid(oTarget) && nCounter > 0)
	{
		if(GetIsFriend(oTarget, oPC))
		{
			nCounter--;
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0f), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	PRCSetSchool();
}
	 */
	
	
	
	