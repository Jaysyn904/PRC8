/*
    sp_ironbody

    Transmutation
    Level: Earth 8, Sor/Wiz 8
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level (D)
    This spell transforms your body into living iron, which grants you several powerful resistances and abilities.
    You gain damage reduction 15/adamantine. You are immune to blindness, critical hits, ability score damage, deafness, disease, drowning, electricity, poison, stunning, and all spells or attacks that affect your physiology or respiration, because you have no physiology or respiration while this spell is in effect. You take only half damage from acid and fire of all kinds. However, you also become vulnerable to all special attacks that affect iron golems.
    You gain a +6 enhancement bonus to your Strength score, but you take a –6 penalty to Dexterity as well (to a minimum Dexterity score of 1), and your speed is reduced to half normal. You have an arcane spell failure chance of 50% and a –8 armor check penalty, just as if you were clad in full plate armor. You cannot drink (and thus can’t use potions) or play wind instruments.
    Your unarmed attacks deal damage equal to a club sized for you (1d4 for Small characters or 1d6 for Medium characters), and you are considered armed when making unarmed attacks.
    Your weight increases by a factor of ten, causing you to sink in water like a stone. However, you could survive the crushing pressure and lack of air at the bottom of the ocean—at least until the spell duration expires.
    Arcane Material Component: A small piece of iron that was once part of either an iron golem, a hero’s armor, or a war machine.

    By: Flaming_Sword
    Created: Sept 27, 2006
    Modified: Sept 27, 2006

    Copied from psionics
*/

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    //int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    //int nPenetr = nCasterLevel + SPGetPenetr();

    effect eLink    =                          EffectDamageReduction(15, DAMAGE_POWER_PLUS_FIVE);
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
           eLink    = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_DROWN));
           eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100));
           eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50));
           eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50));
           eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 6));
           eLink    = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
           eLink    = EffectLinkEffects(eLink, EffectSpellFailure(50, SPELL_SCHOOL_GENERAL));
           eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BLUR));
           eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
           eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
           eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
    effect eVis     =                         EffectVisualEffect(VFX_IMP_HEAD_ODD);
           eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION));
           eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE));
    effect eDex     = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, 6));

    float fDuration = 60.0f * nCasterLevel;
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, fDuration);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    PRCSetSchool();
}