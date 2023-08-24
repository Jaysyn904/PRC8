/*:://////////////////////////////////////////////
//:: Spell Name Arcane Mark
//:: Spell FileName PHS_S_ArcaneMark
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Universal
    Level: Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: 0M.
    Effect: One personal rune or mark, all of which must fit within 0.33 sq. M.
    Duration: Permanent
    Saving Throw: None
    Spell Resistance: No

    This spell allows you to inscribe your personal rune or mark, which can
    consist of no more than six characters. The writing can be visible or
    invisible. An arcane mark spell enables you to etch the rune upon any
    substance without harm to the material upon which it is placed. If an
    invisible mark is made, a detect magic spell causes it to glow and be visible,
    though not necessarily understandable.

    See invisibility, true seeing, a gem of seeing, or a robe of eyes likewise
    allows the user to see an invisible arcane mark. A read magic spell reveals
    the words, if any. The mark cannot be dispelled, but it can be removed by
    the caster or by an erase spell.

    If an arcane mark is placed on a living being, normal wear gradually causes
    the effect to fade in about a month.

    Arcane mark must be cast on an object prior to casting instant summons on
    the same object (see that spell description for details).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Creates a placeable which does the visual effect and stuff.

    Mainly a placeholder!

    Rating: 1: Need to add a thing to look at the markings (placeable
    probably), and set the text on that. Text is setup beforehand.

    Set the text on chat, and when set, set to a custom number thingy.

    Then make the placable have that custom number as it's text - like a converation,
    because it works.

    Possibly make it so it can never be made invisible.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_ARCANE_MARK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetLocation(oCaster);
}
