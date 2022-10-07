//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an area of effect that will cover the
    creature with a stone shell holding them in
    place.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: August  2003
//:: Updated   : October 2003
//:://////////////////////////////////////////////
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STONEHOLD));

        int nPenetr = SPGetPenetrAOE(oCaster);
        //Make a SR check
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            int nDC = PRCGetSaveDC(oTarget, oCaster);
            //Make a Fort Save
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                int nMetaMagic = PRCGetMetaMagicFeat();
                int nRounds = PRCMaximizeOrEmpower(6, 1, nMetaMagic);
                float fDelay = PRCGetRandomDelay(0.45, 1.85);

                effect eLink = EffectLinkEffects(EffectParalyze(), EffectVisualEffect(VFX_DUR_STONEHOLD));

                //Apply the VFX impact and linked effects
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds),FALSE));
            }
        }
    }
    PRCSetSchool();
}