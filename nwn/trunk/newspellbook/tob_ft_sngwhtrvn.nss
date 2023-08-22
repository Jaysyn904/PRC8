//::///////////////////////////////////////////////
//:: Name      Song of the White Raven
//:: FileName  tob_ft_sngwhtrvn.nss
//:://////////////////////////////////////////////
/** While you are in any White Raven stance, you 
can activate your bardic music ability to inspire 
courage as a swift action. Your crusader and 
warblade levels stack with your bard levels to 
determine the bonus granted by your inspire 
courage ability.

Author:    Stratovarius
Created:   24.9.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"

void main()
{
    object oInitiator = OBJECT_SELF;
    int nDisc = GetDisciplineByManeuver(GetHasActiveStance(oInitiator));
    //make sure there's Bard Song uses left
    if (!GetHasFeat(FEAT_BARD_SONGS, oInitiator))
    {
        FloatingTextStringOnCreature("You are out of Bard Song uses for the day.", oInitiator, FALSE);
        return;
    }
    else if (nDisc == DISCIPLINE_WHITE_RAVEN)
    {
        //use up one
        DecrementRemainingFeatUses(oInitiator, FEAT_BARD_SONGS);
        ExecuteScript("nw_s2_bardsong", oInitiator);
    }    
}

