//:://////////////////////////////////////////////  
//:: Half-Vampire special ability selection convo  
//:: tmp_c_halfvamp.nss  
//:://////////////////////////////////////////////  
#include "inc_dynconv"  
#include "prc_inc_template"  
#include "inc_nwnx_funcs"  
  
const int STAGE_ENTRY   = 0;  
const int STAGE_CONFIRM = 1;  
  
void main()  
{  
    object oPC = GetPCSpeaker();  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
  
    if(nValue == 0) // something else called the script  
        return;  
  
    if(nValue == DYNCONV_SETUP_STAGE)  
    {  
        if(!GetIsStageSetUp(nStage, oPC))  
        {  
            if(nStage == STAGE_ENTRY)  
            {  
                SetHeader("Select your half-vampire special ability:");  
                AddChoice("Blood Drain (Ex)", 1);  
                AddChoice("Charm Gaze (Su)", 2);  
                AddChoice("Children of the Night (Su)", 3);  
                MarkStageSetUp(STAGE_ENTRY, oPC);  
                SetDefaultTokens();  
            }  
            else if(nStage == STAGE_CONFIRM)  
            {  
                int nChoice = GetLocalInt(oPC, "PRC_HalfVamp_Choice");  
                string sName = (nChoice == 1) ? "Blood Drain" :  
                               (nChoice == 2) ? "Charm Gaze" :  
                                                 "Children of the Night";  
                SetHeader("You have selected " + sName + ".\n\nIs this correct?");  
                AddChoice("Yes", TRUE);  
                AddChoice("No", FALSE);  
                MarkStageSetUp(STAGE_CONFIRM, oPC);  
            }  
        }  
        SetupTokens();  
    }  
    else if(nValue == DYNCONV_EXITED || nValue == DYNCONV_ABORTED)  
    {  
        DeleteLocalInt(oPC, "PRC_HalfVamp_Choice");  
    }  
    else  
    {  
        int nChoice = GetChoice(oPC);  
        if(nStage == STAGE_ENTRY)  
        {  
            SetLocalInt(oPC, "PRC_HalfVamp_Choice", nChoice);  
            nStage = STAGE_CONFIRM;  
            MarkStageNotSetUp(nStage, oPC);  
        }  
        else if(nStage == STAGE_CONFIRM)  
        {  
            if(nChoice == TRUE)  
            {  
                int nAbility = GetLocalInt(oPC, "PRC_HalfVamp_Choice");  
                ApplyTemplateToObject(TEMPLATE_HALF_VAMPIRE, oPC);  
                SetPersistantLocalInt(oPC, "HVamp_AbilityChoice", nAbility);  
  
                int nFeat;  
                if(nAbility == 1)      nFeat = FEAT_TEMPLATE_HALF_VAMPIRE_BLOOD_DRAIN;  
                else if(nAbility == 2) nFeat = FEAT_TEMPLATE_HALF_VAMPIRE_CHARM_GAZE;  
                else if(nAbility == 3) nFeat = FEAT_TEMPLATE_HALF_VAMPIRE_CHILDREN_NIGHT;  
  
                int nNWNxEE = GetPRCSwitch(PRC_NWNXEE_ENABLED);  
                int nPRCx   = GetPRCSwitch(PRC_PRCX_ENABLED);  
                int bFuncs  = (nNWNxEE && nPRCx);  
  
                if(bFuncs)  
                {  
                    PRC_Funcs_AddFeat(oPC, nFeat);  
                }  
                else  
                {  
                    effect eFeat = EffectBonusFeat(nFeat);  
                    eFeat = UnyieldingEffect(eFeat);  
                    eFeat = TagEffect(eFeat, "HVampAbilityFeat");  
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFeat, oPC);  
                }  
  
                DeleteLocalInt(oPC, "PRC_HalfVamp_Choice");  
                DelayCommand(0.01, EvalPRCFeats(oPC));  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
            }  
            else  
            {  
                nStage = STAGE_ENTRY;  
                DeleteLocalInt(oPC, "PRC_HalfVamp_Choice");  
                MarkStageNotSetUp(STAGE_ENTRY, oPC);  
                MarkStageNotSetUp(STAGE_CONFIRM, oPC);  
            }  
        }  
        SetStage(nStage, oPC);  
    }  
}