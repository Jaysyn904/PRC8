//::///////////////////////////////////////////////
//:: Jump Skill
//:://////////////////////////////////////////////
//:: 
//:: Jumps to target if pass check, or fall over if fail
//:: 
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Sept 4, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_skills"

void main()
{
    object oPC = OBJECT_SELF;
    location lLoc = PRCGetSpellTargetLocation();
    
    PerformJump(oPC, lLoc, TRUE);
}
