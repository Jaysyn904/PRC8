/*
28/03/21 by Stratovarius

Siphon Spell Power, Ur-Priest

Because they steal whatever power they can, ur-priests learn to manipulate their energy in ways that confound other casters. 
An ur-priest of 6th level or higher can temporarily sacrifice two (or more) lower-level spell slots and use those slots to 
prepare a higher-level spell. The higher-level spell must be of a level the ur-priest can cast. Only one exchange of this 
sort can be made each day. The levels of the lower-level slots are totaled, then reduced to three-quarters (round down) to 
determine the level of the extra higher-level spell slot. For example, an ur-priest who sacrifices a 3rd-level spell and a 
5th-level spell can use that spell slot to prepare an additional 6th-level spell (3 + 5 = 8, and 8 × 3/4 = 6).
*/

#include "prc_inc_spells"
#include "inc_dynconv"

void main()
{
    object oCaster = OBJECT_SELF;
    int nFeat      = PRCGetSpellId();
    
    if (nFeat == 3915)
    {
        int nSpellId = GetLocalInt(oCaster, "UrSiphon");
        if (nSpellId > 0)
        {
    	    AssignCommand(oCaster, DoRacialSLA(nSpellId));
    	}   
    	else 
    		IncrementRemainingFeatUses(oCaster, 3309);
    }
    else
    {
        AssignCommand(oCaster, ClearAllActions(TRUE));
        StartDynamicConversation("prc_ur_siphoncnv", oCaster, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oCaster);
    }    
}