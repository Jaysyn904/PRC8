//::///////////////////////////////////////////////
//:: Name      Curse Water
//:: FileName  sp_curse_water.nss
//:://////////////////////////////////////////////
/** @file Curse Water
Transmutation [Evil]
Level:  Clr 1
Components:   V, S, M
Range: Touch
Casting Time:   1 minute
Target: Bottle of Water touched
Duration: Instantaneous
Saving Throw:   Will negates (object)
Spell Resistance:   Yes (object)

This spell imbues a flask of water with negative energy, turning it
into unholy water. Unholy water damages good outsiders the way holy water
damages undead and evil outsiders.

Material Component: 5 pounds of powdered silver (worth 25 gp).
*/
////////////////////////////////////////////////////
// Author: Tenjac
// Date: 4.10.06
////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
  if(!X2PreSpellCastCode()) return;

  PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

  object oPC = OBJECT_SELF;

  CreateItemOnObject("prc_cursedwater", oPC, 1);

  PRCSetSchool();
}

