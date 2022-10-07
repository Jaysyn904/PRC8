/*:://////////////////////////////////////////////
//:: Spell Name Flesh to Stone
//:: Spell FileName phs_s_fleshstone
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Flesh to Stone
    Transmutation
    Level: Sor/Wiz 6
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Spell Resistance: Yes

    The subject, along with all its carried gear, turns into a mindless, inert
    statue (with all the bonuses of a statue, such as immunity to mind-affecting
    spells). If the statue resulting from this spell is damaged, the subject
    (if ever returned to its original state) has similar damage. The creature
    is not dead, but it does not seem to be alive either when viewed with
    spells such as deathwatch.

    Only creatures made of flesh are affected by this spell.

    Material Component: Lime, water, and earth.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Petrify, using the NwN petrify effect

    Wappered, similar to the one in SoU, but this has the resist spell outside it

    The petrify effect also gives bonus immunities of a construct and damage
    resistance of 5/- to phisical damage.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FLESH_TO_STONE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FLESH_TO_STONE);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Spell resistance and immunity check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Save and petrify, and immune to petrify, wrapper.
            PHS_SpellFortitudePetrify(oTarget, nCasterLevel, nSpellSaveDC);
        }
    }
}
