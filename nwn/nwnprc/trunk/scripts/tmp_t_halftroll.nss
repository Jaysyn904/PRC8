//::///////////////////////////////////////////////
//:: Name           Half-troll template test script
//:: FileName       tmp_t_halftroll
//:: 
//:://////////////////////////////////////////////
/*“Half-troll” is an inherited template that can be added to any animal, dragon, fey, giant, humanoid, magical beast, monstrous humanoid, or outsider (referred to hereafter as the base creature). The creature’s type becomes giant, and a half-troll with an outsider as the base creature also gains the extraplanar subtype. The half-troll uses all the base creature’s statistics and special abilities except as
noted here.

AC: Natural armor improves by +4.

Damage: Half-trolls have bite and claw attacks. If the base creature does not have these attack forms, use the appropriate damage values based on the half-troll’s size (see the table below). Otherwise, use the values from the table or the base creature’s damage, whichever is greater.

Size		Bite Damage		Claw Damage
Fine		1 				—
Diminutive	1d2 			1
Tiny		1d3				1d2
Small		1d4				1d3
Medium		1d6				1d4
Large		1d8				1d6
Huge		2d6				1d8
Gargantuan	2d8				2d6
Colossal	4d6				2d8

Special Attacks: A half-troll retains all the special attacks of the base creature. Half-trolls also gain two claw attacks (or the base creature’s number of claw attacks, whichever is higher) and the special ability to rend.

Rend (Ex): If a half-troll hits with two or more claw attacks against the same opponent, it latches onto the opponent’s body and tears the flesh. This attack automatically deals an additional amount of damage based on the half-troll’s size (see the table below). A half-troll adds 1 1/2 times its Strength modifier to this base rend damage.

Size		Rend Damage
Fine 		—
Diminutive	1d2
Tiny		2d2
Small		2d3
Medium		2d4
Large		2d6
Huge		2d8
Gargantuan	4d6
Colossal	4d8

Special Qualities: A half-troll has all the special qualities of the base creature, plus darkvision with a range of 60 feet, fast healing 5, and scent.

Fast Healing (Ex): A half-troll heals 5 points of damage each round so long as it has at least 1 hit point. Fast healing does not restore hit points lost from starvation, thirst, or suffocation, and it does not allow a half-troll to regrow or reattach lost body parts.

Scent (Ex): A half-troll can detect approaching enemies, sniff out hidden foes, and track by sense of smell.

Abilities: Adjust from the base creature as follows: Str +6, Dex +2, Con +6, Int –2, Cha –2.

Alignment: Usually chaotic neutral or chaotic evil.

Level Adjustment: +4
*/
#include "prc_inc_template"
#include "prc_inc_natweap"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    
//:: No aberrations, constructs, oozes, plants, shapechangers, undead or vermin.
    int nRace = MyPRCGetRacialType(oPC);
    if(nRace == RACIAL_TYPE_ABERRATION ||
		nRace == RACIAL_TYPE_CONSTRUCT ||
		nRace == RACIAL_TYPE_OOZE ||
		nRace == RACIAL_TYPE_PLANT ||
		nRace == RACIAL_TYPE_SHAPECHANGER ||
		nRace == RACIAL_TYPE_UNDEAD ||
		nRace == RACIAL_TYPE_VERMIN)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }  
	
//:: No undead.
    if(GetHasTemplate(TEMPLATE_LICH, oPC) ||
    GetHasTemplate(TEMPLATE_DEMILICH, oPC) ||
    GetHasTemplate(TEMPLATE_NECROPOLITAN, oPC) ||
	GetHasTemplate(TEMPLATE_ARCHLICH, oPC) ||	
	GetHasTemplate(TEMPLATE_ALHOON, oPC) ||
	GetHasTemplate(TEMPLATE_CURST, oPC) ||
	GetHasTemplate(TEMPLATE_CRYPTSPAWN, oPC) ||
	GetHasTemplate(TEMPLATE_BAELNORN, oPC) ||	
    GetLevelByClass(CLASS_TYPE_BAELNORN, oPC) > 0 ||
    GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }	
}   