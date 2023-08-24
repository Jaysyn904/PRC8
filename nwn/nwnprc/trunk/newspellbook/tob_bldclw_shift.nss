/*
   ----------------
   Bloodclaw Master Shifting

   tob_bldclw_shift.nss
   ----------------

    3/10/08 by Stratovarius
*/ /** @file
  
    You gain two claws of 1d4 damage, and a +2 strength bonus.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "psi_inc_psifunc"

void main()
{
        // Set up some data
        object oInitiator         = OBJECT_SELF;
        effect eVis               = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
        effect eDur               = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        object oLClaw, oRClaw;
        float fDuration           = RoundsToSeconds(GetAbilityModifier(ABILITY_CONSTITUTION, oInitiator) + GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oInitiator));

        // Create the creature weapon
        oLClaw = GetPsionicCreatureWeapon(oInitiator, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_L, fDuration);
        oRClaw = GetPsionicCreatureWeapon(oInitiator, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_R, fDuration);

        // Add the base damage
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d4), oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d4), oRClaw, fDuration);
        
        // Do VFX
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eLink = EffectLinkEffects(eDur, eStr);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, fDuration, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oInitiator);
        
        //add the claws to the Natural Attack system
        string sResRef = "prc_diaclaw_0_";        

        sResRef += GetAffixForSize(PRCGetCreatureSize(oInitiator));
        
        AddNaturalPrimaryWeapon(oInitiator, sResRef, 2, TRUE);
        //Set up claws to expire at end of power
        DelayCommand(6.0f, 
            NaturalPrimaryWeaponTempCheck(oInitiator, oInitiator, MOVE_BLOODCLAW_SHIFT, FloatToInt(fDuration) / 6, sResRef));
}