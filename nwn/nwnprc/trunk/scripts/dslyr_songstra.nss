#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nStr = GetHasFeat(FEAT_EPIC_DRAGONSONG_STRENGTH,GetAreaOfEffectCreator()) ? 6: 4;
    int nCon = GetHasFeat(FEAT_EPIC_DRAGONSONG_STRENGTH,GetAreaOfEffectCreator()) ? 4: 0;
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nStr);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,nCon);
    effect eLink = EffectLinkEffects(eStr, eDur);
           eLink = EffectLinkEffects(eLink, eCon);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
           eLink = EffectLinkEffects(eLink, eVis2);
     if(GetIsReactionTypeFriendly(oTarget,GetAreaOfEffectCreator())|| GetFactionEqual(oTarget,GetAreaOfEffectCreator()) )
     {
        if (!PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget)) // deaf targets can't hear the song.
        {
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_BULLS_STRENGTH, FALSE));
           SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0,FALSE);
           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
     }


}
