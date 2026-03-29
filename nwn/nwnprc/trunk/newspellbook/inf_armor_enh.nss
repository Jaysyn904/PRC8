// inf_armor_enh.nss    
/* 
Armor Enhancement, Lesser
Transmutation
Level: Artificer 1
Components: S, M
Casting Time: 1 minute
Range: Touch
Target: Armor or shield touched
Duration: 10 min./level
Saving Throw: None (object)
Spell Resistance: No (object)

The armor or shield you touch temporarily gains a special ability 
commonly found on magic armor or shields.
You can choose any special ability whose market price is equivalent to
 a +1 bonus or up to 5,000 gp, such as light fortification or shadow. 
 The armor or shield does not need to have an existing enhancement 
 bonus, nor does it gain one when you imbue it with this infusion.
Material Component: An ointment made from rare spices and minerals, 
costing 10 gp.

Armor Enhancement
Transmutation
Level: Artificer 2

As lesser armor enhancement, but you can choose any special ability 
whose market price is equivalent to a bonus of up to +3 or up to 
35,000 gp, such as ghost touch or acid resistance.
Material Component: An ointment costing 50 gp.

Armor Enhancement, Greater
Transmutation
Level: Artificer 3

As lesser armor enhancement, but you can choose any special ability 
whose market price is equivalent to a bonus of up to +5 or up to 
100,000 gp, such as etherealness or greater fire resistance.
Material Component: An ointment costing 100 gp.  
   */
  
#include "inc_debug"      
#include "prc_craft_inc"    
#include "inc_dynconv"  
  
// Placeholder magic numbers for spell IDs  
const int ARMOR_ENH_LESS = 5001;  
const int ARMOR_ENH = 5002;  
const int ARMOR_ENH_GREATER = 5003;  
  
// Dynamic conversation stages  
const int STAGE_PROPERTY_SELECTION = 0;  
const int STAGE_CONFIRMATION = 1;  


void HandleConversation(object oPC, object oArmor, int nMaxEnhancement, int nMaxCost, string sLocalVar, int nSpellID, int nCasterLevel)  
{  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
      
    if(nValue == 0) return;  
      
    if(nValue == DYNCONV_SETUP_STAGE)  
    {  
        if(!GetIsStageSetUp(nStage, oPC))  
        {  
            if(nStage == STAGE_PROPERTY_SELECTION)  
            {  
                // Set header first  
                SetHeader("Select an armor enhancement:");  
                  
                // Initialize default tokens BEFORE adding choices  
                SetDefaultTokens();  
                  
                // Read directly from craft_armour.2da  
                int nFileEnd = PRCGetFileEnd("craft_armour");  
                int nChoice = 1;  
                int i;  
                  
                for(i = 0; i <= nFileEnd; i++)  
                {  
                    // Get enhancement and cost for this specific line  
                    int nEnhancement = StringToInt(Get2DACache("craft_armour", "Enhancement", i));  
                    int nAdditionalCost = StringToInt(Get2DACache("craft_armour", "AdditionalCost", i));  
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_armour", "Name", i)));  
                      
                    // Debug output  
                    SendMessageToPC(oPC, "Line " + IntToString(i) + ": " + sName + " (Enh:" + IntToString(nEnhancement) + ", Cost:" + IntToString(nAdditionalCost) + ")");  
                      
                    // Check if this property is within limits  
                    if(nEnhancement <= nMaxEnhancement && nAdditionalCost <= nMaxCost)  
                    {  
                        AddChoice(sName, i, oPC);  
                        nChoice++;  
                    }  
                }  
                  
                MarkStageSetUp(STAGE_PROPERTY_SELECTION, oPC);  
            }  
            else if(nStage == STAGE_CONFIRMATION)  
            {  
                int nPropertyLine = GetLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_armour", "Name", nPropertyLine)));  
                  
                SetHeader("Apply " + sName + " to the armor?");  
                  
                AddChoice("Yes", TRUE, oPC);  
                AddChoice("No", FALSE, oPC);  
                  
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);  
            }  
        }  
          
        SetupTokens();  
    }  
    else if(nValue == DYNCONV_EXITED)  
    {  
        // Cleanup  
        DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
        DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
        DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
    }  
    else if(nValue == DYNCONV_ABORTED)  
    {  
        // Cleanup  
        DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
        DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
        DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
    }  
    else  
    {  
        int nChoice = GetChoice(oPC);  
          
        if(nStage == STAGE_PROPERTY_SELECTION)  
        {  
            // Store selection and go to confirmation  
            SetLocalInt(oPC, "ArmorEnh_SelectedProperty", nChoice);  
            nStage = STAGE_CONFIRMATION;  
            MarkStageNotSetUp(STAGE_PROPERTY_SELECTION, oPC);  
        }  
        else if(nStage == STAGE_CONFIRMATION)  
        {  
            if(nChoice == TRUE) // User confirmed  
            {  
                // Apply the property  
                object oArmor = GetLocalObject(oPC, "ARMOR_ENH_TARGET");  
                int nPropertyLine = GetLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                int nCasterLevel = GetLocalInt(oPC, "ArmorEnh_CasterLevel");  
                  
				float fDuration = TurnsToSeconds(nCasterLevel * 10);    
				int nMetaMagic = PRCGetMetaMagicFeat();    
				if(nMetaMagic & METAMAGIC_EXTEND)    
					fDuration *= 2;    
				  
				// Debug output    
				SendMessageToPC(oPC, "Duration: " + FloatToString(fDuration) + " seconds");  
				  
				// Add fallback for very small durations    
				if (fDuration <= 1.0) fDuration = 30.0f;
				
				SendMessageToPC(oPC, "Fallback Duration: " + FloatToString(fDuration) + " seconds"); 
                  
                // Create property directly  
                itemproperty ip;  
/*                 if(nPropertyLine == 0)  
                {  
                    // +1 Enhancement  
                    ip = ConstructIP(ITEM_PROPERTY_AC_BONUS, 0, 1, 0);  
                }  
                else  
                {   */
                    // Read property data from 2DA and construct  
                    string sIPData = Get2DACache("craft_armour", "IP1", nPropertyLine);  
                    struct ipstruct iptemp = GetIpStructFromString(sIPData);  
                    ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);  
                //}  
                  
                // Apply with proper duration  
                ip = TagItemProperty(ip, "ArmorEnhInfusion");  
                IPSafeAddItemProperty(oArmor, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
                  
                // Clean up and exit  
                DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
                DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
                DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
            }  
            else // User cancelled  
            {  
                // Go back to property selection  
                nStage = STAGE_PROPERTY_SELECTION;  
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);  
            }  
        }  
          
        SetStage(nStage, oPC);  
    }  
}  
  
void main()  
{  
    object oPC = GetPCSpeaker();  
    if(!GetIsObjectValid(oPC)) oPC = OBJECT_SELF;  
      
    // Check if we're in conversation mode  
    if(GetLocalInt(oPC, "ArmorEnh_ConvMode"))  
    {  
        // Retrieve parameters for conversation  
        object oArmor = GetLocalObject(oPC, "ARMOR_ENH_TARGET");  
        int nMaxEnhancement = GetLocalInt(oPC, "ArmorEnh_MaxEnh");  
        int nMaxCost = GetLocalInt(oPC, "ArmorEnh_MaxCost");  
        string sLocalVar = GetLocalString(oPC, "ArmorEnh_LocalVar");  
        int nSpellID = GetLocalInt(oPC, "ArmorEnh_SpellID");  
        int nCasterLevel = GetLocalInt(oPC, "ArmorEnh_CasterLevel");  
          
        HandleConversation(oPC, oArmor, nMaxEnhancement, nMaxCost, sLocalVar, nSpellID, nCasterLevel);  
        return;  
    }  
      
    // Normal spell execution  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
    if (!X2PreSpellCastCode()) return;  
      
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    int nSpellID = PRCGetSpellId();  
      
    // Declare variables  
    int nGoldCost, nMaxEnhancement, nMaxCost;  
    string sLocalVar;  
      
    // Set parameters based on spell level  
    switch(nSpellID)  
    {  
        case ARMOR_ENH_LESS:  
            nGoldCost = 10;  
            nMaxEnhancement = 1;  
            nMaxCost = 5000;  
            sLocalVar = "ARMOR_ENH_LESS_PROPERTY";  
            break;  
        case ARMOR_ENH:  
            nGoldCost = 50;  
            nMaxEnhancement = 3;  
            nMaxCost = 35000;  
            sLocalVar = "ARMOR_ENH_PROPERTY";  
            break;  
        case ARMOR_ENH_GREATER:  
            nGoldCost = 100;  
            nMaxEnhancement = 5;  
            nMaxCost = 100000;  
            sLocalVar = "ARMOR_ENH_GREATER_PROPERTY";  
            break;  
        default:  
            // Default to lesser version for testing  
            nGoldCost = 10;  
            nMaxEnhancement = 1;  
            nMaxCost = 5000;  
            sLocalVar = "ARMOR_ENH_LESS_PROPERTY";  
            break;  
    }  
      
    // Check material component  
    if(GetGold(oCaster) < nGoldCost)  
    {  
        FloatingTextStringOnCreature("You need " + IntToString(nGoldCost) + "gp worth of rare spices and minerals.", oCaster, FALSE);  
        return;  
    }  
      
    // Get targeted armor or shield  
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);
	//object oArmor = IPGetTargetedOrEquippedArmor(TRUE);	<- don't delete
    if(!GetIsObjectValid(oArmor))  
    {  
        FloatingTextStrRefOnCreature(83826, oCaster, FALSE); // "Invalid target"  
        return;  
    }  
      
    // Check if returning from conversation with a selection  
    int nPropertyLine = GetLocalInt(oCaster, sLocalVar);  
    if(nPropertyLine > 0)  
    {  
        // Apply the property  
        float fDuration = TurnsToSeconds(nCasterLevel * 10);  
        int nMetaMagic = PRCGetMetaMagicFeat();  
        if(nMetaMagic & METAMAGIC_EXTEND)  
            fDuration *= 2;  
  
        if (fDuration <= 1.0) fDuration = 30.0f;  
          
        // Create property directly  
        itemproperty ip;  

		// Read property data from 2DA and construct  
		string sIPData = Get2DACache("craft_armour", "IP1", nPropertyLine);  
		struct ipstruct iptemp = GetIpStructFromString(sIPData);  
		ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);          
          
        // Apply with proper duration  
        ip = TagItemProperty(ip, "ArmorEnhInfusion");  
        IPSafeAddItemProperty(oArmor, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
          
        DeleteLocalInt(oCaster, sLocalVar);  
        return;  
    }  
      
    // Store parameters for conversation and start it  
    SetLocalInt(oPC, "ArmorEnh_ConvMode", 1);  
    SetLocalObject(oPC, "ARMOR_ENH_TARGET", oArmor);  
    SetLocalInt(oPC, "ArmorEnh_MaxEnh", nMaxEnhancement);  
    SetLocalInt(oPC, "ArmorEnh_MaxCost", nMaxCost);  
    SetLocalString(oPC, "ArmorEnh_LocalVar", sLocalVar);  
    SetLocalInt(oPC, "ArmorEnh_SpellID", nSpellID);  
    SetLocalInt(oPC, "ArmorEnh_CasterLevel", nCasterLevel);  
      
    // Start the dynamic conversation using this same script  
    StartDynamicConversation("inf_armor_enh", oPC, 0, FALSE, TRUE);  
}
   
   
/* void HandleConversation(object oPC, object oArmor, int nMaxEnhancement, int nMaxCost, string sLocalVar, int nSpellID, int nCasterLevel)  
{  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
      
    if(nValue == 0) return;  
      
    if(nValue == DYNCONV_SETUP_STAGE)  
    {  
        if(!GetIsStageSetUp(nStage, oPC))  
        {  
            if(nStage == STAGE_PROPERTY_SELECTION)  
            {  
                // Set header first  
                SetHeader("Select an armor enhancement:");  
                  
                // Initialize default tokens BEFORE adding choices  
                SetDefaultTokens();  
                  
                // Read directly from craft_armour.2da  
                int nFileEnd = PRCGetFileEnd("craft_armour");  
                int nChoice = 1;  
                int i;  
                  
                for(i = 0; i <= nFileEnd; i++)  
                {  
                    // Get enhancement and cost for this specific line  
                    int nEnhancement = StringToInt(Get2DACache("craft_armour", "Enhancement", i));  
                    int nAdditionalCost = StringToInt(Get2DACache("craft_armour", "AdditionalCost", i));  
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_armour", "Name", i)));  
                      
                    // Debug output  
                    SendMessageToPC(oPC, "Line " + IntToString(i) + ": " + sName + " (Enh:" + IntToString(nEnhancement) + ", Cost:" + IntToString(nAdditionalCost) + ")");  
                      
                    // Check if this property is within limits  
                    if(nEnhancement <= nMaxEnhancement && nAdditionalCost <= nMaxCost)  
                    {  
                        AddChoice(sName, i, oPC);  
                        nChoice++;  
                    }  
                }  
                  
                MarkStageSetUp(STAGE_PROPERTY_SELECTION, oPC);  
            }  
            else if(nStage == STAGE_CONFIRMATION)  
            {  
                int nPropertyLine = GetLocalInt(oPC, "ArmorEnh_SelectedProperty");
				
                string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_armour", "Name", nPropertyLine)));  
                  
                SetHeader("Apply " + sName + " to the armor?");  
                  
                AddChoice("Yes", TRUE, oPC);  
                AddChoice("No", FALSE, oPC);  
                  
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);  
            }  
        }  
          
        SetupTokens();  
    }  
    else if(nValue == DYNCONV_EXITED)  
    {  
        // Cleanup  
        DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
        DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
        DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
    }  
    else if(nValue == DYNCONV_ABORTED)  
    {  
        // Cleanup  
        DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
        DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
        DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
    }  
    else  
    {  
        int nChoice = GetChoice(oPC);  
          
        if(nStage == STAGE_PROPERTY_SELECTION)  
        {  
            // Store selection and go to confirmation  
            SetLocalInt(oPC, "ArmorEnh_SelectedProperty", nChoice);  
            nStage = STAGE_CONFIRMATION;  
            MarkStageNotSetUp(STAGE_PROPERTY_SELECTION, oPC);  
        }  
        else if(nStage == STAGE_CONFIRMATION)  
        {  
            if(nChoice == TRUE) // User confirmed  
            {  
                // Apply the property  
                object oArmor = GetLocalObject(oPC, "ARMOR_ENH_TARGET");  
                int nPropertyLine = GetLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                int nCasterLevel = GetLocalInt(oPC, "ArmorEnh_CasterLevel");  
                  
				float fDuration = TurnsToSeconds(nCasterLevel * 10);    
				int nMetaMagic = PRCGetMetaMagicFeat();    
				if(nMetaMagic & METAMAGIC_EXTEND)    
					fDuration *= 2;    
				  
				// Debug output    
				SendMessageToPC(oPC, "Duration: " + FloatToString(fDuration) + " seconds");  
				  
				// Add fallback for very small durations    
				if (fDuration <= 1.0) fDuration = 30.0f;
                  
                // Create property directly  
                itemproperty ip;  
                if(nPropertyLine == 0)  
                {  
                    // +1 Enhancement  
                    ip = ConstructIP(ITEM_PROPERTY_AC_BONUS, 0, 1, 0);  
                }  
                else  
                {  
                    // Read property data from 2DA and construct  
                    string sIPData = Get2DACache("craft_armour", "IP1", nPropertyLine);  
                    struct ipstruct iptemp = GetIpStructFromString(sIPData);  
                    ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);  
                }  
                  
                // Apply with proper duration  
                ip = TagItemProperty(ip, "ArmorEnhInfusion");  
                IPSafeAddItemProperty(oArmor, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
                  
                // Clean up and exit  
                DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
                DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
                DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
				return;							
            }  
            else // User cancelled  
            {  
                // Go back to property selection  
                nStage = STAGE_PROPERTY_SELECTION;  
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);  
            }  
        }  
          
        SetStage(nStage, oPC);  
    }  
}  
  
void main()  
{  
    object oPC = GetPCSpeaker();  
    if(!GetIsObjectValid(oPC)) oPC = OBJECT_SELF;  
      
    // Check if we're in conversation mode  
    if(GetLocalInt(oPC, "ArmorEnh_ConvMode"))  
    {  
        // Retrieve parameters for conversation  
        object oArmor = GetLocalObject(oPC, "ARMOR_ENH_TARGET");  
        int nMaxEnhancement = GetLocalInt(oPC, "ArmorEnh_MaxEnh");  
        int nMaxCost = GetLocalInt(oPC, "ArmorEnh_MaxCost");  
        string sLocalVar = GetLocalString(oPC, "ArmorEnh_LocalVar");  
        int nSpellID = GetLocalInt(oPC, "ArmorEnh_SpellID");  
        int nCasterLevel = GetLocalInt(oPC, "ArmorEnh_CasterLevel");  
          
        HandleConversation(oPC, oArmor, nMaxEnhancement, nMaxCost, sLocalVar, nSpellID, nCasterLevel);  
        return;  
    }  
      
    // Normal spell execution  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
    if (!X2PreSpellCastCode()) return;  
      
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    //int nSpellID = PRCGetSpellId();  
	int nSpellID = ARMOR_ENH_GREATER;
      
    // Declare variables  
    int nGoldCost, nMaxEnhancement, nMaxCost;  
    string sLocalVar;  
      
    // Set parameters based on spell level  
    switch(nSpellID)  
    {  
        case ARMOR_ENH_LESS:  
            nGoldCost = 10;  
            nMaxEnhancement = 1;  
            nMaxCost = 5000;  
            sLocalVar = "ARMOR_ENH_LESS_PROPERTY";  
            break;  
        case ARMOR_ENH:  
            nGoldCost = 50;  
            nMaxEnhancement = 3;  
            nMaxCost = 35000;  
            sLocalVar = "ARMOR_ENH_PROPERTY";  
            break;  
        case ARMOR_ENH_GREATER:  
            nGoldCost = 100;  
            nMaxEnhancement = 5;  
            nMaxCost = 100000;  
            sLocalVar = "ARMOR_ENH_GREATER_PROPERTY";  
            break;  
        default:  
            // Default to lesser version for testing  
            nGoldCost = 10;  
            nMaxEnhancement = 1;  
            nMaxCost = 5000;  
            sLocalVar = "ARMOR_ENH_LESS_PROPERTY";  
            break;  
    }  
      
    // Check material component  
    if(GetGold(oCaster) < nGoldCost)  
    {  
        FloatingTextStringOnCreature("You need " + IntToString(nGoldCost) + "gp worth of rare spices and minerals.", oCaster, FALSE);  
        return;  
    }  
      
    // Get targeted armor or shield  
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);  
    if(!GetIsObjectValid(oArmor))  
    {  
        FloatingTextStrRefOnCreature(83826, oCaster, FALSE); // "Invalid target"  
        return;  
    }  
      
    // Store parameters for conversation and start it  
    SetLocalInt(oPC, "ArmorEnh_ConvMode", 1);  
    SetLocalObject(oPC, "ARMOR_ENH_TARGET", oArmor);  
    SetLocalInt(oPC, "ArmorEnh_MaxEnh", nMaxEnhancement);  
    SetLocalInt(oPC, "ArmorEnh_MaxCost", nMaxCost);  
    SetLocalString(oPC, "ArmorEnh_LocalVar", sLocalVar);  
    SetLocalInt(oPC, "ArmorEnh_SpellID", nSpellID);  
    SetLocalInt(oPC, "ArmorEnh_CasterLevel", nCasterLevel);  
      
    // Start the dynamic conversation using this same script  
    DelayCommand(0.1f, StartDynamicConversation("inf_armor_enh", oPC, 0, FALSE, TRUE));  
} */

  
  
/* void HandleConversation(object oPC, object oArmor, int nMaxEnhancement, int nMaxCost, string sLocalVar, int nSpellID, int nCasterLevel)  
{  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
      
    if(nValue == 0) return;  
      
    if(nValue == DYNCONV_SETUP_STAGE)  
    {  
        if(!GetIsStageSetUp(nStage, oPC))  
        {  
            if(nStage == STAGE_PROPERTY_SELECTION)  
            {  
                // Set header first  
                SetHeader("Select an armor enhancement:");  
                  
                // Initialize default tokens BEFORE adding choices  
                SetDefaultTokens();  
                  
                // Read directly from craft_armour.2da  
                int nFileEnd = PRCGetFileEnd("craft_armour");  
                int nChoice = 1;  
                int i;  
                  
                AddChoice("Enhancement +1", 0, oPC);  
                  
                for(i = 1; i <= nFileEnd; i++)  
                {  
                    // Get enhancement and cost for this specific line  
                    int nEnhancement = StringToInt(Get2DACache("craft_armour", "Enhancement", i));  
                    int nAdditionalCost = StringToInt(Get2DACache("craft_armour", "AdditionalCost", i));  
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_armour", "Name", i)));  
                      
                    // Debug output  
                    SendMessageToPC(oPC, "Line " + IntToString(i) + ": " + sName + " (Enh:" + IntToString(nEnhancement) + ", Cost:" + IntToString(nAdditionalCost) + ")");  
                      
                    // Check if this property is within limits  
                    if(nEnhancement <= nMaxEnhancement && nAdditionalCost <= nMaxCost)  
                    {  
                        AddChoice(sName, i, oPC);  
                        nChoice++;  
                    }  
                }  
                  
                MarkStageSetUp(STAGE_PROPERTY_SELECTION, oPC);  
            }  
            else if(nStage == STAGE_CONFIRMATION)  
            {  
                int nPropertyLine = GetLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                string sName;  
                  
                if(nPropertyLine == 0)  
                    sName = "Enhancement +1";  
                else  
                    sName = GetStringByStrRef(StringToInt(Get2DACache("craft_armour", "Name", nPropertyLine)));  
                  
                SetHeader("Apply " + sName + " to the armor?");  
                  
                AddChoice("Yes", TRUE, oPC);  
                AddChoice("No", FALSE, oPC);  
                  
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);  
            }  
        }  
          
        SetupTokens();  
    }  
    else if(nValue == DYNCONV_EXITED)  
    {  
        // Cleanup  
        DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
        DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
        DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
    }  
    else if(nValue == DYNCONV_ABORTED)  
    {  
        // Cleanup  
        DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
        DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
        DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
    }  
    else  
    {  
        int nChoice = GetChoice(oPC);  
          
        if(nStage == STAGE_PROPERTY_SELECTION)  
        {  
            // Store selection and go to confirmation  
            SetLocalInt(oPC, "ArmorEnh_SelectedProperty", nChoice);  
            nStage = STAGE_CONFIRMATION;  
            MarkStageNotSetUp(STAGE_PROPERTY_SELECTION, oPC);  
        }  
        else if(nStage == STAGE_CONFIRMATION)  
        {  
            if(nChoice == TRUE) // User confirmed  
            {  
                // Apply the property  
                object oArmor = GetLocalObject(oPC, "ARMOR_ENH_TARGET");  
                int nPropertyLine = GetLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                int nCasterLevel = GetLocalInt(oPC, "ArmorEnh_CasterLevel");  
                  
				float fDuration = TurnsToSeconds(nCasterLevel * 10);    
				int nMetaMagic = PRCGetMetaMagicFeat();    
				if(nMetaMagic & METAMAGIC_EXTEND)    
					fDuration *= 2;    
				  
				// Debug output    
				SendMessageToPC(oPC, "Duration: " + FloatToString(fDuration) + " seconds");  
				  
				// Add fallback for very small durations    
				if (fDuration <= 1.0) fDuration = 30.0f;
                  
                // Create property directly  
                itemproperty ip;  
                if(nPropertyLine == 0)  
                {  
                    // +1 Enhancement  
                    ip = ConstructIP(ITEM_PROPERTY_AC_BONUS, 0, 1, 0);  
                }  
                else  
                {  
                    // Read property data from 2DA and construct  
                    string sIPData = Get2DACache("craft_armour", "IP1", nPropertyLine);  
                    struct ipstruct iptemp = GetIpStructFromString(sIPData);  
                    ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);  
                }  
                  
                // Apply with proper duration  
                ip = TagItemProperty(ip, "ArmorEnhInfusion");  
                IPSafeAddItemProperty(oArmor, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
                  
                // Clean up and exit  
                DeleteLocalInt(oPC, "ArmorEnh_ConvMode");  
                DeleteLocalObject(oPC, "ARMOR_ENH_TARGET");  
                DeleteLocalInt(oPC, "ArmorEnh_SelectedProperty");  
                  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
            }  
            else // User cancelled  
            {  
                // Go back to property selection  
                nStage = STAGE_PROPERTY_SELECTION;  
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);  
            }  
        }  
          
        SetStage(nStage, oPC);  
    }  
}  
  
void main()  
{  
    object oPC = GetPCSpeaker();  
    if(!GetIsObjectValid(oPC)) oPC = OBJECT_SELF;  
      
    // Check if we're in conversation mode  
    if(GetLocalInt(oPC, "ArmorEnh_ConvMode"))  
    {  
        // Retrieve parameters for conversation  
        object oArmor = GetLocalObject(oPC, "ARMOR_ENH_TARGET");  
        int nMaxEnhancement = GetLocalInt(oPC, "ArmorEnh_MaxEnh");  
        int nMaxCost = GetLocalInt(oPC, "ArmorEnh_MaxCost");  
        string sLocalVar = GetLocalString(oPC, "ArmorEnh_LocalVar");  
        int nSpellID = GetLocalInt(oPC, "ArmorEnh_SpellID");  
        int nCasterLevel = GetLocalInt(oPC, "ArmorEnh_CasterLevel");  
          
        HandleConversation(oPC, oArmor, nMaxEnhancement, nMaxCost, sLocalVar, nSpellID, nCasterLevel);  
        return;  
    }  
      
    // Normal spell execution  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
    if (!X2PreSpellCastCode()) return;  
      
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    int nSpellID = PRCGetSpellId();  
      
    // Declare variables  
    int nGoldCost, nMaxEnhancement, nMaxCost;  
    string sLocalVar;  
      
    // Set parameters based on spell level  
    switch(nSpellID)  
    {  
        case ARMOR_ENH_LESS:  
            nGoldCost = 10;  
            nMaxEnhancement = 1;  
            nMaxCost = 5000;  
            sLocalVar = "ARMOR_ENH_LESS_PROPERTY";  
            break;  
        case ARMOR_ENH:  
            nGoldCost = 50;  
            nMaxEnhancement = 3;  
            nMaxCost = 35000;  
            sLocalVar = "ARMOR_ENH_PROPERTY";  
            break;  
        case ARMOR_ENH_GREATER:  
            nGoldCost = 100;  
            nMaxEnhancement = 5;  
            nMaxCost = 100000;  
            sLocalVar = "ARMOR_ENH_GREATER_PROPERTY";  
            break;  
        default:  
            // Default to lesser version for testing  
            nGoldCost = 10;  
            nMaxEnhancement = 1;  
            nMaxCost = 5000;  
            sLocalVar = "ARMOR_ENH_LESS_PROPERTY";  
            break;  
    }  
      
    // Check material component  
    if(GetGold(oCaster) < nGoldCost)  
    {  
        FloatingTextStringOnCreature("You need " + IntToString(nGoldCost) + "gp worth of rare spices and minerals.", oCaster, FALSE);  
        return;  
    }  
      
    // Get targeted armor or shield  
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);  
    if(!GetIsObjectValid(oArmor))  
    {  
        FloatingTextStrRefOnCreature(83826, oCaster, FALSE); // "Invalid target"  
        return;  
    }  
      
    // Check if item already has an infusion  
    itemproperty ipExisting = GetFirstItemProperty(oArmor);  
    while(GetIsItemPropertyValid(ipExisting))  
    {  
        if(GetItemPropertyTag(ipExisting) == "ArmorEnhInfusion")  
        {  
            FloatingTextStringOnCreature("This armor already has an armor enhancement infusion.", oCaster, FALSE);  
            return;  
        }  
        ipExisting = GetNextItemProperty(oArmor);  
    }  
      
    // Check if returning from conversation with a selection  
    int nPropertyLine = GetLocalInt(oCaster, sLocalVar);  
    if(nPropertyLine > 0)  
    {  
        // Apply the property  
        float fDuration = TurnsToSeconds(nCasterLevel * 10);  
        int nMetaMagic = PRCGetMetaMagicFeat();  
        if(nMetaMagic & METAMAGIC_EXTEND)  
            fDuration *= 2;  
  
        if (fDuration <= 1.0) fDuration = 30.0f;  
          
        // Create property directly  
        itemproperty ip;  
        if(nPropertyLine == 0)  
        {  
            // +1 Enhancement  
            ip = ConstructIP(ITEM_PROPERTY_AC_BONUS, 0, 1, 0);  
        }  
        else  
        {  
            // Read property data from 2DA and construct  
            string sIPData = Get2DACache("craft_armour", "IP1", nPropertyLine);  
            struct ipstruct iptemp = GetIpStructFromString(sIPData);  
            ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);  
        }  
          
        // Apply with proper duration  
        ip = TagItemProperty(ip, "ArmorEnhInfusion");  
        IPSafeAddItemProperty(oArmor, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
          
        DeleteLocalInt(oCaster, sLocalVar);  
        return;  
    }  
      
    // Store parameters for conversation and start it  
    SetLocalInt(oPC, "ArmorEnh_ConvMode", 1);  
    SetLocalObject(oPC, "ARMOR_ENH_TARGET", oArmor);  
    SetLocalInt(oPC, "ArmorEnh_MaxEnh", nMaxEnhancement);  
    SetLocalInt(oPC, "ArmorEnh_MaxCost", nMaxCost);  
    SetLocalString(oPC, "ArmorEnh_LocalVar", sLocalVar);  
    SetLocalInt(oPC, "ArmorEnh_SpellID", nSpellID);  
    SetLocalInt(oPC, "ArmorEnh_CasterLevel", nCasterLevel);  
      
    // Start the dynamic conversation using this same script  
    StartDynamicConversation("inf_armor_enh", oPC, 0, FALSE, TRUE);  
}

   */