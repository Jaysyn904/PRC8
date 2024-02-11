/*
12/10/19 by Stratovarius

Quicker than the Eye

Apprentice, Night's Long Fingers 
Level/School: 1st/Transmutation 
Range: Personal 
Target: You 
Duration: 1 minutes/level

A faint layer of shadow flows like ink over your hands, staining them pitch black -- and then, in an instant, they appear normal once more.

You gain a +5 enhancement bonus on Pickpocket, Open Lock, and Disable Trap checks. This bonus increases to +10 at 5th level, and +15 at 10th level. 
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
    	int nBoost = 5;
    	if (myst.nShadowcasterLevel >= 5) nBoost += 5;
    	if (myst.nShadowcasterLevel >= 10) nBoost += 5;
        myst.eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_DISABLE_TRAP, nBoost), EffectSkillIncrease(SKILL_OPEN_LOCK, nBoost));
        myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillIncrease(SKILL_PICK_POCKET, nBoost));
        myst.eLink = EffectLinkEffects(myst.eLink, EffectVisualEffect(VFX_DUR_MARK_OF_THE_HUNTER));
               
        myst.fDur = 60.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}