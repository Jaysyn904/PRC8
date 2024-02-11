/////////////////////////////////////////////////////////////////////
//
// Panacea - Heals 1d8+1/lvl (max 1d8+20) hp, cures the following
// conditions: blinded, confused, dazed, deafened, diseased,
// frightened, paralyzed, poisoned, sleep, and stunned.
//
/////////////////////////////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    // Get the target and raise the spell cast event.
    object oTarget = PRCGetSpellTargetObject();
    // Compute the damage to add to the dice roll.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nAdd = nCasterLvl;
    if (nAdd > 20) nAdd = 20;
    int nPenetr = nCasterLvl + SPGetPenetr();

    // If the target is not undead then heal it and remove all harmfull effects.  If
    // the target is undead then check for SR.
    if (RACIAL_TYPE_UNDEAD != MyPRCGetRacialType(oTarget)
    && !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
    {
        PRCSignalSpellEvent(oTarget, FALSE);

        // Look for detrimental effects and remove them.  Removes the following effects:
        // blinded, confused, dazed, deafened, diseased, frightened, paralyzed,
        // poisoned, sleep, and stunned.
        effect eEffect = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eEffect))
        {
            // GetIsValidEffect() appears to be returning TRUE sometimes even for invalid effects so
            // catch that here.
            int nEffectType = GetEffectType(eEffect);
            if (EFFECT_TYPE_INVALIDEFFECT == nEffectType)
            {
                PrintString("****EFFECT_TYPE_INVALIDEFFECT returned but GetIsValidEffect() returns TRUE");
                break;
            }

            // catch all of the detrimental effects and remove them.
            if (EFFECT_TYPE_BLINDNESS == nEffectType ||
                EFFECT_TYPE_CONFUSED == nEffectType ||
                EFFECT_TYPE_DAZED == nEffectType ||
                EFFECT_TYPE_DEAF == nEffectType ||
                EFFECT_TYPE_DISEASE == nEffectType ||
                EFFECT_TYPE_FRIGHTENED == nEffectType ||
                EFFECT_TYPE_PARALYZE == nEffectType ||
                EFFECT_TYPE_POISON == nEffectType ||
                EFFECT_TYPE_SLEEP == nEffectType ||
                EFFECT_TYPE_STUNNED == nEffectType)
                RemoveEffect(oTarget, eEffect);

            eEffect = GetNextEffect(oTarget);
        }

        // Roll the healing 'damage'.
        int nHeal = PRCGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1, 8, 0, nAdd);
        if (GetLevelByClass(CLASS_TYPE_HEALER, OBJECT_SELF))
            nHeal += GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

        // Apply the healing and VFX.
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal, oTarget), oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget);
    }
    else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        PRCSignalSpellEvent(oTarget);

        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            int nTouch = PRCDoMeleeTouchAttack(oTarget);;
            if (nTouch > 0)
            {
                // Roll the damage (allowing for a critical) and let the target make a will save to
                // halve the damage.
                int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1 == nTouch ? 1 : 2, 8, 0, nAdd);
                nDamage += SpellDamagePerDice(OBJECT_SELF, 1);
                if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF)))
                {
                    nDamage /= 2;
                        if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                        {
                        nDamage = 0;
                        }
                }

                // Apply damage and VFX.
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_POSITIVE), oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget);
            }
        }
    }

    PRCSetSchool();
}
