//::///////////////////////////////////////////////
//:: Select Extend Spell
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
    if (!GetHasFeat(FEAT_EXTEND_SPELL, oPC))
    {
        FloatingTextStringOnCreature("You don't have Extend Spell, canceling", oPC, FALSE);
        return;
    }    
    
    int nDance = GetLocalInt(oPC, "SpelldanceExtend");
    
    if (nDance)
    {
        DeleteLocalInt(oPC, "SpelldanceExtend");
        sMsg = "Spelldance Extend turned off";
    }
    else
    {
        SetLocalInt(oPC, "SpelldanceExtend", TRUE);
        sMsg = "Spelldance Extend turned on";
    }    
       
    FloatingTextStringOnCreature(sMsg, oPC, FALSE);
}