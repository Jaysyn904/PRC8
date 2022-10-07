//////////////////////////////////////////////////
// Girallon Windmill Flesh Rip Onhit
// tob_event_girwfr.nss
// Tenjac 10/17/07
//////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oSpellOrigin = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
        
        int nHits = GetLocalInt(oTarget, "TOB_GIR_WINDMILL_FR");
        nHits ++;
        
        SetLocalInt(oTarget, "TOB_GIR_WINDMILL_FR", nHits);
}