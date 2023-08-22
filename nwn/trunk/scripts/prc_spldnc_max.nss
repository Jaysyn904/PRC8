//::///////////////////////////////////////////////
//:: Select Maximize Spell
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
    if (!GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC))
    {
        FloatingTextStringOnCreature("You don't have Maximize Spell, canceling", oPC, FALSE);
        return;
    }    
    
    int nDance = GetLocalInt(oPC, "SpelldanceMaximize");
    
    if (nDance)
    {
        DeleteLocalInt(oPC, "SpelldanceMaximize");
        sMsg = "Spelldance Maximize turned off";
    }
    else
    {
        SetLocalInt(oPC, "SpelldanceMaximize", TRUE);
        sMsg = "Spelldance Maximize turned on";
    }    
       
    FloatingTextStringOnCreature(sMsg, oPC, FALSE);
}