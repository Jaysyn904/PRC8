/*:://////////////////////////////////////////////
//:: Spell Name Dimensional Lock : On Exit
//:: Spell FileName PHS_S_DimenlockB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Removes one lot of spell visuals from Dimensional Lock.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Only remove from this AOE's AOE IF we failed, and a local is == 2.
    object oSelf = OBJECT_SELF;
    object oTarget = GetExitingObject();
    string sId = "PHS_DIMEN_LOCK_SR" + ObjectToString(oTarget);
    // Local
    if(GetLocalInt(oSelf, sId) == 2)
    {
        // Exit - remove effects
        PHS_AOE_OnExitEffects(PHS_SPELL_DIMENSIONAL_LOCK);
    }
}
