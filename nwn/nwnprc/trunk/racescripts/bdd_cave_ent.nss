// Cave entrance 

#include "inc_dynconv"
void main()
{
    object oPC = GetEnteringObject();
    int nRanks = GetSkillRank(SKILL_SPOT, oPC);
    if (nRanks > 5) // Can actually succeed
    {
        if (GetIsSkillSuccessful(oPC, SKILL_SPOT, 26)) // Have to spot the cave opening
	    {
	    	AssignCommand(oPC, ClearAllActions(TRUE));
	    	StartDynamicConversation("bdd_cave_conv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
	    }
    }    
}