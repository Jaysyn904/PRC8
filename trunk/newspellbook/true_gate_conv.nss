//:://////////////////////////////////////////////
//:: Conjunctive Gate Conversation
//:: true_gate_conv
//:://////////////////////////////////////////////
/** @file
    This allows you to choose which summon to get using Conjuctive Gate (and normal Gate)

    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "prc_alterations"
#include "true_inc_trufunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SUMMON_CHOICE = 0;
const int STAGE_CONFIRMATION  = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

int NameToInt(string sSummon)
{
        // Celestials
        if      (sSummon == "Astral Deva"           ) return 1;
        else if (sSummon == "Bralani Eladrin"       ) return 2;
        else if (sSummon == "Celestial Avenger"     ) return 3;
        else if (sSummon == "Hound Archon"          ) return 4;
        else if (sSummon == "Lantern Archon"        ) return 5;
        else if (sSummon == "Word Archon"           ) return 6;
        // Demons/Devils
        else if (sSummon == "Balor"                 ) return 7;
        else if (sSummon == "Bezekira"              ) return 8;
        else if (sSummon == "Cornugon"              ) return 9;
        else if (sSummon == "Erinyes"               ) return 10;
        else if (sSummon == "Gelugon"               ) return 11;
        else if (sSummon == "Glabrezu"              ) return 12;
        else if (sSummon == "Hamatula"              ) return 13;
        else if (sSummon == "Imp"                   ) return 14;
        //else if (sSummon == "Marilith"              ) return 15;
        else if (sSummon == "Osyluth"               ) return 16;
        else if (sSummon == "Succubus"              ) return 17;
        else if (sSummon == "Vrock"                 ) return 18;
        // Elementals
        else if (sSummon == "Elder Air Elemental"   ) return 19;
        else if (sSummon == "Elder Earth Elemental" ) return 20;
        else if (sSummon == "Elder Fire Elemental"  ) return 21;
        else if (sSummon == "Elder Water Elemental" ) return 22;
        else if (sSummon == "Steam Mephit"          ) return 23;
        // Slaadi
        else if (sSummon == "Green Slaad"           ) return 24;
        else if (sSummon == "Red Slaadi"            ) return 25;
        else if (sSummon == "Death Slaadi"          ) return 26;
	
	// on Error
	return -1;
}

string IntToName(int nChoice)
{
        // Celestials
        if      (nChoice == 1 ) return "Astral Deva";
        else if (nChoice == 2 ) return "Bralani Eladrin";
        else if (nChoice == 3 ) return "Celestial Avenger";
        else if (nChoice == 4 ) return "Hound Archon";
        else if (nChoice == 5 ) return "Lantern Archon";
        else if (nChoice == 6 ) return "Word Archon";
        // Demons/Devils
        else if (nChoice == 7 ) return "Balor";
        else if (nChoice == 8 ) return "Bezekira";
        else if (nChoice == 9 ) return "Cornugon";
        else if (nChoice == 10) return "Erinyes";
        else if (nChoice == 11) return "Gelugon";
        else if (nChoice == 12) return "Glabrezu";
        else if (nChoice == 13) return "Hamatula";
        else if (nChoice == 14) return "Imp";
        //else if (nChoice == 15) return "Marilith";
        else if (nChoice == 16) return "Osyluth";
        else if (nChoice == 17) return "Succubus";
        else if (nChoice == 18) return "Vrock";
        // Elementals
        else if (nChoice == 19) return "Elder Air Elemental";
        else if (nChoice == 20) return "Elder Earth Elemental";
        else if (nChoice == 21) return "Elder Fire Elemental";
        else if (nChoice == 22) return "Elder Water Elemental";
        else if (nChoice == 23) return "Steam Mephit";
        // Slaadi
        else if (nChoice == 24) return "Green Slaad";
        else if (nChoice == 25) return "Red Slaadi";
        else if (nChoice == 26) return "Death Slaadi";

    // on Error
    return "";
}

int SummonResrefToInt(string sSummon)
{
        // Celestials
        if      (sSummon == "true_deva")         return 1;
        else if (sSummon == "true_bralan")       return 2;
        else if (sSummon == "NW_S_CTRUMPET")     return 3;
        else if (sSummon == "NW_S_CHOUND")       return 4;
        else if (sSummon == "NW_S_CLANTERN")     return 5;
        else if (sSummon == "true_wordarch")     return 6;
        // Demons/Devils
        else if (sSummon == "NW_S_BALOR")        return 7;
        else if (sSummon == "prc_doa_hellcat")   return 8;
        else if (sSummon == "prc_sum_cornugon")  return 9;
        else if (sSummon == "erinyes")           return 10;
        else if (sSummon == "prc_sum_gelugon")   return 11;
        else if (sSummon == "prc_sum_glabrezu")  return 12;
        else if (sSummon == "prc_sum_hamatula")  return 13;
        else if (sSummon == "NW_S_IMP")          return 14;
        //else if (sSummon == "tog_marilith")      return 15;
        else if (sSummon == "prc_sum_osyluth")   return 16;
        else if (sSummon == "NW_S_SUCCUBUS")     return 17;
        else if (sSummon == "NW_S_VROCK")        return 18;
        // Elementals
        else if (sSummon == "nw_s_airelder")     return 19;
        else if (sSummon == "nw_s_earthelder")   return 20;
        else if (sSummon == "nw_s_fireelder")    return 21;
        else if (sSummon == "nw_s_waterelder")   return 22;
        else if (sSummon == "nw_s_mepsteam")     return 23;
        // Slaadi
        else if (sSummon == "NW_S_SLAADGRN")     return 24;
        else if (sSummon == "NW_S_SLAADRED")     return 25;
        else if (sSummon == "NW_S_SLAADDETH")    return 26;
	
	// on Error
	return -1;
}

string IntToSummonResref(int nChoice)
{
	// Celestials
        if      (nChoice == 1 ) return "true_deva";
        else if (nChoice == 2 ) return "true_bralan";
        else if (nChoice == 3 ) return "NW_S_CTRUMPET";
        else if (nChoice == 4 ) return "NW_S_CHOUND";
        else if (nChoice == 5 ) return "NW_S_CLANTERN";
        else if (nChoice == 6 ) return "true_wordarch";
        // Demons/Devils
        else if (nChoice == 7 ) return "NW_S_BALOR";
        else if (nChoice == 8 ) return "prc_doa_hellcat";
        else if (nChoice == 9 ) return "prc_sum_cornugon";
        else if (nChoice == 10) return "erinyes";
        else if (nChoice == 11) return "prc_sum_gelugon";
        else if (nChoice == 12) return "prc_sum_glabrezu";
        else if (nChoice == 13) return "prc_sum_hamatula";
        else if (nChoice == 14) return "NW_S_IMP";
        // else if (nChoice == 15) return "tog_marilith";
        else if (nChoice == 16) return "prc_sum_osyluth";
        else if (nChoice == 17) return "NW_S_SUCCUBUS";
        else if (nChoice == 18) return "NW_S_VROCK";
        // Elementals
        else if (nChoice == 19) return "nw_s_airelder";
        else if (nChoice == 20) return "nw_s_earthelder";
        else if (nChoice == 21) return "nw_s_fireelder";
        else if (nChoice == 22) return "nw_s_waterelder";
        else if (nChoice == 23) return "nw_s_mepsteam";
        // Slaadi
        else if (nChoice == 24) return "NW_S_SLAADGRN";
        else if (nChoice == 25) return "NW_S_SLAADRED";
        else if (nChoice == 26) return "NW_S_SLAADDETH";
	
	// on Error
	return "";
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
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_SUMMON_CHOICE)
            {
                // Set the header
                SetHeader("Select the creature you would like to summon.");

                // Add responses for the PC
                // Celestials
                AddChoice("Astral Deva",           SummonResrefToInt("true_deva"),        oPC);
                AddChoice("Bralani Eladrin",       SummonResrefToInt("true_bralan"),      oPC);
                AddChoice("Celestial Avenger",     SummonResrefToInt("NW_S_CTRUMPET"),    oPC);
                AddChoice("Hound Archon",          SummonResrefToInt("NW_S_CHOUND"),      oPC);
                AddChoice("Lantern Archon",        SummonResrefToInt("NW_S_CLANTERN"),    oPC);
                AddChoice("Word Archon",           SummonResrefToInt("true_wordarch"),    oPC);
                // Demons/Devils
                AddChoice("Balor",                 SummonResrefToInt("NW_S_BALOR"),       oPC);
                AddChoice("Bezekira",              SummonResrefToInt("prc_doa_hellcat"),  oPC);
                AddChoice("Cornugon",              SummonResrefToInt("prc_sum_cornugon"), oPC);
                AddChoice("Erinyes",               SummonResrefToInt("erinyes"),          oPC);
                AddChoice("Gelugon",               SummonResrefToInt("prc_sum_gelugon"),  oPC);
                AddChoice("Glabrezu",              SummonResrefToInt("prc_sum_glabrezu"), oPC);
                AddChoice("Hamatula",              SummonResrefToInt("prc_sum_hamatula"), oPC);
                AddChoice("Imp",                   SummonResrefToInt("NW_S_IMP"),         oPC);
                // AddChoice("Marilith",              SummonResrefToInt("tog_marilith"),     oPC);
                AddChoice("Osyluth",               SummonResrefToInt("prc_sum_osyluth"),  oPC);
                AddChoice("Succubus",              SummonResrefToInt("NW_S_SUCCUBUS"),    oPC);
                AddChoice("Vrock",                 SummonResrefToInt("NW_S_VROCK"),       oPC);
                // Elementals
                AddChoice("Elder Air Elemental",   SummonResrefToInt("nw_s_airelder"),    oPC);
                AddChoice("Elder Earth Elemental", SummonResrefToInt("nw_s_earthelder"),  oPC);
                AddChoice("Elder Fire Elemental",  SummonResrefToInt("nw_s_fireelder"),   oPC);
                AddChoice("Elder Water Elemental", SummonResrefToInt("nw_s_waterelder"),  oPC);
                AddChoice("Steam Mephit",          SummonResrefToInt("nw_s_mepsteam"),    oPC);
                // Slaadi
                AddChoice("Green Slaad",           SummonResrefToInt("NW_S_SLAADGRN"),    oPC);
                AddChoice("Red Slaadi",            SummonResrefToInt("NW_S_SLAADRED"),    oPC);
                AddChoice("Death Slaadi",          SummonResrefToInt("NW_S_SLAADDETH"),   oPC);

                MarkStageSetUp(STAGE_SUMMON_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "TrueGateChoice");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = IntToName(nChoice);
                string sText = "You have selected " + sName + " as the creature to summon.\n";

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
        DeleteLocalInt(oPC, "TrueGateChoice");
        DeleteLocalFloat(oPC, "TrueGateDuration");
        DeleteLocalInt(oPC, "TrueGateCastLevel");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "TrueGateChoice");
        DeleteLocalFloat(oPC, "TrueGateDuration");
        DeleteLocalInt(oPC, "TrueGateCastLevel");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SUMMON_CHOICE)
        {
            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "TrueGateChoice", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
                int nVis;
                // Get the choice
                int nSummon = GetLocalInt(oPC, "TrueGateChoice");
                if (DEBUG)
                {
                    DoDebug("true_gate_conv: Summon is " + IntToSummonResref(nSummon));
                    DoDebug("true_gate_conv: Duration is " + FloatToString(GetLocalFloat(oPC, "TrueGateDuration")));
                }

                if(nSummon < 7)
                    nVis = VFX_FNF_SUMMON_CELESTIAL;
                else if(nSummon > 6 && nSummon < 19)
                    nVis = VFX_FNF_SUMMON_GATE;
                else
                {
                    nVis = VFX_FNF_SUMMON_MONSTER_3;
                }

                // Convert to Resref and setup effect
                effect eSummon = EffectSummonCreature(IntToSummonResref(nSummon), nVis);
                // Do Multisummon
                MultisummonPreSummon();
                // Bring in the creature
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, oPC, GetLocalFloat(oPC, "TrueGateDuration"));

                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else // Reset
            {
                nStage = STAGE_SUMMON_CHOICE;
                MarkStageNotSetUp(STAGE_SUMMON_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "TrueGateChoice");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
