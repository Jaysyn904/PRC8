//:://////////////////////////////////////////////
//:: change the PC clone using letoscript
//:: prc_ccc_app_lspw.nss
//:://////////////////////////////////////////////
/** @file
    Destroys the existing PC clone and replaces it 
    with a new one, modified by letoscript.
    
    Note: the letoscript modifications are done elsewhere
    this script simply uses the modified object

    @author Primogenitor (commented by fluffyamoeba)
    @date   Created  - 2006.10.10
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "ccc_inc_misc"

void main()
{   
    string sThreadID = GetLocalString(GetModule(), "LetoResultThread");
    object oPC = GetLocalObject(GetModule(), "PCForThread"+sThreadID);
    object oClone = GetLocalObject(oPC, "Clone");
    object oNewClone = GetLocalObject(GetModule(), "LetoResultObject");
    //for debugging
    PrintString("oPC is "+GetName(oPC)+" "+ObjectToString(oPC));
    PrintString("oClone is "+GetName(oClone)+" "+ObjectToString(oClone));
    PrintString("oNewClone is "+GetName(oNewClone)+" "+ObjectToString(oNewClone));
    //destroy the old clone
    AssignCommand(oClone, SetIsDestroyable(TRUE));
    DestroyObject(oClone);
    oClone = oNewClone;
    //reset the locals linking master and clone
    SetLocalObject(oPC, "Clone", oClone);
    SetLocalObject(oClone, "Master", oPC);
    //restart the pseudohb checking that the master is still logged on
    AssignCommand(oClone, CloneMasterCheck());
    //add the new clone to the PC so that you can see there portrait
    ChangeToStandardFaction(oClone, STANDARD_FACTION_MERCHANT);
    //apply a vfx to cover the swap
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
    //stop the waiting
    DeleteLocalInt(oPC, "DynConv_Waiting");
}
