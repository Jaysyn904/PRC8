//:://////////////////////////////////////////////////
//:: animobj_hb.nss
/*
    OnHeartbeat event handler for animated objects.
*/
//:://////////////////////////////////////////////////

#include "X0_INC_HENAI"

void main()
{
    object oSelf = OBJECT_SELF;

    //animated objects stop animating after casterlvl rounds
    int iRoundsToGo = GetLocalInt(oSelf, "Rounds");
    if(iRoundsToGo <= 0 || !GetIsObjectValid(GetMaster()))
    {
        ExecuteScript("animobj_killself", oSelf);
        return;
    }
    SetLocalInt(oSelf, "Rounds", iRoundsToGo - 1);

    // Schedule next HeartBeat
    DelayCommand(6.0f, ExecuteScript("animobj_hb", oSelf));
}