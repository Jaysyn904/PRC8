//:://////////////////////////////////////////////
//:: PRC Switch manipulation conversation
//:: prc_switchesc
//:://////////////////////////////////////////////
/** @file
    This conversation is used for changing values
    of the PRC switches ingame.

    @todo Primo: TLKify this

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "inc_epicspells"
#include "prc_inc_leadersh"
#include "prc_inc_natweap"
#include "prc_inc_template"
#include "inc_switch_setup"
#include "pnp_shft_poly"
#include "inc_sql"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                           =   0;
const int STAGE_SWITCHES                        =   1;
const int STAGE_SWITCHES_VALUE                  =   2;
const int STAGE_EPIC_SPELLS                     =   3;
const int STAGE_EPIC_SPELLS_ADD                 =   4;
const int STAGE_EPIC_SPELLS_REMOVE              =   5;
const int STAGE_EPIC_SPELLS_CONTING             =   6;
const int STAGE_SHOPS                           =   8;
const int STAGE_TEFLAMMAR_SHADOWLORD            =   9;
const int STAGE_LEADERSHIP                      =  10;
const int STAGE_LEADERSHIP_ADD_STANDARD         =  11;
const int STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM =  12;
const int STAGE_LEADERSHIP_ADD_CUSTOM_RACE      =  13;
const int STAGE_LEADERSHIP_ADD_CUSTOM_GENDER    =  14;
const int STAGE_LEADERSHIP_ADD_CUSTOM_CLASS     =  15;
const int STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN     =  16;
const int STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM   =  17;
const int STAGE_LEADERSHIP_REMOVE               =  18;
const int STAGE_LEADERSHIP_DELETE               =  19;
const int STAGE_LEADERSHIP_DELETE_CONFIRM       =  20;
const int STAGE_MISC_OPTIONS                    =  21;
const int STAGE_SPELLS                          =  22;
const int STAGE_WILDSHAPE_SLOTS                 =  23;
const int STAGE_WILDSHAPE_SHAPE                 =  24;
const int STAGE_ELEMENTALSHAPE_SLOTS            =  25;
const int STAGE_ELEMENTALSHAPE_SHAPE            =  26;
const int STAGE_DRAGONSHAPE_SLOTS               =  27;
const int STAGE_DRAGONSHAPE_SHAPE               =  28;
const int STAGE_PNP_FAMILIAR_COMPANION          =  29;
const int STAGE_NATURAL_WEAPON                  =  30;
const int STAGE_TEMPLATE                        =  31;
const int STAGE_TEMPLATE_CONFIRM                =  32;
const int STAGE_TEMPLATE_HALF_DRAGON            =  33;
const int STAGE_TEMPLATE_HALF_DRAGON_CONFIRM    =  34;
const int STAGE_WOL_PURCHASE                    =  35;
const int STAGE_WOL_CONFIRM                     =  36;
const int STAGE_WOL_RITUALS                     =  37;
const int STAGE_WOL_HEADER                      =  38;
const int STAGE_WOL_RESEARCH                    =  39;
const int STAGE_WOL_RESEARCH_2                  =  40;
const int STAGE_LA_BUYOFF                       =  41;
const int STAGE_ENCOUNTER_AREAS                 =  42;
const int STAGE_ENCOUNTER_CONFIRM               =  43;
const int STAGE_ABERRANT_SLOTS                  =  44;
const int STAGE_ABERRANT_SHAPE                  =  45;

const int STAGE_CDKEY_ADD                       = 509;
const int STAGE_APPEARANCE                      = 510;
const int STAGE_HEAD                            = 520;
const int STAGE_WINGS                           = 530;
const int STAGE_TAIL                            = 540;
const int STAGE_BODYPART                        = 550;
const int STAGE_BODYPART_CHANGE                 = 551;
const int STAGE_PORTRAIT                        = 560;
const int STAGE_EQUIPMENT                       = 590;
const int STAGE_EQUIPMENT_SIMPLE                = 591; //e.g. shield
const int STAGE_EQUIPMENT_LAYERED               = 592; //e.g. helm
const int STAGE_EQUIPMENT_COMPOSITE             = 593; //e.g. sword
const int STAGE_EQUIPMENT_COMPOSITE_B           = 594;
const int STAGE_EQUIPMENT_ARMOR                 = 595; //e.g. armor

const int CHOICE_RETURN_TO_PREVIOUS             = 0xEFFFFFFF;
const int CHOICE_SWITCHES_USE_2DA               = 0xEFFFFFFE;


// PnP shifting constants
const int TYPE_WILD_SHAPE              =  1;//0x01
const int TYPE_ELEMENTAL_SHAPE         =  2;//0x02
const int TYPE_DRAGON_SHAPE            =  4;//0x04
const int TYPE_POLYMORPH_SELF          =  8;//0x08
const int TYPE_ABERRANT_SHAPE          = 16;//0x16

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void AddPortraits(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("portraits", "Race", i) != "")
        {
            sName = Get2DACache("portraits", "BaseResRef", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddPortraits(i, nMax, oPC));
}

void AddTails(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("tailmodel", "MODEL", i) != "")
        {
            sName = Get2DACache("tailmodel", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddTails(i, nMax, oPC));
}

void AddWings(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("wingmodel", "MODEL", i) != "")
        {
            sName = Get2DACache("wingmodel", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddWings(i, nMax, oPC));
}

void AddAppearances(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("appearance", "RACE", i) != "")
        {
            //test for tlk name
            sName = GetStringByStrRef(StringToInt(Get2DACache("appearance", "STRING_REF", i)));
            //no tlk name, use label
            if(sName == "")
                sName = Get2DACache("appearance", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddAppearances(i, nMax, oPC));
}

void AddCohortRaces(int nMin, int nMax, object oPC)
{
    int i;
    int nMaxHD = GetCohortMaxLevel(GetLeadershipScore(oPC), oPC);
    int bUseSimpleRacialHD = GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD);
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        if(Get2DACache("racialtypes", "PlayerRace", i) == "1")
        {
            sName = GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", i)));
            //if using racial HD, dont add them untill they can afford the minimum racial hd
            if(bUseSimpleRacialHD)
            {
                if(nMaxHD > StringToInt(Get2DACache("ECL", "RaceHD", i)))
                    AddChoice(sName, i, oPC);
            }
            else
                AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddCohortRaces(i, nMax, oPC));
}

void AddTemplates(int nMin, int nMax, object oPC)
{
    int i;
    for(i=nMin;i<=nMax;i++)
    {
        string sName;
        string sScript = Get2DACache("templates", "MaintainScript", i);
        int nNameID = StringToInt(Get2DACache("templates", "Name", i));
        if(nNameID != 0)
            sName = GetStringByStrRef(nNameID);
        else
            sName = Get2DACache("templates", "Label", i);
        //check type
        //inherited templates can only be taken with 1 HD
        if(((StringToInt(Get2DACache("templates", "Type", i)) & 1)
                && GetHitDice(oPC) > 1)
            || !ApplyTemplateToObject(i, oPC, FALSE))
        {
            sName = PRC_TEXT_GRAY+sName+"</c>";
        }
        if(sScript != "")
            AddChoice(sName, i);
    }
}

void AddLegacies(object oPC, int nResearch = FALSE)
{
    //DoDebug("Entered AddLegacies");
    //Weapons of Legacy never stack, so dont let them
    if(GetPersistantLocalInt(oPC, "LegacyOwner") && !nResearch)
        return;

    int i;
    for(i=1;i<=60;i++)
    {
        string sName;
        int nNameID = StringToInt(Get2DACache("wol_items", "Name", i));
        if(nNameID != 0)
            sName = GetStringByStrRef(nNameID);
        else
            sName = Get2DACache("wol_items", "Label", i);

        // Test if they can purchase a legacy
        string sScript = Get2DACache("wol_items", "TestScript", i);
        int nGold = StringToInt(Get2DACache("wol_items", "Cost", i));
        if (DEBUG) DoDebug("AddLegacies: "+sName+" - "+sScript+", Gold needed "+IntToString(nGold)+", Gold possessed "+IntToString(GetGold(oPC)));
        if(sScript != "" && !ExecuteScriptAndReturnInt(sScript, oPC) && GetGold(oPC) >= nGold && !nResearch)
            AddChoice(sName, i);
        else if (sScript != "" && nResearch) // Research mode   
            AddChoice(sName, i);
    }
}

void AddRitualCost(object oPC)
{
    // Which weapon do we have?
    int nWoL = GetPersistantLocalInt(oPC, "LegacyOwner");
    string sName;
    int nNameID = StringToInt(Get2DACache("wol_items", "Name", nWoL));
    if(nNameID != 0)
        sName = GetStringByStrRef(nNameID);    

    // They've paid for everything
    if (GetHasFeat(FEAT_GREATER_LEGACY)) return;
    // Pay for greater rituals
    if (GetHasFeat(FEAT_LESSER_LEGACY))
    {
        int nGold = StringToInt(Get2DACache("wol_items", "Greater", nWoL));
        if (GetGold(oPC) >= nGold && nGold > 999) AddChoice("Purchase the Greater Legacy for "+sName+", at a cost of "+IntToString(nGold)+" gold", nGold);
    }
    else if (GetHasFeat(FEAT_LEAST_LEGACY))
    {
        int nGold = StringToInt(Get2DACache("wol_items", "Lesser", nWoL));
        if (GetGold(oPC) >= nGold && nGold > 999) AddChoice("Purchase the Lesser Legacy for "+sName+", at a cost of "+IntToString(nGold)+" gold", nGold);
    }   
    else
    {
        int nGold = StringToInt(Get2DACache("wol_items", "Least", nWoL));
        if (GetGold(oPC) >= nGold) AddChoice("Purchase the Least Legacy for "+sName+", at a cost of "+IntToString(nGold)+" gold", nGold);
    }     
}

void AddShapes(int nMin, int nMax, object oPC, int nType)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        int nLimit = GetPRCSwitch(PNP_SHFT_USECR) ? StringToInt(Get2DACache("prc_polymorph", "CR", i)) : StringToInt(Get2DACache("prc_polymorph", "HD", i));
        if(nLimit <= GetHitDice(oPC))
        {
            int nName = StringToInt(Get2DACache("prc_polymorph", "Name", i));
            sName = nName != 0 ? GetStringByStrRef(nName) : Get2DACache("prc_polymorph", "Label", i);

            if(sName != "" && HexToInt(Get2DACache("prc_polymorph", "Type", i)) & nType)
                AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
    {
        DelayCommand(0.00f, AddShapes(i, nMax, oPC, nType));
    }
    else
    {
        FloatingTextStringOnCreature("Done", oPC, FALSE);
        DeleteLocalInt(oPC, "DynConv_Waiting");
    }
}

void CohortSetAlignment(int nMoral, int nOrder, object oCohort)
{
    if(!GetIsObjectValid(oCohort))
        return;
    if(GetIsPC(oCohort))
        return;
    int nCurrentOrder = GetLawChaosValue(oCohort);
    int nCurrentMoral = GetGoodEvilValue(oCohort);
    if(nCurrentOrder == -1
        || nCurrentMoral == -1)
        return;
    if(nCurrentMoral < nMoral)
        AdjustAlignment(oCohort, ALIGNMENT_GOOD, nMoral-nCurrentMoral, FALSE);
    else if(nCurrentMoral > nMoral)
        AdjustAlignment(oCohort, ALIGNMENT_EVIL, nCurrentMoral-nMoral, FALSE);
    if(nCurrentOrder < nOrder)
        AdjustAlignment(oCohort, ALIGNMENT_LAWFUL, nOrder-nCurrentOrder, FALSE);
    else if(nCurrentOrder > nOrder)
        AdjustAlignment(oCohort, ALIGNMENT_CHAOTIC, nCurrentOrder-nOrder, FALSE);
}

int GetStrRefForTemplate(int nTemplate)
{
    int nStrRef = (16838640 + 2 * nTemplate) - 2;//Starts at 'Black Half-Dragon' = 16838640
    return nStrRef;
}

//Part of Server Security Script by FunkySwerve
int GetCanAddNewKey(object oPC)
{
    string sPlayer = GetStringLowerCase(GetPCPlayerName(oPC));
    if(GetPRCSwitch(PRC_USE_DATABASE))    
    {
        sPlayer = ReplaceSingleChars(sPlayer,"'","~");
        string sSQL = "SELECT val FROM pwdata WHERE name='PlayernameKey_" + sPlayer + "'";
        PRC_SQLExecDirect(sSQL);
        if (PRC_SQLFetch() == PRC_SQL_SUCCESS) /* there's at least one key stored already */
        {
            string sStoredKey = PRC_SQLGetData(1);
            int nLength =  GetStringLength(sStoredKey);
            if (nLength > 61) /* allow 7 keys max key-key-key-key-key-key-key    6 spacers + 7x8 keys = 62 */
            {
                return TRUE;
            }
            else return FALSE;
        }
    }
    else
    {
        string sStoredKey = GetCampaignString("PlayernameKey", sPlayer );
        if (sStoredKey != "")
        {
            int nLength =  GetStringLength(sStoredKey);
            if (nLength > 65) /* allow 7 keys max SET-key-key-key-key-key-key-key   SET/ADD + 7 spacers + 7x8 keys = 66 */
                return TRUE;
        }
        return FALSE;
    }
    return FALSE; /* this should never be reached if your database is running, since the first key add is automatic oncliententer */
}

void AddNewCDKey(object oPC)
{
    string sPlayer = GetStringLowerCase(GetPCPlayerName(oPC));
    if(GetPRCSwitch(PRC_USE_DATABASE))    
    {
        sPlayer = ReplaceSingleChars(sPlayer,"'","~");
        string sSQL = "UPDATE pwdata SET tag='Adding' WHERE name='PlayernameKey_"+ sPlayer + "'"; //must mark as adding
        PRC_SQLExecDirect(sSQL);
    }
    else
    {
        string sStoredKey = GetCampaignString("PlayernameKey", sPlayer);
        string sKeys = "ADD" + GetStringRight(sStoredKey, GetStringLength(sStoredKey) - 3);//mark as adding
        SetCampaignString("PlayernameKey", sPlayer, sKeys);
    }
}
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
            if(nStage == STAGE_ENTRY)
            {
                SetHeader("What do you want to do?");

                if(!GetPRCSwitch(PRC_DISABLE_SWITCH_CHANGING_CONVO) || GetIsDMPossessed(oPC) || GetIsDM(oPC))
                    AddChoice("Alter code switches.", 1);
                if(GetIsEpicSpellcaster(oPC))
                    AddChoice("Manage Epic Spells.", 2);
                AddChoice("Purchase general items, such as scrolls or crafting materials.", 3);
                AddChoice("Attempt to identify everything in my inventory.", 4);
                if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
                    && !GetPersistantLocalInt(oPC, "shadowwalkerstok"))
                    AddChoice("Join the Shadowlords as a prerequisite for the Teflammar Shadowlord class.", 5);
                if(!GetPRCSwitch(PRC_DISABLE_REGISTER_COHORTS) && GetCanRegister(oPC))
                    AddChoice("Register this character as a cohort.", 6);
                if(GetMaximumCohortCount(oPC))
                    AddChoice("Manage cohorts.", 7);
                if(GetPrimaryNaturalWeaponCount(oPC))
                    AddChoice("Select primary natural weapon.", 8);
                if(!GetPRCSwitch(PRC_DISABLE_CONVO_TEMPLATE_GAIN))
                    AddChoice("Gain a template.", 9);
                if(!GetPRCSwitch(PRC_DISABLE_WOL_GAIN))
                    AddChoice("Weapons of Legacy.", 35);  
                if(GetCanBuyoffLA(oPC))
                    AddChoice("LA Buyoff.", 41); 
                if(!GetPRCSwitch(PRC_DISABLE_ENCOUNTERS))
                    AddChoice("Visit an encounter area", 42);                     
                if(DEBUG) //this doesn't work at all
                //if(!GetPRCSwitch(PRC_APPEARNCE_CHANGE_DISABLE))
                    AddChoice("Change appearance.", 10);
                AddChoice("Miscellaneous options.", 11);
                if(DEBUG)//TO DO: add separate switch
                    AddChoice("Wipe PRC Spellbooks", 12);

                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SWITCHES)
            {
                SetHeader("Select a variable to modify.\n"
                        + "See prc_inc_switches for descriptions.\n"
                        + "In most cases zero is off and any other value is on."
                         );

                // First choice is Back, so people don't have to scroll ten pages to find it
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                // Add a special choices
                AddChoice("Read personal_switch.2da and set switches based on it's contents", CHOICE_SWITCHES_USE_2DA);


                // Get the switches container waypoint, and call the builder function if it doesn't exist yet (it should)
                object oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                if(!GetIsObjectValid(oWP))
                {
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP did not exist, attempting creation");
                    CreateSwitchNameArray();
                    oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP " + (GetIsObjectValid(oWP) ? "created":"not created"));
                }
                int i;
                for(i = 0; i < array_get_size(oWP, "Switch_Name"); i++)
                {
                    AddChoice(array_get_string(oWP, "Switch_Name", i), i, oPC);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SWITCHES_VALUE)
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                int nVal = GetPRCSwitch(sVarName);

                SetHeader("CurrentValue is: " + IntToString(nVal) + "\n"
                        + "CurrentVariable is: " + sVarName + "\n"
                        + "Select an ammount to modify the variable by:"
                          );

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                AddChoice("-10", -10);
                AddChoice("-5", -5);
                AddChoice("-4", -4);
                AddChoice("-3", -3);
                AddChoice("-2", -2);
                AddChoice("-1", -1);
                AddChoice("+1", 1);
                AddChoice("+2", 2);
                AddChoice("+3", 3);
                AddChoice("+4", 4);
                AddChoice("+5", 5);
                AddChoice("+10", 10);
            }
            else if(nStage == STAGE_EPIC_SPELLS)
            {
                SetHeader("Make a selection.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                if(GetCastableFeatCount(oPC)>0)
                    AddChoice("Remove an Epic Spell from the radial menu.", 1);
                if(GetCastableFeatCount(oPC)<7)
                    AddChoice("Add an Epic Spell to the radial menu.", 2);
                AddChoice("Manage any active contingencies.", 3);
                if(!GetPRCSwitch(PRC_EPIC_CONVO_LEARNING_DISABLE))
                    AddChoice("Research an Epic Spell.", 4);
                AddChoice("List known epic spells.", 5);
                AddChoice("List known epic seeds.", 6);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_ADD)
            {
                SetHeader("Choose the spell to add.");
                int i;
                for(i = 0; i < 71; i++)
                {
                    int nSpellFeat = GetFeatForSpell(i);
                    if(GetHasEpicSpellKnown(i, oPC)
                        && !GetHasFeat(nSpellFeat, oPC))
                    {
                        string sName = GetNameForSpell(i);
                        AddChoice(sName, i, oPC);
                    }
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
            {
                SetHeader("Choose the spell to remove.");
                int i;
                for(i = 0; i < 71; i++)
                {
                    int nFeat = GetFeatForSpell(i);
                    if(GetHasFeat(nFeat, oPC))
                    {
                        string sName = GetNameForSpell(i);
                        AddChoice(sName, i, oPC);
                    }
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_CONTING)
            {
                SetHeader("Choose an active contingency to dispel. Dispelling will pre-emptively end the contingency and restore the reserved epic spell slot for your use.");
                if(GetLocalInt(oPC, "nContingentRez"))
                    AddChoice("Dispel any contingent resurrections.", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SHOPS)
            {
                SetHeader("Select what type of item you wish to purchase.");
                if(GetHasFeat(FEAT_BREW_POTION, oPC)
                    || GetHasFeat(FEAT_SCRIBE_SCROLL, oPC)
                    || GetHasFeat(FEAT_CRAFT_WAND, oPC))
                    AddChoice("Magic item raw materials", 1);
                if(!GetPRCSwitch(PRC_DISABLE_COMPONENTS_SHOP))
                    AddChoice("Material components for spells", 2);
                if(!GetPRCSwitch(PRC_SPELLSLAB_NOSCROLLS))
                    AddChoice("Spell scrolls", 3);
                if (GetIsEpicSpellcaster(oPC)
                    && GetPRCSwitch(PRC_SPELLSLAB) != 3
                    )
                    AddChoice("Epic spell books", 4);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_TEFLAMMAR_SHADOWLORD)
            {
                SetHeader("This will cost you 10,000 GP, are you prepared to pay this?");
                if(GetHasGPToSpend(oPC, 10000))
                    AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP)
            {
                SetHeader("What do you want to change?");
                if(GetCurrentCohortCount(oPC) < GetMaximumCohortCount(oPC)
                    && !GetLocalInt(oPC, "CohortRecruited")
                    && !GetPRCSwitch(PRC_DISABLE_CUSTOM_COHORTS))
                    AddChoice("Recruit a custom cohort", 1);
                if(GetCurrentCohortCount(oPC) < GetMaximumCohortCount(oPC)
                    && !GetLocalInt(oPC, "CohortRecruited")
                    && !GetPRCSwitch(PRC_DISABLE_STANDARD_COHORTS))
                    AddChoice("Recruit a standard cohort", 4);
                //not implemented, remove via radial or conversation
                //if(GetCurrentCohortCount(oPC))
                //    AddChoice("Dismiss an existing cohort", 2);
                if(GetCampaignInt(COHORT_DATABASE, "CohortCount")>0)
                    AddChoice("Delete a stored custom cohort", 3);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD)
            {
                SetHeader("Select a cohort:");

                int nCohortCount = GetCampaignInt(COHORT_DATABASE, "CohortCount");
                int i;
                for(i=1;i<=nCohortCount;i++)
                {
                    if(GetIsCohortChoiceValidByID(i, oPC))
                    {
                        string sName = GetCampaignString(COHORT_DATABASE, "Cohort_"+IntToString(i)+"_name");
                        AddChoice(sName, i);
                    }
                }

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM)
            {
                string sHeader = "Are you sure you want this cohort?";

                int nCohortID = GetLocalInt(oPC, "CohortID");
                string sName = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_name");
                int    nRace = GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_race");
                int    nClass1=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class1");
                int    nClass2=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class2");
                int    nClass3=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class3");
                int    nOrder= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_order");
                int    nMoral= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_moral");
                sHeader +="\n"+sName;
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", nRace)));
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass1)));
                if(nClass2 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass2)));
                if(nClass3 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass3)));
                SetHeader(sHeader);
                AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_RACE)
            {
                SetHeader("Select a race for the cohort:");
                AddCohortRaces(  0, 255, oPC);/*
                DelayCommand(0.0f, AddCohortRaces(101, 200, oPC));
                DelayCommand(0.0f, AddCohortRaces(201, 255, oPC));
*/
                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_GENDER)
            {
                SetHeader("Select a gender for the cohort:");
                AddChoice("Male", GENDER_MALE);
                AddChoice("Female", GENDER_FEMALE);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CLASS)
            {
                SetHeader("Select a class for the cohort:");
                int i;
                //only do bioware base classes for now otherwise the AI will fubar
                for(i=0;i<=10;i++)
                {
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", i)));
                    AddChoice(sName, i);
                }
                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN)
            {
                SetHeader("Select an alignment for the cohort:");

                int nClass = GetLocalInt(oPC, "CustomCohortClass");
                if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_GOOD,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(112), 0);
                }
                if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(115), 1);
                }
                if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(118), 2);
                }
                if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(113), 3);
                }
                if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(116), 4);
                }
                if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(119), 5);
                }
                if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_EVIL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(114), 6);
                }
                if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(117), 7);
                }
                if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(120), 8);
                }
                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM)
            {
                string sHeader = "Are you sure you want this cohort?";
                int    nRace = GetLocalInt(oPC, "CustomCohortRace");
                int    nClass= GetLocalInt(oPC, "CustomCohortClass");
                int    nOrder= GetLocalInt(oPC, "CustomCohortOrder");
                int    nMoral= GetLocalInt(oPC, "CustomCohortMoral");
                int    nGender=GetLocalInt(oPC, "CustomCohortGender");
                string sKey=   GetPCPublicCDKey(oPC);
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", nRace)));
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
                SetHeader(sHeader);
                // GetIsCohortChoiceValid(sName, nRace, nClass1, nClass2,            nClass3,            nOrder, nMoral, nEthran, sKey, nDeleted, oPC);
                if(GetIsCohortChoiceValid("",    nRace, nClass,  CLASS_TYPE_INVALID, CLASS_TYPE_INVALID, nOrder, nMoral, FALSE,   sKey, FALSE,    oPC))
                {
                    AddChoice("Yes", 1);
                    AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                }
                else
                    AddChoice("This cohort is invalid", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_DELETE)
            {
                SetHeader("Select a cohort to delete:");

                int nCohortCount = GetCampaignInt(COHORT_DATABASE, "CohortCount");
                int i;
                for(i=1;i<=nCohortCount;i++)
                {
                    if(GetIsCohortChoiceValidByID(i, oPC))
                    {
                        string sName = GetCampaignString(COHORT_DATABASE, "Cohort_"+IntToString(i)+"_name");
                        AddChoice(sName, i);
                    }
                }

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_DELETE_CONFIRM)
            {
                string sHeader = "Are you sure you want to delete this cohort?";

                int nCohortID = GetLocalInt(oPC, "CohortID");
                string sName = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_name");
                int    nRace = GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_race");
                int    nClass1=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class1");
                int    nClass2=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class2");
                int    nClass3=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class3");
                int    nOrder= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_order");
                int    nMoral= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_moral");
                sHeader +="\n"+sName;
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", nRace)));
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass1)));
                if(nClass2 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass2)));
                if(nClass3 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass3)));
                SetHeader(sHeader);
                AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_NATURAL_WEAPON)
            {
                string sHeader = "Select a natural weapon to use.";
                SetHeader(sHeader);
                AddChoice("Unarmed", -1);
                int i;
                for(i=0;i<GetPrimaryNaturalWeaponCount(oPC);i++)
                {
                    string sName;
                    //use resref for now
                    sName = array_get_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, i);
                    if(sName != "")
                    {
                        AddChoice(sName, i);
                        if (DEBUG) DoDebug("STAGE_NATURAL_WEAPON "+sName+" "+IntToString(i));
                    }                        
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_WOL_HEADER)
            {
                string sHeader = "Do you wish to purchase a legacy or research legacy weapons?";
                SetHeader(sHeader);
                AddChoice("Purchase", 1);
                AddChoice("Research", 2);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            } 
            else if (nStage == STAGE_WOL_RESEARCH)
            {
                string sHeader = "Select a Weapon of Legacy to research:";
                SetHeader(sHeader);
                AddLegacies(oPC, TRUE);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }    
            else if (nStage == STAGE_WOL_RESEARCH_2)
            {
                int nWoL = GetLocalInt(oPC, "WoLToResearch");
                string sName;
                string sHeader;
                int nNameID = StringToInt(Get2DACache("wol_items", "Name", nWoL));
                int nDescID = StringToInt(Get2DACache("wol_items", "Description", nWoL));
                if(nNameID != 0)
                    sName = GetStringByStrRef(nNameID);
                else
                    sName = Get2DACache("wol_items", "Label", nWoL);

                sHeader = "You have selected: "+sName+"\n";
                sHeader += GetStringByStrRef(nDescID);
                SetHeader(sHeader);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }            
            else if (nStage == STAGE_WOL_PURCHASE)
            {
                string sHeader = "Select a Weapon of Legacy to purchase. You can only ever have one legacy:";
                SetHeader(sHeader);
                AddLegacies(oPC);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_WOL_RITUALS)
            {
                string sHeader = "Select a Legacy Ritual to Perform";
                SetHeader(sHeader);
                AddRitualCost(oPC);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }             
            else if (nStage == STAGE_WOL_CONFIRM)
            {
                int nWoL = GetLocalInt(oPC, "WoLToBuy");
                string sName;
                string sHeader;
                int nNameID = StringToInt(Get2DACache("wol_items", "Name", nWoL));
                int nDescID = StringToInt(Get2DACache("wol_items", "Description", nWoL));
                if(nNameID != 0)
                    sName = GetStringByStrRef(nNameID);
                else
                    sName = Get2DACache("wol_items", "Label", nWoL);

                sHeader = "You have selected: "+sName+"\n";
                sHeader += GetStringByStrRef(nDescID)+"\n";
                sHeader += "\nAre you sure you want this weapon of legacy?";
                SetHeader(sHeader);
                AddChoice("Yes", TRUE);
                AddChoice("No", FALSE);

                MarkStageSetUp(nStage, oPC);
            } 
            else if (nStage == STAGE_LA_BUYOFF)
            {
                string sHeader = "Do you wish to buyoff a point of LA? It will cost "+IntToString(GetBuyoffCost(oPC))+" XP";
                SetHeader(sHeader);
                AddChoice("Yes", TRUE);
                AddChoice("No", FALSE);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }  
            else if (nStage == STAGE_ENCOUNTER_AREAS)
            {
                string sHeader = "Please choose which encounter area to travel to. The encounter level given is the expected level of PC to travel there.";
                SetHeader(sHeader);
                AddChoice("Basin of Deadly Dust (EL 4)", 10);

                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);            
            }
            else if (nStage == STAGE_ENCOUNTER_CONFIRM)
            {
            	// Yes, there's an offset
                int nEA = GetLocalInt(oPC, "EncounterChoice") - 10;
                
                string sHeader;
                int nNameID = StringToInt(Get2DACache("encounter_areas", "Name", nEA));
                int nDescID = StringToInt(Get2DACache("encounter_areas", "Description", nEA));
                string sName = GetStringByStrRef(nNameID);
            
                sHeader = "You have selected: "+sName+"\n";
                sHeader += GetStringByStrRef(nDescID)+"\n";
                sHeader += "\nAre you sure you want to travel to this encounter area?";
                SetHeader(sHeader);
                AddChoice("Yes", TRUE);
                AddChoice("No", FALSE);

                MarkStageSetUp(nStage, oPC);          
            }            
            else if (nStage == STAGE_TEMPLATE)
            {
                string sHeader = "Select a template to gain:";
                SetHeader(sHeader);
                AddTemplates(0, PRCGetFileEnd("templates"), oPC);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_TEMPLATE_HALF_DRAGON)
            {
                int nTemplateID = GetLocalInt(oPC, "TemplateIDToGain");
                string sName;
                string sHeader;
                int nNameID = StringToInt(Get2DACache("templates", "Name", nTemplateID));
                int nDescID = StringToInt(Get2DACache("templates", "Description", nTemplateID));
                if(nNameID != 0)
                    sName = GetStringByStrRef(nNameID);
                else
                    sName = Get2DACache("templates", "Label", nTemplateID);
                if(((StringToInt(Get2DACache("templates", "Type", nTemplateID)) & 1) && GetHitDice(oPC) > 1)
                    || !ApplyTemplateToObject(nTemplateID, oPC, FALSE))
                {
                    sHeader = GetStringByStrRef(nDescID)+"\n";
                    SetHeader(sHeader);
                    AddChoice("Back", FALSE);
                }
                else
                {
                    sHeader = GetStringByStrRef(nDescID)+"\n\n";
                    sHeader += "Select your draconic heritage:";
                    SetHeader(sHeader);
                    int i;
                    for(i = 1; i < 38; i++)
                    {
                        AddChoice(GetStringByStrRef(GetStrRefForTemplate(i)), i, oPC);
                    }
                    MarkStageSetUp(STAGE_TEMPLATE_HALF_DRAGON, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                }
            }
            else if (nStage == STAGE_TEMPLATE_HALF_DRAGON_CONFIRM)
            {
                int nDragID = GetLocalInt(oPC, "PRC_HalfDragon_Choice");
                string sName = GetStringByStrRef(GetStrRefForTemplate(nDragID));
                string sText = "You have selected " + sName + " template.\n\n";
                sText += GetStringByStrRef(GetStrRefForTemplate(nDragID)+1) + "\n\n";
                sText += "Is this correct?";

                SetHeader(sText);
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"
                MarkStageSetUp(STAGE_TEMPLATE_HALF_DRAGON_CONFIRM, oPC);
            }
            else if (nStage == STAGE_TEMPLATE_CONFIRM)
            {
                int nTemplateID = GetLocalInt(oPC, "TemplateIDToGain");
                string sName;
                string sHeader;
                int nNameID = StringToInt(Get2DACache("templates", "Name", nTemplateID));
                int nDescID = StringToInt(Get2DACache("templates", "Description", nTemplateID));
                if(nNameID != 0)
                    sName = GetStringByStrRef(nNameID);
                else
                    sName = Get2DACache("templates", "Label", nTemplateID);
                if(((StringToInt(Get2DACache("templates", "Type", nTemplateID)) & 1) && GetHitDice(oPC) > 1)
                    || !ApplyTemplateToObject(nTemplateID, oPC, FALSE))
                {
                    sHeader = GetStringByStrRef(nDescID)+"\n";
                    SetHeader(sHeader);
                    AddChoice("Back", FALSE);
                }
                else
                {
                    sHeader = "You have selected: "+sName+"\n";
                    sHeader += GetStringByStrRef(nDescID)+"\n";
                    sHeader += "\nAre you sure you want this template?";
                    SetHeader(sHeader);
                    AddChoice("Yes", TRUE);
                    AddChoice("No", FALSE);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_MISC_OPTIONS)
            {
                SetHeader("You can setup various options for PRC spells and abilities here:");
                if(GetHasFeat(FEAT_WILD_SHAPE, oPC))
                    AddChoice(GetStringByStrRef(504), 1);//Wild Shape
                if(GetHasFeat(FEAT_ELEMENTAL_SHAPE, oPC))
                    AddChoice(GetStringByStrRef(505), 2);//Elemental Shape
                if(GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON, oPC))
                    AddChoice(GetStringByStrRef(8667), 3);//Dragon Shape
                if(GetHasFeat(FEAT_ABERRANT_WILD_SHAPE, oPC))
                    AddChoice(GetStringByStrRef(16790272), 4);//Aberration Wild Shape                    
                //AddChoice("Spell options.", 5);
                //AddChoice("PnP familiar/animal compnion.", 6);

                //PW Security System by FunkySwerve
                if(GetPCPublicCDKey(oPC)!="" && GetPRCSwitch(PRC_PW_SECURITY_CD_CHECK))//only in multiplayer mode
                {
                    if(GetCanAddNewKey(oPC))
                    {
                        AddChoice("PW - add new CD Key", 100);
                    }
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_WILDSHAPE_SLOTS)
            {
                SetHeader("You attune yourself to nature, recallling animal forms.");
                AddChoice(GetStringByStrRef(8178), 401);//Brown Bear
                AddChoice(GetStringByStrRef(8179), 402);//Wolf
                AddChoice(GetStringByStrRef(8180), 403);//Panther
                AddChoice(GetStringByStrRef(8181), 404);//Boar
                AddChoice(GetStringByStrRef(8182), 405);//Badger

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_WILDSHAPE_SHAPE)
            {
                SetHeader("Assign which shape to this form?");
                SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                AddShapes(0, 500/*PRCGetFileEnd("prc_polymorph")*/, oPC, TYPE_WILD_SHAPE);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_ELEMENTALSHAPE_SLOTS)
            {
                SetHeader("You attune yourself to nature, recallling elemental forms.");
                AddChoice(GetStringByStrRef(8174), 397);//Fire
                AddChoice(GetStringByStrRef(8175), 398);//Water
                AddChoice(GetStringByStrRef(8176), 399);//Earth
                AddChoice(GetStringByStrRef(8177), 400);//Air

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_ELEMENTALSHAPE_SHAPE)
            {
                SetHeader("Assign which shape to this form?");
                SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                AddShapes(0, 500/*PRCGetFileEnd("prc_polymorph")*/, oPC, TYPE_ELEMENTAL_SHAPE);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_DRAGONSHAPE_SLOTS)
            {
                SetHeader("You attune yourself to nature, recallling dragon forms.");
                AddChoice(GetStringByStrRef(12491), 707);//Red
                AddChoice(GetStringByStrRef(12467), 708);//Blue
                AddChoice(GetStringByStrRef(12487), 709);//Green

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_DRAGONSHAPE_SHAPE)
            {
                SetHeader("Assign which shape to this form?");
                SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                AddShapes(0, 500/*PRCGetFileEnd("prc_polymorph")*/, oPC, TYPE_DRAGON_SHAPE);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_ABERRANT_SLOTS)
            {
                SetHeader("You attune yourself to nature, recallling animal forms.");
                AddChoice(GetStringByStrRef(8178), 401);//Brown Bear
                AddChoice(GetStringByStrRef(8179), 402);//Wolf
                AddChoice(GetStringByStrRef(8180), 403);//Panther
                AddChoice(GetStringByStrRef(8181), 404);//Boar
                AddChoice(GetStringByStrRef(8182), 405);//Badger

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_ABERRANT_SHAPE)
            {
                SetHeader("Assign which shape to this form?");
                SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                AddShapes(0, 500/*PRCGetFileEnd("prc_polymorph")*/, oPC, TYPE_ABERRANT_SHAPE);
                SetDefaultTokens();

                MarkStageSetUp(nStage, oPC);
            }            
            else if (nStage == STAGE_PNP_FAMILIAR_COMPANION)
            {
                string sHeader = "This will remove all information about your pnp familiars.";
                SetHeader(sHeader);
                AddChoice("Dismiss familiar.", 1);
                AddChoice("Dismiss animal companion.", 2);
                AddChoice("Dismiss shaman's animal companion.", 3);
                AddChoice("Dismiss ultimate ranger's animal companion.", 4);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_CDKEY_ADD)
            {
                string sHeader = "With this option you can add new CD Key to your account (max 7 keys allowed). After selecting OK please logout, swap to the new key and login again.";
                SetHeader(sHeader);
                AddChoice("OK", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        //end of conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
        DeleteLocalInt(oPC, "CohortID");
        DeleteLocalInt(oPC, "CustomCohortRace");
        DeleteLocalInt(oPC, "CustomCohortClass");
        DeleteLocalInt(oPC, "CustomCohortMoral");
        DeleteLocalInt(oPC, "CustomCohortOrder");
        DeleteLocalInt(oPC, "CustomCohortGender");
        DeleteLocalInt(oPC, "TemplateIDToGain");
        DeleteLocalInt(oPC, "WildShapeSlot");
        DeleteLocalInt(oPC, "PRC_HalfDragon_Choice");
        DeleteLocalInt(oPC, "EncounterChoice");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        //abort conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
        DeleteLocalInt(oPC, "CohortID");
        DeleteLocalInt(oPC, "CustomCohortRace");
        DeleteLocalInt(oPC, "CustomCohortClass");
        DeleteLocalInt(oPC, "CustomCohortMoral");
        DeleteLocalInt(oPC, "CustomCohortOrder");
        DeleteLocalInt(oPC, "CustomCohortGender");
        DeleteLocalInt(oPC, "TemplateIDToGain");
        DeleteLocalInt(oPC, "WildShapeSlot");
        DeleteLocalInt(oPC, "PRC_HalfDragon_Choice");
        DeleteLocalInt(oPC, "EncounterChoice");
    }
    else
    {
        // PC response handling
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if(nChoice == 1)
                nStage = STAGE_SWITCHES;
            else if(nChoice == 2)
                nStage = STAGE_EPIC_SPELLS;
            else if(nChoice == 3)
                nStage = STAGE_SHOPS;
            else if(nChoice == 4)
            {
                AssignCommand(oPC, TryToIDItems(oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == 5)
                nStage = STAGE_TEFLAMMAR_SHADOWLORD;
            else if(nChoice == 6)
            {
                RegisterAsCohort(oPC);
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == 7)
                nStage = STAGE_LEADERSHIP;
            else if(nChoice == 8)
                nStage = STAGE_NATURAL_WEAPON;
            else if(nChoice == 9)
                nStage = STAGE_TEMPLATE;
            else if(nChoice == 35)
                nStage = STAGE_WOL_HEADER;   
            else if(nChoice == 41)
                nStage = STAGE_LA_BUYOFF;                 
            else if(nChoice == 42)
                nStage = STAGE_ENCOUNTER_AREAS;                 
            else if(nChoice == 10)
                nStage = STAGE_APPEARANCE;
            else if(nChoice == 11)
                nStage = STAGE_MISC_OPTIONS;
            else if(nChoice == 12)
            {
                DelayCommand(1.0, ExecuteScript("prc_wipeNSB", oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }

            // Mark the target stage to need building if it was changed (ie, selection was other than ID all)
            if(nStage != STAGE_ENTRY)
                MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_SWITCHES_USE_2DA)
            {
                object oModule = GetModule();
                int i = 0;
                string sSwitchName, sSwitchType, sSwitchValue;
                // Use Get2DAString() instead of Get2DACache() to avoid caching.
                // People might want to set different switch values when playing in different modules.
                // Or just change the switch values midplay.
                while((sSwitchName = Get2DAString("personal_switch", "SwitchName", i)) != "")
                {
                    // Read rest of the line
                    sSwitchType  = Get2DAString("personal_switch", "SwitchType",  i);
                    sSwitchValue = Get2DAString("personal_switch", "SwitchValue", i);

                    // Determine switch type and set the var
                    if(sSwitchType == "float")
                        SetLocalFloat(oModule, sSwitchName, StringToFloat(sSwitchValue));
                    else if(sSwitchType == "int")
                        SetPRCSwitch(sSwitchName, StringToInt(sSwitchValue));
                    else if(sSwitchType == "string")
                        SetLocalString(oModule, sSwitchName, sSwitchValue);

                    // Increment loop counter
                    i += 1;
                }
            }
            else
            {
                //move to another stage based on response
                SetLocalString(oPC, "VariableName", GetChoiceText(oPC));
                nStage = STAGE_SWITCHES_VALUE;
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES_VALUE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                nStage = STAGE_SWITCHES;
            }
            else
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                SetPRCSwitch(sVarName, GetPRCSwitch(sVarName) + nChoice);
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS)
        {
            int nOldStage = nStage;
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if (nChoice == 1)
                nStage = STAGE_EPIC_SPELLS_REMOVE;
            else if (nChoice == 2)
                nStage = STAGE_EPIC_SPELLS_ADD;
            else if (nChoice == 3)
                nStage = STAGE_EPIC_SPELLS_CONTING;
            else if (nChoice == 4)
            {
                //research an epic spell
                object oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_ess_research", GetLocation(oPC));
                if(!GetIsObjectValid(oPlaceable))
                    DoDebug("Research placeable not valid.");
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, DoPlaceableObjectAction(oPlaceable, PLACEABLE_ACTION_USE));
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPlaceable);
                DestroyObject(oPlaceable, 60.0);
                //end the conversation
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if (nChoice == 5)
            {
                int i;
                for(i = 0; i < 71; i++)
                {
                    if(GetHasEpicSpellKnown(i, oPC))
                    {
                        SendMessageToPC(oPC, GetNameForSpell(i)+" is known.");
                    }
                }
            }
            else if (nChoice == 6)
            {
                int i;
                for(i = 0; i < 28; i++)
                {
                    if(GetHasEpicSeedKnown(i, oPC))
                    {
                        SendMessageToPC(oPC, GetNameForSeed(i)+" is known.");
                    }
                }
            }
            if(nOldStage != nStage)
                MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_ADD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else
            {
                GiveFeat(oPC, StringToInt(Get2DACache("epicspells", "SpellFeatIPID", nChoice)));
                ClearCurrentStage();
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else
            {
                TakeFeat(oPC, StringToInt(Get2DACache("epicspells", "SpellFeatIPID", nChoice)));
                ClearCurrentStage();
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_CONTING)
        {
            //contingencies
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else if(nChoice == 1) //contingent resurrection
                SetLocalInt(oPC, "nContingentRez", 0);

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SHOPS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if (nChoice == 1)
            {
                //Magic item raw materials
                object oStore = GetObjectByTag("prc_magiccraft");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_magiccraft", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if (nChoice == 2)
            {
                //Material componets for spells
                object oStore = GetObjectByTag("prc_materialcomp");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_materialcomp", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if (nChoice == 3)
            {
                //Spell scrolls
                object oStore = GetObjectByTag("prc_scrolls");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_scrolls", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if (nChoice == 4)
            {
                //Epic spell books
                object oStore = GetObjectByTag("prc_epicspells");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_epicspells", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }

            //MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_TEFLAMMAR_SHADOWLORD)
        {
            nStage = STAGE_ENTRY;
            if(nChoice == 1)
            {
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, TakeGoldFromCreature(10000, oPC, TRUE));
                //use a persistant local instead of an item
                //CreateItemOnObject("shadowwalkerstok", oPC);
                SetPersistantLocalInt(oPC, "shadowwalkerstok", TRUE);
                SetLocalInt(oPC, "PRC_PrereqTelflam", 0);
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP)
        {
            if(nChoice == 1)
                nStage = STAGE_LEADERSHIP_ADD_STANDARD;
            else if(nChoice == 2)
                nStage = STAGE_LEADERSHIP_REMOVE;
            else if(nChoice == 3)
                nStage = STAGE_LEADERSHIP_DELETE;
            else if(nChoice == 4)
                nStage = STAGE_LEADERSHIP_ADD_CUSTOM_RACE;
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_REMOVE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {

            }
            else
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                RemoveCohortFromPlayer(GetCohort(nCohortID, oPC), oPC);
            }
            nStage = STAGE_LEADERSHIP;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP;
            else
            {
                SetLocalInt(oPC, "CohortID", nChoice);
                nStage = STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM;
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM)
        {
            if(nChoice == 1)
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                AddCohortToPlayer(nCohortID, oPC);
                //mark the player as having recruited for the day
                SetLocalInt(oPC, "CohortRecruited", TRUE);
                nStage = STAGE_LEADERSHIP;
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP_ADD_STANDARD;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_RACE)
        {
            SetLocalInt(oPC, "CustomCohortRace", nChoice);
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_GENDER;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_GENDER)
        {
            SetLocalInt(oPC, "CustomCohortGender", nChoice);
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_CLASS;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CLASS)
        {
            SetLocalInt(oPC, "CustomCohortClass", nChoice);
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN)
        {
            switch(nChoice)
            {
                case 0: //lawful good
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 85);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 85);
                    break;
                case 1: //neutral good
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 50);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 85);
                    break;
                case 2: //chaotic good
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 15);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 85);
                    break;
                case 3: //lawful neutral
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 85);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 50);
                    break;
                case 4: //true neutral
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 50);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 50);
                    break;
                case 5: //chaotic neutral
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 15);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 50);
                    break;
                case 6: //lawful evil
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 85);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 15);
                    break;
                case 7: //neutral evil
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 50);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 15);
                    break;
                case 8: //chaotic evil
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 15);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 15);
                    break;
            }
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM)
        {
            if(nChoice == 1)
            {
                int    nRace = GetLocalInt(oPC, "CustomCohortRace");
                int    nClass= GetLocalInt(oPC, "CustomCohortClass");
                int    nOrder= GetLocalInt(oPC, "CustomCohortOrder");
                int    nMoral= GetLocalInt(oPC, "CustomCohortMoral");
                int    nGender= GetLocalInt(oPC, "CustomCohortGender");
                string sResRef = "prc_npc_"+IntToString(nRace)+"_"+IntToString(nClass)+"_"+IntToString(nGender);
                location lSpawn = GetLocation(oPC);
                object oCohort = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn, TRUE, COHORT_TAG);
                //change alignment
                CohortSetAlignment(nMoral, nOrder, oCohort);
                DelayCommand(1.0, CohortSetAlignment(nMoral, nOrder, oCohort));
                DelayCommand(3.0, CohortSetAlignment(nMoral, nOrder, oCohort));
                DelayCommand(5.0, CohortSetAlignment(nMoral, nOrder, oCohort));
                //level it up
                int i;
                //if simple racial HD on, give them racial HD
                if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
                {
                    //get the real race
                    int nRace = GetRacialType(oCohort);
                    int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", nRace));
                    int nRacialClass = StringToInt(Get2DACache("ECL", "RaceClass", nRace));
                    for(i=0;i<nRacialHD;i++)
                    {
                        LevelUpHenchman(oCohort, nRacialClass, TRUE);
                    }
                }
                //give them their levels in their class
                int nLevel = GetCohortMaxLevel(GetLeadershipScore(oPC), oPC);
                for(i=GetHitDice(oCohort);i<nLevel;i++)
                {
                    LevelUpHenchman(oCohort, CLASS_TYPE_INVALID, TRUE);
                }
                //add to player
                //also does name/portrait/bodypart changes via DoDisguise
                DelayCommand(0.01, AddCohortToPlayerByObject(oCohort, oPC));
                //mark the player as having recruited for the day
                SetLocalInt(oPC, "CohortRecruited", TRUE);
                nStage = STAGE_LEADERSHIP;
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_DELETE)
        {
            SetLocalInt(oPC, "CohortID", nChoice);
            nStage = STAGE_LEADERSHIP_DELETE_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_DELETE_CONFIRM)
        {
            if(nChoice == 1)
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                DeleteCohort(nCohortID);
                nStage = STAGE_LEADERSHIP;
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP_DELETE;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_NATURAL_WEAPON)
        {
            /*if(nChoice = -512)
                //no primary natural weapon
                SetPersistantLocalInt(oPC, "NaturalWeaponPlayerOverride", -1);
            else
                //specific natural weapon
                SetPersistantLocalInt(oPC, "NaturalWeaponPlayerOverride", nChoice);*/
            SetPrimaryNaturalWeapon(oPC, nChoice);

            nStage = STAGE_ENTRY;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_WOL_HEADER)
        {
            if(nChoice == 1)
            {        
                if(GetPersistantLocalInt(oPC, "LegacyOwner"))
                    nStage = STAGE_WOL_RITUALS;
                else    
                    nStage = STAGE_WOL_PURCHASE;
            }
            else if(nChoice == 2)
                nStage = STAGE_WOL_RESEARCH;
                
            MarkStageNotSetUp(nStage, oPC);                    
        } 
        else if (nStage == STAGE_WOL_RESEARCH)
        {
            SetLocalInt(oPC, "WoLToResearch", nChoice);

            nStage = STAGE_WOL_RESEARCH_2;
            MarkStageNotSetUp(nStage, oPC);
        }       
        else if (nStage == STAGE_WOL_RESEARCH_2)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_WOL_RESEARCH;
            MarkStageNotSetUp(nStage, oPC);
        }         
        else if (nStage == STAGE_WOL_PURCHASE)
        {
            SetLocalInt(oPC, "WoLToBuy", nChoice);

            nStage = STAGE_WOL_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        } 
        else if (nStage == STAGE_WOL_RITUALS)
        {
            // Cost is always over 999
            if(nChoice > 999)
            {
                // Pay for the item, create it and equip it
                TakeGoldFromCreature(nChoice, oPC, TRUE);
                UpgradeLegacy(oPC);
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_WOL_CONFIRM;
                MarkStageNotSetUp(nStage, oPC);
            }
        }        
        else if (nStage == STAGE_WOL_CONFIRM)
        {
            if(nChoice)
            {
                int nWoL = GetLocalInt(oPC, "WoLToBuy");
                if (!GetPRCSwitch(PRC_DISABLE_WOL_AREA) && Get2DACache("wol_items", "Area", nWoL) != "") JumpToEncounterArea(oPC, nWoL);
                else ApplyWoLToObject(nWoL, oPC);
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_WOL_PURCHASE;
                MarkStageNotSetUp(nStage, oPC);
            }
        }   
        else if (nStage == STAGE_LA_BUYOFF)
        {
            if(nChoice)
            {
                BuyoffLevel(oPC);
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage, oPC);
            }
        }    
        else if (nStage == STAGE_ENCOUNTER_AREAS)
        {
            if(nChoice)
            {
            	SetLocalInt(oPC, "EncounterChoice", nChoice);
                nStage = STAGE_ENCOUNTER_CONFIRM;
            }
            else
            {
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage, oPC);
            }        	
        }
        else if (nStage == STAGE_ENCOUNTER_CONFIRM)
        {
            if(nChoice)
            {
            	int nEA = GetLocalInt(oPC, "EncounterChoice");
            	ClearAllActions();
            	if (nEA == 10) 
            	{
            		//FloatingTextStringOnCreature("Jumping to the Basin of Deadly Dust", oPC, FALSE);
            		SetLocalInt(oPC, "BDD_Enter", TRUE);
            		SetLocalLocation(oPC, "EA_Return", GetLocation(oPC));
            		CreateArea("bdd_basinrim");
            		CreateArea("bdd_cave");
            		CreateArea("bdd_smelter");
            		DelayCommand(1.5, AssignCommand(oPC, JumpToLocation(GetLocation(GetWaypointByTag("bdd_enter")))));
            	}	
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage, oPC);
            }        	
        }        
        else if (nStage == STAGE_TEMPLATE)
        {
            SetLocalInt(oPC, "TemplateIDToGain", nChoice);

            nStage = nChoice == TEMPLATE_HALF_DRAGON ? STAGE_TEMPLATE_HALF_DRAGON : STAGE_TEMPLATE_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_TEMPLATE_HALF_DRAGON)
        {
            if(nChoice)
            {
                SetLocalInt(oPC, "PRC_HalfDragon_Choice", nChoice);
                nStage = STAGE_TEMPLATE_HALF_DRAGON_CONFIRM;
            }
            else
            {
                nStage = STAGE_TEMPLATE;
                MarkStageNotSetUp(nStage, oPC);
            }
        }
        else if (nStage == STAGE_TEMPLATE_HALF_DRAGON_CONFIRM)
        {
            if(nChoice == TRUE)
            {
                int nTemplate = GetLocalInt(oPC, "PRC_HalfDragon_Choice");
                ApplyTemplateToObject(TEMPLATE_HALF_DRAGON, oPC);
                SetPersistantLocalInt(oPC, "HalfDragon_Template", nTemplate);
                DelayCommand(0.01, EvalPRCFeats(oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_TEMPLATE_HALF_DRAGON;
                DeleteLocalInt(oPC, "PRC_HalfDragon_Choice");
                MarkStageNotSetUp(nStage, oPC);
                MarkStageNotSetUp(STAGE_TEMPLATE_HALF_DRAGON_CONFIRM, oPC);
            }
        }
        else if (nStage == STAGE_TEMPLATE_CONFIRM)
        {
            if(nChoice)
            {
                int nTemplateID = GetLocalInt(oPC, "TemplateIDToGain");
                ApplyTemplateToObject(nTemplateID, oPC);
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_TEMPLATE;
                MarkStageNotSetUp(nStage, oPC);
            }
        }
        else if (nStage == STAGE_MISC_OPTIONS)
        {
            if(nChoice == 1)
            {
                nStage = STAGE_WILDSHAPE_SLOTS;
                MarkStageNotSetUp(nStage, oPC);
            }
            else if(nChoice == 2)
            {
                nStage = STAGE_ELEMENTALSHAPE_SLOTS;
                MarkStageNotSetUp(nStage, oPC);
            }
            else if(nChoice == 3)
            {
                nStage = STAGE_DRAGONSHAPE_SLOTS;
                MarkStageNotSetUp(nStage, oPC);
            }
            else if(nChoice == 4)
            {
                nStage = STAGE_ABERRANT_SLOTS;
                MarkStageNotSetUp(nStage, oPC);
            }            
            else if(nChoice == 100)
            {
                nStage = STAGE_CDKEY_ADD;
                MarkStageNotSetUp(nStage, oPC);
            }
        }
        else if (nStage == STAGE_WILDSHAPE_SLOTS)
        {
            SetLocalInt(oPC, "WildShapeSlot", nChoice);

            nStage = STAGE_WILDSHAPE_SHAPE;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_WILDSHAPE_SHAPE)
        {
            int nSlot = GetLocalInt(oPC, "WildShapeSlot");
            SetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSlot), nChoice);

            nStage = STAGE_WILDSHAPE_SLOTS;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_ELEMENTALSHAPE_SLOTS)
        {
            SetLocalInt(oPC, "WildShapeSlot", nChoice);

            nStage = STAGE_ELEMENTALSHAPE_SHAPE;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_ELEMENTALSHAPE_SHAPE)
        {
            int nSlot = GetLocalInt(oPC, "WildShapeSlot");
            SetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSlot), nChoice);

            nStage = STAGE_ELEMENTALSHAPE_SLOTS;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_DRAGONSHAPE_SLOTS)
        {
            SetLocalInt(oPC, "WildShapeSlot", nChoice);

            nStage = STAGE_DRAGONSHAPE_SHAPE;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_DRAGONSHAPE_SHAPE)
        {
            int nSlot = GetLocalInt(oPC, "WildShapeSlot");
            SetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSlot), nChoice);

            nStage = STAGE_DRAGONSHAPE_SLOTS;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_ABERRANT_SLOTS)
        {
            SetLocalInt(oPC, "WildShapeSlot", nChoice);

            nStage = STAGE_ABERRANT_SHAPE;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_ABERRANT_SHAPE)
        {
            int nSlot = GetLocalInt(oPC, "WildShapeSlot");
            SetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSlot), nChoice);

            nStage = STAGE_ABERRANT_SLOTS;
            MarkStageNotSetUp(nStage, oPC);
        }        
        else if (nStage == STAGE_PNP_FAMILIAR_COMPANION)
        {
            if(nChoice == 1)
            {
                DeletePersistantLocalInt(oPC, "PnPFamiliarType");
                MyDestroyObject(GetLocalObject(oPC, "Familiar"));
                MyDestroyObject(GetItemPossessedBy(oPC, "prc_pnp_familiar"));
            }
       }
       else if (nStage == STAGE_CDKEY_ADD)
       {
            if(nChoice == 1)
                AddNewCDKey(oPC);

            nStage = STAGE_ENTRY;
            MarkStageNotSetUp(nStage, oPC);
       }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
