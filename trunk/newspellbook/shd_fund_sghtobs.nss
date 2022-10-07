/*
21/02/19 by Stratovarius

Sight Obscured

Fundamental 
Level/School: 0/Illusion (Glamer) 
Range: Touch 
Target: Creature touched 
Duration: 1 round/level

You cloak the subject and her movements in subtly shifting shadow.

This mystery grants a +5 circumstance bonus on Hide and Pick Pocket checks.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23669);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, 5), EffectVisualEffect(VFX_DUR_AURA_CHAOS));
        myst.eLink = SupernaturalEffect(EffectLinkEffects(myst.eLink, EffectSkillIncrease(SKILL_PICK_POCKET, 5)));
               
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}