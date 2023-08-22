//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an area of effect that will cover the
    creature with a stone shell holding them in
    place.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: May 04, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"



#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail.
    //--------------------------------------------------------------------------
    if(!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nPenetr = SPGetPenetrAOE(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nRounds, nDC;
    float fDelay;
    effect eHold = EffectLinkEffects(EffectParalyze(), EffectVisualEffect(VFX_DUR_STONEHOLD));
    effect eFind;

    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STONEHOLD));
            if(!GetHasSpellEffect(SPELL_STONEHOLD, oTarget))
            {
                if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
                {
                    nDC = PRCGetSaveDC(oTarget, oCaster);
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                       nRounds = PRCMaximizeOrEmpower(6, 1, nMetaMagic);
                       fDelay = PRCGetRandomDelay(0.75, 1.75);
                       DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, RoundsToSeconds(nRounds),FALSE));
                    }
                    else
                    {
                        eFind = GetFirstEffect(oTarget);
                        int bDone = FALSE ;
                        while(GetIsEffectValid(eFind) && !bDone)
                        {
                            if(GetEffectCreator(eFind) == oCaster
                            && GetEffectSpellId(eFind) == SPELL_STONEHOLD)
                            {
                                RemoveEffect(oTarget, eFind);
                                bDone = TRUE;
                            }
                            eFind = GetNextEffect(oTarget);
                        }
                    }
                }
            }
        }
        oTarget = GetNextInPersistentObject();
    }
    PRCSetSchool();
}