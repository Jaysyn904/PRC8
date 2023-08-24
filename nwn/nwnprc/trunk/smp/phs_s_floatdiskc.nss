/*:://////////////////////////////////////////////
//:: Name Floating Disk Heartbeat
//:: FileName PHS_S_FloatDiskC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is the heartbeat script.

    It checks weight allowances, and what weight it has. Drops things until
    it has under the weight limit.

    Wieght limit is 100lbs/level.

    GetWeight returns 10ths of pounds, so we'd normally divide by 10 to get the
    real lbs value. Its set to know it is 10ths of pounds, however, and caster
    limit is 1000/level for this purpose.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oSelf = OBJECT_SELF;
    object oCaster = GetLocalObject(oSelf, "PHS_MASTER");

    // check if master is valid and we havn't been dispelled!
    if(!GetIsObjectValid(oCaster) || GetDistanceToObject(oCaster) > 8.0 ||
       !GetHasSpellEffect(PHS_SPELL_FLOATING_DISK))
    {
        // This means they are in the same area, and too far away, or not
        // valid, or been displled.
        SetPlotFlag(oSelf, FALSE);
        DestroyObject(oSelf);
        return;
    }

    // Get weight allowance
    int nWeight = GetWeight();
    int nLimit = GetLocalInt(oSelf, "PHS_WEIGHT_LIMIT");

    // Drop things
    if(nWeight > nLimit)
    {
        FloatingTextStringOnCreature("A Floating disk is holding too much", oCaster, FALSE);
        // Drop the first things until we get under nLimit.
        object oItem = GetFirstItemInInventory(oSelf);
        while(GetIsObjectValid(oItem) && nWeight > nLimit)
        {
            // Make us drop it.
            nWeight -= GetWeight(oItem);
            CopyItem(oItem, OBJECT_INVALID, TRUE);
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);

            // Next item
            oItem = GetNextItemInInventory(oSelf);
        }
    }

    // Move to casters location - 5ft away, however (say, 2 meters)
    ClearAllActions();
    ActionMoveToObject(oCaster, FALSE, 2.0);
}
