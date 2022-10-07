//::///////////////////////////////////////////////
//:: Orc Domain Power
//:: prc_domain_orc.nss
//::///////////////////////////////////////////////
/*
    Smite with damage bonus equal to cleric level.
    If the target is Elf or Dwarf, +4 on the attack
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
    if(!DecrementDomainUses(PRC_DOMAIN_ORC, oPC)) return;

    object oTarget = PRCGetSpellTargetObject();
    effect eDummy = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    int nRace = MyPRCGetRacialType(oTarget);
    int nCleric = GetDomainCasterLevel(oPC);
    int nBonus = (nRace == RACIAL_TYPE_ELF || nRace == RACIAL_TYPE_DWARF) ? 4 : 0;

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, nBonus, nCleric, DAMAGE_TYPE_DIVINE, FALSE, "Orc Domain Power Hit", "Orc Domain Power Miss");
}