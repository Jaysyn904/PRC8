#include "moi_inc_moifunc" 

itemproperty SapphireDR(int nClass)
{
	itemproperty iDR;
	if (nClass >= 30) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_10_HP);
	else if (nClass >= 27) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_9_HP);
	else if (nClass >= 24) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_8_HP);
	else if (nClass >= 21) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_7_HP);
	else if (nClass >= 18) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_6_HP);
	else if (nClass >= 15) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_5_HP);
	else if (nClass >= 12) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_4_HP);
	else if (nClass >= 9) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_3_HP);
	else if (nClass >= 6) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_2_HP);
	else if (nClass >= 3) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_1_HP);
	
	return iDR;
}

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oSkin = GetPCSkin(oMeldshaper);
	int nClass = GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oMeldshaper);
   	if (nClass >= 3) IPSafeAddItemProperty(oSkin, SapphireDR(nClass), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}
