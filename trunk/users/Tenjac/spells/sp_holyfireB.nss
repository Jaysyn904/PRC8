//:://////////////////////////////////////////////
//:: Name     Holy Fire On Exit
//:: FileName   sp_holyfireB.nss
//:://////////////////////////////////////////////
/** @file Evocation [Fire, Good]
Level: Cleric 2, Paladin 3,
Components: V, S, DF,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round

All undead within range of your next turning attempt
(if you make it before this spell's duration expires)
are especially vulnerable to the attempt. Whether you
succeed in turning them or not, the undead take hit 
point damage equal to the result of your turning damage
roll. This damage is half fire and half sacred energy.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/21/2022
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
        object oCaster = GetAreaOfEffectCreator();
        object oTarget = GetExitingObject();  
        
        effect eToDispel = GetFirstEffect(oTarget);
        
        while(GetIsEffectValid(eToDispel))
        {
        	if(GetEffectSpellId(eToDispel) == SPELL_HOLY_FIRE)

                        {
                                RemoveEffect(oTarget, eToDispel);
                        }
                        
                        eToDispel = GetNextEffect(oTarget);
                }
        }
}