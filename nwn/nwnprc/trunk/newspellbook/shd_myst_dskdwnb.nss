/*
12/02/19 by Stratovarius

Dusk and Dawn, OnExit

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

void main()
{
    object oShadow = GetAreaOfEffectCreator();
    object oTarget  = GetExitingObject();
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"6");  

    // Loop over effects, removing the ones from this power
    effect eAOE;
    if(GetHasSpellEffect(MYST_DUSK_AND_DAWN_DUSK, oTarget) || GetHasSpellEffect(FUND_BLACK_CANDLE_DARK, oTarget) || GetHasSpellEffect(MYST_DEADLY_SHADE_DR, oTarget) || GetHasSpellEffect(MYST_DEADLY_SHADE_NEG, oTarget))
    {
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == oShadow && (GetEffectSpellId(eAOE) == MYST_DUSK_AND_DAWN_DUSK || GetEffectSpellId(eAOE) == FUND_BLACK_CANDLE_DARK || GetEffectSpellId(eAOE) == MYST_DEADLY_SHADE_DR || GetEffectSpellId(eAOE) == MYST_DEADLY_SHADE_NEG))
            {
                RemoveEffect(oTarget, eAOE);
                DeleteLocalInt(oTarget, "DeadlyShade");
            }
            // Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }// end while - Effect loop
    }// end if - Target has been affected at all
}
