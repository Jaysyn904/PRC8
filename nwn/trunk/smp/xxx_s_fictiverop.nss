/*:://////////////////////////////////////////////
//:: Spell Name Fictive Rope
//:: Spell FileName XXX_S_FictiveRop
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Also known as: Muntazea’s Fictive Rope
    Level: Sor/Wiz 1
    Components: V, M
    Casting Time: 1 standard action
    Range: Personal
    Effect: Creates rope
    Duration: 1 hour/level
    Saving Throw: None
    Spell Resistance: No
    Source: Various (Israfel666)

    This spell creates a normal length of rope, 35 meters long, suitable for
    animate rope. You cannot sell or drop the rope.

    Material Component: A piece of string, twine or thread.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    One rope thing. Gets destroyed:

    - When entering a server
    - After a DelayCommand() to delete it from the game.

    Basically, covers all bases. If they leave when the duratoin runs out (or
    before) it goes. If they do not, it does at the normal time.

    Oh, and it is cursed - cannot be sold or dropped.

    It is, however, only really useful for Animate Rope.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_FICTIVE_ROPE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // Duration, 1 hour a level
    float fDuration = SMP_GetDuration(SMP_HOURS, nCasterLevel, nMetaMagic);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_FICTIVE_ROPE, FALSE);

    // Create the rope (Cursed, Plotted)
    object oNewRope = CreateItemOnObject("xxx_ropestuff", oTarget);

    // Delay the deletion
    DelayCommand(fDuration, DestroyObject(oNewRope));
}
