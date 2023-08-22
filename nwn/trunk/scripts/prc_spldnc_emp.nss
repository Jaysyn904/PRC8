//::///////////////////////////////////////////////
//:: Select Empower Spell
//:: prc_spldnc_ext.nss
//::///////////////////////////////////////////////
/*
    Used to select which metamagics to spelldance
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    string sMsg;
    if (!GetHasFeat(FEAT_EMPOWER_SPELL, oPC))
    {
        FloatingTextStringOnCreature("You don't have Empower Spell, canceling", oPC, FALSE);
        return;
    }    
    
    int nDance = GetLocalInt(oPC, "SpelldanceEmpower");
    
    if (nDance)
    {
        DeleteLocalInt(oPC, "SpelldanceEmpower");
        sMsg = "Spelldance Empower turned off";
    }
    else
    {
        SetLocalInt(oPC, "SpelldanceEmpower", TRUE);
        sMsg = "Spelldance Empower turned on";
    }    
       
    FloatingTextStringOnCreature(sMsg, oPC, FALSE);
}