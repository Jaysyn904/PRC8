//::///////////////////////////////////////////////
//:: Destruction Domain Power
//:: prc_domain_destr.nss
//::///////////////////////////////////////////////
/*
    Smite with damage bonus equal to cleric level. +4 on the attack
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_domain"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(PRC_DOMAIN_DESTRUCTION, oPC)) return;

    object oTarget = PRCGetSpellTargetObject();
    effect eDummy = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    int nCleric = GetDomainCasterLevel(oPC);

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 4, nCleric, DAMAGE_TYPE_DIVINE, FALSE, "Destruction Domain Power Hit", "Destruction Domain Power Miss");
}