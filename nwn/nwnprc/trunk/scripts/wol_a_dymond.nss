#include "prc_inc_template"

void main()
{
    int nCount = FALSE;
    object oPC;
    object oTarget = GetFirstObjectInArea(GetObjectByTag("wol_a_dymond"));
    while (GetIsObjectValid(oTarget))
    {
        if (GetTag(oTarget) == "WOL_TwigBlight" && !GetIsDead(oTarget))
        {
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(2), oTarget, 6.0);
             nCount++;
        }
        else if (GetTag(oTarget) == "NW_ELFMERC006") ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oTarget);
        else if (GetIsPC(oTarget)) oPC = oTarget;
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInArea(GetObjectByTag("wol_a_dymond"));
    }
    
    if (nCount == FALSE && GetIsObjectValid(oPC) && !GetPersistantLocalInt(oPC, "LegacyOwner"))
    {
    	AssignCommand(oPC, SpeakString("You have recovered Dymondheart, and the oiled wood of its blade gleams in your hand."));
    	ApplyWoLToObject(30, oPC);
    	CreateObject(OBJECT_TYPE_PLACEABLE, "prc_ea_return", GetLocation(oPC));
    }
}