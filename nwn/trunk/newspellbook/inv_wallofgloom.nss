//::///////////////////////////////////////////////
//:: Wall of Fire
//:: NW_S0_WallFire.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall of fire that burns any creature
    entering the area around the wall.  Those moving
    through the AOE are burned for 4d6 fire damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;

    //Declare Area of Effect object using the appropriate constant
    effect eAOE = EffectAreaOfEffect(INVOKE_VFX_PER_WALL_OF_GLOOM);
    //Get the location where the wall is to be placed.
    location lTarget = PRCGetSpellTargetLocation();
    int nDuration = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    if(nDuration == 0)
    {
        nDuration = 1;
    }

    //Create the Area of Effect Object declared above.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

}
