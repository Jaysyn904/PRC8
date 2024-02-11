/*
18/02/19 by Stratovarius

Truth Revealed

Master, Eyes of the Night Sky 
Level/School: 7th/Divination 
Range: Personal 
Target: You 
Duration: 1 minute/level

By focusing on the spiritual shadow of the world, you can see hidden truths.

This mystery functions like the spell true seeing.
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
        myst.fDur = 60.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        
        myst.eLink    = EffectLinkEffects(myst.eLink, EffectVisualEffect(PSI_DUR_SYNESTHETE));
        myst.eLink    = EffectLinkEffects(myst.eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eTrueSee = EffectTrueSeeing();        
        
        // Adjust to PnP-like True Seeing
        if(GetPRCSwitch(PRC_PNP_TRUESEEING))
        {
            eTrueSee  = EffectSeeInvisible();
            int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
            // Default to 15
            if(nSpot == 0)
                nSpot = 15;
            effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
            eTrueSee     = EffectLinkEffects(eTrueSee , eSpot);
        }

        // Finish the effect link
        myst.eLink = EffectLinkEffects(myst.eLink, eTrueSee);        
        
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}