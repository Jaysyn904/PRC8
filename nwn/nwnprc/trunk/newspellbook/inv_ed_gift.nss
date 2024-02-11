#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(!CheckTurnUndeadUses(oPC, 1))
    {
        SpeakStringByStrRef(40550);//"This ability is tied to your turn undead ability, which has no more uses for today."
        return;
    }

    int nDiscLvl = GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oPC);
    int nWarlockLvl = GetLevelByClass(CLASS_TYPE_WARLOCK, oPC);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nSpell = GetSpellId();
    effect eGift;

    if(nSpell == INVOKE_FEARFUL_GLARE)
    {
        object oTarget = PRCGetSpellTargetObject();

        if(!PRCGetIsAliveCreature(oTarget))
        {
            FloatingTextStringOnCreature("Target is not a living creature!", oPC, FALSE);
            return;
        }
        if(GetHitDice(oTarget) > GetHitDice(oPC))
        {
            FloatingTextStringOnCreature("Target is too powerful!", oPC, FALSE);
            return;
        }

        int nDC = 10 + nDiscLvl + nCha;
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
        {
            eGift = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR), EffectShaken());
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGift, oTarget, RoundsToSeconds(1));
        }
    }
    if(nSpell == INVOKE_DAMAGE_REDUCTION)
    {
        int nDur = max(3 + nCha, 1);
        int nRedAmt = ((nWarlockLvl + 1) / 4) + (max(nDiscLvl / 2, 1));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReduction(nRedAmt, DAMAGE_POWER_PLUS_THREE), oPC, RoundsToSeconds(nDur));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oPC);
    }
    if(nSpell == INVOKE_FIENDISH_RESISTANCE)
    {
        int nDur = max(3 + nCha, 1);
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        {
            FloatingTextStringOnCreature("Your deity must be evil!", oPC, FALSE);
            return;
        }

        int nResistAmt = nWarlockLvl >= 20 ? 10 : 5;
            nResistAmt += GetHasFeat(FEAT_MASTER_OF_THE_ELEMENTS, oPC) ? 10 : 0;
            nResistAmt += 10 + nDiscLvl;
        eGift = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_ACID, nResistAmt), EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistAmt));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGift, oPC, RoundsToSeconds(nDur));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION), oPC);
    }
    if(nSpell == INVOKE_PROTECTIVE_AURA)
    {
        int nDur = max(3 + nCha, 1);
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        {
            FloatingTextStringOnCreature("Your deity must be good!", oPC, FALSE);
            return;
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "", "", "sp_gen_exit"), oPC, RoundsToSeconds(nDur));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC);

        //Setup Area Of Effect object
        object oAoE = GetAreaOfEffectObject(GetLocation(oPC), GetAreaOfEffectTag(AOE_MOB_CIRCGOOD), oPC);
        SetAllAoEInts(nSpell, oAoE, GetSpellSaveDC(), 0, nDiscLvl);
    }
    if(nSpell == INVOKE_STRENGTH_OF_WILL)
    {
        int nDur = max(3 + nCha, 1);
        int nBonus = max(nDiscLvl / 2, 1);

        eGift = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE), EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus, SAVING_THROW_TYPE_MIND_SPELLS));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGift, oPC, RoundsToSeconds(nDur));
    }
    if(nSpell == INVOKE_WILD_FRENZY)
    {
        int nDur = max(3 + nCha, 1);
        int nTempHP = 2 * nDiscLvl;
        if(GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
        {
            FloatingTextStringOnCreature("Your deity must be chaotic!", oPC, FALSE);
            return;
        }

        eGift = EffectLinkEffects(EffectAttackIncrease(2), EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGift, oPC, RoundsToSeconds(nDur));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nTempHP), oPC, RoundsToSeconds(nDur));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oPC);
    }
}