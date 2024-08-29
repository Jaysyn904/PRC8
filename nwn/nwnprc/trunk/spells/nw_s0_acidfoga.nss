//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
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
//:://///////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003

//:: This spell isn't supposed to have a saving throw.
//:: modified by Jaysyn: 2024-08-25 14:41:58


#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eSlow = EffectMovementSpeedDecrease(50);
    float fDelay = PRCGetRandomDelay(1.0, 2.2);
    int nPenetr = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level") + SPGetPenetr(oCaster);
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_FOG));
        //Spell resistance check
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
        {
            //Roll Damage
            //Enter Metamagic conditions
            int nDamage = d6(2);
            if (nMetaMagic & METAMAGIC_MAXIMIZE)
                nDamage = 12;//Damage is at max
            if (nMetaMagic & METAMAGIC_EMPOWER)
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(SPELL_ACID_FOG, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += 2;                 
			nDamage += SpellDamagePerDice(oCaster, 2);

			//slowing effect
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget,0.0f,FALSE);
			// * BK: Removed this because it reduced damage, didn't make sense nDamage = d6();
            

            //Set Damage Effect with the modified damage
            effect eDam = PRCEffectDamage(oTarget, nDamage, GetLocalInt(OBJECT_SELF, "Acid_Fog_Damage"));
            //Apply damage and visuals
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            PRCBonusDamage(oTarget);
        }
    }
    PRCSetSchool();
}

//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
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
//:://///////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
/* #include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eSlow = EffectMovementSpeedDecrease(50);
    float fDelay = PRCGetRandomDelay(1.0, 2.2);
    int nPenetr = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level") + SPGetPenetr(oCaster);
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_FOG));
        //Spell resistance check
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
        {
            //Roll Damage
            //Enter Metamagic conditions
            int nDamage = d6(2);
            if (nMetaMagic & METAMAGIC_MAXIMIZE)
                nDamage = 12;//Damage is at max
            if (nMetaMagic & METAMAGIC_EMPOWER)
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(SPELL_ACID_FOG, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += 2;                 
			nDamage += SpellDamagePerDice(oCaster, 2);
            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,oCaster)), SAVING_THROW_TYPE_ACID, oCaster, fDelay))
            {
                //slowing effect
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget,0.0f,FALSE);
                // * BK: Removed this because it reduced damage, didn't make sense nDamage = d6();
            }

            //Set Damage Effect with the modified damage
            effect eDam = PRCEffectDamage(oTarget, nDamage, GetLocalInt(OBJECT_SELF, "Acid_Fog_Damage"));
            //Apply damage and visuals
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            PRCBonusDamage(oTarget);
        }
    }
    PRCSetSchool();
} */