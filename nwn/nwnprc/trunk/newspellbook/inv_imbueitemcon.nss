//:://////////////////////////////////////////////
//:: Imbue Item conversation
//:: inv_imbueitemcon
//:://////////////////////////////////////////////
/** @file
    Conversation to select a spell for crafting 
    limited use items.

    @date Modified - 2008.02.26
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "inv_inc_invfunc"
#include "prc_x2_craft"


//////////////////////////////////////////////////
/* Constant definitions                         */
//////////////////////////////////////////////////

const int STAGE_SELECT_TYPE  = 0;
const int STAGE_SELECT_LEVEL = 1;
const int STAGE_SELECT_SPELL = 2;
const int STAGE_CONFIRM      = 3;
const int STAGE_CRAFT_FINISH = 4;

const int SPELL_TYPE_ARCANE  = 9;
const int SPELL_TYPE_DIVINE  = 225;

const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
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
            if(nStage == STAGE_SELECT_TYPE)
            {
                SetLocalInt(oPC, "UsingImbueItem", TRUE);
                AddChoice("Arcane", SPELL_TYPE_ARCANE);
                AddChoice("Divine", SPELL_TYPE_DIVINE);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                SetHeader("Select the source of the spell you want to craft into the object.");
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
            }
            else if(nStage == STAGE_SELECT_LEVEL)
            {
                int nClass             = GetLocalInt(oPC, "SpellType");
                int nSpellbookMinLevel = 0;
                int nSpellbookMaxLevel = min((GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + 1) / 2, 9);
                if(DEBUG) DoDebug("inv_imbueitemcon: Spellbook max level: " + IntToString(nSpellbookMaxLevel));
                string sFile           = GetFileForClass(nClass);
                int i;

                for(i = nSpellbookMinLevel; i <= nSpellbookMaxLevel; i++)
                {
                    AddChoice(GetStringByStrRef(7544)/*"Spell Level"*/ + " " + IntToString(i), i);
                }
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                SetHeader("Select the level of the spell you want to craft into the object.");
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
            }
            else if(nStage == STAGE_SELECT_SPELL)
            {
                int nClass      = GetLocalInt(oPC, "SpellType");
                int nSpellLevel = GetLocalInt(oPC, "SelectedLevel");
                string sFile    = GetFileForClass(nClass);

                // Set up header
                // "You have <selectcount> level <spelllevel> spells remaining to select."
                SetHeader("Select a spell to use in crafting this item.");

                // List all spells not yet selected of this level
                int i;
                int nRow;
                string sTag = "SpellLvl_" + IntToString(nClass) + "_Level_" + IntToString(nSpellLevel);
                object oWP = GetObjectByTag(sTag);
                for(i = 0; i < array_get_size(oWP, "Lkup"); i++)
                {
                    int nRow    = array_get_int(oWP, "Lkup", i);
                    int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nRow));
                    if(Get2DACache(sFile, "ReqFeat", nRow) == "") // Has no prerequisites
                    {
                        int nFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nRow));
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))), nRow, oPC);

                        if(DEBUG) DoDebug("prc_s_spellgain: Adding spell selection choice:\n"
                                        + "i = " + IntToString(nRow)          + "\n"
                                        + "sFile = " + sFile                  + "\n"
                                        + "nFeatID = " + IntToString(nFeatID) + "\n"
                                        + "resref = " + IntToString(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID)))
                                          );
                    }
                }

                SetDefaultTokens();
                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_CONFIRM)
            {
                int nRow     = GetLocalInt(oPC, "SelectedSpell");
                int nClass   = GetLocalInt(oPC, "SpellType");
                string sFile = GetFileForClass(nClass);
                int nFeat    = StringToInt(Get2DACache(sFile, "FeatID", nRow));

                string sToken  = GetStringByStrRef(16824209) + "\n\n"; // "You have selected:"
                       sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT",        nFeat))) + "\n";
                       sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeat))) + "\n\n";
                       sToken += GetStringByStrRef(16824210); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE);
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE);

                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens();
            }
            // Conversation finished stage
            else if(nStage == STAGE_CRAFT_FINISH)
            {
                if(DEBUG) DoDebug("inv_imbueitemcon: Building finish note");
                int bSucceeded = GetLocalInt(oPC, "ImbueCraftingSuccess");
                if(bSucceeded)
                    SetHeader("Imbue Item succeeded.");
                else
                    SetHeader("Imbue Item failed.");
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        int nClass   = GetLocalInt(oPC, "SpellType");
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "SelectedLevel");
        DeleteLocalInt(oPC, "SpellType");
        DeleteLocalInt(oPC, "SelectedSpell");
        DeleteLocalInt(oPC, "SpellbookMinSpelllevel");
        DeleteLocalInt(oPC, "SpellbookMaxSpelllevel");
        DeleteLocalInt(oPC, "ImbueCraftingSuccess");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        int nClass   = GetLocalInt(oPC, "SpellType");
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "SelectedLevel");
        DeleteLocalInt(oPC, "SelectedSpell");
        DeleteLocalInt(oPC, "SpellType");
        DeleteLocalInt(oPC, "SpellbookMinSpelllevel");
        DeleteLocalInt(oPC, "SpellbookMaxSpelllevel");
        DeleteLocalInt(oPC, "ImbueCraftingSuccess");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SELECT_TYPE)
        {
            SetLocalInt(oPC, "SpellType", nChoice);
            if(DEBUG) DoDebug("inv_imbueitemcon: Spell type chosen: " + IntToString(nChoice));
            nStage = STAGE_SELECT_LEVEL;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SELECT_LEVEL)
        {
            SetLocalInt(oPC, "SelectedLevel", nChoice);
            if(DEBUG) DoDebug("inv_imbueitemcon: Spell level chosen: " + IntToString(nChoice));
            nStage = STAGE_SELECT_SPELL;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SELECT_SPELL)
        {
            SetLocalInt(oPC, "SelectedSpell", nChoice);
            if(DEBUG) DoDebug("inv_imbueitemcon: Spell chosen: " + IntToString(nChoice));
            nStage = STAGE_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_CONFIRM)
        {
            // Move to another stage based on response, for example
            if(nChoice == TRUE)
            {
                int nClass   = GetLocalInt(oPC, "SpellType");
                int nRow     = GetLocalInt(oPC, "SelectedSpell");
                string sFile = GetFileForClass(nClass);
                int nLevel   = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK);
                int nSpell   = StringToInt(Get2DACache(sFile, "RealSpellID", nRow));
                int bCanCraft = FALSE;
                int nUMDDC   = nClass == 9 ? 15 : 25;
                nUMDDC += StringToInt(Get2DACache("spells", "Innate", nSpell));
                object oBaseItem = GetLocalObject(oPC, "CraftingBaseItem");
                
                //run UMD check
                if(GetIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, nUMDDC))
                    bCanCraft = TRUE;
                
                int nRet = FALSE;
                
                if(bCanCraft && oBaseItem != OBJECT_INVALID)
                {
                    switch(GetBaseItemType(oBaseItem))
                    {
                        case 101 :
                            // -------------------------------------------------
                            // Brew Potion
                            // -------------------------------------------------
                           nRet = CICraftCheckBrewPotion(oBaseItem,oPC,nSpell);
                           break;


                        case 102 :
                           // -------------------------------------------------
                           // Scribe Scroll
                           // -------------------------------------------------
                           nRet = CICraftCheckScribeScroll(oBaseItem,oPC,nSpell);
                           break;
        
        
                        case 103 :
                           // -------------------------------------------------
                           // Craft Wand
                           // -------------------------------------------------
                           nRet = CICraftCheckCraftWand(oBaseItem,oPC,nSpell);
                           break;
        
                        case 200 :
                           // -------------------------------------------------
                           // Craft Rod
                           // -------------------------------------------------
                           //nRet = CICraftCheckCraftWand(oBaseItem,oPC);
                           break;
        
                        case BASE_ITEM_CRAFTED_STAFF :
                           // -------------------------------------------------
                           // Craft Staff
                           // -------------------------------------------------
                           nRet = CICraftCheckCraftStaff(oBaseItem,oPC,nSpell);
                           break;
                    }
                }
                SetLocalInt(oPC, "ImbueCraftingSuccess", nRet);
                nStage = STAGE_CRAFT_FINISH;
                MarkStageNotSetUp(nStage, oPC);
            }
            else
            {
                DeleteLocalInt(oPC, "SelectedSpell");
                nStage = STAGE_SELECT_TYPE;
                MarkStageNotSetUp(nStage, oPC);
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
