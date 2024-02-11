//:://////////////////////////////////////////////
//:: Created By: Solowing
//:: Created On: September 2, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_switches"
#include "x2_inc_spellhook"

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetLocalInt(oPC,"arcstrikeactive"))
    {
        SetLocalInt(oPC,"arcstrikeactive",TRUE);
        FloatingTextStringOnCreature("Spell Storing Activated",oPC);
        SetLocalString(OBJECT_SELF,"arcstrikeovscript", PRCGetUserSpecificSpellScript());
        PRCSetUserSpecificSpellScript("prc_arc_strike");
    }
    else
    {
        PRCSetUserSpecificSpellScript(GetLocalString(OBJECT_SELF,"arcstrikeovscript"));
        FloatingTextStringOnCreature("Spell Storing Deactivated",oPC);
        DeleteLocalInt(oPC,"arcstrikeactive");
    }
}
