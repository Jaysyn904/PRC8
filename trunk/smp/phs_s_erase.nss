/*:://////////////////////////////////////////////
//:: Spell Name Erase
//:: Spell FileName PHS_S_Erase
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 1, Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One book or scroll
    Duration: Instantaneous
    Saving Throw: See text
    Spell Resistance: No

    Erase removes writings of either magical or mundane nature from a scroll or
    from one or two pages of paper, parchment, or similar surfaces. With this
    spell, you can remove explosive runes, a glyph of warding, a sepia snake
    sigil, or an arcane mark, but not illusory script or a symbol spell. You can
    only target a book or scroll in your inventory.

    To erase magic writing you must succeed on a caster level check (1d20 +
    caster level) against DC 15. (A natural 1 or 2 is always a failure on this
    check.) If you fail to erase explosive runes, a glyph of warding, or a sepia
    snake sigil, you accidentally activate that writing instead.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is possible:

    Can't do yet really. Not until the spells it removes are done. Rating: 4 or so though

    But I'll set it up here.

    Now, what would be funny, heh, is an Erase scroll with some spell
    cast on it :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_ERASE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oItem = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();

    // DC 15 for any magical writing. 1 or 2 auto fails.
    int nDC = 15;
    int nDiceRoll;

    // Declare effects
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_ERASE);

    // Check if item is valid and in our inventory
    if(GetIsObjectValid(oItem) &&
       GetItemPossessor(oItem) == oCaster &&
       GetObjectType(oItem) == OBJECT_TYPE_ITEM)
    {
        // We make a hidden check, it just will always play the VFX if its
        // a valid item
        PHS_ApplyVFX(oCaster, eVis);

        // Fire spell cast at event
        PHS_SignalSpellCastAt(oCaster, PHS_SPELL_ERASE, FALSE);

        // Check if they have explosive runes set
        if(GetLocalInt(oItem, PHS_EXPLOSIVE_RUNES_SET))
        {
            // Try and remove it
            nDiceRoll = d20();

            // Pass or fail? (1 or 2 auto fails!)
            if(nDiceRoll == 1 || nDiceRoll == 2 || nDiceRoll + nCasterLevel < nDC)
            {
                // FAIL - explode
                PHS_ExplosiveRunesExplode(oItem);
            }
            else
            {
                // PASS - remove it
                DeleteLocalInt(oItem, PHS_EXPLOSIVE_RUNES_SET);
                DeleteLocalInt(oItem, PHS_EXPLOSIVE_RUNES_DC);
                DeleteLocalObject(oItem, PHS_EXPLOSIVE_RUNES_OBJECT);
            }
        }
        // Check second things and so on.

        // glyph of warding,
        // or a sepia snake sigil
    }
}
