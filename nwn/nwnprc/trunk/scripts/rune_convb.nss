//:://////////////////////////////////////////////
//:: Runescarred berserker conversation
//:: run_convb
//:://////////////////////////////////////////////
/** @file
    Conversation to handle runescarring


    @author Primogenitor
    @date   Created  - 2006.09.05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////


//yes this is a global variable
//used to count the scars used in GetCanScribeLocation
//since the return is used for the header string
int nRuneCount = 0;

const int STAGE_ENTRY   = 0;
const int STAGE_SPELL   = 1;
const int STAGE_LEVEL   = 2;
const int STAGE_CONFIRM = 3;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

string GetCanScribeLocation(string sHeader, int nLoc, object oPC)
{
    string sName;
    string sVar;
    switch(nLoc)
    {
        case 1: sName = "Face";        sVar = "Runescar_Face";        break;
        case 2: sName = "Left Arm";    sVar = "Runescar_Arm_Left";    break;
        case 3: sName = "Left Chest";  sVar = "Runescar_Chest_Left";  break;
        case 4: sName = "Left Hand";   sVar = "Runescar_Hand_Left";   break;
        case 5: sName = "Right Arm";   sVar = "Runescar_Arm_Right";   break;
        case 6: sName = "Right Chest"; sVar = "Runescar_Chest_Right"; break;
        case 7: sName = "Right Hand";  sVar = "Runescar_Hand_Right";  break;
    }
    int nSpellID = GetPersistantLocalInt(oPC, sVar);
    if(nSpellID)
    {
        nRuneCount++;
        nSpellID = nSpellID-1;
        //string sSpellIDName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
        sHeader += (sName+": "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)))+"\n");
    }
    else
        AddChoice(sName, nLoc, oPC);
    return sHeader;
}

void AddRunescarSpellChoice(int nSpellID, object oPC, int nSpellLevel = -1)
{
    //default to innate level
    if(nSpellLevel == -1)
        nSpellLevel = StringToInt(Get2DACache("spells", "Innate", nSpellID));

    string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));

    sName += " (level "+IntToString(nSpellLevel)+")";

    //test if spare slot this day
    if(GetLocalInt(oPC, "Runescar_slot_"+IntToString(nSpellLevel))
        && GetAbilityScore(oPC, ABILITY_WISDOM)>=10+nSpellLevel)
        AddChoice(sName, nSpellID, oPC);
    //store the level to cast it at
    SetLocalInt(oPC, "Runescar_spell_level_"+IntToString(nSpellID), nSpellLevel);
}

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
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(nStage == STAGE_ENTRY)
            {
                string sHeader = "You currently have the following Runescars scribed:\n";
                nRuneCount = 0;
                sHeader = GetCanScribeLocation(sHeader, 1, oPC);
                sHeader = GetCanScribeLocation(sHeader, 2, oPC);
                sHeader = GetCanScribeLocation(sHeader, 3, oPC);
                sHeader = GetCanScribeLocation(sHeader, 4, oPC);
                sHeader = GetCanScribeLocation(sHeader, 5, oPC);
                sHeader = GetCanScribeLocation(sHeader, 6, oPC);
                sHeader = GetCanScribeLocation(sHeader, 7, oPC);

                if(nRuneCount < 7)
                    sHeader += "\nWhere would you like to scribe a new Runescar?";
                else
                    sHeader += "\nYou cannot scribe a new Runescar at this time.";

                SetHeader(sHeader);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SPELL)
            {
                //select the spell to scribe
                SetHeader("Which spell would you like to scribe as a Runescar?");
                AddRunescarSpellChoice(SPELL_CURE_MODERATE_WOUNDS,      oPC, 1);
                AddRunescarSpellChoice(SPELL_DIVINE_FAVOR,              oPC, 1);
                AddRunescarSpellChoice(SPELL_PROTECTION__FROM_CHAOS,    oPC, 1);
                AddRunescarSpellChoice(SPELL_PROTECTION_FROM_EVIL,      oPC, 1);
                AddRunescarSpellChoice(SPELL_PROTECTION_FROM_GOOD,      oPC, 1);
                AddRunescarSpellChoice(SPELL_PROTECTION_FROM_LAW,       oPC, 1);
                AddRunescarSpellChoice(SPELL_RESIST_ELEMENTS,           oPC, 1);
                AddRunescarSpellChoice(SPELL_SEE_INVISIBILITY,          oPC, 1);
                AddRunescarSpellChoice(SPELL_TRUE_STRIKE,               oPC, 1);
                AddRunescarSpellChoice(SPELL_ENDURANCE,                 oPC, 2);
                AddRunescarSpellChoice(SPELL_BULLS_STRENGTH,            oPC, 2);
                AddRunescarSpellChoice(SPELL_CURE_SERIOUS_WOUNDS,       oPC, 2);
                AddRunescarSpellChoice(SPELL_DARKVISION,                oPC, 2);
                AddRunescarSpellChoice(SPELL_INVISIBILITY,              oPC, 2);
                AddRunescarSpellChoice(SPELL_KEEN_EDGE,                 oPC, 2);
                AddRunescarSpellChoice(SPELL_PROTECTION_FROM_ELEMENTS,  oPC, 2);
                AddRunescarSpellChoice(SPELL_CURE_CRITICAL_WOUNDS,      oPC, 3);
                AddRunescarSpellChoice(SPELL_DEATH_WARD,                oPC, 3);
                AddRunescarSpellChoice(SPELL_DIVINE_POWER,              oPC, 3);
                AddRunescarSpellChoice(SPELL_FREEDOM_OF_MOVEMENT,       oPC, 3);
                AddRunescarSpellChoice(SPELL_HASTE,                     oPC, 3);
                AddRunescarSpellChoice(SPELL_GREATER_MAGIC_WEAPON,      oPC, 3);
                AddRunescarSpellChoice(SPELL_IMPROVED_INVISIBILITY,     oPC, 4);
                AddRunescarSpellChoice(SPELL_NEUTRALIZE_POISON,         oPC, 4);
                AddRunescarSpellChoice(SPELL_RESTORATION,               oPC, 4);
                AddRunescarSpellChoice(SPELL_RIGHTEOUS_MIGHT,           oPC, 4);
                AddRunescarSpellChoice(SPELL_STONESKIN,                 oPC, 4);
                AddRunescarSpellChoice(SPELL_ANTIMAGIC_FIELD,           oPC, 5);
                AddRunescarSpellChoice(SPELL_RUNE_DIMENSION_DOOR,       oPC, 5);
                AddRunescarSpellChoice(SPELL_HEAL,                      oPC, 5);
                AddRunescarSpellChoice(SPELL_POLYMORPH_SELF,            oPC, 5);
                AddRunescarSpellChoice(SPELL_SPELL_RESISTANCE,          oPC, 5);
                /*
                missing spells
                LEVEL 1 --
                    Low-Light Vision,
                LEVEL 3 --
                    Air Walk,
                LEVEL 4 --
                    Spell Immunity,
                */

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_LEVEL)
            {
                SetHeader("Which level would you like to scribe this Runescar?");
                int nSpellID = GetLocalInt(oPC, "Runescar_spell");
                int nSpellLevel = GetLocalInt(oPC, "Runescar_spell_level_"+IntToString(nSpellID));
                int nMinLevel = (nSpellLevel*2)-1;
                int i;
                for(i=GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);i>=nMinLevel; i--)
                {
                    AddChoice("Level "+IntToString(i), i);
                }
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRM)
            {
                int nSpellID = GetLocalInt(oPC, "Runescar_spell");
                int nLoc = GetLocalInt(oPC, "Runescar_location");
                int nLevel = GetLocalInt(oPC, "Runescar_level");
                int nSpellLevel = GetLocalInt(oPC, "Runescar_spell_level_"+IntToString(nSpellID));
                int nGP = 5*nSpellLevel*nLevel;
                int nXP = nGP/25;
                string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
                string sLoc;
                switch(nLoc)
                {
                    case 1: sLoc = "Face";        break;
                    case 2: sLoc = "Left Arm";    break;
                    case 3: sLoc = "Left Chest";  break;
                    case 4: sLoc = "Left Hand";   break;
                    case 5: sLoc = "Right Arm";   break;
                    case 6: sLoc = "Right Chest"; break;
                    case 7: sLoc = "Right Hand";  break;
                }
                string sHeader = "You have selected to scribe "+sName+" on your "+sLoc+" at level "+IntToString(nLevel)+".\n";
                sHeader += "This will cost "+IntToString(nGP)+"gp and "+IntToString(nXP)+"xp.\n";
                sHeader += "You will take "+IntToString(nSpellLevel)+"d6 damage.\n";
                sHeader += "Is this correct?";
                int nHitDiceXP = (500 * GetHitDice(oPC) * (GetHitDice(oPC) - 1));
                if(GetGold(oPC) < nGP)
                {
                    if((GetXP(oPC)-nHitDiceXP)<nXP)
                        AddChoice("Insufficient gold and experience",  0);
                    else
                        AddChoice("Insufficient gold",  0);
                }
                else if((GetXP(oPC)-nHitDiceXP)<nXP)
                    AddChoice("Insufficient experience",  0);
                else
                {
                    AddChoice("Yes", 1);
                    AddChoice("No",  0);
                }
                SetHeader(sHeader);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "Runescar_location");
        DeleteLocalInt(oPC, "Runescar_spell");
        DeleteLocalInt(oPC, "Runescar_level");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "Runescar_location");
        DeleteLocalInt(oPC, "Runescar_spell");
        DeleteLocalInt(oPC, "Runescar_level");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            SetLocalInt(oPC, "Runescar_location", nChoice);
            nStage = STAGE_SPELL;
        }
        else if(nStage == STAGE_SPELL)
        {
            SetLocalInt(oPC, "Runescar_spell", nChoice);
            nStage = STAGE_LEVEL;
        }
        else if(nStage == STAGE_LEVEL)
        {
            SetLocalInt(oPC, "Runescar_level", nChoice);
            nStage = STAGE_CONFIRM;
        }
        else if(nStage == STAGE_CONFIRM)
        {
            if(nChoice)
            {
                int nSpellID = GetLocalInt(oPC, "Runescar_spell");
                int nLoc = GetLocalInt(oPC, "Runescar_location");
                int nLevel = GetLocalInt(oPC, "Runescar_level");
                int nSpellLevel = GetLocalInt(oPC, "Runescar_spell_level_"+IntToString(nSpellID));
                int nGP = 5*nSpellLevel*nLevel;
                int nXP = nGP/25;
                //remove GP & XP
                SetXP(oPC, GetXP(oPC)-nXP);
                TakeGoldFromCreature(nGP, oPC, TRUE);
                //do damage
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nSpellLevel)), oPC);
                //mark the scar
                string sVar;
                switch(nLoc)
                {
                    case 1: sVar = "Runescar_Face";        break;
                    case 2: sVar = "Runescar_Arm_Left";    break;
                    case 3: sVar = "Runescar_Chest_Left";  break;
                    case 4: sVar = "Runescar_Hand_Left";   break;
                    case 5: sVar = "Runescar_Arm_Right";   break;
                    case 6: sVar = "Runescar_Chest_Right"; break;
                    case 7: sVar = "Runescar_Hand_Right";  break;
                }
                //+1 for 0 == null to work
                SetPersistantLocalInt(oPC, sVar, nSpellID+1);
                SetPersistantLocalInt(oPC, sVar+"_level", nLevel);
                //use a useage
                SetLocalInt(oPC, "Runescar_slot_"+IntToString(nSpellLevel),
                    GetLocalInt(oPC, "Runescar_slot_"+IntToString(nSpellLevel))-1);
            }
            MarkStageNotSetUp(STAGE_ENTRY, oPC);
            MarkStageNotSetUp(STAGE_SPELL, oPC);
            MarkStageNotSetUp(STAGE_LEVEL, oPC);
            MarkStageNotSetUp(STAGE_CONFIRM, oPC);
            nStage = STAGE_ENTRY;
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
