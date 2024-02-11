//::///////////////////////////////////////////////
//:: Slayer of Domiel Cha to saves
//:: prc_sod_divgrace.nss
//:://////////////////////////////////////////////
//:: Applies Slayer of Domiel Bonuses by using
//:: ActionCastSpellOnSelf called from prc_slayerdomiel
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();

    // Charisma to all saves
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nCha);
    eSave = ExtraordinaryEffect(eSave);

    PRCRemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);
}
