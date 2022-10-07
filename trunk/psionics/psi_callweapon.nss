//:://////////////////////////////////////////////
//:: Call Weaponry Conversation
//:: psi_callweapon
//:://////////////////////////////////////////////
/** @file
    This allows you to choose any weapon and summon it using the Call Weaponry power.


    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_WEAPON_CHOICE = 0;
const int STAGE_CONFIRMATION  = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_WEAPON_CHOICE)
            {
                // Set the header
                SetHeader("Select the Weapon Type you would like to call.");
                // Add responses for the PC

                // This reads all of the legal choices from baseitems.2da
                int i;
		for(i = 0; i < 112; i++) //Total rows in baseitems.2da
		{
			// If the selection is a legal weapon
			if (StringToInt(Get2DACache("baseitems", "WeaponType", i)) > 0)
			{
				string sWeaponName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", i)));
				// Just in case its a blank entry, don't put it here
				if (sWeaponName != "")
				{
					AddChoice(sWeaponName, i, oPC);
				}
			}
                }

/*
                AddChoice("Bastard Sword", BASE_ITEM_BASTARDSWORD, oPC);
                AddChoice("Battle Axe", BASE_ITEM_BATTLEAXE, oPC);
                AddChoice("Club", BASE_ITEM_CLUB, oPC);
                AddChoice("Dagger", BASE_ITEM_DAGGER, oPC);
                AddChoice("Dart", BASE_ITEM_DART, oPC);
                AddChoice("Dire Mace", BASE_ITEM_DIREMACE, oPC);
                AddChoice("Double Axe", BASE_ITEM_DOUBLEAXE, oPC);
*/

                MarkStageSetUp(STAGE_WEAPON_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "PRC_Power_CallWeaponry_SelectedWpn");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", nChoice)));
                string sText = "You have selected " + sName + " as your chosen weapon.\n";
                sText += "Is this correct?";

                SetHeader(sText);
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "PRC_Power_CallWeaponry_SelectedWpn");
        DeleteLocalInt(oPC, "PRC_Power_CallWeapon_Augment");
        DeleteLocalFloat(oPC, "PRC_Power_CallWeapon_Duration");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "PRC_Power_CallWeaponry_SelectedWpn");
        DeleteLocalInt(oPC, "PRC_Power_CallWeapon_Augment");
        DeleteLocalFloat(oPC, "PRC_Power_CallWeapon_Duration");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_WEAPON_CHOICE)
        {
            // Go to this stage next
            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "PRC_Power_CallWeaponry_SelectedWpn", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
                // This is what the basic non-magical version of bioware weapons use as a resref
                string sWeaponTemplate = "nw_" + Get2DACache("baseitems", "ItemClass", GetLocalInt(oPC, "PRC_Power_CallWeaponry_SelectedWpn")) + "001";
                string sAmmo = "";
                object oAmmo;
                int nEnhance = GetLocalInt(oPC, "PRC_Power_CallWeapon_Augment");
                int nBaseType;
                float fDur = GetLocalFloat(oPC, "PRC_Power_CallWeapon_Duration");

                object oItem = CreateItemOnObject(sWeaponTemplate, oPC);
                nBaseType = GetBaseItemType(oItem);

		if(nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
		{
			sAmmo = "nw_wamar001";
			oAmmo = CreateItemOnObject(sAmmo, oPC, d6(3));
			AssignCommand(oPC, ActionEquipItem(oAmmo, INVENTORY_SLOT_ARROWS));
			// Ammoed weapons get their ammo enhanced as well
			if (nEnhance > 0) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oAmmo, fDur);
		}
		if(nBaseType == BASE_ITEM_HEAVYCROSSBOW || nBaseType == BASE_ITEM_LIGHTCROSSBOW)
		{
			sAmmo = "nw_wambo001";
			oAmmo = CreateItemOnObject(sAmmo, oPC, d6(3));
			AssignCommand(oPC, ActionEquipItem(oAmmo, INVENTORY_SLOT_BOLTS));
			// Ammoed weapons get their ammo enhanced as well
			if (nEnhance > 0) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oAmmo, fDur);
		}
		if(nBaseType == BASE_ITEM_SLING)
		{
			sAmmo = "nw_wambu001";
			oAmmo = CreateItemOnObject(sAmmo, oPC, d6(3));
			AssignCommand(oPC, ActionEquipItem(oAmmo, INVENTORY_SLOT_BULLETS));
			// Ammoed weapons get their ammo enhanced as well
			if (nEnhance > 0) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oAmmo, fDur);
		}

                if (IPGetIsMeleeWeapon(oItem)) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem, fDur);

                // If the power was augmented, add a straight enhancement bonus equivalent to the augmentation value
                if(nEnhance > 0) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oItem, fDur);
                // Otherwise add +1 enhancement bonus and -1 to attack and damage. This is to simulate the fact that the weapon can always pierce DR X/+1
                else
                {
                    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(1), oItem, fDur);
                    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackPenalty(1), oItem, fDur);
                    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamagePenalty(1), oItem, fDur);
                }
                // No dropping and no selling the item
                SetPlotFlag(oItem, TRUE);
                SetDroppableFlag(oItem, FALSE);

                // Equip the weapon
                AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));

                // Remove the item when the duration is over.
                DestroyObject(oItem, fDur);

                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_WEAPON_CHOICE;
                MarkStageNotSetUp(STAGE_WEAPON_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "PRC_Power_CallWeaponry_SelectedWpn");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
