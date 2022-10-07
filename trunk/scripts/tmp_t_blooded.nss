//::///////////////////////////////////////////////
//:: Name           Blooded One template test script
//:: FileName       tmp_t_blooded
//:: 
//:://////////////////////////////////////////////
/*“Blooded” is a template that can be added to any humanoid (referred to hereafter as the “base creature”). It uses all the base creature’s statistics and special abilities, except as listed here.
AC: Natural armor improves by +2.
Special Attacks: A blooded one retains all the special attacks of the base creature, and also gains the following special attack. 
War Cry (Ex): Once per day, a blooded one can scream a special war cry. This causes all blooded ones within 30 feet (including itself) to gain a +1 morale bonus on all attack and damage rolls for 2d4 rounds. 
This effect does not stack with other war cries. 
Abilities: Adjust from the base creature as follows: Str +2, Con +4, Int –2.
Feats: Same as the base creature, except that a blooded one gains Combat Reflexes.
Level Adjustment: Same as the base creature +1.
*/
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    
    // Humanoid only
    if(!PRCAmIAHumanoid(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
}