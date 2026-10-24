//::///////////////////////////////////////////////
//:: D&D 3.0 werewolf template eligibility
//:: tmp_t_wwolf
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"
#include "prc_inc_wwolf"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

    if(!PRCWWIsHumanoid(oPC)
        || PRCWWHasTemplate(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}
