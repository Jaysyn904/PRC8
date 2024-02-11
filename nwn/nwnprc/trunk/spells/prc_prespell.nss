//::///////////////////////////////////////////////
//:: Spell Hook 
//:: prc_prespell
//:://////////////////////////////////////////////
/*
    This file executes the prespell cast code
    X2PreSpellCastCode2()
    to be found in x2_inc_spellhook.nss
    as a script to save space in the spell codes

    The code of the X2PreSpellCastCode2() function takes up
    roughly 100 kBytes. This will be added to every spell, if the
    function is called directly, rather than here, via a script

    Thus the spell codes take up far less space, but the execution
    time is higher because of the (slight) overhead of ExecuteScript;

    However, the loading time for the spell codes will be much
    less and the total memory usage of the nwn program will also
    be much less, so all in all performance should be much improved 
*/

//:://////////////////////////////////////////////
//:: Created By: motu99
//:: Created On: 2007-06-08
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    object oCaster = OBJECT_SELF;
    /*
    int nSpellID = GetLocalInt(oCaster, "PSCC_Id");
    int nClass = GetLocalInt(oCaster, "PSCC_Cls");
    object oItem = GetLocalObject(oCaster, "PSCC_Itm");
    int nMetaMagic = GetLocalInt(oCaster, "PSCC_Met");
    int nCasterLevel = GetLocalInt(oCaster, "PSCC_Lvl");
    object oTarget = GetLocalObject(oCaster, "PSCC_Tgt");

    int nReturn = X2PreSpellCastCode2(nSpellID, oTarget, nMetaMagic, nCasterLevel, nClass, oItem, oCaster);
    */
    int nReturn = X2PreSpellCastCode2();

    SetLocalInt(oCaster, "PSCC_Ret", nReturn);
}
