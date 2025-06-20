//::///////////////////////////////////////////////
//:: PRC Spellbook OnTrigger Script
//:: prc_nui_sc_trggr
//:://////////////////////////////////////////////
/*
    This is the OnTarget action script used to make spell attacks with the
    selected spell from the PRC Spellbook NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////

#include "prc_nui_consts"
#include "inc_newspellbook"

void main()
{
    // Get the selected PRC spell we are going to cast
    int featId = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);

    // if the spell has a master feat this is it. This will return 0 if not set.
    int subSpellID = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);

    int isPersonalFeat = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);

    // if this is a personal feat then this was called directly since we never entered
    // targetting and this should be applied immediatly to the executing player.
    if (isPersonalFeat)
    {
        ActionUseFeat(featId, OBJECT_SELF, subSpellID);
        // we want to remove this just in case of weird cases.
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    }
    else
    {

        // Get the target and location data we are casting at
        object oTarget = GetLocalObject(OBJECT_SELF, "TARGETING_OBJECT");
        location spellLocation = GetLocalLocation(OBJECT_SELF, "TARGETING_POSITION");

        // if the object is valid and isn't empty then cast spell at target
        if (GetIsObjectValid(oTarget) && GetObjectType(oTarget))
            spellLocation = LOCATION_INVALID;
        // otherwise if the area is a valid location to cast at, cast at location
        else if (GetIsObjectValid(GetAreaFromLocation(spellLocation)))
            oTarget = OBJECT_INVALID;

        ActionUseFeat(featId, oTarget, subSpellID, spellLocation);
    }

    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
}