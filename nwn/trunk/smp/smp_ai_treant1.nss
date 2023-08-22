/*:://////////////////////////////////////////////
//:: Name Treant Changestaff Monster - On Heartbeat
//:: FileName SMP_AI_Treant1
//:://////////////////////////////////////////////
    On Heartbeat.

    Moves to the caster, depending on orders.

    1 = Heartbeat. They do all the work for the staff.

    This will drop it if we are dispelled.

    Use default On Spawn.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Delcare major variables
    object oSelf = OBJECT_SELF;
    object oMaster = GetMaster();

    // Make sure we have not been dispelled.
    if(!GetHasSpellEffect(PHS_SPELL_CHANGESTAFF))
    {
        // Drop the staff!
        object oStaff = GetLocalObject(oSelf, "PHS_CHANGESTAFF_STAFF");

        // Copy it to our location
        CopyItem(oStaff, OBJECT_INVALID, TRUE);
        // Destroy original
        DestroyObject(oStaff);

        // Go
        //SMPAI_DispelSelf();
        return;
    }

    // Check if in combat
    if(!GetIsInCombat())
    {
        // Move to the master
        ClearAllActions();
        ActionForceFollowObject(oMaster, 2.0);
    }
}
