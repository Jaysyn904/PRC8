#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    object oTarget = PRCGetSpellTargetObject();
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        // Fire cast spell at event for the specified target
        PRCSignalSpellEvent(oTarget);
        int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

        // Make SR check
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLvl+SPGetPenetr()))
        {
            // Fort save or die, if the fort save is successful will save or dazed for
            // 1d4 rounds.
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF), SAVING_THROW_TYPE_SPELL))
            {
                DeathlessFrenzyCheck(oTarget);

                // Target dies if it fails fort save.
                effect eDead = EffectDeath();
                eDead = EffectLinkEffects(eDead, EffectVisualEffect(VFX_IMP_DEATH));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDead, oTarget);
            }
            else if (GetHasMettle(oTarget, SAVING_THROW_FORT))
            {
        // This script does nothing if it has Mettle, bail
            return;
        }
            else if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF), SAVING_THROW_TYPE_SPELL))
            {
                float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(d4()));

                effect eDazed = EffectDazed();
                eDazed = EffectLinkEffects(eDazed, EffectVisualEffect(VFX_IMP_DAZED_S));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazed, oTarget, fDuration,TRUE,-1,nCasterLvl);
            }

            // The target always takes a -2 penalty to saves, attacks, and skill checks,
            // we do it out here in case the target is immune to death effects (it could
            // then still be alive even if it fails it's fort save).
            if (!GetIsDead(oTarget))
            {
                // Determine the spell's duration, taking metamagic feats into account.
                float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));

                // Target's saves, attack rolls, and skill checks are reduced by 2 for the
                // spell's duration.
                effect eDebuff = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
                eDebuff = EffectLinkEffects(eDebuff, EffectAttackDecrease(2));
                eDebuff = EffectLinkEffects(eDebuff, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
                eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, fDuration,TRUE,-1,nCasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                    EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
            }
        }
    }

    PRCSetSchool();
}
