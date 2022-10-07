/*
12/10/19 by Stratovarius

Sickening Shadow

Initiate, Darkened Alleys
Level/School: 5th/Necromancy [Darkness]
Range: Close (25 ft. + 5 ft./2 levels)
Area: 30-ft.-radius emanation
Duration: 1 round/level
Saving Throw: Fortitude partial; see text
Spell Resistance: Yes

An oily black smoke rolls out of nowhere, obscuring sight and sound. It leaves a distasteful residue on everything within, and the scent is one of open sewers and putrefied flesh.

The area of sickening shadow is filled with shadowy illumination, as per darkness. All creatures within the area, or those who enter it, must attempt a Fortitude save or be nauseated. 
Those who succeed are merely sickened. Creatures within the area must repeat the save each round until they either fail or leave the area. Once a creature has left the sickening shadow, 
the sickened effect lasts for 2d6 rounds. Nausea lasts for 1d4 rounds and is then followed by an additional 2d6 rounds of being sickened. 
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
        myst.fDur = 6.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;   
        
        effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);

        // Do impact VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_DUSK_AND_DAWN);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        myst.nSaveDC = GetShadowcasterDC(oShadow);
        SetLocalMystery(oShadow, MYST_HOLD_MYST, myst);            
    }
}