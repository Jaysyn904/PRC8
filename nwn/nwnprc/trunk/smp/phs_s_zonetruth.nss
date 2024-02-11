/*:://////////////////////////////////////////////
//:: Spell Name Zone of Truth
//:: Spell FileName PHS_S_ZoneTruth
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Clr 2, Pal 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Area: 6.67M-radius (20-ft.) emanation
    Duration: 1 min./level
    Saving Throw: Will negates
    Spell Resistance: Yes
    DM Spell: Partly; see text

    Creatures within the emanation area (or those who enter it) can’t speak any
    deliberate and intentional lies. Each potentially affected creature is
    allowed a (private) save to avoid the effects when the spell is cast or
    when the creature first enters the emanation area. Affected creatures are
    aware of this enchantment. Therefore, they may avoid answering questions to
    which they would normally respond with a lie, or they may be evasive as long
    as they remain within the boundaries of the truth. Creatures who leave the
    area are free to speak as they choose.

    Note that any unwilling PC or DM will not undertake the spell properly. Only
    each player (and any DMs in the area) will know the results of the saving
    throw. Normal resistance and saves are done so that the caster will not know
    if they are forced to tell the truth or not.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Invisible Zone of Truth;

    - DM run for NPC's.
    - DM's know all results of all saving throws. Displayed to DM's privatly.

    PC's must DIY, although the saves are made privatly and not against the
    enemy player at all.

    Instead, I have added a (placeable) object into the SMP area, tagged
    as "PHS_ZONE_OF_TRUTH" and thus use that to pass into the parameters, as
    well as the Resisting spell part (ok, not too good because SR might always
    suceed, but oh well).

    The main thing is the caster DOES NOT KNOW if the person has passed or failed
    in the saves or resistance checks. For personal spells, it is fine, for this,
    it is not.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"


void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ZONE_OF_TRUTH)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_ZONE_OF_TRUTH);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
