#include "prc_inc_sp_tch"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oTarget = PRCGetSpellTargetObject();

    // Determine damage dice.
    int nCasterLvl = PRCGetCasterLevel();
    int nDice = nCasterLvl;
    if (nDice > 5) nDice = 5;
    int nPenetr = nCasterLvl + SPGetPenetr();

    // Adjust the damage type of necessary.
    int nDamageType = PRCGetElementalDamageType(DAMAGE_TYPE_COLD, OBJECT_SELF);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        // Fire cast spell at event for the specified target
        PRCSignalSpellEvent(oTarget);

        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            // Make touch attack, saving result for possible critical
            int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
            if (nTouchAttack > 0)
            {
                // Roll the damage of (1d6+1) / level, doing double damage on a crit.
                int nDamage = PRCGetMetaMagicDamage(nDamageType,
                    1 == nTouchAttack ? nDice : (nDice * 2), 6, 1);
				nDamage += SpellDamagePerDice(OBJECT_SELF, nDice);
                // Apply the damage and the damage visible effect to the target.
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                    PRCEffectDamage(oTarget, nDamage, nDamageType), oTarget);
                    PRCBonusDamage(oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                    EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
            }
        }
    }

    PRCSetSchool();
}
