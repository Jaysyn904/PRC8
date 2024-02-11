/*
12/12/19 by Stratovarius

Grasping Shadows, OnExit

Master, Shadowscape
Level/School: 7th/Conjuration (Creation)
Range: Medium (100 ft. + 10 ft./level)
Area/Target: 20-ft.-radius spread
Duration: 1 round/level
Saving Throw: Will partial
Spell Resistance: See text

Stalks of shadows burst from the ground, as though desperate to escape the bonds of the earth, and immediately flail at everyone nearby.

This mystery creates an area of grasping tendrils that function as the spell Evard's black tentacles (PH 228), with one additional hazard: 
Anyone successfully grappled by a tentacle must attempt a Will save or go blind. A successful save means the individual is safe from blinding
during that particular grapple, but if she escapes and is then regrappled, she must make another saving throw. The blindness is permanent until magically cured.
*/

#include "shd_inc_shdfunc"

void main()
{
    object oShadow = GetAreaOfEffectCreator();
    object oTarget  = GetExitingObject();
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST);  

    // Loop over effects, removing the ones from this power
    effect eAOE;
    if(GetHasSpellEffect(MYST_GRASPING_SHADOWS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        int bValid = FALSE;
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == MYST_GRASPING_SHADOWS)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}
