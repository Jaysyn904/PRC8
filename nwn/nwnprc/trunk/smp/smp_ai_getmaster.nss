/*:://////////////////////////////////////////////
//:: Name Check if master
//:: FileName SMP_AI_GetMaster
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is a conversation script.

    Returns TRUE if the the PC is our master or spell caster master raster blaster
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_CONSTANT"

int StartingConditional()
{
    // Get the PC
    object oPC = GetPCSpeaker();

    // Check
    if(GetMaster(OBJECT_SELF) == oPC ||
       GetLocalObject(OBJECT_SELF, SMP_MASTER) == oPC)
    {
        return TRUE;
    }
    return FALSE;
}
