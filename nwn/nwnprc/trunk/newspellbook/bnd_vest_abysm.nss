/*
25/03/21 by Stratovarius

Abysm, the Schismed
    
Abysm, the Schismed, is a living vestige of a psionic mythal. As a vestige, Abysm gives its host access to several psionic effects.
  
Vestige Level: 8th
Binding DC: 34
Special Requirement: No
  
Influence: Your speech pattern becomes disconnected, as if many voices are trying to speak through you. Your mannerisms also change from moment to moment: masculine to feminine, regal to shy, and confident to passive. Abysm requires that the binder not use a psicrystal for the duration of the binding.
  
Granted Abilities: 
While bound to Abysm, you gain powers that various city inhabitants had at some point in their lifetimes.

Psionic Boon: You gain 21 power points when you bind to Abysm. These are added to your pool of power if you already possess psionic power, or they create a pool and you become a psionic creature for the duration of this binding.

Overpower: You gain access to the psionic powers animal affinity, energy missile, clairvoyant sense, and astral construct for the duration of the binding. You may manifest each power as a psion.
*/

#include "bnd_inc_bndfunc"
#include "psi_inc_psifunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_TIMELESS_BODY), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ABYSM_PSIONIC_BOON)) 
    {
    	GainPowerPoints(oBinder, 21, TRUE);
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_PSIONIC_FOCUS),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ABYSM_OVERPOWER   )) 
	{
		// Psion animal affinity, energy missile, clairvoyant sense, and astral construct
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12098),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12119),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12105),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12051),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		SetLocalInt(oBinder, "AbysmPsion", GetBinderLevel(oBinder, VESTIGE_ABYSM));
	}	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));     
}