/*:://////////////////////////////////////////////
//:: Spell Name
//:: Spell FileName
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    3E Spellcasting
    Universal
    Level: All 0
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You

    This lets you read the book of knowledge - all there is to know about
    casting spells in NwN and the 3.5E rules governing them. It pops up in
    conversation form.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Starts conversation (privatly, with self) for all information for spell
    casting is.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

void main()
{
    // Start conversation PHS_Magicoverview
    ClearAllActions();
    ActionStartConversation(OBJECT_SELF, "phs_magicoverview", TRUE, FALSE);
}
