/*
13/02/19 by Stratovarius

Dancing Shadows

Apprentice, Shutters and Clouds 
Level/School: 3rd/Illusion (Glamer) 
Range: Touch 
Target: One creature
Duration: 1 round/level 

You draw the shadows around yourself or another subject, where they waver and shift, partially obscuring form.

You grant the subject gains total concealment. 
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
        myst.eLink = EffectLinkEffects(EffectConcealment(50), EffectVisualEffect(VFX_DUR_SHADOWS_ANTILIGHT));
               
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}