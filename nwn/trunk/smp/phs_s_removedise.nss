/*:://////////////////////////////////////////////
//:: Spell Name Remove Disease
//:: Spell FileName PHS_S_RemoveDise
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 3, Drd 3, Rgr 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Fortitude negates (harmless)
    Spell Resistance: Yes (harmless)

    Remove disease cures all diseases that the subject is suffering from. The
    spell also kills parasites, including green slime and others. Certain special
    diseases may not be countered by this spell or may be countered only by a
    caster of a certain level or higher.

    Note: Since the spell’s duration is instantaneous, it does not prevent
    reinfection after a new exposure to the same disease at a later date.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Removes disease.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REMOVE_DISEASE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nType;

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Apply VFX
    PHS_ApplyVFX(oTarget, eVis);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_REMOVE_DISEASE, FALSE);

    // We remove all effect of disease
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        // - Remove all of Disease
        if(nType == EFFECT_TYPE_DISEASE)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
}
