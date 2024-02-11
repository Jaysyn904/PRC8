//::///////////////////////////////////////////////
//:: Name           Whelm test script
//:: FileName       wol_t_whelm
//:://////////////////////////////////////////////
/*
Dwarf
Base attack bonus +3
Weapon proficiency (warhammer)
*/

#include "prc_inc_template"

void main()
{
	object oPC = OBJECT_SELF;
	int nRace = MyPRCGetRacialType(oPC);
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
		
    if(nRace != RACIAL_TYPE_DWARF)
	{
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   	 
	if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    } 
	if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_WARHAMMER, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    	
}