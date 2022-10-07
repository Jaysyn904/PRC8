#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    float fSec = HoursToSeconds(1);

    // A Drunken Master has had a drink. Add effects:
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 1);
    effect eCns = EffectAbilityIncrease(ABILITY_CONSTITUTION, 1);

    effect eVFX2 = EffectVisualEffect(VFX_DUR_BLUR);

    //save info prior to lowering effects:
    int nReflexSave = GetReflexSavingThrow(oPC);
    int nTumble = GetSkillRank(SKILL_TUMBLE);
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY);
    int nRSAfter, nTumbleAfter, nDexModAfter;

    //Apply the major bonuses:
    ApplyAbilityDamage(oPC, ABILITY_WISDOM,       1, DURATION_TYPE_TEMPORARY, TRUE, fSec);
    ApplyAbilityDamage(oPC, ABILITY_INTELLIGENCE, 1, DURATION_TYPE_TEMPORARY, TRUE, fSec);
    ApplyAbilityDamage(oPC, ABILITY_DEXTERITY,    1, DURATION_TYPE_TEMPORARY, TRUE, fSec);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oPC, fSec);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCns, oPC, fSec);

    //Apply VFX's
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX2, oPC, fSec);

    //run checks to see if Reflex Saving Throw, Tumble and Dex Modifier have been changed:
    nRSAfter = GetReflexSavingThrow(oPC);
    nTumbleAfter = GetSkillRank(SKILL_TUMBLE);
    nDexModAfter = GetAbilityModifier(ABILITY_DEXTERITY);

    if(nDexModAfter < nDexMod)
        {ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(nDexMod - nDexModAfter), oPC, fSec);}
    if(nRSAfter < nReflexSave)
        {ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nReflexSave - nRSAfter), oPC, fSec);}
    if(nTumbleAfter < nTumble)
        {ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_TUMBLE, nTumble - nTumbleAfter), oPC, fSec);}

    FloatingTextStringOnCreature("You are Drunk Like a Demon", oPC);
}
