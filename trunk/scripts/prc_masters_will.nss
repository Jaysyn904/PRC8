//////////////////////////////////////////////////////////////////
// Master's Will
// prc_masters_will.nss
/////////////////////////////////////////////////////////////////
/** @file Master’s Will [Vile]
The elder evil you serve is fickle in its rewards and punishments.

Prerequisites: Chosen of Evil or undead type, Evil Brand.
Benefit: As an immediate action, you can beseech the
elder evil for assistance. Roll 1d20. If the result of the die
roll is an odd number, you gain a +8 bonus on attack rolls,
saving throws, and skill checks for 1 round. If the
result is even, you take 1 point of damage for each Hit Die or
character level you possess.

*/
/////////////////////////////////////////////////////////////////
// Tenjac - 5/23/08
/////////////////////////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    int nRoll = d20(1);

    if(nRoll%2==1)
    {
        effect eLink = EffectLinkEffects(EffectAttackIncrease(8), EffectSavingThrowIncrease(SAVING_THROW_ALL, 8, SAVING_THROW_TYPE_ALL));
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, 8));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0f);
        SendMessageToPC(oPC, "The elder evil you serve favors you.");
    }
    else
    {
        int nHD = GetHitDice(oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nHD, DAMAGE_TYPE_MAGICAL), oPC);
        SendMessageToPC(oPC, "The elder evil you serve rebukes you.");
    }
}