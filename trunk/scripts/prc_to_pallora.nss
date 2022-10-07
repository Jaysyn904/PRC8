//::///////////////////////////////////////////////
//:: Thrall of Orcus Pallor of Death
//:: prc_to_pallorA.nss
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the enemy
    must make a will save or be struck with fear because
    of the Thrall's appearance
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 11, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eFear = EffectFrightened();
    effect eLink = EffectLinkEffects(eFear, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    int nDC = 10 + GetLevelByClass(CLASS_TYPE_ORCUS, GetAreaOfEffectCreator()) + GetAbilityModifier(ABILITY_INTELLIGENCE, GetAreaOfEffectCreator());
    int nDuration = GetLevelByClass(CLASS_TYPE_ORCUS, GetAreaOfEffectCreator());
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
        {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
