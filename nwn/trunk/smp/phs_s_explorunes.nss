/*:://////////////////////////////////////////////
//:: Spell Name Explosive Runes
//:: Spell FileName PHS_S_ExploRunes
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    SR applies.

    You trace these mystic runes upon a book, map, scroll, or similar object
    bearing written information. The runes detonate when read, such as when
    reading the spell on them or reading the book, dealing 6d6 points of force
    damage. The reader takes the full damage with no saving throw; any other
    creature within 10 feet of the runes is entitled to a Reflex save for half
    damage. The object on which the runes were written is instantly destroyed.

    You and any party members can read the protected writing without triggering
    the runes. Likewise, you can remove the runes whenever desired. Another
    creature can remove them with a successful dispel magic or erase spell, but
    attempting to dispel or erase the runes and failing to do so triggers the
    explosion.

    Note: Magic traps such as explosive runes are hard to detect and disable. A
    rogue (only) can use the Search skill to find the runes and Disable Device
    to thwart them, using his Disarm Magical Device tool to try and detect
    magical runes on an item. The DC in each case is 25 + spell level, or 28
    for explosive runes.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Must target a book or a scroll.

    If it hasn't got the property "Cast Spell", it adds "Read" to the items
    properties.

    It will be stripped each time a client enters a server, too, else it'd
    bodge because the ID of the caster would always be wrong.

    FAQ: Adding your own Explosive Runes with no caster:

    - Make sure the item has a "Read" cast spell, or, failing that, an actual
      spell to read. Read doesn't even have to work as long as the explosive
      runes are set up right.
    - Put the local integer variable PHS_EXPLOSIVE_RUNES_SET to 1
    - Set the integer, PHS_EXPLOSIVE_RUNES_DC, to the DC of the save you want
      (Default might be around DC16, for 10 + 3 + 3, the lowest level caster)

    Thats it! If no caster is found, you see, it is still used, but of course
    any function it uses just won't take into account alignment ETC.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook check - special note, it'd be funny if they read a scroll
    // with the actual spell on and got exploded!
    if(!PHS_SpellHookCheck(PHS_SPELL_EXPLOSIVE_RUNES)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration is permament - we set local variables to the object to use this
    // spell, so it will stay, and stay hidden, with the object.


    // Check if item is valid
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // Make sure it doesn't already have the runes (we don't tell the
        // caster one way or another)
        if(!GetLocalInt(oTarget, PHS_EXPLOSIVE_RUNES_SET))
        {
            // Set the variables
            SetLocalInt(oTarget, PHS_EXPLOSIVE_RUNES_SET, TRUE);
            SetLocalInt(oTarget, PHS_EXPLOSIVE_RUNES_DC, nSpellSaveDC);
            SetLocalObject(oTarget, PHS_EXPLOSIVE_RUNES_OBJECT, oCaster);
        }
    }
}
