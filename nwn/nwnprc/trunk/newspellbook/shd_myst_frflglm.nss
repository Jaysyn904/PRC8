/*
12/10/19 by Stratovarius

Fearful Gloom

Initiate, Darkened Alleys
Level/School: 4th/Necromancy [Darkness, Fear, Mind-Affecting]
Range: Close (25 ft. + 5 ft./2 levels)
Area: 30-ft.-radius emanation
Duration: 1 round/level
Saving Throw: Will partial; see text
Spell Resistance: Yes

Plumes of blackness swiftly fill the air like a viscous fog. The shifting of shadow and mists just barely suggests the presence of screaming faces and indescribable horrors lurking in the dark.

The area of fearful gloom is filled with shadowy illumination, as per darkness. All creatures within the area, or who enter it, must attempt a Will save or become frightened; on a successful 
save, they are shaken instead. If the creature has fewer than 5 HD, it is frightened. Creatures within the area must repeat the save each round until they either fail or leave the area. Once a 
creature has left the fearful gloom, the effects last an additional 2d6 rounds. 
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