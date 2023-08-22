//:://////////////////////////////////////////////
//:: Short description
//:: prc_pnp_school
//:://////////////////////////////////////////////
/** @file
    @todo Primo: Could you add comments to the code?
          This one is sort of painful to figure out
          without them.
          And the usual header comment + TLKification :D


    @author Primogenitor
    @date   Created  - yyyy.mm.dd
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"



//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SCHOOL_SELECTION          = 0;
const int STAGE_OPPOSING_SCHOOL_SELECTION = 1;
const int STAGE_CONFIRMATION              = 2;
const int STAGE_COMPLETION                = 3;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

//This used Bitwise math
//this thread should help if you dont understand bitwise math
//http://nwn.bioware.com/forums/viewtopic.html?topic=391126&forum=47

void AddSchool(int nSchool, int nSchool2 = 0, int nSchool3 = 0)
{
    string sName;
    sName += GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool)));
    if(nSchool2 && !nSchool3)
        sName += " and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
    if(nSchool2 && nSchool3)
    {
        sName += ", "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
        sName += ", and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool3)));
    }
    int nValue = nSchool + (nSchool2 << 4) + (nSchool3 << 8);

    AddChoice(sName, nValue);

    if(DEBUG)
    {
        DoDebug("sName = "+sName+"\n"
              + "nValue = "+IntToString(nValue)+"\n"
              + "nSchool = "+IntToString(nSchool)+"\n"
              + "nSchool2 = "+IntToString(nSchool2)+"\n"
              + "nSchool3 = "+IntToString(nSchool3)+"\n"
              + "nSchool2 << 4 = "+IntToString(nSchool2 << 4)+"\n"
              + "nSchool3 << 8 = "+IntToString(nSchool3 << 8)+"\n"
                );
    }
}

int GetIPFromSchool(int nSchool)
{
    switch(nSchool)
    {
        case SPELL_SCHOOL_GENERAL:      return 241;
        case SPELL_SCHOOL_ABJURATION:   return 242;
        case SPELL_SCHOOL_CONJURATION:  return 243;
        case SPELL_SCHOOL_DIVINATION:   return 244;
        case SPELL_SCHOOL_ENCHANTMENT:  return 245;
        case SPELL_SCHOOL_EVOCATION:    return 246;
        case SPELL_SCHOOL_ILLUSION:     return 247;
        case SPELL_SCHOOL_NECROMANCY:   return 248;
        case SPELL_SCHOOL_TRANSMUTATION:return 249;
    }
    return 0;
}

int GetIPFromOppSchool(int nSchool)
{
    switch(nSchool)
    {
        case SPELL_SCHOOL_ABJURATION:   return 233;
        case SPELL_SCHOOL_CONJURATION:  return 234;
        case SPELL_SCHOOL_DIVINATION:   return 235;
        case SPELL_SCHOOL_ENCHANTMENT:  return 236;
        case SPELL_SCHOOL_EVOCATION:    return 237;
        case SPELL_SCHOOL_ILLUSION:     return 238;
        case SPELL_SCHOOL_NECROMANCY:   return 239;
        case SPELL_SCHOOL_TRANSMUTATION:return 240;
    }
    return 0;
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
               if(nStage == STAGE_SCHOOL_SELECTION) //select a school
            {
                SetHeader("Select a specialist school.");

                int i;
                for(i = 0; i < 9; i++) //use 9 to force original schools only
                {
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", i))), i, oPC);
                }

                MarkStageSetUp(STAGE_SCHOOL_SELECTION, oPC);
            }
            else if(nStage == STAGE_OPPOSING_SCHOOL_SELECTION)//select oposing school(s)
            {
                int nSchool = GetLocalInt(oPC, "School");
                int a,b,c;
                switch(nSchool)
                {
                    case SPELL_SCHOOL_ABJURATION:
                        AddSchool(SPELL_SCHOOL_CONJURATION);
                        AddSchool(SPELL_SCHOOL_ENCHANTMENT);
                        AddSchool(SPELL_SCHOOL_EVOCATION);
                        AddSchool(SPELL_SCHOOL_ILLUSION);
                        AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                        AddSchool(SPELL_SCHOOL_DIVINATION, SPELL_SCHOOL_NECROMANCY);
                        break;
                    case SPELL_SCHOOL_CONJURATION:
                        AddSchool(SPELL_SCHOOL_EVOCATION);
                        AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                        AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ENCHANTMENT);
                        AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ILLUSION);
                        AddSchool(SPELL_SCHOOL_ENCHANTMENT, SPELL_SCHOOL_ILLUSION);
                        // 8^3? Ouch! ... Attempt to reduce the load somewhat
                        for(a=1;a<=8;a++)
                        {
                            if(a == SPELL_SCHOOL_EVOCATION     ||
                               a == SPELL_SCHOOL_TRANSMUTATION ||
                               a == SPELL_SCHOOL_CONJURATION)
                                continue;

                            for(b=a+1;b<=8;b++)
                            {
                                if(b == SPELL_SCHOOL_EVOCATION     ||
                                   b == SPELL_SCHOOL_TRANSMUTATION ||
                                   b == SPELL_SCHOOL_CONJURATION)
                                    continue;

                                for(c=b+1;c<=8;c++)
                                {
                                    if(c == SPELL_SCHOOL_EVOCATION     ||
                                       c == SPELL_SCHOOL_TRANSMUTATION ||
                                       c == SPELL_SCHOOL_CONJURATION)
                                        continue;

                                    /*if(!(a == SPELL_SCHOOL_EVOCATION
                                      || b == SPELL_SCHOOL_EVOCATION
                                      || c == SPELL_SCHOOL_EVOCATION
                                      || a == SPELL_SCHOOL_TRANSMUTATION
                                      || b == SPELL_SCHOOL_TRANSMUTATION
                                      || c == SPELL_SCHOOL_TRANSMUTATION
                                      || a == SPELL_SCHOOL_CONJURATION
                                      || b == SPELL_SCHOOL_CONJURATION
                                      || c == SPELL_SCHOOL_CONJURATION
                                      || (a == SPELL_SCHOOL_ABJURATION
                                       && b == SPELL_SCHOOL_ENCHANTMENT
                                       && c == SPELL_SCHOOL_ILLUSION
                                      ) ))*/
                                    if(!(a == SPELL_SCHOOL_ABJURATION
                                      && b == SPELL_SCHOOL_ENCHANTMENT
                                      && c == SPELL_SCHOOL_ILLUSION))
                                    {
                                        AddSchool(a,b,c);
                                    }
                                }
                            }
                        }
                        break;
                    case SPELL_SCHOOL_DIVINATION:
                        for(a=1;a<=8;a++)
                        {
                            if(a != SPELL_SCHOOL_DIVINATION)
                                AddSchool(a);
                        }
                        break;
                    case SPELL_SCHOOL_ENCHANTMENT:
                        AddSchool(SPELL_SCHOOL_ABJURATION);
                        AddSchool(SPELL_SCHOOL_CONJURATION);
                        AddSchool(SPELL_SCHOOL_EVOCATION);
                        AddSchool(SPELL_SCHOOL_ILLUSION);
                        AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                        AddSchool(SPELL_SCHOOL_DIVINATION, SPELL_SCHOOL_NECROMANCY);
                        break;
                    case SPELL_SCHOOL_EVOCATION:
                        AddSchool(SPELL_SCHOOL_CONJURATION);
                        AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                        AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ENCHANTMENT);
                        AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ILLUSION);
                        AddSchool(SPELL_SCHOOL_ENCHANTMENT, SPELL_SCHOOL_ILLUSION);
                        for(a=1;a<=8;a++)
                        {
                            if(a == SPELL_SCHOOL_EVOCATION     ||
                               a == SPELL_SCHOOL_TRANSMUTATION ||
                               a == SPELL_SCHOOL_CONJURATION)
                                continue;

                            for(b=a+1;b<=8;b++)
                            {
                                if(b == SPELL_SCHOOL_EVOCATION     ||
                                   b == SPELL_SCHOOL_TRANSMUTATION ||
                                   b == SPELL_SCHOOL_CONJURATION)
                                    continue;

                                for(c=b+1;c<=8;c++)
                                {
                                    if(c == SPELL_SCHOOL_EVOCATION     ||
                                       c == SPELL_SCHOOL_TRANSMUTATION ||
                                       c == SPELL_SCHOOL_CONJURATION)
                                        continue;

                                    if(!(a == SPELL_SCHOOL_ABJURATION
                                      && b == SPELL_SCHOOL_ENCHANTMENT
                                      && c == SPELL_SCHOOL_ILLUSION))
                                    {
                                        AddSchool(a,b,c);
                                    }
                                }
                            }
                        }
                        break;
                    case SPELL_SCHOOL_ILLUSION:
                        AddSchool(SPELL_SCHOOL_ABJURATION);
                        AddSchool(SPELL_SCHOOL_CONJURATION);
                        AddSchool(SPELL_SCHOOL_EVOCATION);
                        AddSchool(SPELL_SCHOOL_ENCHANTMENT);
                        AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                        AddSchool(SPELL_SCHOOL_DIVINATION, SPELL_SCHOOL_NECROMANCY);
                        break;
                    case SPELL_SCHOOL_NECROMANCY:
                        for(a=1;a<=8;a++)
                        {
                            if(a != SPELL_SCHOOL_NECROMANCY)
                                AddSchool(a);
                        }
                        break;
                    case SPELL_SCHOOL_TRANSMUTATION:
                        AddSchool(SPELL_SCHOOL_CONJURATION);
                        AddSchool(SPELL_SCHOOL_EVOCATION);
                        AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ENCHANTMENT);
                        AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ILLUSION);
                        AddSchool(SPELL_SCHOOL_ENCHANTMENT, SPELL_SCHOOL_ILLUSION);
                        for(a=1;a<=8;a++)
                        {
                            if(a == SPELL_SCHOOL_EVOCATION     ||
                               a == SPELL_SCHOOL_TRANSMUTATION ||
                               a == SPELL_SCHOOL_CONJURATION)
                                continue;

                            for(b=a+1;b<=8;b++)
                            {
                                if(b == SPELL_SCHOOL_EVOCATION     ||
                                   b == SPELL_SCHOOL_TRANSMUTATION ||
                                   b == SPELL_SCHOOL_CONJURATION)
                                    continue;

                                for(c=b+1;c<=8;c++)
                                {
                                    if(c == SPELL_SCHOOL_EVOCATION     ||
                                       c == SPELL_SCHOOL_TRANSMUTATION ||
                                       c == SPELL_SCHOOL_CONJURATION)
                                        continue;

                                    if(!(a == SPELL_SCHOOL_ABJURATION
                                      && b == SPELL_SCHOOL_ENCHANTMENT
                                      && c == SPELL_SCHOOL_ILLUSION))
                                    {
                                        AddSchool(a,b,c);
                                    }
                                }
                            }
                        }
                        break;
                }
                SetHeader("Select a set of opposition school(s).");
                MarkStageSetUp(STAGE_OPPOSING_SCHOOL_SELECTION, oPC);
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nSchool  = GetLocalInt(oPC, "School" );
                int nSchool1 = GetLocalInt(oPC, "School1");
                int nSchool2 = GetLocalInt(oPC, "School2");
                int nSchool3 = GetLocalInt(oPC, "School3");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName;
                sName += GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool1)));
                if(nSchool2 && !nSchool3)
                    sName += " and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
                if(nSchool2 && nSchool3)
                {
                    sName += ", "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
                    sName += ", and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool3)));
                }

                string sText = "You have selected "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool)))
                    +" as your specialist school.\n";
                if(nSchool != SPELL_SCHOOL_GENERAL)
                    sText += "You have selected "+sName+" as your opposition school(s).\n";
                sText += "Is this correct?";
                SetHeader(sText);
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);
            }
            else if(nStage == STAGE_COMPLETION)//completion
            {
                //end stage, do not set responces
                string sText = "Your PnP Spell Schools are now setup";
                SetHeader(sText);
            }
        }

        // Do token setup
        SetupTokens();
        SetDefaultTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "School");
        DeleteLocalInt(oPC, "School1");
        DeleteLocalInt(oPC, "School2");
        DeleteLocalInt(oPC, "School3");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // Abort conversation cleanup
        DeleteLocalInt(oPC, "School");
        DeleteLocalInt(oPC, "School1");
        DeleteLocalInt(oPC, "School2");
        DeleteLocalInt(oPC, "School3");
    }
    // Handle PC responses
    else
    {
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SCHOOL_SELECTION)//select a school
        {
            if(nChoice == SPELL_SCHOOL_GENERAL)
                nStage = STAGE_CONFIRMATION;// generalist, go to confirmation
            else
                nStage = STAGE_OPPOSING_SCHOOL_SELECTION;//select opposing school
            SetLocalInt(oPC, "School", nChoice);
        }
        else if(nStage == STAGE_OPPOSING_SCHOOL_SELECTION)//select opposing school(s)
        {
            int nSchool1 = nChoice & 15;
            int nSchool2 = (nChoice & 240) >> 4;
            int nSchool3 = (nChoice & 3840) >> 8;
            SetLocalInt(oPC, "School1", nSchool1);
            SetLocalInt(oPC, "School2", nSchool2);
            SetLocalInt(oPC, "School3", nSchool3);
            nStage = STAGE_CONFIRMATION;

            if(DEBUG)
            {
                DoDebug("nChoice = "+IntToString(nChoice)+"\n"
                      + "nSchool1 = "+IntToString(nSchool1)+"\n"
                      + "nSchool2 = "+IntToString(nSchool2)+"\n"
                      + "nSchool3 = "+IntToString(nSchool3)+"\n"
                      + "nValue & 240 = "+IntToString(nValue & 240)+"\n"
                      + "nValue & 3840 = "+IntToString(nValue & 3840)+"\n"
                       );
            }
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
                nStage = STAGE_COMPLETION;
                int nSchool  = GetLocalInt(oPC, "School" );
                int nSchool1 = GetLocalInt(oPC, "School1");
                int nSchool2 = GetLocalInt(oPC, "School2");
                int nSchool3 = GetLocalInt(oPC, "School3");
                object oSkin = GetPCSkin(oPC);
                itemproperty ipSchool = PRCItemPropertyBonusFeat(GetIPFromSchool(nSchool));
                itemproperty ipSchool1 = PRCItemPropertyBonusFeat(GetIPFromOppSchool(nSchool1));
                itemproperty ipSchool2 = PRCItemPropertyBonusFeat(GetIPFromOppSchool(nSchool2));
                itemproperty ipSchool3 = PRCItemPropertyBonusFeat(GetIPFromOppSchool(nSchool3));
                IPSafeAddItemProperty(oSkin, ipSchool, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                if(nSchool1 != 0)
                    IPSafeAddItemProperty(oSkin, ipSchool1, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                if(nSchool2 != 0)
                    IPSafeAddItemProperty(oSkin, ipSchool2, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                if(nSchool3 != 0)
                    IPSafeAddItemProperty(oSkin, ipSchool3, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
            else
            {
                nStage = STAGE_SCHOOL_SELECTION;
                MarkStageNotSetUp(STAGE_SCHOOL_SELECTION, oPC);
                MarkStageNotSetUp(STAGE_OPPOSING_SCHOOL_SELECTION, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "School");
            DeleteLocalInt(oPC, "School1");
            DeleteLocalInt(oPC, "School2");
            DeleteLocalInt(oPC, "School3");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
