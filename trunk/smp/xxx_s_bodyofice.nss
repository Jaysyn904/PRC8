/*:://////////////////////////////////////////////
//:: Spell Name Body of Ice
//:: Spell FileName XXX_S_BodyofIce
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Cold]
    Level: Drd 4, Sor/Wiz 4
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Personal
    Target: Caster
    Duration: 1 round/level
    Saving Throw: None
    Spell Resistance: No (Harmless)
    Source: Various (cthulhu)

    The transmuted caster's body is transformed into a mixture of pure ice and
    magical energy. Because of the caster's new form they gain the subtype
    [Cold] (immune to all cold damage and take double damage from fire), and are
    immune to critical hits.

    In this ice form the caster finds themselves more in tune with the
    Quasi-Elemental Plane of Ice and understands its detail and essence. All of
    their spells with the cold descriptor gain a +2 to their saving throw DC.

    Focus: A small crystal that comes from the center of a glacier.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Simple and easy, eh what?

    No, really, good advantages (if specific) and the immunity to critical hits
    is great.

    If the critical hit immunity is to much, +AC or something might be better,
    or some damage shield (does cold damage, small amount).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_BODY_OF_ICE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Duration is 1 round/level
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_ICESKIN);
    effect eImmunityIncrease = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
    effect eImmunityDecrease = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 100);
    effect eCritical = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eImmunityIncrease);
    eLink = EffectLinkEffects(eLink, eImmunityDecrease);
    eLink = EffectLinkEffects(eLink, eCritical);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous casting
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_BODY_OF_ICE, oTarget);

    //Fire cast spell at event for the specified target
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BODY_OF_ICE, FALSE);

    // Apply the VFX impact and effects
    SMP_ApplyDuration(oTarget, eLink, fDuration);
}
