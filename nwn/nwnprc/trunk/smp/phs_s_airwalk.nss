/*:://////////////////////////////////////////////
//:: Spell Name Air Walk
//:: Spell FileName PHS_S_AirWalk
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Air]
    Level: Air 4, Clr 4, Drd 4
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature (Gargantuan or smaller) touched
    Duration: 10 min./level
    Saving Throw: None
    Spell Resistance: Yes (harmless)

    This is a DM run spell, and this spell only applies a visual effect.

    The subject can tread on air as if walking on solid ground. Moving upward is
    similar to walking up a hill. The maximum upward or downward angle possible
    is 45 degrees, at a rate equal to one-half the air walker’s normal speed.

    A strong wind (21+ mph) can push the subject along or hold it back. At the
    end of its turn each round, the wind blows the air walker 5 feet for each 5
    miles per hour of wind speed. The creature may be subject to additional
    penalties in exceptionally strong or turbulent winds, such as loss of control
    over movement or physical damage from being buffeted about.

    Should the spell duration expire while the subject is still aloft, the magic
    fails slowly. The subject floats downward 60 feet per round for 1d6 rounds.
    If it reaches the ground in that amount of time, it lands safely. If not, it
    falls the rest of the distance, taking 1d6 points of damage per 10 feet of
    fall. Since dispelling a spell effectively ends it, the subject also
    descends in this way if the air walk spell is dispelled, but not if it is
    negated by an antimagic field.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    DM run spell.

    Visual effect, thats about it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oTarget = GetSpellTargetObject();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_AIR_WALK, FALSE);

    // Create an air pulse effect
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);

    // Apply the effect.
    PHS_ApplyVFX(oTarget, eVis);

    // Signal the spell cast to DM's.
    PHS_AlertDMsOfSpell("Air Walk", PHS_GetSpellSaveDC(), PHS_GetCasterLevel());
}
