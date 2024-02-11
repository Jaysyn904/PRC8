/*
14/02/19 by Stratovarius

Step Into Shadow

Initiate, Ebon Roads 
Level/School: 4th/Conjuration (Teleportation) 
Range: Long (400 ft. + 40 ft./level) 
Target: You and touched objects or other touched willing creatures 
Duration: Instantaneous

You transport yourself through the Plane of Shadow to any spot within range. Your shadow stretches out from you until it reaches your chosen destination, passing through solid objects and moving independently of the ambient light. You appear to fall into your shadow at one end, and rise from it at the other.

This mystery functions like the spell dimension door.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "spinc_dimdoor"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        int bSelfOrParty = DIMENSIONDOOR_SELF;
        if (myst.nMystId == MYST_STEP_SHADOW_PARTY)
            bSelfOrParty = DIMENSIONDOOR_PARTY;

        DimensionDoor(oShadow, myst.nShadowcasterLevel, myst.nMystId, "", bSelfOrParty);            
    }
}