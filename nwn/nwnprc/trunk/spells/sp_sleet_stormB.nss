//::///////////////////////////////////////////////
//:: Name      Sleet Storm On Exit
//:: FileName  sp_sleet_stormB.nss
//:://////////////////////////////////////////////
/**@file Sleet Storm

Conjuration (Creation) [Cold]
Level: Drd 3, Sor/Wiz 3 
Components: V, S, M/DF 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (40-ft. radius, 20 ft. high) 
Duration: 1 round/level 
Saving Throw: None 
Spell Resistance: No

Driving sleet blocks all sight (even darkvision) 
within it and causes the ground in the area to be
icy. A creature can walk within or through the 
area of sleet at half normal speed with a DC 10 
Balance check. Failure means it can’t move in that
round, while failure by 5 or more means it falls 
(see the Balance skill for details).

The sleet extinguishes torches and small fires.

Arcane Material Component: A pinch of dust and a 
few drops of water.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    if(GetHasSpellEffect(SPELL_SLEET_STORM, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by CotA then remove it
                if(GetEffectSpellId(eAOE) == SPELL_SLEET_STORM)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    PRCSetSchool();
}
