//::///////////////////////////////////////////////
//:: [Censure Daemons]
//:: [prc_s_censuredm.nss]
//:://////////////////////////////////////////////
//:: All allies in the area are immune to fear
//:: and other mind effects created by outsiders
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
     
     if(!GetHasSpellEffect(GetSpellId()))
     { 
	//Declare major variables including Area of Effect Object
    	effect eAOE = EffectAreaOfEffect(113);
    	effect eVis = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eGood = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    	effect eLink = EffectLinkEffects(eAOE, eVis);
    	eLink = EffectLinkEffects(eLink, eDur);
	
    	object oTarget = PRCGetSpellTargetObject();
	
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eGood, oTarget);
     	sMes = "*Courage of Heaven Activated*";
     }
     else     
     {
	// Removes effects
	PRCRemoveSpellEffects(GetSpellId(), oPC, oPC);
	sMes = "*Courage of Heaven Deactivated*";
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}
