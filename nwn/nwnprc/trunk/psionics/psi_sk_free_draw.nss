//::///////////////////////////////////////////////
//:: Soulknife: Free Draw
//:: psi_sk_free_draw
//::///////////////////////////////////////////////
/** Soulknife: Free Draw
    Creates the mindblade as a free action.
    Implemented by having the ReqAction column for
    the feat as 0. Use limited to 1 / round.


    @author Ornedan
    @date   Created  - 04.04.2005
    @date   Modified - 01.09.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"

void main()
{
    object oPC = OBJECT_SELF;

    // Check whether the PC can take a free action and is commandable
    if(!(GetCanTakeFreeAction(oPC, TRUE) && GetCommandable(oPC)))
        return;

    if(!GetLocalInt(oPC, FREEDRAW_USED))
    {
        // Mark the Free Draw attempt for this round used
        SetLocalInt(oPC, FREEDRAW_USED, TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oPC, FREEDRAW_USED));

        // Run the mindblade manifestation script as normal
        ExecuteScript("psi_sk_manifmbld", oPC);
    }
    else
        SendMessageToPCByStrRef(oPC, 16824496); // "You cannot use this feat more than once per round."
}