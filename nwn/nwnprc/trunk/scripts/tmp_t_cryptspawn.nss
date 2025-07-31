//::///////////////////////////////////////////////
//:: Name           Crypt Spawn template test script
//:: FileName       tmp_t_cryptspawn
//:: 
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 2022/03/07
//:://////////////////////////////////////////////
/*CREATING A CRYPT SPAWN
“Crypt spawn” is a template that can be applied to any living creature (referred to hereafter as the “base creature”). The base creature’s type changes to “undead.” It uses all the base creature’s statistics and special abilities except as noted here.

Hit Dice: Increase to d12.

AC: A crypt spawn gains a natural armor bonus (see the table below). If the base creature already has natural armor, use the better value.

Hit Dice  Natural Armor
1–4 		+1
5–8 		+2
9–12 		+3
13–16 		+4
17+ 		+5

Special Qualities: A crypt spawn retains all the special qualities of the base creature and those listed below, and also gains the undead type.

Darkvision (Ex): A crypt spawn can see in complete darkness as if it were daylight.

Turn Resistance (Ex): A crypt spawn has +2 turn resistance.

Abilities: As an undead creature, a crypt spawn has no Constitution score.

Skills: A crypt spawn receives a +4 racial bonus on Intimidate checks. Otherwise as the base creature.

Climate/Terrain: Same as the base creature and underground.

Organization: Same as the base creature.

Challenge Rating: Same as the base creature +1.

Treasure: Same as the base creature.

Alignment: Usually evil.  Few nonevil beings are willing to submit to the undeath after death spell or become an undead creature.

Level Adjustment: Same as base creature +2

*/


#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    
//:: Any living creature.
    int nRace = MyPRCGetRacialType(oPC);
    if(nRace == RACIAL_TYPE_CONSTRUCT ||
       nRace == RACIAL_TYPE_UNDEAD)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }  
	
//:: If it's already undead, it can't become undead again.
    if(GetHasTemplate(TEMPLATE_LICH, oPC) ||
    GetHasTemplate(TEMPLATE_DEMILICH, oPC) ||
	GetHasTemplate(TEMPLATE_ARCHLICH, oPC) ||
	GetHasTemplate(TEMPLATE_ALHOON, oPC) ||
	GetHasTemplate(TEMPLATE_CRYPTSPAWN, oPC) ||
	GetHasTemplate(TEMPLATE_NECROPOLITAN, oPC) ||
	GetHasTemplate(TEMPLATE_BAELNORN, oPC) ||
    GetLevelByClass(CLASS_TYPE_BAELNORN, oPC) > 0 ||
    GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }	
}