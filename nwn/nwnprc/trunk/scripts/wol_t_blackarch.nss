//::///////////////////////////////////////////////
//:: Name           Bow of the Black Archer test script
//:: FileName       wol_t_blackarch
//:://////////////////////////////////////////////
/*
Cannot be drow
Base attack bonus +3 
Hide 2 ranks 
Move Silently 2 ranks 
Favored enemy elves +2 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(2 > GetSkillRank(SKILL_HIDE, oPC, TRUE))
    {
        //DoDebug("wol_t_blackarch doesn't have Hide");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(2 > GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE))
    {
        //DoDebug("wol_t_blackarch doesn't have MS");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(!GetHasFeat(FEAT_FAVORED_ENEMY_ELF, oPC))
    {
        //DoDebug("wol_t_blackarch doesn't have FE: Elf");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(3 > GetBaseAttackBonus(oPC))
    {
        //DoDebug("wol_t_blackarch doesn't have BAB");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
        
    int nRace = GetRacialType(oPC);
    if(nRace == RACIAL_TYPE_DROW_MALE
        || nRace == RACIAL_TYPE_DROW_FEMALE
        || nRace == RACIAL_TYPE_HALFDROW
        || nRace == RACIAL_TYPE_DRIDER
        )
    {
        //DoDebug("wol_t_blackarch doesn't have Drow");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
    
    //DoDebug("wol_t_blackarch end of script");
}