#include "sp_moon_inc"

void ApplyGoodHope(object oCaster, object oTarget, float fDuration,
    int nCasterLevel, int nSpellID)
{
    PRCSignalSpellEvent(oTarget, FALSE, nSpellID, oCaster);

    // Opposed spells cancel target by target. The subject is left with
    // neither effect; Good Hope is not applied after removing the despair.
    if(GetHasSpellEffect(SPELL_CRUSHING_DESPAIR, oTarget))
    {
        PRCRemoveEffectsFromSpell(oTarget, SPELL_CRUSHING_DESPAIR);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
        return;
    }

    if(GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster))
        return;
    if(PRCDoResistSpell(oCaster, oTarget,
        nCasterLevel + SPGetPenetr(oCaster)))
        return;

    MoonSpellRemoveSpellEffects(nSpellID, oTarget);

    effect eLink = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    eLink = EffectLinkEffects(eLink, EffectAttackIncrease(2, ATTACK_BONUS_MISC));
    eLink = EffectLinkEffects(eLink,
        EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BASE_WEAPON));
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLevel, oCaster);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    location lTarget = PRCGetSpellTargetLocation();
    float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(nCasterLevel));
    int nTargets = 0;

    // A 15-foot radius guarantees that no two automatically selected subjects
    // can be more than the rules' 30 feet apart.
    float fClusterRadius = FeetToMeters(15.0f);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fClusterRadius,
        lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nTargets < nCasterLevel)
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)
        && MoonSpellIsLivingCreature(oTarget))
        {
            ApplyGoodHope(oCaster, oTarget, fDuration, nCasterLevel, nSpellID);
            nTargets++;
        }

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fClusterRadius,
            lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    PRCSetSchool();
}
