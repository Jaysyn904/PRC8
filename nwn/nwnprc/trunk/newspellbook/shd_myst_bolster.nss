/*
13/02/19 by Stratovarius

Bolster

Initiate, Body and Soul 
Level/School: 4th/Transmutation 
Range: Touch 
Target: Creature touched 
Duration: 10 minutes/level or until discharged

By linking the creature touched and the Plane of Shadow, you temporarily trade some of its traits for more potent ones belonging to creatures of that shady realm.

You grant the subject 5 temporary hit points for each of its Hit Dice (maximum 75)
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        int nAmount = PRCMin(75, GetHitDice(oTarget) * 5);
        myst.eLink = EffectLinkEffects(EffectTemporaryHitpoints(nAmount), EffectVisualEffect(VFX_DUR_CHAOS_CLOAK));
               
        myst.fDur = 600.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}