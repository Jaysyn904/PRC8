//::///////////////////////////////////////////////
//:: Knight - Bulwark of Defense
//:: prc_knght_blwrk.nss
//:://////////////////////////////////////////////
//:: Difficult Terrain
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	effect eAOE = EffectAreaOfEffect(AOE_MOB_BULWARK_DEFENSE);
     	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
