//::///////////////////////////////////////////////
//:: Name           Sling of the Dire Wind test script
//:: FileName       wol_t_direwind
//:://////////////////////////////////////////////
/*
Base Fortitude save +3
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(3 > GetFortitudeSavingThrow(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
}