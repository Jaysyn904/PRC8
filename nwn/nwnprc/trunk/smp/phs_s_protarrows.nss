/*:://////////////////////////////////////////////
//:: Spell Name Protection from Arrows
//:: Spell FileName PHS_S_ProtArrows
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Sor/Wiz 2
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 hour/level or until discharged
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The warded creature gains resistance to piercing weapons. The subject gains
    damage resistance 10/- against piercing weapons. Once the spell has
    prevented a total of 10 points of damage per caster level (maximum 100
    points), it is discharged.

    Focus: A piece of shell from a tortoise or a turtle.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Affects all piercing to the limit.

    Shamefully, all piercing is a bit bad, but oh well...
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PROTECTION_FROM_ARROWS)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Damage is 10 * Caster level, max of 100.
    int nDamageMax = PHS_LimitInteger(nCasterLevel * 10, 100);

    // Delcare effects
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_PROTECTION_ARROWS);
    effect eDamageResistance = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10, nDamageMax);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eDamageResistance);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_PROTECTION_FROM_ARROWS, oTarget);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PROTECTION_FROM_ARROWS, FALSE);

    // Apply effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
