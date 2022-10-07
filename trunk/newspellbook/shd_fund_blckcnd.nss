/*
21/02/19 by Stratovarius

Black Candle

Fundamental 
Level/School: 1st/Evocation [Light or Darkness] 
Range: Touch 
Target: Object touched 
Duration: 1 round/level
Saving Throw: None 
Spell Resistance: No

You draw on extraplanar shadow or banish existing shadows to let in the light.

This mystery functions like the spell light or the spell darkness. Only one of these two effects is possible per use, and you must decide which effect is desired when casting.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23666);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        location lTarget = PRCGetSpellTargetLocation();
        myst.fDur = 6.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;   
        
        if (myst.nMystId == FUND_BLACK_CANDLE_LIGHT)
        {
            // Create AoE
            myst.eLink = SupernaturalEffect(EffectAreaOfEffect(VFX_MOB_DAYLIGHT));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur);            
        }
        else
        {
            // Create AoE
            myst.eLink = SupernaturalEffect(EffectAreaOfEffect(AOE_PER_DUSK_AND_DAWN));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur);  
        }    
    }
}