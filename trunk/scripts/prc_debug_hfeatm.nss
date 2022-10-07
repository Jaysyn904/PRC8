//:://////////////////////////////////////////////
//:: Debug: Duplicate hide feat monitor
//:: prc_debug_hfeatm
//:://////////////////////////////////////////////
/** @file
    Checks if the PC has multiple instances of the
    same itempropertybonusfeat on their hide.

    @author Ornedan
    @date   Created - 2005.9.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_utility"

const string SET_NAME = "PRC_DEBUG_HFeatM_IPs";


void main()
{if(DEBUG){ // This should do nothing if DEBUG is not active
    object oPC   = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    // If the skin has no itemproperties, nothing to do
    itemproperty ip = GetFirstItemProperty(oSkin);
    if(!GetIsItemPropertyValid(ip))
        return;

    // Create the set to store the ipfeat numbers in
    if(set_exists(oPC, SET_NAME))
        set_delete(oPC, SET_NAME);
    set_create(oPC, SET_NAME);

    // Loop over all itemproperties, looking for duplicates
    int nErrorFound = FALSE;
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT)
        {
            int nIPFeat = GetItemPropertySubType(ip);
            if(set_contains_int(oPC, SET_NAME, nIPFeat))
            {
                DoDebug("prc_debug_hfeatm: Duplicate bonus feat on the hide: " + IntToString(nIPFeat) + " - '" + GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nIPFeat))) + "'");
                nErrorFound = TRUE;
            }
            else
                set_add_int(oPC, SET_NAME, nIPFeat);
        }

        ip = GetNextItemProperty(oSkin);
    }

    // Cleanup
    set_delete(oPC, SET_NAME);

    // Request a bugreport
    if(nErrorFound)
    {
        DoDebug("prc_debug_hfeatm: Found duplicate bonus feats on the hide of " + DebugObject2Str(oPC) + "; Build: "
              + GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", GetClassByPosition(1, oPC)))) + " " + IntToString(GetLevelByPosition(1, oPC))
              + (GetClassByPosition(2, oPC) != CLASS_TYPE_INVALID ?
                 " / " + GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", GetClassByPosition(2, oPC)))) + " " + IntToString(GetLevelByPosition(2, oPC))
                 : ""
                 )
              + (GetClassByPosition(3, oPC) != CLASS_TYPE_INVALID ?
                 " / " + GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", GetClassByPosition(3, oPC)))) + " " + IntToString(GetLevelByPosition(3, oPC))
                 : ""
                 )
                );

        DoDebug("A duplicate itemproperty feat has been discovered. This is a critical bug, so please report it.\n\n"
              + "The report should contain an excerpt from your log (nwn/logs/nwclientlog1.txt) that contains all lines starting with"
              + "'prc_debug_hfeatm:'."
                );
    }
}}