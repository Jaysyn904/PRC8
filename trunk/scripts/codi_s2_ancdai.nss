//:://////////////////////////////////////////////
//:: Ancestral Daisho conversation starter
//:: codi_s2_ancdai
//:://////////////////////////////////////////////
/** @file
    This script starts the new ancestral daisho
     management conversation

    @author Primogenitor
            Original by CODI
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"

void main()
{
    StartDynamicConversation("codi_s2_ancdaic", OBJECT_SELF, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, OBJECT_SELF);
    //give them the items
    int bHasKatana = FALSE;
    int bHasWakizashi = FALSE;
    //check if they already have them
    object oTest = GetFirstItemInInventory(OBJECT_SELF);
    while(GetIsObjectValid(oTest))
    {
        if(GetTag(oTest) == "codi_katana")
            bHasKatana = TRUE;
        if(GetTag(oTest) == "codi_wakizashi")
            bHasWakizashi = TRUE;
        oTest = GetNextItemInInventory(OBJECT_SELF);
    }
    //may be equipped too
    int i;
    for(i=0;i<14;i++)
    {
        oTest = GetItemInSlot(i, OBJECT_SELF);
        if(GetTag(oTest) == "codi_katana")
            bHasKatana = TRUE;
        if(GetTag(oTest) == "codi_wakizashi")
            bHasWakizashi = TRUE;
    }
    //katana
    if(!bHasKatana)
    {
        object oKatana = CreateItemOnObject("codi_mw_katana", OBJECT_SELF);
        object oKatana2 = CopyObject(oKatana, GetLocation(OBJECT_SELF), OBJECT_SELF, "codi_katana");
        DestroyObject(oKatana);
        //check in inventory
        if(GetItemPossessor(oKatana2) != OBJECT_SELF)
            DestroyObject(oKatana2);
        else
        {
            SetItemCursedFlag(oKatana2, TRUE);
            SetStolenFlag(oKatana2, TRUE);
        }
        SetName(oKatana2, GetName(OBJECT_SELF)+"'s "+GetName(oKatana2));
    }
    //wakizashi (short sword)
    if(!bHasWakizashi)
    {
        object oWakizashi = CreateItemOnObject("codi_mw_short", OBJECT_SELF);
        object oWakizashi2 = CopyObject(oWakizashi, GetLocation(OBJECT_SELF), OBJECT_SELF, "codi_wakizashi");
        DestroyObject(oWakizashi);
        //check in inventory
        if(GetItemPossessor(oWakizashi2) != OBJECT_SELF)
            DestroyObject(oWakizashi2);
        else
        {
            SetItemCursedFlag(oWakizashi2, TRUE);
            SetStolenFlag(oWakizashi2, TRUE);
        }
        SetName(oWakizashi2, GetName(OBJECT_SELF)+"'s Wakizashi");
    }
}

