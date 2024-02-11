/*
13/02/19 by Stratovarius

Sight Eclipsed

Apprentice, Cloak of Shadows 
Level/School: 2nd/Illusion (Glamer) 
Range: Personal 
Target: You 
Duration: 1 round/level

You cloak yourself in shadow and shift the light that would reveal you into the Plane of Shadow.

While this mystery is in effect, you gain Hide in Plain Sight
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
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        object oSkin = GetPCSkin(oShadow);
        // Duration Effects
        //AddSkinFeat(FEAT_HIDE_IN_PLAIN_SIGHT, IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT, oSkin, oShadow, myst.fDur);
        
        itemproperty ipHIPS = ItemPropertyBonusFeat(IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT);
        ActionDoCommand(AddItemProperty(DURATION_TYPE_TEMPORARY, ipHIPS, oSkin, myst.fDur));        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(PSI_DUR_SHADOW_BODY), oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}