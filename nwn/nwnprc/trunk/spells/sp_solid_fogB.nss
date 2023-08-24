//::///////////////////////////////////////////////
//:: Name      Solid Fog: On Exit
//:: FileName  sp_solid_fogB.nss
//:://////////////////////////////////////////////
/**@file Solid Fog
Conjuration (Creation)
Level: Sor/Wiz 4, Hexblade 4
Components: V, S, M
Duration: 1 min./level
Spell Resistance: No

This spell functions like fog cloud, but in addition
to obscuring sight, the solid fog is so thick that 
any creature attempting to move through it progresses
at a speed of 5 feet, regardless of its normal speed,
and it takes a -2 penalty on all melee attack and 
melee damage rolls. The vapors prevent effective 
ranged weapon attacks (except for magic rays and the
like). A creature or object that falls into solid fog
is slowed, so that each 10 feet of vapor that it 
passes through reduces falling damage by 1d6. A 
creature can’t take a 5-foot step while in solid fog.

However, unlike normal fog, only a severe wind 
(31+ mph) disperses these vapors, and it does so in 
1 round.

Solid fog can be made permanent with a permanency 
spell. A permanent solid fog dispersed by wind 
reforms in 10 minutes.

Material Component: A pinch of dried, powdered peas 
                    combined with powdered animal hoof.
**/

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    if(GetHasSpellEffect(SPELL_SOLID_FOG, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by either half of Fog from the Void
                    if(GetEffectSpellId(eAOE) == SPELL_SOLID_FOG)
                    {
                        RemoveEffect(oTarget, eAOE);
                    }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}