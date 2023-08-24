//:://////////////////////////////////////////////
//:: Shadowsmith Shadow Craft Conversation
//:: shd_smith_craft
//:://////////////////////////////////////////////
/** @file
    This allows you to choose any weapon and create it.

    @author Stratovarius
    @date   Created  - 05.03.2019
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
                SetHeader("Select the item you would like to shadow craft.");
                // Add responses for the PC

                // This reads all of the legal choices from baseitems.2da
                int i;
		        for(i = 0; i < 64; i++) //Weapon rows in baseitems.2da
		        {
                    if (DEBUG) DoDebug("shd_smith_craft Step #1");
		        	// If the selection is a legal weapon
		        	if (StringToInt(Get2DACache("baseitems", "WeaponType", i)) > 0)
		        	{
                        if (DEBUG) DoDebug("shd_smith_craft Step #2");
		        		string sWeaponName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", i)));
		        		// Skip blanks and items with moving parts 
		        		if (sWeaponName != "")
		        		{
                            if (DEBUG) DoDebug("shd_smith_craft Step #3");
                            if (i != 4 && i != 6 && i != 7 && i != 8 && i != 11 && i != 35 && i != 45 && i != 61 && i != 111) 
                            {
                                AddChoice(sWeaponName, i, oPC);
                            }    
		        		}
		        	}
                }
                AddChoice("Dwarven Waraxe", 108, oPC);
                if (GetLevelByClass(CLASS_TYPE_SHADOWSMITH, oPC) >= 8)
                {
                    AddChoice("Padded Armor", 1001, oPC);
                    AddChoice("Leather Armor", 1002, oPC);
                    AddChoice("Studded Leather Armor", 1003, oPC);
                    AddChoice("Chain Shirt Armor", 1004, oPC);
                }
                
                MarkStageSetUp(STAGE_WEAPON_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "ShadowCraft_Choice");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", nChoice)));
                if (nChoice > 1000)
                {
                    if (nChoice == 1001) sName = "Padded Armor";
                    else if (nChoice == 1002) sName = "Leather Armor";
                    else if (nChoice == 1003) sName = "Studded Leather Armor";
                    else if (nChoice == 1004) sName = "Chain Shirt Armor";
                }
                string sText = "You have selected " + sName + " as your shadow crafted item.\n";
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
        DeleteLocalInt(oPC, "ShadowCraft_Choice");
        DeleteLocalInt(oPC, "ShadowCraft_Augment");
        DeleteLocalFloat(oPC, "ShadowCraft_Duration");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "ShadowCraft_Choice");
        DeleteLocalInt(oPC, "ShadowCraft_Augment");
        DeleteLocalFloat(oPC, "ShadowCraft_Duration");
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
            SetLocalInt(oPC, "ShadowCraft_Choice", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
                int nEnhance = 0;
                int nClass = GetLevelByClass(CLASS_TYPE_SHADOWSMITH, oPC);
                if (nClass > 5) nEnhance = nClass - 5;
                int nBaseType, nSuccess;
                float fDur = HoursToSeconds(nClass);
                object oItem;
                int nItem = GetLocalInt(oPC, "ShadowCraft_Choice");
                
                if (1000 > nItem) // Crafting weapons
                {
                    if (nEnhance > 0) nSuccess = GetIsSkillSuccessful(oPC, SKILL_CRAFT_WEAPON, 20+nEnhance);
                    // This is what the basic non-magical version of bioware weapons use as a resref
                    string sWeaponTemplate = "nw_" + Get2DACache("baseitems", "ItemClass", nItem) + "001";
                    string sAmmo = "";
                    object oAmmo;
    
                    oItem = CreateItemOnObject(sWeaponTemplate, oPC);
                    nBaseType = GetBaseItemType(oItem);
    
		            if(nBaseType == BASE_ITEM_LONGBOW && nBaseType == BASE_ITEM_SHORTBOW)
		            {
		            	sAmmo = "nw_wamar001";
		            	oAmmo = CreateItemOnObject(sAmmo, oPC, d6(3));
		            	AssignCommand(oPC, ActionEquipItem(oAmmo, INVENTORY_SLOT_ARROWS));
		                	// Ammoed weapons get their ammo enhanced as well
		            	if (nEnhance > 0 && nSuccess) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oAmmo, fDur);
		            }
		            else if(nBaseType == BASE_ITEM_HEAVYCROSSBOW && nBaseType == BASE_ITEM_LIGHTCROSSBOW)
		            {
		            	sAmmo = "nw_wambo001";
		            	oAmmo = CreateItemOnObject(sAmmo, oPC, d6(3));
		            	AssignCommand(oPC, ActionEquipItem(oAmmo, INVENTORY_SLOT_BOLTS));
		            	// Ammoed weapons get their ammo enhanced as well
                        if (nEnhance > 0 && nSuccess) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oAmmo, fDur);
		            }
		            else if(nBaseType == BASE_ITEM_SLING)
		            {
		            	sAmmo = "nw_wambu001";
		            	oAmmo = CreateItemOnObject(sAmmo, oPC, d6(3));
		            	AssignCommand(oPC, ActionEquipItem(oAmmo, INVENTORY_SLOT_BULLETS));
		            	// Ammoed weapons get their ammo enhanced as well
                        if (nEnhance > 0 && nSuccess) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oAmmo, fDur);
		            }
    
                    if (IPGetIsMeleeWeapon(oItem)) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem, fDur);
    
                    // If the power was augmented, add a straight enhancement bonus equivalent to the augmentation value
                    if (nEnhance > 0 && nSuccess) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nEnhance), oItem, fDur);
                    // Equip the weapon
                    AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));                    
                }
                else if (nItem > 1000) // Armor picked
                {
                    string sArmor;
                    if (nItem == 1001) sArmor = "nw_aarcl009"; // Padded
                    else if (nItem == 1002) sArmor = "nw_aarcl001"; // Leather
                    else if (nItem == 1003) sArmor = "nw_aarcl002"; // Studded
                    else                    sArmor = "nw_aarcl012"; // Chain
                    
                    oItem = CreateItemOnObject(sArmor, oPC);
                    
                    if (nEnhance > 0) nSuccess = GetIsSkillSuccessful(oPC, SKILL_CRAFT_ARMOR, 20+nEnhance);
                    if (nEnhance > 0 && nSuccess) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonus(nEnhance), oItem, fDur);
                    // Improved Shadow item ability, always granted by default.
                    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertySkillBonus(SKILL_HIDE, 10), oItem, fDur);
                    // Equip the weapon
                    AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));                    
                }

                // No dropping and no selling the item
                SetPlotFlag(oItem, TRUE);
                SetDroppableFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, TRUE);

                // Remove the item when the duration is over.
                DelayCommand(fDur - 1.0, SetPlotFlag(oItem, FALSE));
                DelayCommand(fDur - 1.0, AssignCommand(oItem, SetIsDestroyable(TRUE)));
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

            DeleteLocalInt(oPC, "ShadowCraft_Choice");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}