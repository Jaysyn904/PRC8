/*:://////////////////////////////////////////////
//:: Spell Name Mage Hand
//:: Spell FileName PHS_S_MageHand
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 0, Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One nonmagical, unattended object weighing up to 5 lb.
    Duration: Instant
    Saving Throw: None
    Spell Resistance: No

    You point your finger at an object and can lift it and move it at will from
    a distance. As long as it is light enough, you bring it towards you quickly,
    and it is dropped at your feet.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed to an instant effect - can be useful for grabbing objects from
    afar. No save or SR for this. Object must be unattended.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGE_HAND)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();  // Item
    location lCaster = GetLocation(oCaster);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_MAGE_HAND, FALSE);

    // Check oTarget's type
    if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM &&
      !GetIsObjectValid(GetItemPossessor(oTarget)))
    {
        // Get oTargets weight and plot status. GetWeight is 10ths of pounds.
        // A 3.5lbs object will return 35 with this.
        if(GetWeight(oTarget) <= 50 && !GetPlotFlag(oTarget))
        {
            // Send message to caster and move the target item
            FloatingTextStringOnCreature("You have sucessfully grabbed and moved " + GetName(oTarget), oCaster, FALSE);
            // Copy item
            CopyObject(oTarget, lCaster);
        }
    }
}
