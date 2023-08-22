//:://////////////////////////////////////////////
//:: Conhort dynamic conversation
//:: filename
//:://////////////////////////////////////////////
/** @file
    Dynamic conversation file for cohorts
    Handles all the normal cohort options
    plus:
        item useage
        feat useage
        spell useage
        interactions with nearby stuff

    Note: This is one of the few convos where
    the PC is not talking to themselves

    @author Primogenitor
    @date   Created  - 2006.07.12
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_leadersh"
#include "x0_inc_henai"
//#include "x0_i0_henchman"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                   =   0;
const int STAGE_REENTRY                 =   1;
const int STAGE_SPELL                   = 100;
const int STAGE_SPELL_TARGET            = 101;
const int STAGE_FEAT                    = 200;
const int STAGE_FEAT_TARGET             = 201;
const int STAGE_ITEM                    = 300;
const int STAGE_ITEM_SPELL              = 301;
const int STAGE_ITEM_TARGET             = 302;
const int STAGE_IDENTIFY                = 400;
const int STAGE_IDENTIFY_YES            = 401;
const int STAGE_IDENTIFY_NO             = 402;
const int STAGE_TACTICS                 = 500;
const int STAGE_TACTICS_EQUIP           = 501;
const int STAGE_TACTICS_DEFEND          = 502;
const int STAGE_TACTICS_ATTACK          = 503;
const int STAGE_TACTICS_DISTANCE        = 504;
const int STAGE_TACTICS_DISTANCE_CLOSE  = 541;
const int STAGE_TACTICS_DISTANCE_MEDIUM = 542;
const int STAGE_TACTICS_DISTANCE_LONG   = 542;
const int STAGE_TACTICS_LOCK_HELP       = 505;
const int STAGE_TACTICS_LOCK_NOHELP     = 506;
const int STAGE_TACTICS_STEALTH_ALWAYS  = 507;
const int STAGE_TACTICS_STEALTH_COMBAT  = 507;
const int STAGE_TACTICS_STEALTH_NEVER   = 508;
const int STAGE_LEAVE                   = 600;
const int STAGE_LEAVE_YES               = 601;
const int STAGE_LEAVE_NO                = 602;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////


void AddUseableFeats(int nMin, int nMax, object oPC, object oCohort)
{
    int i;
    for(i=nMin;i<nMax;i++)
    {
        if(GetHasFeat(i, oCohort))
        {
            //test if its useable
            int nSpellID = StringToInt(Get2DACache("feat", "SPELLID", i));
            //0 is Aid so this is a safe comparison
            if(nSpellID)
            {
                //test if it has a sucessor
                string sSucessor = Get2DACache("feat", "SUCCESSOR", i);
                if(sSucessor == ""
                    || (sSucessor != ""
                        && !GetHasFeat(StringToInt(sSucessor), oCohort)))
                {
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", i)));
                    //test for subradials
                    if(Get2DACache("spells", "SubRadSpell1", nSpellID) != "")
                    {
                        int j;
                        for(j=1;j<=5;j++)
                        {
                            string sSubName;
                            int nSubSpellID = StringToInt(Get2DACache("spells", "SubRadSpell"+IntToString(j), nSpellID));
                            if(nSubSpellID)
                            {
                                sSubName = sName+" : "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSubSpellID)));
                                //set them less than zero so we know its a subradial
                                AddChoice(sSubName, 0-nSubSpellID, oPC);
                                //store the feat to decrement
                                SetLocalInt(oCohort, "SubradialSpellFeatID"+IntToString(nSubSpellID), i);
                            }
                        }
                    }
                    else
                    {
                        AddChoice(sName, i, oPC);
                    }
                }
            }
        }
    }
    if(i<GetPRCSwitch(FILE_END_FEAT))
    {
        DelayCommand(0.0, AddUseableFeats(nMax, nMax+(nMax-nMin), oPC, oCohort));
    }
}

void AddUseableSpells(int nMin, int nMax, object oPC, object oCohort)
{
    int i;
    for(i=nMin;i<nMax;i++)
    {
        if(GetHasSpell(i, oCohort))
        {
            string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i)));
            //test for subradials
            if(Get2DACache("spells", "SubRadSpell1", i) != "")
            {
                int j;
                for(j=1;j<=5;j++)
                {
                    string sSubName;
                    int nSubSpellID = StringToInt(Get2DACache("spells", "SubRadSpell"+IntToString(j), i));
                    if(nSubSpellID)
                    {
                        sSubName = sName+" : "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSubSpellID)));
                        //set them less than zero so we know its a subradial
                        AddChoice(sSubName, 0-nSubSpellID, oPC);
                    }
                }
            }
            else
            {
                AddChoice(sName, i, oPC);
            }
        }
    }
    if(i<GetPRCSwitch(FILE_END_SPELLS))
    {
        DelayCommand(0.0, AddUseableSpells(nMax, nMax+(nMax-nMin), oPC, oCohort));
    }
}



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    object oCohort = OBJECT_SELF;
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
            if(nStage == STAGE_ENTRY
                || nStage == STAGE_REENTRY)
            {
                if(oPC == GetMaster(oCohort))
                {
                    if(nStage == STAGE_ENTRY)
                        SetHeader("What do you want?");
                    else if(nStage == STAGE_REENTRY)
                        SetHeader("What do you *really* want?");
                    AddChoice("I need you to cast a spell", 1, oPC);
                    AddChoice("I need you to use a feat", 2, oPC);
                    AddChoice("I need you to use an item", 3, oPC);
                    AddChoice("I need you to identify my equipment", 4, oPC);
                    AddChoice("I need you to change your tactics", 5, oPC);
                    AddChoice("I think we need to part ways", 6, oPC);
                }
                else
                {
                    if(!GetIsObjectValid(GetMaster(oCohort)))
                        if(DEBUG) DoDebug("Master not valid!");
                    if(!GetIsObjectValid(oCohort))
                        if(DEBUG) DoDebug("Cohort not valid!");
                    //speaker not their master
                    SetHeader("Sorry, I can't talk to you right now. Ask "+GetName(GetMaster(oCohort))+" and see if they can help.");
                    //no responces
                }
                //SetHeader("Foo.");
                //AddChoice("Bar", 1, oPC);
                //AddChoice("Baz!", 2, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //using spellss
            else if(nStage == STAGE_SPELL)
            {
                SetHeader("If I must. Which spell do you want me to cast?");
                AddUseableSpells(0, 1000, oPC, oCohort);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //targetting spells is combined with feats
            //using feats
            else if(nStage == STAGE_FEAT)
            {
                SetHeader("If I must. Which feat do you want me to use?");
                AddUseableFeats(0, 1000, oPC, oCohort);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_FEAT_TARGET
                || nStage == STAGE_SPELL_TARGET)
            {
                int nFeat = GetLocalInt(oCohort, "PRC_FeatToUse");
                int nSpellID = StringToInt(Get2DACache("feat", "SPELLID", nFeat));
                if(nFeat < 0)
                {
                    //subradial feat
                    nSpellID = 0-nFeat;
                    nFeat = GetLocalInt(oCohort, "SubradialSpellFeatID"+IntToString(nSpellID));
                }
                if(nStage == STAGE_SPELL_TARGET)
                    nSpellID = GetLocalInt(oCohort, "PRC_SpellToUse");

                int nTargetType = HexToInt(Get2DACache("spells", "TargetType", nSpellID));
                int nHostileSpell = StringToInt(Get2DACache("spells", "HostileSetting", nSpellID));
                string sRangeType = Get2DACache("spells", "Range", nSpellID);
                float fRange = 50.0;
                if(sRangeType == "S"
                    || sRangeType == "T"
                    || sRangeType == "P")
                    fRange = 8.0;
                else if(sRangeType == "M")
                    fRange = 20.0;
                else if(sRangeType == "L")
                    fRange = 40.0;

                /*
                #  0x01 = 1 = Self
                # 0x02 = 2 = Creature
                # 0x04 = 4 = Area/Ground
                # 0x08 = 8 = Items
                # 0x10 = 16 = Doors
                # 0x20 = 32 = Placeables
                */
                int nCaster     = nTargetType &  1;
                int nCreature   = nTargetType &  2;
                int nLocation   = nTargetType &  4;
                int nItem       = nTargetType &  8;
                int nDoor       = nTargetType & 16;
                int nPlaceable  = nTargetType & 32;
                int nCount;
                if(array_exists(oCohort, "PRC_ItemsToUse_Target"))
                    array_delete(oCohort, "PRC_ItemsToUse_Target");
                array_create(oCohort, "PRC_ItemsToUse_Target");
                //self
                if(nCaster)
                {
                    AddChoice("Self ("+GetName(oCohort)+")", array_get_size(oCohort, "PRC_ItemsToUse_Target"));
                    array_set_object(oCohort, "PRC_ItemsToUse_Target",
                        array_get_size(oCohort, "PRC_ItemsToUse_Target"), oCohort);

                }
                //nearby objects or locations of those objects
                if(nCreature
                    || nDoor
                    || nPlaceable
                    || nLocation)
                {
                    object oTest = GetFirstObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oCohort));
                    while(GetIsObjectValid(oTest))
                    {
                        int nType = GetObjectType(oTest);
                        if(((nType == OBJECT_TYPE_CREATURE && nCreature)
                            || (nType == OBJECT_TYPE_DOOR && nDoor)
                            || (nType == OBJECT_TYPE_PLACEABLE && nPlaceable)
                            || nLocation)
                            && oTest != oCohort)//self-casting is covered earlier
                        {
                            AddChoice(GetName(oTest), array_get_size(oCohort, "PRC_ItemsToUse_Target"));
                            array_set_object(oCohort, "PRC_ItemsToUse_Target",
                                array_get_size(oCohort, "PRC_ItemsToUse_Target"), oTest);
                        }
                        oTest = GetNextObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oCohort));
                    }
                }
                //items in inventory
                if(nItem)
                {
                    object oTest = GetFirstItemInInventory(oCohort);
                    while(GetIsObjectValid(oTest))
                    {
                        AddChoice("(in inventory) "+GetName(oTest), array_get_size(oCohort, "PRC_ItemsToUse_Target"));
                        array_set_object(oCohort, "PRC_ItemsToUse_Target",
                            array_get_size(oCohort, "PRC_ItemsToUse_Target"), oTest);
                        oTest = GetNextItemInInventory(oCohort);
                    }
                }

                if(nStage == STAGE_FEAT_TARGET)
                {

                    SetHeader("Who or what do you want me to use "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)))+" on?");
                }
                else if(nStage == STAGE_SPELL_TARGET)
                    SetHeader("Who or what do you want me to cast "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)))+" on?");

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //using items
            else if(nStage == STAGE_ITEM)
            {
                SetHeader("If I must. Which item do you want me to activate?");

                if(!array_exists(oCohort, "PRC_ItemsToUse"))
                {
                    array_create(oCohort, "PRC_ItemsToUse");
                    int nSlot;
                    for(nSlot = 0; nSlot < 14; nSlot++)
                    {
                        object oItem = GetItemInSlot(nSlot, oCohort);
                        if(GetIsObjectValid(oItem)
                            && GetIdentified(oItem))
                        {
                            AddChoice(GetName(oItem), array_get_size(oCohort, "PRC_ItemsToUse"));
                            array_set_object(oCohort, "PRC_ItemsToUse", array_get_size(oCohort, "PRC_ItemsToUse"), oItem);
                        }
                    }
                    object oItem = GetFirstItemInInventory(oCohort);
                    while(GetIsObjectValid(oItem))
                    {
                        if(GetIdentified(oItem))
                        {
                            itemproperty ipTest = GetFirstItemProperty(oItem);
                            itemproperty ipInvalid;
                            while(GetIsItemPropertyValid(ipTest))
                            {
                                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                                {
                                    AddChoice(GetName(oItem), array_get_size(oCohort, "PRC_ItemsToUse"));
                                    array_set_object(oCohort, "PRC_ItemsToUse", array_get_size(oCohort, "PRC_ItemsToUse"), oItem);
                                    ipTest = ipInvalid;
                                }
                                else
                                    ipTest = GetNextItemProperty(oItem);
                            }
                        }
                        oItem = GetNextItemInInventory(oCohort);
                    }
                }
                else
                {
                    int i;
                    for(i=0;i<array_get_size(oCohort, "PRC_ItemsToUse");i++)
                    {
                        object oItem = array_get_object(oCohort, "PRC_ItemsToUse", i);
                        AddChoice(GetName(oItem), i);
                    }
                }

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_ITEM_SPELL)
            {
                object oItem = GetLocalObject(oCohort, "PRC_ItemToUse");
                itemproperty ipTest = GetFirstItemProperty(oItem);
                while(GetIsItemPropertyValid(ipTest))
                {
                    if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                    {
                        int nSpellID = GetItemPropertySubType(ipTest);
                        //convert that to a real ID
                        nSpellID = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nSpellID));
                        AddChoice(ItemPropertyToString(ipTest), nSpellID);
                    }
                    ipTest = GetNextItemProperty(oItem);
                }

                SetHeader("What do you want me to do with "+GetName(oItem)+"?");

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_ITEM_TARGET)
            {
                object oItem = GetLocalObject(oCohort, "PRC_ItemToUse");
                int nSpellID = GetLocalInt(oCohort, "PRC_ItemToUse_Spell");

                int nTargetType = HexToInt(Get2DACache("spells", "TargetType", nSpellID));
                int nHostileSpell = StringToInt(Get2DACache("spells", "HostileSetting", nSpellID));
                string sRangeType = Get2DACache("spells", "Range", nSpellID);
                float fRange = 50.0;
                if(sRangeType == "S"
                    || sRangeType == "T"
                    || sRangeType == "P")
                    fRange = 8.0;
                else if(sRangeType == "M")
                    fRange = 20.0;
                else if(sRangeType == "L")
                    fRange = 40.0;

                /*
                #  0x01 = 1 = Self
                # 0x02 = 2 = Creature
                # 0x04 = 4 = Area/Ground
                # 0x08 = 8 = Items
                # 0x10 = 16 = Doors
                # 0x20 = 32 = Placeables
                */
                int nCaster     = nTargetType &  1;
                int nCreature   = nTargetType &  2;
                int nLocation   = nTargetType &  4;
                int nItem       = nTargetType &  8;
                int nDoor       = nTargetType & 16;
                int nPlaceable  = nTargetType & 32;
                //potions are caster only
                if(GetBaseItemType(oItem) == BASE_ITEM_POTIONS
                    || GetBaseItemType(oItem) == BASE_ITEM_ENCHANTED_POTION)
                {
                    nCaster = TRUE;
                    nCreature = FALSE;
                    nLocation = FALSE;
                    nItem = FALSE;
                    nDoor = FALSE;
                    nPlaceable = FALSE;
                }
                int nCount;
                if(array_exists(oCohort, "PRC_ItemsToUse_Target"))
                    array_delete(oCohort, "PRC_ItemsToUse_Target");
                array_create(oCohort, "PRC_ItemsToUse_Target");
                //self
                if(nCaster)
                {
                    AddChoice("Self ("+GetName(oCohort)+")", array_get_size(oCohort, "PRC_ItemsToUse_Target"));
                    array_set_object(oCohort, "PRC_ItemsToUse_Target",
                        array_get_size(oCohort, "PRC_ItemsToUse_Target"), oCohort);

                }
                //nearby objects or locations of those objects
                if(nCreature
                    || nDoor
                    || nPlaceable
                    || nLocation)
                {
                    object oTest = GetFirstObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oCohort));
                    while(GetIsObjectValid(oTest))
                    {
                        int nType = GetObjectType(oTest);
                        if(((nType == OBJECT_TYPE_CREATURE && nCreature)
                             || (nType == OBJECT_TYPE_DOOR && nDoor)
                             || (nType == OBJECT_TYPE_PLACEABLE && nPlaceable)
                             || nLocation)
                            && oTest != oCohort)
                        {
                            AddChoice(GetName(oTest), array_get_size(oCohort, "PRC_ItemsToUse_Target"));
                            array_set_object(oCohort, "PRC_ItemsToUse_Target",
                                array_get_size(oCohort, "PRC_ItemsToUse_Target"), oTest);
                        }
                        oTest = GetNextObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oCohort));
                    }
                }
                //items in inventory
                if(nItem)
                {
                    int nSlot;
                    for(nSlot = 0; nSlot < 14; nSlot++)
                    {
                        object oItem = GetItemInSlot(nSlot, oCohort);
                        if(GetIsObjectValid(oItem))
                        {
                            AddChoice("(in inventory) "+GetName(oItem), array_get_size(oCohort, "PRC_ItemsToUse_Target"));
                            array_set_object(oPC, "PRC_ItemsToUse_Target", array_get_size(oPC, "PRC_ItemsToUse_Target"), oItem);
                        }
                    }
                    object oTest = GetFirstItemInInventory(oCohort);
                    while(GetIsObjectValid(oTest))
                    {
                        AddChoice("(in inventory) "+GetName(oTest), array_get_size(oCohort, "PRC_ItemsToUse_Target"));
                        array_set_object(oCohort, "PRC_ItemsToUse_Target",
                            array_get_size(oCohort, "PRC_ItemsToUse_Target"), oTest);
                        oTest = GetNextItemInInventory(oCohort);
                    }
                }

                SetHeader("Who or what do you want me to use "+GetName(oItem)+" on?");

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //Identification of stuff
            else if(nStage == STAGE_IDENTIFY)
            {
                SetHeader("Eh. Maybe. Allow me to rummage through your things. If something is found that is identifiable, I will tell you. Good enough?");
                AddChoice("Good enough, go ahead.", 1, oPC);
                AddChoice("Maybe later then.", 2, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_IDENTIFY_YES)
            {
                string sList;
                sList += "Okay, I have identified:\n";

                //taken from TryToIDItems() in inc_utility
                int nLore = GetSkillRank(SKILL_LORE, oCohort);
                int nGP;
                string sMax = Get2DACache("SkillVsItemCost", "DeviceCostMax", nLore);
                int nMax = StringToInt(sMax);
                if (sMax == "") nMax = 120000000;
                object oItem = GetFirstItemInInventory(oPC);
                while(oItem != OBJECT_INVALID)
                {
                    if(!GetIdentified(oItem))
                    {
                        // Check for the value of the item first.
                        SetIdentified(oItem, TRUE);
                        nGP = GetGoldPieceValue(oItem);
                        SetIdentified(oItem, FALSE);
                        // If oPC has enough Lore skill to ID the item, then do so.
                        if(nMax >= nGP)
                        {
                            SetIdentified(oItem, TRUE);
                            sList += GetName(oItem)+"\n";
                        }
                    }
                    oItem = GetNextItemInInventory(oPC);
                }

                SetHeader(sList);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_IDENTIFY_NO)
            {
                SetHeader("Then why did you bother asking me if you didnt want me to have a look!");

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //tactics
            else if(nStage == STAGE_TACTICS)
            {
                SetHeader("*You* would advise *me* on tactics?");

                AddChoice("I want to adjust your equipment.", 1, oPC);
                //x0_d2_hen_attck
                if(!GetAssociateState(NW_ASC_MODE_DEFEND_MASTER, oCohort))
                    AddChoice("Defend me and don't attack until I do.", 2, oPC);
                //x0_d2_hen_defnd
                if(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER, oCohort))
                    AddChoice("Go ahead and attack as soon as you see enemies.", 3, oPC);
                AddChoice("I want to change the distance you stay away from me.", 4, oPC);
                //nw_ch_no_locks
                if(!GetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, oCohort))
                    AddChoice("Help me if I fail to open a locked door or chest.", 5, oPC);
                //nw_ch_yes_locks
                if(GetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, oCohort))
                    AddChoice("Don't help me if I fail to open a locked door or chest.", 6, oPC);
                //follows the HotU stealth system, as in xp2_hen_dae conversation
                AddChoice("Try to remain stealthy all the time.", 7, oPC);
                AddChoice("Stay stealthy, but only until the next fight.", 8, oPC);
                //x2_d1_instealth
                //if(GetActionMode(oCohort, ACTION_MODE_STEALTH))
                //not used, cohort drops stealth during conversation
                    AddChoice("Don't try to be stealthy anymore.", 9, oPC);
                AddChoice("I don't want to change anything else right now.", 10, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_TACTICS_EQUIP)
            {
                SetHeader("*sigh* Very well, then. Here is my equipment.");
                OpenInventory(oCohort, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_TACTICS_DEFEND
                || nStage == STAGE_TACTICS_ATTACK
                || nStage == STAGE_TACTICS_LOCK_HELP
                || nStage == STAGE_TACTICS_LOCK_NOHELP
                || nStage == STAGE_TACTICS_STEALTH_ALWAYS
                || nStage == STAGE_TACTICS_STEALTH_COMBAT
                || nStage == STAGE_TACTICS_STEALTH_NEVER
                || nStage == STAGE_TACTICS_DISTANCE_CLOSE
                || nStage == STAGE_TACTICS_DISTANCE_MEDIUM
                || nStage == STAGE_TACTICS_DISTANCE_LONG)
            {
                string sMessage;
                if(nStage == STAGE_TACTICS_DEFEND)
                    sMessage = "Very well, then.";
                else if(nStage == STAGE_TACTICS_ATTACK)
                    sMessage = "None will stand against us!";
                else if(nStage == STAGE_TACTICS_LOCK_HELP)
                    sMessage = "Indeed. Where you have failed, I shall succeed!";
                else if(nStage == STAGE_TACTICS_LOCK_NOHELP)
                    sMessage = "You can attempt them on your own then.";
                else if(nStage == STAGE_TACTICS_STEALTH_ALWAYS)
                    sMessage = "Very well, I shall strike from the shadows whenever I am able.";
                else if(nStage == STAGE_TACTICS_STEALTH_COMBAT)
                    sMessage = "I shall remain hidden until the battle begins, then I will burst forth to slaughter our foes.";
                else if(nStage == STAGE_TACTICS_STEALTH_NEVER)
                    sMessage = "I do not like to hide in the shadows, anyway.";
                else if(nStage == STAGE_TACTICS_DISTANCE_CLOSE
                    || nStage == STAGE_TACTICS_DISTANCE_MEDIUM
                    || nStage == STAGE_TACTICS_DISTANCE_LONG)
                    sMessage = "As you wish.";
                SetHeader(sMessage+" Do you want to change anything else?");

                AddChoice("No, that is all.", 2, oPC);
                AddChoice("Yes.", 1, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_TACTICS_DISTANCE)
            {
                SetHeader("How far apart should we remain, then?");
                AddChoice("Stay close.", 1, oPC);
                AddChoice("Keep a medium distance.", 2, oPC);
                AddChoice("Stay a long distance away.", 3, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //leaving the party
            else if(nStage == STAGE_LEAVE)
            {
                SetHeader("What?! You would turn me aside and make your way without me?");
                AddChoice("Leave me. Now.", 1, oPC);
                AddChoice("Alright, fine. Stay with me, then.", 2, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_LEAVE_YES)
            {
                SetHeader("Bah! Leave if you will, but you shall not get far without me!");
                DelayCommand(3.0, RemoveCohortFromPlayer(oCohort, oPC));
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_LEAVE_NO)
            {
                SetHeader("Ah, so you have not lost your mind completely.");

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //add more stages for more nodes with Else If clauses
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        array_delete(oCohort, "PRC_ItemsToUse");
        array_delete(oCohort, "PRC_ItemsToUse_Target");
        DeleteLocalObject(oCohort, "PRC_ItemToUse");
        DeleteLocalObject(oCohort, "PRC_ItemToUse_Spell");
        DeleteLocalInt(oCohort, "PRC_FeatToUse");
        DeleteLocalInt(oCohort, "PRC_SpellToUse");
        DeleteLocalInt(oCohort, "PRC_InCohortConvoMarker");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        array_delete(oCohort, "PRC_ItemsToUse");
        array_delete(oCohort, "PRC_ItemsToUse_Target");
        DeleteLocalObject(oCohort, "PRC_ItemToUse");
        DeleteLocalObject(oCohort, "PRC_ItemToUse_Spell");
        DeleteLocalInt(oCohort, "PRC_FeatToUse");
        DeleteLocalInt(oCohort, "PRC_SpellToUse");
        DeleteLocalInt(oCohort, "PRC_InCohortConvoMarker");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        int nOldStage = nStage;
        if(nStage == STAGE_ENTRY
            || nStage == STAGE_REENTRY)
        {
            switch(nChoice)
            {
                case 1: nStage = STAGE_SPELL;       break;
                case 2: nStage = STAGE_FEAT;        break;
                case 3: nStage = STAGE_ITEM;        break;
                case 4: nStage = STAGE_IDENTIFY;    break;
                case 5: nStage = STAGE_TACTICS;     break;
                case 6: nStage = STAGE_LEAVE;       break;
            }
        }
        else if(nStage == STAGE_LEAVE)
        {
            switch(nChoice)
            {
                case 1: nStage = STAGE_LEAVE_YES;       break;
                case 2: nStage = STAGE_LEAVE_NO;        break;
            }
        }
        else if(nStage == STAGE_SPELL)
        {
            SetLocalInt(oCohort, "PRC_SpellToUse", nChoice);
            nStage = STAGE_SPELL_TARGET;
        }
        else if(nStage == STAGE_SPELL_TARGET)
        {
            int nSpellID = GetLocalInt(oCohort, "PRC_SpellToUse");
            object oTarget = array_get_object(oCohort, "PRC_ItemsToUse_Target", nChoice);

            //test if location or object
            //use object by preference

            int nTargetType = HexToInt(Get2DACache("spells", "TargetType", nSpellID));
            /*
            # 0x01 = 1 = Self
            # 0x02 = 2 = Creature
            # 0x04 = 4 = Area/Ground
            # 0x08 = 8 = Items
            # 0x10 = 16 = Doors
            # 0x20 = 32 = Placeables
            */
            int nCaster     = nTargetType &  1;
            int nCreature   = nTargetType &  2;
            int nLocation   = nTargetType &  4;
            int nItem       = nTargetType &  8;
            int nDoor       = nTargetType & 16;
            int nPlaceable  = nTargetType & 32;
            int nType = GetObjectType(oTarget);

            if((oTarget == oCohort && nCaster)
                || (nType == OBJECT_TYPE_CREATURE && nCreature)
                || (nType == OBJECT_TYPE_DOOR && nDoor)
                || (nType == OBJECT_TYPE_PLACEABLE && nPlaceable)
                || (nType == OBJECT_TYPE_ITEM && nItem))
            {
                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort, ActionCastSpellAtObject(nSpellID, oTarget));
            }
            else if(nLocation)
            {
                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort, ActionCastSpellAtLocation(nSpellID, GetLocation(oTarget)));
            }

            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        }
        else if(nStage == STAGE_FEAT)
        {
            SetLocalInt(oCohort, "PRC_FeatToUse", nChoice);
            //a few hardcoded feats are fuggly
            if(nChoice == FEAT_ANIMAL_COMPANION)
            {
                DecrementRemainingFeatUses(oCohort, FEAT_ANIMAL_COMPANION);
                AssignCommand(oCohort, SummonAnimalCompanion());
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == FEAT_SUMMON_FAMILIAR)
            {
                DecrementRemainingFeatUses(oCohort, FEAT_SUMMON_FAMILIAR);
                AssignCommand(oCohort, SummonFamiliar());
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }

            //if its self only, use it
            if(StringToInt(Get2DACache("feat", "TARGETSELF", nChoice)))
            {
                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort, ActionUseFeat(nChoice, oCohort));
                //feat used, end conversation
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            nStage = STAGE_FEAT_TARGET;
        }
        else if(nStage == STAGE_FEAT_TARGET)
        {
            int nFeat = GetLocalInt(oCohort, "PRC_FeatToUse");
            object oTarget = array_get_object(oCohort, "PRC_ItemsToUse_Target", nChoice);
            if(nFeat < 0)
            {
                //subradial feat
                int nSpellID;
                nSpellID = 0-nFeat;
                nFeat = GetLocalInt(oCohort, "SubradialSpellFeatID"+IntToString(nSpellID));
                DecrementRemainingFeatUses(oCohort, nFeat);
                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort, ActionCastSpellAtObject(nSpellID, oTarget, METAMAGIC_ANY, TRUE));
            }
            else
            {

                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort, ActionUseFeat(nFeat, oTarget));
            }
            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        }
        else if(nStage == STAGE_ITEM)
        {
            object oItem = array_get_object(oCohort, "PRC_ItemsToUse", nChoice);
            SetLocalObject(oCohort, "PRC_ItemToUse", oItem);
            //if its multiple spells
            itemproperty ipTest = GetFirstItemProperty(oItem);
            int nSpellCount;
            while(GetIsItemPropertyValid(ipTest))
            {
                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                    nSpellCount++;
                ipTest = GetNextItemProperty(oItem);
            }
            if(nSpellCount > 1)
            {
                nStage = STAGE_ITEM_SPELL;
            }
            else
            {
                ipTest = GetFirstItemProperty(oItem);
                while(GetIsItemPropertyValid(ipTest))
                {
                    if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                        break;
                    ipTest = GetNextItemProperty(oItem);
                }
                int nSpellID = GetItemPropertySubType(ipTest);
                //convert that to a real ID
                nSpellID = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nSpellID));
                //store it
                SetLocalInt(oCohort, "PRC_ItemToUse_Spell", nSpellID);
                nStage = STAGE_ITEM_TARGET;
            }
        }
        else if(nStage == STAGE_ITEM_SPELL)
        {
            SetLocalInt(oCohort, "PRC_ItemToUse_Spell", nChoice);
            //check if its self-only, if so use it

            object oItem = GetLocalObject(oCohort, "PRC_ItemToUse");
            int nSpellID = GetLocalInt(oCohort, "PRC_ItemToUse_Spell");
            object oTarget = array_get_object(oCohort, "PRC_ItemsToUse_Target", nChoice);
            itemproperty ipIP;
            ipIP = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ipIP))
            {
                if(GetItemPropertyType(ipIP) == ITEM_PROPERTY_CAST_SPELL)
                {
                    int nipSpellID = GetItemPropertySubType(ipIP);
                    //convert that to a real ID
                    nipSpellID = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nipSpellID));
                    if(nipSpellID == nSpellID)
                    {
                        if(DEBUG) DoDebug("Ending itemprop loop "+IntToString(nipSpellID));
                        break;//end while loop
                    }
                }
                ipIP = GetNextItemProperty(oItem);
            }

            //test if location or object
            //use object by preference

            int nTargetType = HexToInt(Get2DACache("spells", "TargetType", nSpellID));

            if(nTargetType == 1)
            {
                //self only item, use it
                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort,
                    ActionUseItemPropertyAtObject(oItem, ipIP, oCohort));
                if(DEBUG) DoDebug("Running ActionUseItemPropertyAtObject() at "+GetName(oCohort));
                //item used, end conversation
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }

            nStage = STAGE_ITEM_TARGET;
        }
        else if(nStage == STAGE_ITEM_TARGET)
        {
            object oItem = GetLocalObject(oCohort, "PRC_ItemToUse");
            int nSpellID = GetLocalInt(oCohort, "PRC_ItemToUse_Spell");
            object oTarget = array_get_object(oCohort, "PRC_ItemsToUse_Target", nChoice);
            itemproperty ipIP;
            ipIP = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ipIP))
            {
                if(GetItemPropertyType(ipIP) == ITEM_PROPERTY_CAST_SPELL)
                {
                    int nipSpellID = GetItemPropertySubType(ipIP);
                    //convert that to a real ID
                    nipSpellID = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nipSpellID));
                    if(nipSpellID == nSpellID)
                    {
                        if(DEBUG) DoDebug("Ending itemprop loop "+IntToString(nipSpellID));
                        break;//end while loop
                    }
                }
                ipIP = GetNextItemProperty(oItem);
            }

            //test if location or object
            //use object by preference

            int nTargetType = HexToInt(Get2DACache("spells", "TargetType", nSpellID));
            /*
            # 0x01 = 1 = Self
            # 0x02 = 2 = Creature
            # 0x04 = 4 = Area/Ground
            # 0x08 = 8 = Items
            # 0x10 = 16 = Doors
            # 0x20 = 32 = Placeables
            */
            int nCaster     = nTargetType &  1;
            int nCreature   = nTargetType &  2;
            int nLocation   = nTargetType &  4;
            int nItem       = nTargetType &  8;
            int nDoor       = nTargetType & 16;
            int nPlaceable  = nTargetType & 32;
            int nType = GetObjectType(oTarget);

            if((oTarget == oCohort && nCaster)
                || (nType == OBJECT_TYPE_CREATURE && nCreature)
                || (nType == OBJECT_TYPE_DOOR && nDoor)
                || (nType == OBJECT_TYPE_PLACEABLE && nPlaceable)
                || (nType == OBJECT_TYPE_ITEM && nItem))
            {
                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort,
                    ActionUseItemPropertyAtObject(oItem, ipIP, oTarget));
                if(DEBUG) DoDebug("Running ActionUseItemPropertyAtObject() at "+GetName(oTarget));
            }
            else if(nLocation)
            {
                AssignCommand(oCohort, ClearAllActions());
                AssignCommand(oCohort,
                    ActionUseItemPropertyAtLocation(oItem, ipIP, GetLocation(oTarget)));
                if(DEBUG) DoDebug("Running ActionUseItemPropertyAtLocation() at "+GetName(oTarget));
            }

            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        }
        else if(nStage == STAGE_IDENTIFY)
        {
            switch(nChoice)
            {
                case 1: nStage = STAGE_IDENTIFY_YES;        break;
                case 2: nStage = STAGE_IDENTIFY_NO;     break;
            }
        }
        else if(nStage == STAGE_TACTICS)
        {
            switch(nChoice)
            {
                case 1: nStage = STAGE_TACTICS_EQUIP;       break;
                case 2: nStage = STAGE_TACTICS_DEFEND;
                        SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE, oCohort);
                        break;
                case 3: nStage = STAGE_TACTICS_ATTACK;
                        SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE, oCohort);
                        break;
                case 4: nStage = STAGE_TACTICS_DISTANCE;        break;
                case 5: nStage = STAGE_TACTICS_LOCK_HELP;
                        SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, TRUE, oCohort);
                        break;
                case 6: nStage = STAGE_TACTICS_LOCK_NOHELP;
                        SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, FALSE, oCohort);
                        break;
                case 7: nStage = STAGE_TACTICS_STEALTH_ALWAYS;
                        AssignCommand(oCohort, ClearAllActions());
                        SetLocalInt(oCohort, "X2_HENCH_STEALTH_MODE", 1);
                        break;
                case 8: nStage = STAGE_TACTICS_STEALTH_COMBAT;
                        AssignCommand(oCohort, ClearAllActions());
                        SetLocalInt(oCohort, "X2_HENCH_STEALTH_MODE", 2);
                        break;
                case 9: nStage = STAGE_TACTICS_STEALTH_NEVER;
                        AssignCommand(oCohort, ClearAllActions());
                        SetLocalInt(oCohort, "X2_HENCH_STEALTH_MODE", 0);
                        SetActionMode(oCohort, ACTION_MODE_STEALTH, FALSE);
                        break;
                case 10: nStage = STAGE_REENTRY;        break;
            }
        }
        else if(nStage == STAGE_TACTICS_DISTANCE)
        {
            switch(nChoice)
            {
                case 1: nStage = STAGE_TACTICS_DISTANCE_CLOSE;
                        //nw_ch_dist_6
                        SetAssociateState(NW_ASC_DISTANCE_2_METERS, TRUE, oCohort);
                        SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE, oCohort);
                        SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE, oCohort);
                        break;
                case 2: nStage = STAGE_TACTICS_DISTANCE_MEDIUM;
                        //nw_ch_dist_12
                        SetAssociateState(NW_ASC_DISTANCE_2_METERS, FALSE, oCohort);
                        SetAssociateState(NW_ASC_DISTANCE_4_METERS, TRUE, oCohort);
                        SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE, oCohort);
                        break;
                case 3: nStage = STAGE_TACTICS_DISTANCE_LONG;
                        //nw_ch_dist_18
                        SetAssociateState(NW_ASC_DISTANCE_2_METERS, FALSE, oCohort);
                        SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE, oCohort);
                        SetAssociateState(NW_ASC_DISTANCE_6_METERS, TRUE, oCohort);
                        break;
            }
        }
        else if(nStage == STAGE_TACTICS_DEFEND
            || nStage == STAGE_TACTICS_ATTACK
            || nStage == STAGE_TACTICS_LOCK_HELP
            || nStage == STAGE_TACTICS_LOCK_NOHELP
            || nStage == STAGE_TACTICS_STEALTH_ALWAYS
            || nStage == STAGE_TACTICS_STEALTH_COMBAT
            || nStage == STAGE_TACTICS_STEALTH_NEVER
            || nStage == STAGE_TACTICS_DISTANCE_CLOSE
            || nStage == STAGE_TACTICS_DISTANCE_MEDIUM
            || nStage == STAGE_TACTICS_DISTANCE_LONG)
        {
            switch(nChoice)
            {
                case 1: nStage = STAGE_TACTICS;        break;
                case 2: AllowExit(DYNCONV_EXIT_FORCE_EXIT);     break;
            }
        }
        else if(nStage == STAGE_LEAVE)
        {
            switch(nChoice)
            {
                case 1: nStage = STAGE_LEAVE_YES;       break;
                case 2: nStage = STAGE_LEAVE_NO;        break;
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
        //if stage changed, mark the new one as not set up
        if(nStage != nOldStage)
            MarkStageNotSetUp(nStage, oPC);
    }
}
