//::///////////////////////////////////////////////
//:: [Forest Master setup script]
//:: [prc_forestmaster.nss]
//:: [Jaysyn 20230106]
//::///////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
//:: Declare major variables
	object oPC 		= OBJECT_SELF;
	object oSkin	= GetPCSkin(oPC);
	object oItem	= GetPCItemLastUnequipped();
	
	int nFMLevel 	= GetLevelByClass(CLASS_TYPE_FORESTMASTER, oPC);
	int nEvent 		= GetRunningEvent();
	
	effect eEffect;
	
	itemproperty ipIP;
	
	
//:: We aren't being called from onPlayerUnequipItem event, instead from the PRCEvalFeats
	if(nEvent == FALSE)
	{	
	// :: Hook in the events
		if(DEBUG) DoDebug("Forest Master: Adding eventhooks");
		AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_forestmaster", TRUE, FALSE);
	}

//:: We're being called from the onPlayerUnequipItem eventhook, so check or skip
	if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
	{
	//:: Remove Great Mallet damage bonuses from maul being unequipped		
		int bHadMaul = (GetBaseItemType(oItem) == BASE_ITEM_MAUL);
		
		if(bHadMaul)
		{

		//:: Remove the Cleave or Great Cleave bonus feat from the maul being unequipped
			IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_TEMPORARY, IP_CONST_FEAT_GREAT_CLEAVE);				
			IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_TEMPORARY, IP_CONST_FEAT_CLEAVE);			
				
		//:: Remove Great Mallet damage bonuses from maul being unequipped
			IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, IP_CONST_DAMAGETYPE_ELECTRICAL);
			IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, IP_CONST_DAMAGETYPE_COLD);
			IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS, DURATION_TYPE_TEMPORARY);
		}
		
	}
//:: End if - Running OnPlayerUnequipItem event
	
	
//:: Setup Oak Strength ////////////////////////////////////////////////////////
	/* Oak Strength (Ex): Beginning at 4th level, the forest master gains a +2 
	bonus to Strength and the ability to make slam attacks. A Small creature’s 
	slam attack deals 1d4 points of damage, one from a Medium-size creature 
	deals 1d6 points of damage, and a Large forest master’s slam attack deals 
	1d8 points of damage. Slam attacks are natural weapon attacks and do not 
	provoke an attack of opportunity from the defender. A forest master can 
	select Improved Critical (slam), Weapon Focus (slam), and (if a fighter of 
	4th level or higher) Weapon Specialization (slam).  Upon gaining this 
	ability, the forest master’s hair takes on a green, leafy appearance. */
//::////////////////////////////////////////////////////////////////////////////	
	if (nFMLevel >= 4)
	{
        string sResRef;
		int nHair;
		int nHairSet = GetLocalInt(oPC, "FM_HAIR_INT");
        int nSize = PRCGetCreatureSize(oPC)+1;
        //primary weapon
        sResRef = "prc_warf_slam_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
		
		if (!nHairSet)
		{
			switch (Random(6))
			{
				case 0: {nHair = 30; 	break;}
				case 1: {nHair = 31; 	break;}
				case 2: {nHair = 49 ;	break;}
				case 3: {nHair = 106; 	break;}
				case 4: {nHair = 107; 	break;}
				case 5: {nHair = 152; 	break;}
				case 6: {nHair = 153; 	break;}		
			}
		
			SetColor(oPC, COLOR_CHANNEL_HAIR, nHair);
			SetLocalInt(oPC, "FM_HAIR_INT", nHair);
		}
    }

//:: Setup Oakheart ///////////////////////////////////////////////////////////////
	/* Oakheart (Ex): Upon reaching 7th level, a forest master’s body becomes a 
	thing of wood and leaf rather than meat and bone. His type changes to plant.
	As 	such, he is immune to mind-affecting effects, poison, sleep, paralysis, 
	stunning, and polymorphing. He is not subject to critical hits or sneak 
	attacks.  However, the forest master becomes vulnerable to fire, and suffers
	double damage from fire attacks if he fails a Reflex saving throw, or half 
	damage if he succeeds. */
//::///////////////////////////////////////////////////////////////////////////////	
	if (nFMLevel >= 7)
		{
			effect eNoStun = EffectImmunity(IMMUNITY_TYPE_STUN);
			eNoStun = SupernaturalEffect(eNoStun);
			eNoStun = ExtraordinaryEffect(eNoStun);
			DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoStun, oPC));
		
		//:: These are handled via cls_feat_formast.2da
/* 			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); */
			
			ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyDamageVulnerability(DAMAGE_TYPE_FIRE, IP_CONST_DAMAGEVULNERABILITY_50_PERCENT);
			IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		}	
	
} //:: End