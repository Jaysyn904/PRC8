/*:://////////////////////////////////////////////
//:: Spell Name Magic Circle against Evil
//:: Spell FileName PHS_S_MagicCirE
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration [Good]
    Level: Clr 3, Good 3, Pal 3, Sor/Wiz 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Area: 3.33-M.-radius emanation from touched creature
    Duration: 10 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: No; see text

    All creatures within the area gain the effects of a protection from evil
    spell, gaining +2 AC, +2 saves and immunity to possession by evil creatures.

    In addition, no nongood summoned creatures can enter the area either. You
    must overcome a creature’s spell resistance in order to keep it at bay, but
    the deflection and resistance bonuses and the protection from mental control
    apply regardless of enemies’ spell resistance. If the summoned creature is
    already in the area when the spell then they ignore the resistance check.
    The protection against summoned creatures ends if the warded creature makes
    an attack against or tries to force the barrier against the blocked creature.

    This spell is not cumulative with protection from evil and vice versa.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE placed on the target.

    The On Enter will do pushback and apply effects. It applies it to ALL creatures.

    Only outsiders and summoned creatures will be affected by the pushback.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // 10 minutes/level duration
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_MAGCIR_EVIL);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE);

    // Remove previous castings
    PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_AREA_OF_EFFECT, PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oTarget);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 1.0 seconds.
    string sLocal = PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL);
    SetLocalInt(oCaster, sLocal, TRUE);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sLocal));

    // Apply effects
    PHS_ApplyDuration(oTarget, eAOE, fDuration);
}
