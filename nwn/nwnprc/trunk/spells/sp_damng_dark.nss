//::///////////////////////////////////////////////
//:: Name      Damning Darkness
//:: FileName  sp_damng_dark.nss
//:://////////////////////////////////////////////
/**@file Damning Darkness
Evocation [Darkness, Evil]
Level: Clr 4, Darkness 4, Sor/Wiz 4
Components: V
Casting Time: 1 action
Range: Touch
Target: Object touched
Duration: 10 minutes/level (D)
Saving Throw: None
Spell Resistance: No 

This spell is similar to darkness, except that those
within the area of darkness also take unholy damage.
Creatures of good alignment take 2d6 points of 
damage per round in the darkness, and creatures
neither good nor evil take 1d6 points of damage. As 
with the darkness spell, the area of darkness is a 
20-foot radius, and the object that serves as the 
spell's target can be shrouded to block the darkness
(and thus the dam­aging effect).

Damning darkness counters or dispels any light spell 
of equal or lower level.

Arcane Material Component: A dollop of pitch with a 
tiny needle hidden inside it.

Author:    Tenjac
Created:  

Fixed by: Jaysyn
Date: 2026-05-26 19:53:19
 
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_inc_itmrstr"
#include "prc_add_spell_dc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel)  
{  
    //Declare major variables including Area of Effect Object  
    int iAttackRoll = 1;  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nPnP = GetPRCSwitch(PRC_PNP_DARKNESS);  
    float fDuration = nPnP ? TurnsToSeconds(nCasterLevel * 10) : RoundsToSeconds(nCasterLevel);//10min/level for PnP  
    effect eAOE = EffectAreaOfEffect(AOE_PER_DAMNDARK);  
  
    //Make sure duration does no equal 0  
    if(fDuration < 6.0f)  
        fDuration = 6.0f;  
  
    //Check Extend metamagic feat.  
    if(nMetaMagic & METAMAGIC_EXTEND)  
       fDuration *= 2;  
  
	int nShadow = PRCMax(GetLocalInt(oCaster, "ShadowMantle_Shoulder"), GetLocalInt(oTarget, "ShadowMantle_Shoulder"));  
	if (nShadow) nPnP = FALSE;  
	if (DEBUG) DoDebug("sp_damng_dark: oCaster "+GetName(oCaster)+" oTarget "+GetName(oTarget)+" nSwitch "+IntToString(nPnP));  
  
    if(!nPnP)  
    {  
        if (nShadow)  
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration);  
        else  
        	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, PRCGetSpellTargetLocation(), fDuration);  
  
        object oAoE = GetAreaOfEffectObject(PRCGetSpellTargetLocation(), "AOE_PER_DAMNDARK");  
        SetAllAoEInts(SPELL_DAMNING_DARKNESS, oAoE, PRCGetSpellSaveDC(SPELL_DAMNING_DARKNESS, SPELL_SCHOOL_EVOCATION), 0, nCasterLevel);  
    }  
    else        
    {        
        object oItemTarget = oTarget;        
          
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)          
        {   //touch attack roll if target creature is not an ally          
            if(!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))          
                iAttackRoll = PRCDoMeleeTouchAttack(oTarget);          
          
            if(iAttackRoll > 0)          
            {          
                oItemTarget = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);     
				if(DEBUG) DoDebug("Damning Darkness: Chest item = " + DebugObject2Str(oItemTarget));				    
                if(!GetIsObjectValid(oItemTarget))          
                {          
                    //no armor, check other slots          
                    int i;          
                    for(i=0;i<14;i++)          
                    {          
                        oItemTarget = GetItemInSlot(i, oTarget);          
                        if(GetIsObjectValid(oItemTarget))     
						{    
							if(DEBUG) DoDebug("Damning Darkness: Found item in slot " + IntToString(i));							    
                            break;//end for loop     
						}							    
                    }          
                }    
                    
                // Apply item property if valid item found    
                if(GetIsObjectValid(oItemTarget))    
                {    
                    if(DEBUG) DoDebug("Damning Darkness: Applying IP to " + DebugObject2Str(oItemTarget));     
                    itemproperty ipDarkness = ItemPropertyAreaOfEffect(IP_CONST_AOE_DAMNING_DARKNESS, nCasterLevel);          
                    IPSafeAddItemProperty(oItemTarget, ipDarkness, fDuration);          
                    if(DEBUG) DoDebug("Damning Darkness: IP applied");    
                    DelayCommand(0.1, VoidCheckPRCLimitations(oItemTarget, OBJECT_INVALID));    
                }    
                // Otherwise fall through to location-based AOE    
            }          
            else          
            {          
                // Touch attack failed - do nothing          
                return 0;          
            }          
        }       
        else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)                
        {                
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, PRCGetSpellTargetLocation(), fDuration);    
                
            object oAoE = GetAreaOfEffectObject(PRCGetSpellTargetLocation(), "AOE_PER_DAMNDARK");        
            SetAllAoEInts(SPELL_DAMNING_DARKNESS, oAoE, PRCGetSpellSaveDC(SPELL_DAMNING_DARKNESS, SPELL_SCHOOL_EVOCATION), 0, nCasterLevel);          
        }       
        // Ground casting or creatures with no equipment - location-based AOE        
        else if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || !GetIsObjectValid(oItemTarget))          
        {          
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, PRCGetSpellTargetLocation(), fDuration);          
          
            object oAoE = GetAreaOfEffectObject(PRCGetSpellTargetLocation(), "AOE_PER_DAMNDARK");          
            SetAllAoEInts(SPELL_DAMNING_DARKNESS, oAoE, PRCGetSpellSaveDC(SPELL_DAMNING_DARKNESS, SPELL_SCHOOL_EVOCATION), 0, nCasterLevel);          
        }      
        // Valid item found on creature - apply item property        
        else        
        {        
            if(DEBUG) DoDebug("Damning Darkness: Applying IP to " + DebugObject2Str(oItemTarget));   
			itemproperty ipDarkness = ItemPropertyAreaOfEffect(IP_CONST_AOE_DAMNING_DARKNESS, nCasterLevel);        
            IPSafeAddItemProperty(oItemTarget, ipDarkness, fDuration);        
            if(DEBUG) DoDebug("Damning Darkness: IP applied");  
			DelayCommand(0.1, VoidCheckPRCLimitations(oItemTarget, OBJECT_INVALID));        
        }        
    }  
  
    return iAttackRoll;    //return TRUE if spell charges should be decremented  
}  
  
void main()  
{  
    if(!X2PreSpellCastCode()) return;  
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);  
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags  
    if(!nEvent) //normal cast  
    {  
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)  
        {   //holding the charge, casting spell on self  
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges  
            return;  
        }  
        DoSpell(oCaster, oTarget, nCasterLevel);  
    }  
    else  
    {  
        if(nEvent & PRC_SPELL_EVENT_ATTACK)  
        {  
            if(DoSpell(oCaster, oTarget, nCasterLevel))  
                DecrementSpellCharges(oCaster);  
        }  
    }  
    PRCSetSchool();  
}