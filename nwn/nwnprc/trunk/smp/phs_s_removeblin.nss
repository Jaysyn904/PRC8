/*:://////////////////////////////////////////////
//:: Spell Name Remove Blindness/Deafness
//:: Spell FileName PHS_S_RemoveBlindness
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 3, Pal 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Fortitude negates (harmless)
    Spell Resistance: Yes (harmless)

    Remove blindness/deafness cures blindness or deafness (your choice),
    whether the effect is normal or magical in nature. The spell does not
    restore ears or eyes that have been lost, but it repairs them if they are
    damaged.

    Remove blindness/deafness counters and dispels blindness/deafness.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can remove one, or the other...

    Make sure to test, uses a sub-dial for now.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REMOVE_BLINDNESS_DEAFNESS)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellId = GetSpellId();
    int nType, nToRemove;

    // Check what to remove
    if(nSpellId == PHS_SPELL_REMOVE_BLINDNESS_DEAFNESS_B)
    {
        // Remove deafness
        nToRemove = EFFECT_TYPE_DEAF;
    }
    else// PHS_SPELL_REMOVE_BLINDNESS_DEAFNESS_A
    {
        // Remove blindness
        nToRemove = EFFECT_TYPE_BLINDNESS;
    }

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Apply VFX
    PHS_ApplyVFX(oTarget, eVis);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_REMOVE_BLINDNESS_DEAFNESS, FALSE);

    // We remove all effect of blindness or deafness
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        // - Remove all of XXX
        if(nType == nToRemove)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
}
