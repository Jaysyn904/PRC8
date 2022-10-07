#include "prc_inc_spells"
#include "prc_spell_const"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    // Get the target and raise the spell cast event.
    object oTarget = PRCGetSpellTargetObject();
    PRCSignalSpellEvent(oTarget, FALSE);

    if(GetHasSpellEffect(SPELL_HEROISM, oTarget))
    {
            PRCRemoveSpellEffects(SPELL_HEROISM,OBJECT_SELF,OBJECT_SELF);
    }

    // Determine the spell's duration, taking metamagic feats into account.
    int nCasterlvl = PRCGetCasterLevel();
    float fDuration = PRCGetMetaMagicDuration(TenMinutesToSeconds(nCasterlvl));

    // Create the chain of buffs to apply, including the vfx.
    effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
    eBuff = EffectLinkEffects (eBuff, EffectAttackIncrease(4, ATTACK_BONUS_MISC));
    eBuff = EffectLinkEffects (eBuff, EffectSkillIncrease(SKILL_ALL_SKILLS, 4));
    eBuff = EffectLinkEffects (eBuff, EffectImmunity(IMMUNITY_TYPE_FEAR));
    //improperly removing gheroism when temp hp expire; fix by unlinking temp hp from other effect ~ Lockindal
    effect eTempHP = EffectTemporaryHitpoints(nCasterlvl > 20 ? 20 : nCasterlvl);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterlvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oTarget, fDuration,TRUE,-1,nCasterlvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
}
