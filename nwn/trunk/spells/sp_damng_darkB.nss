//::///////////////////////////////////////////////
//:: Name      Damning Darkness
//:: FileName  sp_damng_dark.nss
//:://////////////////////////////////////////////
/**@file Damning Darkness
Evocation [Darkness, Evil]
Level: Clr 4, Darkness 4, Sor/Wiz 4
Components: V, M/DF
Casting Time: 1 action
Range: Touch
Target: Object touched
Duration: 10 minutes/level (D)
Saving Throw: None
Spell Resistance: No 

This spell is similar to darkness, except that those
within the area of darkness also take unholy damage.
Creatures of good alignment take 2d6 points of 
damage per round in the darkness, and creatures
neither good nor evil take 1d6 points of damage. As 
with the darkness spell, the area of darkness is a 
20-foot radius, and the object that serves as the 
spell's target can be shrouded to block the darkness
(and thus the dam­aging effect).

Damning darkness counters or dispels any light spell 
of equal or lower level.

Arcane Material Component: A dollop of pitch with a 
tiny needle hidden inside it.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    if(GetHasSpellEffect(SPELL_DAMNING_DARKNESS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_DARKNESS)
                {
                    //If the effect was created by CotA then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_DAMNING_DARKNESS)
                    {
                        RemoveEffect(oTarget, eAOE);
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }   
    PRCSetSchool();
}