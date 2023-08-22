//::///////////////////////////////////////////////
//:: Sanctified Mind Cleansing Strike
//:: psi_smnd_clnstrk.nss
//::///////////////////////////////////////////////
/*
    Performs an attack round.
    The first attack adds Wisdom to the attack roll
    And 1d6 damage per class level.
    Only works on a Psionic creature.
    
    Using this ability requires expending Psionic Focus
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 17.2.2006
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_feat_const"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget  = PRCGetSpellTargetObject();
    effect eDummy = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    int nDamage = d6(GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND, oPC));
    int nAttack = GetAbilityModifier(ABILITY_WISDOM, oPC);

    if(!UsePsionicFocus(oPC))
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }

    if(!GetIsPsionicCharacter(oTarget))
    {
        SendMessageToPC(oPC, "The target is not a psionic creature");
        return;
    }

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, nAttack, nDamage, DAMAGE_TYPE_MAGICAL, FALSE, "Cleansing Strike Hit", "Cleansing Strike Miss");
}