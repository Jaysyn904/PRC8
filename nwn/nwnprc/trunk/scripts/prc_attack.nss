//::///////////////////////////////////////////////
//:: Attack Script
//:: prc_attack.nss
//::///////////////////////////////////////////////
/*
    Calls a scripted full round attack
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 9.7.2020
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy;
    PerformAttackRound(oTarget, oPC, eDummy);
}
