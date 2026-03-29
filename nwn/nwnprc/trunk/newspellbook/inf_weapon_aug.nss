// inf_weapon_aug.nss    
/* 
Weapon Augmentation, Personal
Transmutation
Level: Artificer 1
Components: S, M
Casting Time: 1 minute
Range: Touch
Target: Weapon touched
Duration: 10 min./level
Saving Throw: None (object)
Spell Resistance: No (object)

The weapon you touch temporarily gains a special ability commonly 
found on magic weapons. You can choose any special ability whose 
market price is equivalent to a +1 bonus or up to 10,000 gp, such as 
flaming or keen. The weapon does not have to have an existing 
enhancement bonus, nor does it gain one when you imbue it with this 
infusion. The weapon gains the benefit of the infusion only if you 
wield, throw, or fire it.

Material Component: A patch of rabbit's fur.

Weapon Augmentation, Lesser
Transmutation
Level: Artificer 2
Duration: 10 min./level

Target: One weapon or fifty projectiles, all of which must be in 
contact with each other at the time of casting As personal weapon 
augmentation, but any character can wield the weapon you augment.
Alternatively, you can affect as many as fifty arrows, bolts, or 
bullets. The projectiles must be of the same kind, and they have to be
together (in the same quiver or other container). Projectiles, but 
not thrown weapons, lose their transmutation when used. (Treat 
shuriken as projectiles rather than thrown weapons for the purpose of 
this spell.)

Material Component: An ointment made from rare spices and minerals, costing 20 gp.


   
Weapon Augmentation
Transmutation
Level: Artificer 4

As lesser weapon augmentation, but you can choose any special ability 
whose market price is equivalent to a bonus of up to +3 or up to 
70,000 gp, such as speed.

Material Component: An ointment costing 100 gp.

*/
#include "inc_debug"        
#include "prc_craft_inc"      
#include "inc_dynconv"    
    
// Placeholder magic numbers for spell IDs   
const int WEAPON_AUG_PER 	= 6001;    
const int WEAPON_AUG_LESS 	= 6002;    
const int WEAPON_AUG 		= 6003;   
const int WEAPON_AUG_GREATER = 6004;   
  
// Define constants (these are standard in the crafting system)  
const int CHOICE_BACK = -1;  
  
// Dynamic conversation stages    
const int STAGE_PROPERTY_SELECTION = 0;    
const int STAGE_BANE = 1;  // Match crafting system naming  
const int STAGE_CONFIRMATION = 2;    
 
// Helper functions for sorted lists  
void AddToTempList(object oPC, string sChoice, int nChoice)  
{  
    // Simple implementation - just add directly  
    AddChoice(sChoice, nChoice, oPC);  
}  
  
void TransferTempList(object oPC)  
{  
    // No-op for simple implementation  
}
 
//Adds names to a list based on sTable (2da), delayed recursion to avoid TMI  
void PopulateList(object oPC, int MaxValue, int bSort, string sTable, int i = 0)  
{  
    if(GetLocalInt(oPC, "DynConv_Waiting") == FALSE)  
        return;  
          
    if(i <= MaxValue)  
    {  
        string sTemp = Get2DACache(sTable, "Name", i);  
        if(sTemp != "")  
        {  
            if(bSort)     
                AddToTempList(oPC, ActionString(GetStringByStrRef(StringToInt(sTemp))), i);  
            else          
                AddChoice(ActionString(GetStringByStrRef(StringToInt(sTemp))), i, oPC);  
        }  
          
        if(!(i % 100) && i) //i != 0, i % 100 == 0  
            FloatingTextStringOnCreature("*Tick*", oPC, FALSE);  
    }  
    else  
    {  
        if(bSort) TransferTempList(oPC);  
        DeleteLocalInt(oPC, "DynConv_Waiting");  
        FloatingTextStringOnCreature("*Done*", oPC, FALSE);  
        return;  
    }  
    DelayCommand(0.01, PopulateList(oPC, MaxValue, bSort, sTable, i + 1));  
}  
  

  
void HandleConversation(object oPC, object oWeapon, int nMaxEnhancement, int nMaxCost, string sLocalVar, int nSpellID, int nCasterLevel)    
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
                SetHeader("Select a weapon augmentation:");    
                    
                // Initialize default tokens BEFORE adding choices    
                SetDefaultTokens();    
                     
                int nFileEnd = PRCGetFileEnd("craft_weapon");    
                int nChoice = 1;    
                int i;    
                    
                for(i = 0; i <= nFileEnd; i++)    
                {    
                    // Get enhancement and cost for this specific line    
                    int nEnhancement = StringToInt(Get2DACache("craft_weapon", "Enhancement", i));    
                    int nAdditionalCost = StringToInt(Get2DACache("craft_weapon", "AdditionalCost", i));    
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_weapon", "Name", i)));    
                        
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
            else if(nStage == STAGE_BANE)    
            {    
                // Exact copy from crafting system  
                SetHeader("Select a racial type.");  
                AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);  
                AddChoice(ActionString("Back"), CHOICE_BACK, oPC);  
                SetLocalInt(oPC, "DynConv_Waiting", TRUE);  
                PopulateList(oPC, PRCGetFileEnd("racialtypes"), TRUE, "racialtypes");  
                MarkStageSetUp(nStage);  
            }    
            else if(nStage == STAGE_CONFIRMATION)    
            {    
                int nPropertyLine = GetLocalInt(oPC, "WeaponAug_SelectedProperty");    
                string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_weapon", "Name", nPropertyLine)));    
                    
                SetHeader("Apply " + sName + " to the weapon?");    
                    
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
        DeleteLocalInt(oPC, "WeaponAug_ConvMode");    
        DeleteLocalObject(oPC, "WEAPON_AUG_TARGET");    
        DeleteLocalInt(oPC, "WeaponAug_SelectedProperty");    
        DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE);    
    }    
    else if(nValue == DYNCONV_ABORTED)    
    {    
        // Cleanup    
        DeleteLocalInt(oPC, "WeaponAug_ConvMode");    
        DeleteLocalObject(oPC, "WEAPON_AUG_TARGET");    
        DeleteLocalInt(oPC, "WeaponAug_SelectedProperty");    
        DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE);    
    }    
    else    
    {    
        int nChoice = GetChoice(oPC);    
            
        if(nStage == STAGE_PROPERTY_SELECTION)    
        {    
            // Store selection and check if Bane/Dread    
            SetLocalInt(oPC, "WeaponAug_SelectedProperty", nChoice);    
            if(nChoice == 26 || nChoice == 27) // Bane or Dread    
            {    
                nStage = STAGE_BANE;    
            }    
            else    
            {    
                nStage = STAGE_CONFIRMATION;    
            }    
            MarkStageNotSetUp(STAGE_PROPERTY_SELECTION, oPC);    
        }    
        else if(nStage == STAGE_BANE)    
        {    
            // Exact copy from crafting system logic  
            if(nChoice == CHOICE_BACK)  
                nStage = STAGE_PROPERTY_SELECTION;  
            else  
            {  
                nStage = STAGE_CONFIRMATION;  
                SetLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE, nChoice);  
            }  
            MarkStageNotSetUp(nStage, oPC);  
        }    
        else if(nStage == STAGE_CONFIRMATION)    
        {    
            if(nChoice == TRUE) // User confirmed    
            {    
                // Apply the property    
                object oWeapon = GetLocalObject(oPC, "WEAPON_AUG_TARGET");    
                int nPropertyLine = GetLocalInt(oPC, "WeaponAug_SelectedProperty");    
                int nCasterLevel = GetLocalInt(oPC, "WeaponAug_CasterLevel");    
                    
				float fDuration = TurnsToSeconds(nCasterLevel * 10);      
				int nMetaMagic = PRCGetMetaMagicFeat();      
				if(nMetaMagic & METAMAGIC_EXTEND)      
					fDuration *= 2;      
				    
				// Debug output      
				SendMessageToPC(oPC, "Duration: " + FloatToString(fDuration) + " seconds");    
				    
				// Add fallback for very small durations      
				if (fDuration <= 1.0) fDuration = 30.0f;  
				  
				SendMessageToPC(oPC, "Fallback Duration: " + FloatToString(fDuration) + " seconds");   
                    
                // Create property with special handling for Bane/Dread    
                itemproperty ip;    
                if(nPropertyLine == 26 || nPropertyLine == 27) // Bane or Dread    
                {    
                    // Use the special handling function from the crafting system    
                    ip = PropSpecialHandling(oWeapon, "craft_weapon", nPropertyLine, 1);    
                }    
                else    
                {    
                    // Standard property construction    
                    string sIPData = Get2DACache("craft_weapon", "IP1", nPropertyLine);    
                    struct ipstruct iptemp = GetIpStructFromString(sIPData);    
                    ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);    
                }    
                    
                // Apply with proper duration    
                ip = TagItemProperty(ip, "WeaponAugInfusion");    
                IPSafeAddItemProperty(oWeapon, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);    
                    
                // Clean up and exit    
                DeleteLocalInt(oPC, "WeaponAug_ConvMode");    
                DeleteLocalObject(oPC, "WEAPON_AUG_TARGET");    
                DeleteLocalInt(oPC, "WeaponAug_SelectedProperty");    
                DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE);    
                    
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);    
            }    
            else // User cancelled    
            {    
                // Go back to property selection or BANE stage    
                if(GetLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE))  
                {  
                    nStage = STAGE_BANE;  
                    DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE);  
                }  
                else  
                {  
                    nStage = STAGE_PROPERTY_SELECTION;  
                }  
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
    if(GetLocalInt(oPC, "WeaponAug_ConvMode"))  
    {  
        // Retrieve parameters for conversation  
        object oWeapon = GetLocalObject(oPC, "WEAPON_AUG_TARGET");  
        int nMaxEnhancement = GetLocalInt(oPC, "WeaponAug_MaxEnh");  
        int nMaxCost = GetLocalInt(oPC, "WeaponAug_MaxCost");  
        string sLocalVar = GetLocalString(oPC, "WeaponAug_LocalVar");  
        int nSpellID = GetLocalInt(oPC, "WeaponAug_SpellID");  
        int nCasterLevel = GetLocalInt(oPC, "WeaponAug_CasterLevel");  
          
        HandleConversation(oPC, oWeapon, nMaxEnhancement, nMaxCost, sLocalVar, nSpellID, nCasterLevel);  
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
        case WEAPON_AUG_PER:  
            nGoldCost = 0;  
            nMaxEnhancement = 1;  
            nMaxCost = 10000;  
            sLocalVar = "WEAPON_AUG_PER_PROPERTY";  
            break;  
        case WEAPON_AUG_LESS:  
            nGoldCost = 20;  
            nMaxEnhancement = 1;  
            nMaxCost = 10000;  
            sLocalVar = "WEAPON_AUG_LESS_PROPERTY";  
            break;  
        case WEAPON_AUG:  
            nGoldCost = 100;  
            nMaxEnhancement = 3;  
            nMaxCost = 70000;  
            sLocalVar = "WEAPON_AUG_PROPERTY";  
            break;
        case WEAPON_AUG_GREATER:  
            nGoldCost = 200;  
            nMaxEnhancement = 5;  
            nMaxCost = 200000;  
            sLocalVar = "WEAPON_AUG_GREATER_PROPERTY";  
            break;			
        default:  
            // Default to lesser version for testing  
            nGoldCost = 20;  
            nMaxEnhancement = 1;  
            nMaxCost = 10000;  
            sLocalVar = "WEAPON_AUG_LESS_PROPERTY";  
            break;  
    }  
      
    // Check material component  
    if(GetGold(oCaster) < nGoldCost)  
    {  
        FloatingTextStringOnCreature("You need " + IntToString(nGoldCost) + "gp worth of rare ointments.", oCaster, FALSE);  
        return;  
    }  
      
    // Get targeted weapon 
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	//object oWeapon = IPGetTargetedOrEquippedArmor(TRUE);	<- don't delete
    if(!GetIsObjectValid(oWeapon))  
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
            
		// Read property data from 2DA and construct  
		string sIPData = Get2DACache("craft_weapon", "IP1", nPropertyLine);  
		struct ipstruct iptemp = GetIpStructFromString(sIPData);  
		itemproperty ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);  
         
          
        // Apply with proper duration  
        ip = TagItemProperty(ip, "WeaponAugInfusion");  
        IPSafeAddItemProperty(oWeapon, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
          
        DeleteLocalInt(oCaster, sLocalVar);  
        return;  
    }  
      
    // Store parameters for conversation and start it  
    SetLocalInt(oPC, "WeaponAug_ConvMode", 1);  
    SetLocalObject(oPC, "WEAPON_AUG_TARGET", oWeapon);  
    SetLocalInt(oPC, "WeaponAug_MaxEnh", nMaxEnhancement);  
    SetLocalInt(oPC, "WeaponAugh_MaxCost", nMaxCost);  
    SetLocalString(oPC, "WeaponAug_LocalVar", sLocalVar);  
    SetLocalInt(oPC, "WeaponAug_SpellID", nSpellID);  
    SetLocalInt(oPC, "WeaponAug_CasterLevel", nCasterLevel);  
      
    // Start the dynamic conversation using this same script  
    StartDynamicConversation("inf_weapon_aug", oPC, 0, FALSE, TRUE); 
}  
  
  
  
  
  
  
  
  
  
  
  
  
/* #include "inc_debug"      
#include "prc_craft_inc"    
#include "inc_dynconv"  
  
// Placeholder magic numbers for spell IDs 
const int WEAPON_AUG_PER 	= 6001;  
const int WEAPON_AUG_LESS 	= 6002;  
const int WEAPON_AUG 		= 6003; 
const int WEAPON_AUG_GREATER = 6004; 

  
// Dynamic conversation stages  
const int STAGE_PROPERTY_SELECTION = 0;  
const int STAGE_CONFIRMATION = 1;  


void HandleConversation(object oPC, object oWeapon, int nMaxEnhancement, int nMaxCost, string sLocalVar, int nSpellID, int nCasterLevel)  
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
                SetHeader("Select a weapon augmentation:");  
                  
                // Initialize default tokens BEFORE adding choices  
                SetDefaultTokens();  
                   
                int nFileEnd = PRCGetFileEnd("craft_weapon");  
                int nChoice = 1;  
                int i;  
                  
                for(i = 0; i <= nFileEnd; i++)  
                {  
                    // Get enhancement and cost for this specific line  
                    int nEnhancement = StringToInt(Get2DACache("craft_weapon", "Enhancement", i));  
                    int nAdditionalCost = StringToInt(Get2DACache("craft_weapon", "AdditionalCost", i));  
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_weapon", "Name", i)));  
                      
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
                int nPropertyLine = GetLocalInt(oPC, "WeaponAug_SelectedProperty");  
                string sName = GetStringByStrRef(StringToInt(Get2DACache("craft_weapon", "Name", nPropertyLine)));  
                  
                SetHeader("Apply " + sName + " to the weapon?");  
                  
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
        DeleteLocalInt(oPC, "WeaponAug_ConvMode");  
        DeleteLocalObject(oPC, "WEAPON_AUG_TARGET");  
        DeleteLocalInt(oPC, "WeaponAug_SelectedProperty");  
    }  
    else if(nValue == DYNCONV_ABORTED)  
    {  
        // Cleanup  
        DeleteLocalInt(oPC, "WeaponAug_ConvMode");  
        DeleteLocalObject(oPC, "WEAPON_AUG_TARGET");  
        DeleteLocalInt(oPC, "WeaponAug_SelectedProperty");  
    }  
    else  
    {  
        int nChoice = GetChoice(oPC);  
          
        if(nStage == STAGE_PROPERTY_SELECTION)  
        {  
            // Store selection and go to confirmation  
            SetLocalInt(oPC, "WeaponAug_SelectedProperty", nChoice);  
            nStage = STAGE_CONFIRMATION;  
            MarkStageNotSetUp(STAGE_PROPERTY_SELECTION, oPC);  
        }  
        else if(nStage == STAGE_CONFIRMATION)  
        {  
            if(nChoice == TRUE) // User confirmed  
            {  
                // Apply the property  
                object oWeapon = GetLocalObject(oPC, "WEAPON_AUG_TARGET");  
                int nPropertyLine = GetLocalInt(oPC, "WeaponAug_SelectedProperty");  
                int nCasterLevel = GetLocalInt(oPC, "WeaponAug_CasterLevel");  
                  
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
				// Read property data from 2DA and construct  
				string sIPData = Get2DACache("craft_weapon", "IP1", nPropertyLine);  
				struct ipstruct iptemp = GetIpStructFromString(sIPData);  
				ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);  
                  
                // Apply with proper duration  
                ip = TagItemProperty(ip, "WeaponAugInfusion");  
                IPSafeAddItemProperty(oWeapon, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
                  
                // Clean up and exit  
                DeleteLocalInt(oPC, "WeaponAug_ConvMode");  
                DeleteLocalObject(oPC, "WEAPON_AUG_TARGET");  
                DeleteLocalInt(oPC, "WeaponAug_SelectedProperty");  
                  
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
    if(GetLocalInt(oPC, "WeaponAug_ConvMode"))  
    {  
        // Retrieve parameters for conversation  
        object oWeapon = GetLocalObject(oPC, "WEAPON_AUG_TARGET");  
        int nMaxEnhancement = GetLocalInt(oPC, "WeaponAug_MaxEnh");  
        int nMaxCost = GetLocalInt(oPC, "WeaponAug_MaxCost");  
        string sLocalVar = GetLocalString(oPC, "WeaponAug_LocalVar");  
        int nSpellID = GetLocalInt(oPC, "WeaponAug_SpellID");  
        int nCasterLevel = GetLocalInt(oPC, "WeaponAug_CasterLevel");  
          
        HandleConversation(oPC, oWeapon, nMaxEnhancement, nMaxCost, sLocalVar, nSpellID, nCasterLevel);  
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
        case WEAPON_AUG_PER:  
            nGoldCost = 0;  
            nMaxEnhancement = 1;  
            nMaxCost = 10000;  
            sLocalVar = "WEAPON_AUG_PER_PROPERTY";  
            break;  
        case WEAPON_AUG_LESS:  
            nGoldCost = 20;  
            nMaxEnhancement = 1;  
            nMaxCost = 10000;  
            sLocalVar = "WEAPON_AUG_LESS_PROPERTY";  
            break;  
        case WEAPON_AUG:  
            nGoldCost = 100;  
            nMaxEnhancement = 3;  
            nMaxCost = 70000;  
            sLocalVar = "WEAPON_AUG_PROPERTY";  
            break;
        case WEAPON_AUG_GREATER:  
            nGoldCost = 200;  
            nMaxEnhancement = 5;  
            nMaxCost = 200000;  
            sLocalVar = "WEAPON_AUG_GREATER_PROPERTY";  
            break;			
        default:  
            // Default to lesser version for testing  
            nGoldCost = 20;  
            nMaxEnhancement = 1;  
            nMaxCost = 10000;  
            sLocalVar = "WEAPON_AUG_LESS_PROPERTY";  
            break;  
    }  
      
    // Check material component  
    if(GetGold(oCaster) < nGoldCost)  
    {  
        FloatingTextStringOnCreature("You need " + IntToString(nGoldCost) + "gp worth of rare ointments.", oCaster, FALSE);  
        return;  
    }  
      
    // Get targeted weapon 
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	//object oWeapon = IPGetTargetedOrEquippedArmor(TRUE);	<- don't delete
    if(!GetIsObjectValid(oWeapon))  
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
            
		// Read property data from 2DA and construct  
		string sIPData = Get2DACache("craft_weapon", "IP1", nPropertyLine);  
		struct ipstruct iptemp = GetIpStructFromString(sIPData);  
		itemproperty ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);  
         
          
        // Apply with proper duration  
        ip = TagItemProperty(ip, "WeaponAugInfusion");  
        IPSafeAddItemProperty(oWeapon, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
          
        DeleteLocalInt(oCaster, sLocalVar);  
        return;  
    }  
      
    // Store parameters for conversation and start it  
    SetLocalInt(oPC, "WeaponAug_ConvMode", 1);  
    SetLocalObject(oPC, "WEAPON_AUG_TARGET", oWeapon);  
    SetLocalInt(oPC, "WeaponAug_MaxEnh", nMaxEnhancement);  
    SetLocalInt(oPC, "WeaponAugh_MaxCost", nMaxCost);  
    SetLocalString(oPC, "WeaponAug_LocalVar", sLocalVar);  
    SetLocalInt(oPC, "WeaponAug_SpellID", nSpellID);  
    SetLocalInt(oPC, "WeaponAug_CasterLevel", nCasterLevel);  
      
    // Start the dynamic conversation using this same script  
    StartDynamicConversation("inf_weapon_aug", oPC, 0, FALSE, TRUE);  
} */