/*:://////////////////////////////////////////////
//:: Spell Name Protection from Evil
//:: Spell FileName PHS_S_ProtFromEv
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration [Good]
    Level: Clr 1, Good 1, Pal 1, Sor/Wiz 1
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: No; see text

    This spell wards a creature from attacks by evil creatures and from mental
    control. It creates a magical barrier around the subject. The barrier moves
    with the subject and has two major effects.

    First, the subject gains a +2 deflection bonus to AC and a +2 resistance
    bonus on saves. Both these bonuses apply against attacks made or effects
    created by evil creatures.

    Second, the barrier blocks any attempt to possess the warded creature (by a
    magic jar attack, for example) or to exercise mental control over the
    creature, making them immune to Charm and Domination caused by evil
    creatures, that grant the caster ongoing control over the subject.

    Arcane Material Component: A little powdered silver with which you trace a
    circle on the floor (or ground) around the creature to be warded.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says.

    I removed the summoned part - it is much too hard to do realistically, and
    would be hard to add.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PROTECTION_FROM_EVIL)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Duration - 1 Minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
    effect eSaves = EffectSavingThrowIncrease(2, SAVING_THROW_ALL);
    effect eMental = PHS_CreateCompulsionImmunityLink();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eAC);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eMental);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Make it against chaotic people
    eLink = VersusAlignmentEffect(eLink, ALIGNMENT_ALL, ALIGNMENT_EVIL);

    // Remove previous castings
    if(PHS_RemoveProtectionFromAlignment(oTarget, ALIGNMENT_EVIL, 1)) return;

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PROTECTION_FROM_EVIL, FALSE);

    // Apply effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
