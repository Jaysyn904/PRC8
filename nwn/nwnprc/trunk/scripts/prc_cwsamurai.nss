//::///////////////////////////////////////////////
//:: Complete Warrior Samurai class evaluation
//:: prc_cwsamurai
//::///////////////////////////////////////////////
/** @file prc_cwsamurai
    Hand out the heirloom daisho mentioned in
    Daisho Proficiency ability.

    Handles adding eventhooks.

    @author Ornedan
    @date   Created - 2006.07.05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"

void main()
{
    object oPC   = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    // See if we could hand out the heirloom daisho and if so, whether we have already handed them out
    if(!GetPRCSwitch(PRC_CWSAMURAI_NO_HEIRLOOM_DAISHO) && !GetPersistantLocalInt(oPC, "PRC_CWSamurai_HeirloomDaisho"))
    {
        // Create the objects - use standard nwn items
        CreateItemOnObject("nw_wswka001", oPC);
        CreateItemOnObject("nw_wswss001", oPC);

        // Set the marker
        SetPersistantLocalInt(oPC, "PRC_CWSamurai_HeirloomDaisho", TRUE);
    }

    // Staredown +4 Intimidate bonus
    if(GetHasFeat(FEAT_CWSM_STAREDOWN, oPC))
        SetCompositeBonus(oSkin, "CWSamurai_Staredown", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);

    // If they have the Frightful Presence ability, eventhook to OnEquip
    if(GetHasFeat(FEAT_CWSM_FRIGHTFUL_PRESENCE))
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "prc_cwsm_fright", TRUE, FALSE);
}