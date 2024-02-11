/*
16/02/19 by Stratovarius

Flood of Shadow

Initiate, Black Magic 
Level/School: 6th/Abjuration 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 20-ft.-radius spread 
Duration: 10 minutes/level 
Saving Throw: None 
Spell Resistance: See text

You inundate the area with strange energies from the Plane of Shadow, warping the effects of magic.

A flood of mystical shadow-power renders casting more difficult. To cast most spells while in an area affected by flood of shadow, the caster must succeed on a Spellcraft check 
(DC 15 + spell level), or the spell is lost with no effect. Mysteries can be cast within or into the affected area without making the Spellcraft check. In addition, if a mystery 
originates in an area affected by flood of shadow, its variable numerical effect is increased by 50% (as if it was empowered), although its level does not increase. This does not
stack with empower mystery.
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

        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_FLOOD_SHADOW);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
    }
}