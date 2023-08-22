/*
13/03/19 by Stratovarius

Deadly Shade

Initiate, Darkened Alleys
Level/School: 6th/Necromancy [Darkness]
Range: Close (25 ft. + 5 ft./2 levels)
Area: 30-ft.-radius emanation
Duration: 1 round/level
Saving Throw: Fortitude negates; see text
Spell Resistance: Yes

Tendrils of darkness flow from the ground like smoke, filling the area with writhing, shifting darkness. A cold draft washes over your soul even as the tendrils rise.

The area of deadly shade is filled with shadowy illumination, as per darkness (PH 216). In addition, each time you invoke this mystery, decide if you wish the spell to deal or absorb damage.

If you choose to deal damage, anyone within the area who suffers hit point damage from any source must make a Fortitude save. Failure indicates that the subject gains a negative level. Success prevents the negative level, but if the individual is damaged again within the area, he must attempt a new save. These negative levels fade in 1 hour per caster level, and they never cause permanent level loss.

If you choose instead to have the deadly shade absorb damage, all creatures within the area gain DR 4/- and energy resistance 4 against all energy types. 
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
        
        effect eImpact   = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);

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