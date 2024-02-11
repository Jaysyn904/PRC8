/*:://////////////////////////////////////////////
//:: Spell Name Modify Memory
//:: Spell FileName PHS_S_ModifyMemo
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Modify Memory
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 4
    Components: V, S
    Casting Time: 1 round; see text
    Range: Close (8M)
    Target: One living creature
    Duration: Permanent
    Saving Throw: Will negates
    Spell Resistance: Yes
    DM Spell: Yes

    This is a DM spell. The visual effects and saves are present, but nothing
    else. You should make sure the target is able to change its memory, such
    as another PC, or have a DM present if you are modifying the memory of an NPC.

    You reach into the subject’s mind and modify as many as 5 minutes of its
    memories in one of the following ways.

    More description.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    DM spell only.

    Will have the save and SR checks as normal, and relays to DMs and the
    caster.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MODIFY_MEMORY)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();

    // Declare Effects
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MODIFY_MEMORY);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MODIFY_MEMORY, FALSE);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Check spell resistance and immunities.
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Immunity: Mind spells
            if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
               !PHS_SpellsIsMindless(oTarget))
            {
                // Make Will Save to negate effect
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Notify DM's:
                    PHS_AlertDMsOfSpell("Modify Memory (SUCEEDED)", nSpellSaveDC, nCasterLevel);

                    // Apply VFX Impact and daze effect
                    PHS_ApplyVFX(oTarget, eVis);
                    return;
                }
            }
        }
    }
    // Failed
    // Notify DM's:
    PHS_AlertDMsOfSpell("Modify Memory (FAILED)", nSpellSaveDC, nCasterLevel);
}
