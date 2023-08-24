/*
Shadow Walk
Type of Feat: Class Specific
Prerequisite: Crinti Shadow Marauder 3
Specifics: You may teleport, as per the spell, once per day.
Use: Selected
*/

#include "spinc_teleport"

void main()
{
    object oPC = OBJECT_SELF;
    Teleport(oPC, GetHitDice(oPC), SPELL_TELEPORT, FALSE, "");   
}

