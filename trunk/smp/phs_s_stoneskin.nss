/*:://////////////////////////////////////////////
//:: Spell Name Stoneskin
//:: Spell FileName PHS_S_Stoneskin
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Drd 5, Earth 6, Sor/Wiz 4, Strength 6
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 10 min./level or until discharged
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The warded creature gains resistance to blows, cuts, stabs, and slashes. The
    subject gains damage reduction 10/+5. (It ignores the first 10 points of
    damage each time it takes damage, though a weapon with a +5 enhancement bonus
    or any magical attack bypasses the reduction.) Once the spell has prevented a
    total of 10 points of damage per caster level (maximum 150 points), it is
    discharged.

    Material Component: Granite and 250 gp worth of diamond dust sprinkled on
    the target’s skin.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Adamite weapons - impossible really...

    So, we make it the 3E +5 version - well, its better then nothing, and
    only very epic weapons can really pierce it.

    Uses standard effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_STONESKIN)) return;

    // Check for the Diamond Dust (250GP value)
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_DIAMOND_DUST, "Diamond Dust", "Stoneskin")) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Stoneskin amount to protect against is up to 150, at 10/+5
    int nStoneskinAmount = PHS_LimitInteger(nCasterLevel * 10, 150);

    // Declare effects
    effect eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nStoneskinAmount);
    effect eDur = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eStone, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_STONESKIN, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STONESKIN, FALSE);

    // Apply effects to the target
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
