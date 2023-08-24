//::///////////////////////////////////////////////
//:: Knight - Vigilant Defender
//:: prc_knght_vigil.nss
//:://////////////////////////////////////////////
//:: Tumble Pen = class level
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	effect eAOE = EffectAreaOfEffect(AOE_MOB_VIGILANT_DEFENDER);
     	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
