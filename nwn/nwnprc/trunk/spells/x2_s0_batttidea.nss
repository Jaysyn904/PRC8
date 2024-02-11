//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTideA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs 06/06/03
//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //Declare major variables
    object oCreator = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    //Check faction of spell targets.
    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator))
    {
        int nPenetr = SPGetPenetrAOE(oCreator);
        effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
        effect eLink = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
               eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));
               eLink = EffectLinkEffects(eLink, EffectDamageDecrease(2, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_BATTLETIDE));

        //Make a SR check
        if(!PRCDoResistSpell(oCreator, oTarget, nPenetr))
        {
            //Make a Fort Save
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget, oCreator)), SAVING_THROW_TYPE_NEGATIVE))
            {
                float fDelay = PRCGetRandomDelay(0.75, 1.75);
                //Apply the VFX impact and linked effects
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE));
            }
        }
    }
    PRCSetSchool();
}