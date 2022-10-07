/*:://////////////////////////////////////////////
//:: Spell Name AOE - Heartbeat - Auto Detected Magical Trap AOE, level 3.
//:: Spell FileName PHS_S_AOE_Auto3
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Sets to be automatically detected, level 3 spell "magical trap".
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Automatically detected
    if(!GetLocalInt(OBJECT_SELF, PHS_MAGICAL_TRAP_ALWAYS_DETECTED))
    {
        SetLocalInt(OBJECT_SELF, PHS_MAGICAL_TRAP_ALWAYS_DETECTED, TRUE);
        SetLocalInt(OBJECT_SELF, PHS_MAGICAL_TRAP_LEVEL, 3);
    }
}
