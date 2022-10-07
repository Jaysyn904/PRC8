//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    object oCaster = GetAreaOfEffectCreator();
    if(!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage = d6(2);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    //Enter Metamagic conditions
    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
        nDamage = 12;//Damage is at max
    if ((nMetaMagic & METAMAGIC_EMPOWER))
        nDamage = nDamage + (nDamage/2);
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(SPELL_ACID_FOG, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += 2;         
	nDamage += SpellDamagePerDice(oCaster, 2);
    int nPenetr = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level") + SPGetPenetr(oCaster);

    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            int nDC = PRCGetSaveDC(oTarget, oCaster);
            int nDamageType = GetLocalInt(OBJECT_SELF, "Acid_Fog_Damage");
            int nSaveType = ChangedSaveType(nDamageType);
            float fDelay = PRCGetRandomDelay(0.4, 1.2);

            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nSaveType, oCaster, fDelay))
            {
                 // This script does nothing if it has Mettle else deal only 1/2 damage
                 nDamage = GetHasMettle(oTarget, SAVING_THROW_FORT) ? 0 : nDamage / 2;
            }
            //Fire cast spell at event for the affected target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_FOG));
            //Spell resistance check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Set the damage effect
                effect eDam = PRCEffectDamage(oTarget, nDamage, nDamageType);

                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                PRCBonusDamage(oTarget);
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }

    PRCSetSchool();
}
