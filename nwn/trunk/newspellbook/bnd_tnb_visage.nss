/*
05/03/21 by Stratovarius

Visage of the Dead: Mindless undead believe you to be one of them and do not attack you except
in self-defense, or when ordered to do so by their creator.

OnEnter
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = GetLocalObject(GetModule(), "TenebrousCharm");
    //FloatingTextStringOnCreature(GetName(oBinder)+" created this AoE", GetFirstPC());

    //Capture the first target object in the shape.
    object oTarget = GetEnteringObject();
    if (!GetIsFriend(oTarget, oBinder) && oTarget != oBinder && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && 10 >= GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, TRUE) && !GetIsObjectValid(GetMaster(oTarget)))
    {
    	SetLocalObject(oBinder, "TenebrousCharm", oTarget);
    	ExecuteScript("bnd_tnb_charm", oBinder);
    }
}
