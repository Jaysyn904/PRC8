/*
     Warlock Fiendish Resilience
     Fast Healing x for 2 minutes(5 minutes if epic)
*/

#include "prc_inc_spells"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    // Ugly hack to tell PreInvocationCastCode() that we are casting as warlock
    SetLocalInt(OBJECT_SELF, PRC_INVOKING_CLASS, CLASS_TYPE_WARLOCK + 1);
    DelayCommand(0.0f, DeleteLocalInt(OBJECT_SELF, PRC_INVOKING_CLASS));

    if(!PreInvocationCastCode()) return;

    //Declare major variables
    int nDuration = 2;
    int nWarlock = GetLevelByClass(CLASS_TYPE_WARLOCK);

    int nLevel;
    if(nWarlock > 37) nLevel = 7;
    else if(nWarlock > 27) nLevel = 6;
    else if(nWarlock > 32) nLevel = 5;
    else if(nWarlock > 22) nLevel = 4;
    else if(nWarlock > 17) nLevel = 3;
    else if(nWarlock > 12) nLevel = 2;
    else if(nWarlock > 7)  nLevel = 1;

    nLevel += (GetLevelByClass(CLASS_TYPE_ELDRITCH_THEURGE) + 5) / 7;

    int nHealAmt;
    switch(nLevel)
    {
        case 1: nHealAmt = 1; break;
        case 2: nHealAmt = 2; break;
        case 3: nHealAmt = 5; break;
        case 4: nHealAmt = 7; break;
        case 5: nHealAmt = 9; break;
        case 6: nHealAmt = 12; break;
        case 7: nHealAmt = 15; break;
    }

    //check for the epic feats
    if(GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_I))
    {
        nHealAmt = 25;
        nDuration = 5;
        int nFeatAmt = 0;
        int bDone = FALSE;
        while(!bDone)
        {
            if(nFeatAmt >= 9)
                bDone = TRUE;
            else if(GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_II + nFeatAmt))
                nFeatAmt++;
            else
                bDone = TRUE;
        }
        nHealAmt += 5 * nFeatAmt;
    }

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eFastHeal = EffectRegenerate(nHealAmt, RoundsToSeconds(1));
    effect eLink = EffectLinkEffects(eFastHeal, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, INVOKE_FIENDISH_RESILIENCE, FALSE));

    //Apply the VFX impact and effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_NATURE), OBJECT_SELF);
}
