//::  
//:: wnd_tmpl_conv.nss  
//::  
  
#include "inc_dynconv"  
  
const int STAGE_PICK_TEMPLATE = 0;  
  
void main()  
{  
    object oPC = GetPCSpeaker();  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
  
    if (nValue == 0) return;  
	
	if (nValue == DYNCONV_EXITED || nValue == DYNCONV_ABORTED)  
    return;
  
    if (nValue == DYNCONV_SETUP_STAGE)  
    {  
        if (!GetIsStageSetUp(nStage, oPC))  
        {  
            if (nStage == STAGE_PICK_TEMPLATE)  
            {
				//SetLocalInt(oPC, "ChoiceOffset", 0);
	
                SetHeader("Select the template this wand will apply to its next NPC target:");  
                AddChoice("Bone Creature",       1);  
                AddChoice("Celestial Creature",  2);  
                AddChoice("Corpse Creature",     3);  
                AddChoice("Corrupt Creature",    4);  
                AddChoice("Effigy Creature",     5);  
                AddChoice("Elder Eidolon",       6);  
                AddChoice("Evolved Undead",      7);  
                AddChoice("Fiendish Creature",   8);  
                AddChoice("Greenbound Creature", 9);  
                AddChoice("Guardian Creature",   10);  
                AddChoice("Paragon Creature",    11); 
				AddChoice("Psuedonatural Creature",    12);
  
                MarkStageSetUp(STAGE_PICK_TEMPLATE, oPC);  
                SetDefaultTokens();  
            }  
        }  
   
        SetupTokens();  
    }  
    else // player made a choice  
	{
		int nChoice = GetChoice(oPC);
		
		//int nChoiceOffset = GetLocalInt(oPC, "ChoiceOffset");
		//int nChoice = GetChoice(oPC) + nChoiceOffset; 
	  
		if (DEBUG) DoDebug("wnd_tmpl_conv: DYNCONV_VARIABLE=" + IntToString(GetLocalInt(oPC, DYNCONV_VARIABLE))  
		+ " ChoiceOffset=" + IntToString(GetLocalInt(oPC, "ChoiceOffset"))  
		+ " GetChoice=" + IntToString(GetChoice(oPC)));
	  
		object oItem = GetLocalObject(oPC, "WND_TEMPLATE_ITEM");  
		string sScript;  
		if      (nChoice == 1)  sScript = "make_bone_cre";  
		else if (nChoice == 2)  sScript = "make_celestial";  
		else if (nChoice == 3)  sScript = "make_corpse_cre";  
		else if (nChoice == 4)  sScript = "make_corrupt_cre";  
		else if (nChoice == 5)  sScript = "make_effigy";  
		else if (nChoice == 6)  sScript = "make_eidolon";  
		else if (nChoice == 7)  sScript = "make_evolved";  
		else if (nChoice == 8)  sScript = "make_fiendish";  
		else if (nChoice == 9)  sScript = "make_greenbound";  
		else if (nChoice == 10) sScript = "make_guardian";  
		else if (nChoice == 11) sScript = "make_paragon";  
		else if (nChoice == 12) sScript = "make_psuedonat";  
	  
		if (sScript != "" && GetIsObjectValid(oItem))  
			SetLocalString(oItem, "WND_TEMPLATE_CHOICE", sScript);  
	  
		AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
	}  
}