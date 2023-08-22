/*:://////////////////////////////////////////////
//:: Spell Name Divine Power
//:: Spell FileName phs_s_divinepowr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Personal Target: You Duration: 1 round/level

    Calling upon the divine power of your patron, you imbue yourself with
    strength and skill in combat. Your base attack bonus becomes equal to your
    character level (which may give you additional attacks), you gain a +6
    enhancement bonus to Strength, and you gain 1 temporary hit point per caster
    level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description. :-)

    We apply it better then the NwN way.

    We can use GetBaseAttackBonus :-D
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_DIVINE_POWER)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Broken the rule of order (well, not really a rule) but we MUST remove
    // the spells effects first.

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DIVINE_POWER, oTarget);

    // Get old BAB
    int nOldBAB = GetBaseAttackBonus(oTarget);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Get duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Calculate the extra BAB we should add for extra attacks
    // - Based on character level (Hit dice) of the caster
    int nNewBAB = GetHitDice(oTarget) - nOldBAB;;

    int nNewAttack = nNewBAB;
    if(nNewAttack > 10) nNewAttack = 10;

    // Extra attacks. Get 1 per 5 levels, min of 1, so have new BAB take old BAB.
    int nExtraAttacks = (PHS_LimitInteger(nNewBAB/5) - PHS_LimitInteger(nOldBAB/5));
    if(nExtraAttacks > 5) nExtraAttacks = 5;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eStrength = EffectAbilityIncrease(ABILITY_STRENGTH, 6);
    effect eHP = EffectTemporaryHitpoints(nCasterLevel);
    effect eAttack = EffectAttackIncrease(nNewAttack);

    effect eLink = EffectLinkEffects(eCessate, eHP);
    // We add the strength link only if we will havn't got any 6 or more bonuses
    // to strength
    if(PHS_GetHasAbilityBonusOfPower(oTarget, ABILITY_STRENGTH, 6) == 0)
    {
        eLink = EffectLinkEffects(eLink, eStrength);
    }
    eLink = EffectLinkEffects(eLink, eAttack);

    // If no extra attacks, we do not use eExtraAttacks
    if(nExtraAttacks > 0)
    {
        effect eExtraAttacks = EffectModifyAttacks(nExtraAttacks);
        eLink = EffectLinkEffects(eLink, eExtraAttacks);
    }

    // Remove any bonuses to strength of 5 or under.
    PHS_RemoveAnyAbilityBonuses(oTarget, ABILITY_STRENGTH, 5);

    //Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DIVINE_POWER, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
