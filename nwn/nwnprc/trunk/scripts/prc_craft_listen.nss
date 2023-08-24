/*
    prc_craft_listen

    Script to be executed by generic listener

    By: Flaming_Sword
    Created: Aug 8, 2006
    Modified: Sept 25, 2006
*/

#include "prc_craft_inc"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, PRC_CRAFT_LISTEN);
    string sString = GetLocalString(oPC, PRC_PLAYER_RESPONSE);
    int nState = GetLocalInt(oPC, PRC_CRAFT_LISTEN);
    if(DEBUG) DoDebug("prc_craft_listen: nState = " + IntToString(nState));

    switch(nState)
    {
        case PRC_CRAFT_LISTEN_SETNAME:
        {
            SetName(oItem, sString);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
            break;
        }
        case PRC_CRAFT_LISTEN_SETAPPEARANCE:
        {
            PRCSetItemAppearance(oPC, oItem, sString);
            break;
        }
        //add more here
    }
    DeleteLocalInt(oPC, PRC_CRAFT_LISTEN);
    DeleteLocalObject(oPC, PRC_CRAFT_LISTEN);
    /*if(nState)
    {
        SetIsDestroyable(TRUE, FALSE, FALSE);
        DestroyObject(OBJECT_SELF);
    }*/
}