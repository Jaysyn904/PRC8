//::///////////////////////////////////////////////
//:: [Verdant Lord setup script]
//:: [prc_verdantlord.nss]
//:: [Jaysyn 2025-08-15 12:39:28]
//::///////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
//:: Declare major variables
	object oPC 		= OBJECT_SELF;
	object oSkin	= GetPCSkin(oPC);
	
	int nVerdant 	= GetLevelByClass(CLASS_TYPE_VERDANT_LORD, oPC);
	
	effect eEffect;
	
	itemproperty ipIP;

//:: Setup Gaea’s Embrace ///////////////////////////////////////////////////////////////
	/* Gaea’s Embrace: At 10th level, the verdant lord permanently becomes a plant 
	creature, though all forms of wild shape that the character could previously 
	use remain available to him. His type changes to plant, and as a result he 
	gains low-light vision, is immune to poison, sleep, paralysis, stunning, and 
	polymorphing, and is not subject to critical hits or mind-influencing effects 
	(charms, compulsions, phantasms, patterns, or morale effects). He no longer 
	suffers penalties for aging and cannot be magically aged. Any aging penalties 
	he may already have suffered, however, remain in place. Bonuses still accrue, 
	and the verdant lord still dies of old age when his time is up. */
//::///////////////////////////////////////////////////////////////////////////////	
	if (nVerdant >= 10)
		{
			effect eNoStun = EffectImmunity(IMMUNITY_TYPE_STUN);
			eNoStun = SupernaturalEffect(eNoStun);
			eNoStun = ExtraordinaryEffect(eNoStun);
			DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoStun, oPC));
		
		//:: Plant Immunities
 			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			
			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		}	
	
} //:: End