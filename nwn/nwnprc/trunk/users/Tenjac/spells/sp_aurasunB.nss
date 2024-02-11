//:://////////////////////////////////////////////
//:: Name     Aura of the Sun On Exit
//:: FileName   sp_aurasunB.nss
//:://////////////////////////////////////////////
/** @file Aura of the Sun
Abjuration [Light]
Level: Cleric 4, Paladin 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: 10 ft.
Area: 10-ft.-radius emanation centered on you
Duration: 1 round/level (D)
Saving Throw: No
Spell Resistance: None

By casting aura of the sun, you fill the area around you with warm, glowing light that eliminates natural 
shadows and hampers magical darkness.Any creature attempting to cast a spell from the shadow subschool or 
a spell with the darkness descriptor within an aura of the sun must succeed on a caster level check (DC 11 +
your caster level), or the spell fails. Areas of magical darkness originating from 3rd-level or lower spells 
and effects are temporarily suppressed when overlapping with an aura of the sun. Creatures that take penalties 
in bright light also take them while within an aura of the sun, and an undead creature takes 1d6 points of positive
energy damage at the end of its turn every round that it spends within the spell's area.Furthermore, any creature 
attempting to hide within the aura takes a -4 penalty on Hide checks.
This effect is centered on you and moves with you.
Anyone who enters the aura immediately becomes subject to its effect, but creatures that leave are no longer affected.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/10/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"
void main()
{
        object oCaster = GetAreaOfEffectCreator();
        object oTarget = GetExitingObject();  
        
        effect eToDispel = GetFirstEffect(oTarget);
        
        while(GetIsEffectValid(eToDispel))
        {
        	if(GetEffectSpellId(eToDispel) == SPELL_AURA_OF_THE_SUN)

                        {
                                RemoveEffect(oTarget, eToDispel);
                        }
                        
                        eToDispel = GetNextEffect(oTarget);
                }
        }
        
        DeleteLocalInt(oTarget, "PRCAuraSunDC");
}