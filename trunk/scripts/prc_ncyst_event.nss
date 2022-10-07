//::///////////////////////////////////////////////
//:: Name     Necrotic Cyst Event Script
//:: FileName   prc_ncyst_event
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*  This script deals an extra 1d6 damage when
    a creature with a necrotic cyst is damaged
    by an undead creature using natural attacks.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 11/13/05
//::
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{
    //Define vars
    int nEvent = GetRunningEvent();
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);

    if(nEvent == EVENT_ONHIT)
    {
        object oAttacker = PRCGetSpellTargetObject();

        //Check for undead
        if (MyPRCGetRacialType(oAttacker) != RACIAL_TYPE_UNDEAD)
        {
            return;
        }
        //Check for unarmnedness
        object oRightH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
        object oLeftH  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);
        int bUnarmed = (!IPGetIsMeleeWeapon(oRightH) &&
        !IPGetIsRangedWeapon(oRightH) &&
        !IPGetIsMeleeWeapon(oLeftH) &&
        !IPGetIsRangedWeapon(oLeftH));

        if(bUnarmed)
        {
            int nDam= d6(1);
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_DIVINE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF);
        }
    }
}



