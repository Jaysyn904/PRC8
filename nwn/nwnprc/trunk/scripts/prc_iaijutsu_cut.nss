#include "prc_effect_inc"

void main()
{
    object oPC = OBJECT_SELF;

    if(!GetHasSpellEffect(SPELL_ONE_STRIKE_TWO_CUTS, oPC))
    {
        effect eAttack = SupernaturalEffect(EffectModifyAttacks(1));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttack, oPC);
        FloatingTextStringOnCreature("One Strike Two Cuts", oPC, FALSE);
    }
    else
    {
        // The code to cancel the effects
        PRCRemoveSpellEffects(SPELL_ONE_STRIKE_TWO_CUTS, oPC, oPC);
        FloatingTextStringOnCreature("One Strike Two Cuts Removed", oPC, FALSE);
    }
}