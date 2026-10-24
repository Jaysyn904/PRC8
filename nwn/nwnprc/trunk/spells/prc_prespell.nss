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

    if(nReturn && GetIsObjectValid(GetObjectByTag("MOONPATH_SURFACE")))
    {
        int nSpellID = PRCGetSpellId(oCaster);
        string sShape = GetStringLowerCase(Get2DACache("spells", "TargetShape", nSpellID));
        // Cones and line templates keep resolving; their target loops clip the
        // far side of the surface. Rejecting their aiming point would erase the
        // near side of the cone too. This does not affect PRC breath scripts.
        int nTargetTypes = HexToInt(Get2DACache("spells", "TargetType", nSpellID));
        int bKnownCenter = sShape == "sphere" || sShape == "hsphere";
        int bObjectOnly = nTargetTypes != 0 && !(nTargetTypes & 4);
        // Missing shape metadata on a location-targeted spell is ambiguous:
        // leave it running and let any patched target loop clip its targets.
        if(bKnownCenter || (bObjectOnly && sShape != "cone" && sShape != "rectangle"))
        {
            object oTarget = PRCGetSpellTargetObject(oCaster);
            location lTarget = PRCGetSpellTargetLocation(oCaster);
            vector vTo = GetPositionFromLocation(lTarget);
            if(GetIsObjectValid(oTarget))
                vTo = GetPosition(oTarget);
            if(GetArea(oCaster) == GetAreaFromLocation(lTarget)
                && MoonPathPortableGate(oTarget, GetArea(oCaster),
                    GetPosition(oCaster), vTo, 1))
                nReturn = FALSE;
        }
    }
    SetLocalInt(oCaster, "PSCC_Ret", nReturn);
}
