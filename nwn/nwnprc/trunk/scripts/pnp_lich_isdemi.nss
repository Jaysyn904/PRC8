//::///////////////////////////////////////////////
//:: FileName pnp_lich_isdemi
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/24/2004 9:30:45 AM
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

// Determines if the the lich is able to start the process of becoming a demilich

int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = FALSE;
	
    if((GetLevelByClass(CLASS_TYPE_LICH, GetPCSpeaker()) >= 4) &&
        GetIsEpicSpellcaster(GetPCSpeaker())) // if is an epic caster, meets prereq
        iPassed = TRUE;

    return iPassed;
}
