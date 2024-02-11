/*
16/02/19 by Stratovarius

Pass Into Shadow

Initiate, Ebon Roads 
Level/School: 5th/Conjuration (Teleportation) 
Range: Touch Effect: Creature touched, or up to eight willing creatures joining hands 
Duration: Instantaneous 

You break down the boundaries between worlds, opening a path into the Plane of Shadow.

This mystery functions like the spell teleport.

Voyage Into Shadow

Initiate, Ebon Roads 
Level/School: 6th/Illusion (Shadow) 
Range: Touch 
Targets: Up to one touched creature/level 
Duration: Instantaneous

You and other creatures you touch enter the Plane of Shadow for a brief span, using it as a means of crossing great distances on the Material Plane.

This mystery functions like the spell greater teleport.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "spinc_teleport"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        int bSelfOrParty = FALSE;
        int bError = FALSE;
        if (myst.nMystId == MYST_PASS_SHADOW_PARTY || myst.nMystId == MYST_VOYAGE_SHADOW_PARTY)
            bSelfOrParty = TRUE;
        if (myst.nMystId == MYST_VOYAGE_SHADOW_SELF || myst.nMystId == MYST_VOYAGE_SHADOW_PARTY)
            bError = TRUE;            

        Teleport(oShadow, myst.nShadowcasterLevel, bSelfOrParty, bError, "");          
    }
}