//:://////////////////////////////////////////////
//:: Name     Meteoric Strike
//:: FileName   sp_meteoric.nss
//:://////////////////////////////////////////////
/** @file Transmutation [Fire]
Level: Druid 4, Paladin 4, Cleric 5,
Components: V, S,
Casting Time: 1 swift action
Range: 0 ft.
Target: Your melee weapon
Duration: 1 round or until discharged
Saving Throw: None or Reflex half; see text
Spell Resistance: See text

Your melee weapon bursts into orange, red, and gold
flames, and shining sparks trail in its wake.
Your next successful melee attack deals extra fire
damage equal to 1d6 points + 1d6 points per four caster
levels.
In addition, the flames splash into all squares adjacent 
to the target.
Any creatures standing in these squares take half damage 
from the explosion, with a Reflex save allowed to halve
this again.
If a creature has spell resistance, it applies to this 
splash effect.
You are not harmed by your own meteoric strike.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/15/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        
        object oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        
        itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
        IPSafeAddItemProperty(oTarget, ipHook, 6.0f)
        AddEventScript(oTarget, "sp_meteoriconhit", FALSE, FALSE);
                
        PRCSetSchool();
}