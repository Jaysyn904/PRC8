//::///////////////////////////////////////////////
//:: Thrall of Orcus Pallor of Death
//:: prc_to_pallor.nss
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the enemy
    must make a will save or be struck with fear because
    of the Thrall's appearance
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 11, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{

    int nDur = GetLevelByClass(CLASS_TYPE_ORCUS, OBJECT_SELF);


    //Set and apply AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_PALLOR);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, TurnsToSeconds(nDur));
}
