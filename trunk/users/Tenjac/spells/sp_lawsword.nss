//:://////////////////////////////////////////////
//:: Name     Lawful Sword
//:: FileName   sp_lawsword.nss
//:://////////////////////////////////////////////
/** @file
Evocation
Level: Paladin 4,
Components: V, S,
Casting Time: 1 standard action
Range: Touch
Target: Weapon touched
Duration: 1 round/level
Saving Throw: None
Spell Resistance: No

Calling to mind thoughts of justice, you run your 
fingers along the weapon, imbuing it with power.

This spell functions like holy sword (PH 242), except
as follows. The weapon functions as a +5 axiomatic 
weapon (+5 enhancement bonus on attack rolls and damage
rolls, lawful-aligned, deals an extra 2d6 points of damage
against chaotic opponents). It also emits a magic circle
against chaos effect (as the spell).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 2/2/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        //+2d6 vs chaotic
        itemproperty iDam = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEBONUS_2d6);
        //+5 vs everything
        itemproperty iAttack = ItemPropertyEnhancementBonus(5);
        
        if(GetObjectType(oTarget)) == OBJECT_TYPE_CREATURE
        {
        	oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        }
        
        IPSafeAddItemProperty(oTarget, iDam, fDur);
        IPSafeAddItemProperty(oTarget, iAttack, fDur);
        
        //magic circle on the weapon
        effect eCircle = EffectAreaOfEffect(AOE_MOB_CIRCCHAOS);
        effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCircle, oTarget, fDur);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        
        PRCSetSchool();
}