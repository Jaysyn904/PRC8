//Unmovable
//prc_lgdr_unmove
//
/*
  Causes the PC to become near immobile and
  grants a 20+ Bonus to Discipline Checks.
*/
//
//

#include "prc_effect_inc"

void main()
{
    object oPC = OBJECT_SELF;

    if(!GetHasSpellEffect(SPELL_UNMOVABLE, oPC))
    {
        //Define Properties
        effect eLink = EffectSkillIncrease(SKILL_DISCIPLINE, 20);
               eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(99));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
        IncrementRemainingFeatUses(oPC, FEAT_UNMOVABLE_1);
        FloatingTextStringOnCreature("Unmovable Activated", oPC, FALSE);
    }
    else
    {
        // The code to cancel the effects
        PRCRemoveSpellEffects(SPELL_UNMOVABLE, oPC, oPC);
        FloatingTextStringOnCreature("Unmovable Deactivated", oPC, FALSE);
    }
}