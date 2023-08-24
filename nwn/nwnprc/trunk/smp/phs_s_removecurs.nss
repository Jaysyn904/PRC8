/*:://////////////////////////////////////////////
//:: Spell Name Remove Curse
//:: Spell FileName PHS_S_RemoveCurs
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 3, Clr 3, Pal 3, Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature or item touched
    Duration: Instantaneous
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    Remove curse instantaneously removes all curses on an object or a creature.
    Remove curse does not remove the curse from a cursed shield, weapon, or suit
    of armor, although the spell typically enables the creature afflicted with
    any such cursed item to remove and get rid of it. Certain special curses
    may not be countered by this spell or may be countered only by a caster of
    a certain level or higher.

    Remove curse counters and dispels bestow curse.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    In addtion to "Curses" this spell can remove:

    - "Seal Magic" if the caster of this spell's caster level is >= the level
      of the "Seal Magic"'s spell caster.
    -

    Added before other remove spells.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REMOVE_CURSE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nType, nSpell;

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Apply VFX
    PHS_ApplyVFX(oTarget, eVis);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_REMOVE_CURSE, FALSE);

    // We remove all effect of poison, and some other spell effects too.
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        nSpell = GetEffectSpellId(eCheck);
        // Special case spells
        switch(nSpell)
        {
            // Must beat the effect's caster level
            case PHS_SPELL_SEAL_MAGIC:
            {
                if(nCasterLevel >= GetLocalInt(GetEffectCreator(eCheck), "PHS_SPELL_CAST_BY_LEVEL_" + IntToString(PHS_SPELL_SEAL_MAGIC)))
                {
                    // Remove
                    RemoveEffect(oTarget, eCheck);
                }
            }
            default:
            {
                // - Remove all curses
                if(nType == EFFECT_TYPE_CURSE)
                {
                    RemoveEffect(oTarget, eCheck);
                }
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
}
