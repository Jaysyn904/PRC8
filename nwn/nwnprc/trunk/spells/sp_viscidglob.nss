#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oTarget = PRCGetSpellTargetObject();



    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        // Fire cast spell at event for the specified target
        PRCSignalSpellEvent(oTarget);

        int CasterLvl = PRCGetCasterLevel();

        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl+SPGetPenetr()))
        {
            // Make touch attack, saving result for possible critical
            int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
            if (nTouchAttack > 0)
            {
                // Impact vfx.
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                    EffectVisualEffect(VFX_IMP_ACID_S), oTarget);

                if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF),
                    SAVING_THROW_TYPE_SPELL))
                {
                    float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(CasterLvl));

                    // Target cannot move no matter what.
                    effect eEffect = EffectCutsceneImmobilize();
                    eEffect = EffectLinkEffects(eEffect,
                        EffectVisualEffect(VFX_DUR_GLOW_LIGHT_GREEN));
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration,TRUE,-1,CasterLvl);
                    // If target is medium or smaller may not take any actions either.
                    if (PRCGetCreatureSize(oTarget) <= CREATURE_SIZE_MEDIUM)
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(),
                            oTarget, fDuration,TRUE,-1,CasterLvl);
                }
                else
                {
                    // Show that the target made it's save.
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE), oTarget);
                }
            }
        }
    }

    PRCSetSchool();
}
