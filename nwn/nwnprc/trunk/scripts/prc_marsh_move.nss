
#include "prc_alterations"

#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    object oTarget;
    effect eHaste = EffectHaste();
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);
    float fDelay;
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = 1;
    int nCount;
    location lSpell = GetSpellTargetLocation();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetSpellTargetLocation());

    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());

    while(GetIsObjectValid(oTarget))
    {
        if(GetIsFriend(oTarget))
        {
            fDelay = PRCGetRandomDelay(0.0, 1.0);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HASTE, FALSE));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1),TRUE,-1));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            nCount++;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    }
}


