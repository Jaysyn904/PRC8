//::///////////////////////////////////////////////
//:: Climb Skill
//:://////////////////////////////////////////////
//:: 
//:: Climb to target if pass check, or fall over if fail
//:: 
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 8, 2009
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_skills"

void main()
{
    object oPC = OBJECT_SELF;
    location lLoc = PRCGetSpellTargetLocation();
    
    DoClimb(oPC, lLoc, TRUE);
}
