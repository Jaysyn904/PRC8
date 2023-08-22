#include "prc_inc_template"

void main()
{
    int nCount = FALSE;
    object oPC;
    object oTarget = GetFirstObjectInArea(GetObjectByTag("wol_a_bbb"));
    while (GetIsObjectValid(oTarget))
    {
        if (GetTag(oTarget) == "WOL_Khofar" && !GetIsDead(oTarget))
        {
             if (!GetIsInCombat(oTarget)) SetActionMode(oTarget, ACTION_MODE_STEALTH, TRUE);
             nCount++;
        }
        else if (GetIsPC(oTarget)) oPC = oTarget;
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInArea(GetObjectByTag("wol_a_bbb"));
    }
    
    if (nCount == FALSE && GetIsObjectValid(oPC) && !GetPersistantLocalInt(oPC, "LegacyOwner"))
    {
    	AssignCommand(oPC, SpeakString("The black wood bow shivers as you grasp it from the corpse of Khofar, whispering of the pain and death that has brought the bow into your possession."));
    	ApplyWoLToObject(2, oPC);
    	CreateObject(OBJECT_TYPE_PLACEABLE, "prc_ea_return", GetLocation(oPC));
    }
}