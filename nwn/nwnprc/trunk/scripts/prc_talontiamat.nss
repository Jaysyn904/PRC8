//::///////////////////////////////////////////////
//:: Talon of Tiamat
//:: prc_talontiamat.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Talons of Tiamat
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 22, 2007
//:://////////////////////////////////////////////


#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int nClass = GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oPC);
	
	//Keen senses: Low light at 4, Darkvision at 8
	if(nClass > 3)
	    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	if(nClass > 7)
	    IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	    
	//Voice of the Dragon
	switch(nClass)
	{
	    case 2:
	    case 3:
	    case 4:
	    case 5:
	        SetCompositeBonus(oSkin, "ToT_Bluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
                SetCompositeBonus(oSkin, "ToT_Intim", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE); break;
	    case 6:
	    case 7:
	    case 8:
	    case 9:
	        SetCompositeBonus(oSkin, "ToT_Bluff", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
                SetCompositeBonus(oSkin, "ToT_Intim", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE); break;
	    case 10:
	        SetCompositeBonus(oSkin, "ToT_Bluff", 6, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
                SetCompositeBonus(oSkin, "ToT_Intim", 6, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE); break;
	    default: break;
	}
	
	//Immunities
	if(GetHasFeat(FEAT_TOT_FIRE_IMMUNITY, oPC))
        { 
            IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	else if(GetHasFeat(FEAT_TOT_COLD_IMMUNITY, oPC))
        { 
            IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	else if(GetHasFeat(FEAT_TOT_ACID_IMMUNITY, oPC))
        { 
            IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	else if(GetHasFeat(FEAT_TOT_ELEC_IMMUNITY, oPC))
        { 
            IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
}
