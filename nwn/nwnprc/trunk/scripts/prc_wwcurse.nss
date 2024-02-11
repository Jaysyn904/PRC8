//::///////////////////////////////////////////////
//:: OnHit for Curse of the Lycanthrope
//:: prc_wwcurse
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 15, 2004
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "prc_alterations"

void main()
{
    int nEvent =GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;

    // * This code runs when the item has the OnHitCastSpell: Unique power property
    // * and it hits a target(weapon) or is being hit (armor)
    // * Note that this event fires for non PC creatures as well.
    if (nEvent ==X2_ITEM_EVENT_ONHITCAST)
    {
        oItem  =  GetSpellCastItem();                  // The item casting triggering this spellscript
        object oSpellOrigin = OBJECT_SELF ;
        object oSpellTarget = PRCGetSpellTargetObject();
        oPC = OBJECT_SELF;

        if (!GetIsPC(oSpellTarget)) return;

        int nRoll = d20(1);
        int nConBonus = GetAbilityModifier(ABILITY_CONSTITUTION, oSpellTarget);
        int nFortitude = GetFortitudeSavingThrow(oSpellTarget);

        if ((nRoll + nConBonus + nFortitude) < 15)
        {
            //Only send message if player isn't already a lycanthrope.
            if (GetLocalInt(oSpellTarget, "PRC_AllowWWolf") != 0)
            {
                FloatingTextStringOnCreature("You have contracted lycanthropy!", oSpellTarget, FALSE);
            }
            SetLocalInt(oSpellTarget, "PRC_AllowWWolf", 0);
        }
    }
}
