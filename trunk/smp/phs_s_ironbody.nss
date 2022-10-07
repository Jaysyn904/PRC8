/*:://////////////////////////////////////////////
//:: Spell Name Iron Body
//:: Spell FileName PHS_S_IronBody
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Earth 8, Sor/Wiz 8
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level (D)

    This spell transforms your body into living iron, which grants you several
    powerful resistances and abilities.

    You gain damage reduction 15/+20. You are immune to blindness, critical hits,
    ability score damage, deafness, disease, drowning, electricity, poison,
    stunning, and all spells or attacks that affect your physiology or respiration,
    because you have no physiology or respiration while this spell is in effect.
    You take only half damage from acid and fire of all kinds. However, you also
    become vulnerable to rust attacks, as an iron golem is.

    You gain a +6 enhancement bonus to your Strength score, but you take a -6
    penalty to Dexterity as well (to a minimum Dexterity score of 3), and your
    speed is reduced to half normal. You have an spell failure chance of
    50% and a -8 penalty on armor-based skills, just as if you were clad in full
    plate armor. You cannot drink (and thus can’t use potions) or play wind
    instruments.

    Arcane Material Component: A small piece of iron that was once part of either
    an iron golem, a hero’s armor, or a war machine.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Currently this does this:

    - Will not work if the dex ability damage, slow or arcane spell failure or
    skill decrease cannot be applied.

    Got to do this - any "remove" spells will now correctly remove everything
    and stop abuse (as does any immunities). Might change, but it'd be hard
    to stop the bad stuff going and keeping the good stuff.

    The "respiratory spells" will be added as EffectSpellImmunity()
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_IRON_BODY)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration is 1 minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    // All "Good" effects
    effect eIron = EffectDamageReduction(15, DAMAGE_POWER_PLUS_TWENTY);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 6);
    effect eBlind = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
    effect eCritical = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eAbility = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
    effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);
    effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
    effect eElect = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
    effect eAcid = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50);
    effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
    // Special visual
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_IRONSKIN);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // Seperate bad effects
    effect ePenDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 6);
    effect ePenSkill = PHS_EffectArmorSkillsDecrease(8);
    effect ePenSlow = EffectMovementSpeedDecrease(50);
    effect ePenFail = EffectSpellFailure(50);

    // Link good effects
    effect eLink = EffectLinkEffects(eIron, eBlind);

    // We add the strength link only if we will havn't got any 6 or more bonuses
    // to strength
    if(PHS_GetHasAbilityBonusOfPower(oTarget, ABILITY_STRENGTH, 6) == 0)
    {
        eLink = EffectLinkEffects(eLink, eStr);
    }
    eLink = EffectLinkEffects(eLink, eCritical);
    eLink = EffectLinkEffects(eLink, eAbility);
    eLink = EffectLinkEffects(eLink, eDisease);
    eLink = EffectLinkEffects(eLink, ePoison);
    eLink = EffectLinkEffects(eLink, eStun);
    eLink = EffectLinkEffects(eLink, eElect);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eFire);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);
    // Add in bad effects.
    eLink = EffectLinkEffects(eLink, ePenDex);
    eLink = EffectLinkEffects(eLink, ePenSkill);
    eLink = EffectLinkEffects(eLink, ePenSlow);
    eLink = EffectLinkEffects(eLink, ePenFail);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_IRON_BODY, oTarget);

    // Remove any bonuses to strength of 5 or under.
    PHS_RemoveAnyAbilityBonuses(oTarget, ABILITY_STRENGTH, 5);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_IRON_BODY, FALSE);

    // Apply bad effects to the target
    //PHS_ApplyDuration(oTarget, ePenDex, fDuration);
    //PHS_ApplyDuration(oTarget, ePenSkill, fDuration);
    //PHS_ApplyDuration(oTarget, ePenSlow, fDuration);
    //PHS_ApplyDuration(oTarget, ePenFail, fDuration);

    // Apply effects to the target
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
