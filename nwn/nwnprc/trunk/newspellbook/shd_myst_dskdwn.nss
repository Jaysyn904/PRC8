/*
12/02/19 by Stratovarius

Dusk and Dawn

Apprentice, Shutters and Clouds 
Level/School: 1st/Evocation 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 20-ft.-radius emanation centered on a point in space 
Duration: 10 minutes/level (D) 
Saving Throw: None 
Spell Resistance: No

By drawing shade from the Plane of Shadow, or banishing the shadows back to it, you control the level of illumination in the area.

You make a dark area lighter or a light area darker, blanketing the affected area in shadowy illumination. Creatures with darkvision can see through this area normally.
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
        location lTarget = PRCGetSpellTargetLocation();
        myst.fDur = 600.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;   
        
        if (myst.nMystId == MYST_DUSK_AND_DAWN_DAWN)
        {
            // Create AoE
            myst.eLink = EffectAreaOfEffect(VFX_MOB_DAYLIGHT);
            if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);            
        }
        else
        {
            effect eImpact   = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);

            // Do impact VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

            // Create AoE
            myst.eLink = EffectAreaOfEffect(AOE_PER_DUSK_AND_DAWN);
            if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
       		myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        	myst.nSaveDC = GetShadowcasterDC(oShadow);
        	SetLocalMystery(oShadow, MYST_HOLD_MYST+"6", myst);            
        }    
    }
}