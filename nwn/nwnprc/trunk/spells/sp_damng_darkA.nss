//::///////////////////////////////////////////////
//:: Name      Damning Darkness
//:: FileName  sp_damng_darka.nss
//:://////////////////////////////////////////////
/**@file Damning Darkness
Evocation [Darkness, Evil]
Level: Clr 4, Darkness 4, Sor/Wiz 4
Components: V, M/DF
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
Created:   6/12/06

Fixed by: Jaysyn
Date: 2026-05-26 19:53:19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_spells"

void DarkLoop(object oTarget, object oPC, int nMetaMagic); 
  
  
void main()  
{  
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);  
      
    int nMetaMagic = PRCGetMetaMagicFeat();  
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);  
    effect eDark = EffectDarkness();  
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);  
	  
    effect eLink = EffectLinkEffects(eDark, eDur);  
	eLink = TagEffect(eLink, "BIO_DARKNESS");  
	  
    effect eLink2 =  EffectLinkEffects(eInvis, eDur);  
	eLink2 = TagEffect(eLink2, "PNP_DARKNESS");  
  
    effect ePnP = EffectLinkEffects(eDur, EffectDarkness());  
    if(GetPRCSwitch(PRC_PNP_DARKNESS_35ED))  
    {  
		ePnP = EffectLinkEffects(eDur, EffectConcealment(20));  
		ePnP = TagEffect(ePnP, "PNP35_DARKNESS");  
	}	  
  
    object oPC = GetAreaOfEffectCreator();  
  
    object oTarget = GetEnteringObject();  
    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oTarget);  
  
	if (iShadow)    
	{      
		ePnP = ShadowlordEffects(iShadow, ePnP);  
		eLink = ShadowlordEffects(iShadow, eLink);  
		eLink2 = ShadowlordEffects(iShadow, eLink2);
		ePnP = TagEffect(ePnP, "SHADOWSIGHT+BLUR");  
		eLink = TagEffect(eLink, "SHADOWSIGHT+BLUR");  
		eLink2 = TagEffect(eLink2, "SHADOWSIGHT+BLUR");		
	}  
  
    int nDuration = PRCGetCasterLevel(oPC);  
    if ((nMetaMagic & METAMAGIC_EXTEND))  
    {  
        nDuration = nDuration *2;  
    }  
      
    if(GetIsObjectValid(oTarget) && oTarget != oPC)  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))  
        {  
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DAMNING_DARKNESS));  
        }  
        else  
        {  
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DAMNING_DARKNESS, FALSE));  
        }  
          
        if (iShadow)  
          SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget,0.0f,FALSE);  
        else    
        {  
            if(GetPRCSwitch(PRC_PNP_DARKNESS))  
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePnP, oTarget,0.0f,FALSE);  
            else  
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);  
        }    
    }  
    else if (oTarget == oPC)  
    {  
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DAMNING_DARKNESS, FALSE));  
        if(GetPRCSwitch(PRC_PNP_DARKNESS))  
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePnP, oTarget,0.0f,FALSE);  
        else  
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget,0.0f,FALSE);  
    }  
  
    // Set local variable to mark target as in AOE for damage tracking  
    SetLocalInt(oTarget, "PRC_DamningDarkness_InAOE", TRUE);  
      
    // Start damage loop  
    DarkLoop(oTarget, oPC, nMetaMagic);   
      
    PRCSetSchool();  
}  
  
void DarkLoop(object oTarget, object oPC, int nMetaMagic)    
{       
    // Check if target is still marked as being in the AOE    
    if(GetIsObjectValid(oTarget) && GetLocalInt(oTarget, "PRC_DamningDarkness_InAOE"))    
    {           
        if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)    
        {    
        	int nDam = PRCMaximizeOrEmpower(6, 2, nMetaMagic) + SpellDamagePerDice(oPC, 2);    
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE), oTarget);    
        }    
            
        else if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)    
        {    
        	int nDam = PRCMaximizeOrEmpower(6, 1, nMetaMagic) + SpellDamagePerDice(oPC, 1);    
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE), oTarget);    
        }    
            
        else    
        {    
            // Evil creatures take no damage    
        }    
                
    }    
    DelayCommand(6.0f, DarkLoop(oTarget, oPC, nMetaMagic));    
}