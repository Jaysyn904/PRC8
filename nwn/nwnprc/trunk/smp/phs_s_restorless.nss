/*:://////////////////////////////////////////////
//:: Spell Name Restoration, Lesser
//:: Spell FileName PHS_S_RestorLess
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 2, Drd 2, Pal 1
    Components: V, S
    Casting Time: 3 rounds
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    Lesser restoration dispels any tempoary magical effects reducing the
    subject’s ability scores. It also eliminates any fatigue and exhaustion
    suffered by the character. It does not restore permanent ability drain.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    3 rounds casting time.

    Will remove (dispel) all magical, tempoary, ability reducing effects, and
    remove fatigue and exhaustion too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RESTORATION_LESSER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Apply VFX
    PHS_ApplyVFX(oTarget, eVis);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RESTORATION_LESSER, FALSE);

    // Remove fatigue and exhaustion
    PHS_RemoveFatigue(oTarget);

    // We remove all effect of ability decrease, and some other spell effects too.
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        // Dispel tempoary, magical ones.
        if(GetEffectType(eCheck) == EFFECT_TYPE_ABILITY_DECREASE &&
           GetEffectDurationType(eCheck) == DURATION_TYPE_TEMPORARY &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
}
