//::///////////////////////////////////////////////
//:: Warmind Chain of Overwhelming Force
//:: psi_wmnd_oforce.nss
//::///////////////////////////////////////////////
/*
    Performs an attack round with +10d6 damage bonus
    on the first attack.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 15.12.2005
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    
    // This is to stop the death attack that happens when using the Chain of Overwhelming Force with Sweeping Strike
    SetLocalInt(oPC, "SweepingStrikeDelay", TRUE);
    DelayCommand(6.0, DeleteLocalInt(oPC, "SweepingStrikeDelay"));
    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 0, d6(10), DAMAGE_TYPE_MAGICAL, FALSE, "Chain of Overwhelming Force Hit", "Chain of Overwhelming Force Miss");
}