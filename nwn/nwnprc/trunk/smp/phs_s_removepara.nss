/*:://////////////////////////////////////////////
//:: Spell Name Remove Paralysis
//:: Spell FileName PHS_S_RemovePara
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 2, Pal 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    You can free one or more creatures from the effects of any temporary
    paralysis or related magic, including a ghoul’s touch or a slow spell. For
    the creature this spell is cast on, the paralysis is negated.

    The spell does not restore ability scores reduced by penalties, damage, or
    drain.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Removes paralysis.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REMOVE_PARALYSIS)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nType;

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Apply VFX
    PHS_ApplyVFX(oTarget, eVis);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_REMOVE_PARALYSIS, FALSE);

    // We remove all effect of paralysis
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        // - Remove all of Paralysis
        if(nType == EFFECT_TYPE_PARALYZE)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
}
