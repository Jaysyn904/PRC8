/*:://////////////////////////////////////////////
//:: Spell Name Read Magic
//:: Spell FileName PHS_S_ReadMagic
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 0, Clr 0, Drd 0, Pal 1, Rgr 1, Sor/Wiz 0
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Touch
    Target: Scroll or book touched
    Duration: Instantaneous

    By means of read magic, you can decipher magical inscriptions on objects-books,
    scrolls, and the like-that would otherwise be unintelligible. This
    deciphering does not normally invoke the magic contained in the writing,
    although it may do so in the case of a cursed scroll. Furthermore, once
    the spell is cast and you have read the magical inscription, you are
    thereafter able to read that particular writing without recourse to the use
    of read magic, thusly, it makes the item identified.

    Focus: A clear crystal or mineral prism.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is casted on an unidentified scroll, and reveals its spell.

    Simple, and easier to do :-D

    The glymph stuff isn't in just yet, but is in description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    //spellhook
    if (!X2PreSpellCastCode()) return;
    // End of Spell Cast Hook

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nType = -1;
    if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        nType = GetBaseItemType(oTarget);

    // Check target - must be scroll or book
    if(!GetIdentified(oTarget) &&
       (nType == BASE_ITEM_SPELLSCROLL ||
       nType == BASE_ITEM_ENCHANTED_SCROLL ||
       nType == BASE_ITEM_BOOK))
    {
        SetIdentified(oTarget, TRUE);
        FloatingTextStringOnCreature("*You have identified the writings on the scroll as " + GetName(oTarget) + "*", oCaster, FALSE);
    }
    else
    {
        // Not something valid to identify!
        FloatingTextStringOnCreature("*You cannot identify that item*", oCaster, FALSE);
        return;
    }

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

    // Signal event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_READ_MAGIC, FALSE));

    // Apply effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

    // Also play animation - reading
    ActionDoCommand(PlayAnimation(ANIMATION_FIREFORGET_READ));

    PRCSetSchool();
}
