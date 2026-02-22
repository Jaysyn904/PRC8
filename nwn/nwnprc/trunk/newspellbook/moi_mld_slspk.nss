/*
23/10/20 by Stratovarius

Soulspark Familiar

Descriptors: None
Classes: Incarnate, soulborn
Chakra: Brow, crown, or throat
Saving Throw: None

A spark of light hovers over your shoulder. While featureless, it seems to emote using its own brilliance, ranging from an angry burn to a contented glow.

You shape a small mote of soul energy called a least soulspark. The presence of the soulspark grants you the Alertness feat. If the soulspark is reduced to 0 or fewer hit points, the meld unshapes.

Essentia: When you allocate essentia to your soulspark familiar, you can select one of the following effects. All essentia invested must be put toward the same effect.

Attack Bonus: Every point of essentia grants the soulspark a +1 bonus on its attack rolls and damage rolls.
Deflection Bonus: Every point of essentia grants the soulspark a +1 deflection bonus to Armor Class.
Healing: Every point of essentia invested grants the soulspark a certain amount of fast healing. A least soulspark gains fast healing equal to 1 × the points of essentia invested, a lesser
soulspark gains fast healing equal to 2 × the points of essentia invested, a standard soulspark gains fast healing equal to 3 × the points of essentia invested, and a greater soulspark gains
fast healing equal to 4 × the points of essentia invested.
Saving Throw Bonus: Every point of essentia grants the soulspark a +1 resistance bonus on all saving throws.

Chakra Bind (Brow)
Your soulspark shimmers like the desert sky.
If you bind soulspark familiar to your brow chakra, you create a standard soulspark.

Chakra Bind (Crown)
Your soulspark glows sapphire blue, like a brilliant gemstone.
If you bind soulspark familiar to your crown chakra, you create a lesser soulspark.

Chakra Bind (Throat)
Your soulspark burns with a fierce blue-white light.
If you bind soulspark familiar to your throat chakra, you create a greater soulspark.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 15:53:41
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void AugmentSoulspark(object oMeldshaper, string sSummon, int nEssentia)
{
	effect eDR = EffectDamageReduction(1, DAMAGE_POWER_PLUS_THREE);
	effect eHeal = ExtraordinaryEffect(EffectRegenerate(nEssentia, 6.0));
   	if (sSummon == "moi_slspk_lesser") 
   	{	
   		eDR = EffectDamageReduction(3, DAMAGE_POWER_PLUS_THREE);
   		eHeal = ExtraordinaryEffect(EffectRegenerate(nEssentia * 2, 6.0));
   	}	
   	else if (sSummon == "moi_slspk_medium")
   	{	
   		eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_THREE);
   		eHeal = ExtraordinaryEffect(EffectRegenerate(nEssentia * 3, 6.0));
   	}   	
   	else if (sSummon == "moi_slspk_greatr") 
   	{	
   		eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
   		eHeal = ExtraordinaryEffect(EffectRegenerate(nEssentia * 4, 6.0));
   	}   	

    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMeldshaper);
    while(GetIsObjectValid(oSummon))
    {
        if(GetResRef(oSummon) == sSummon)
        {
         	SetLocalString(oSummon, "X2_SPECIAL_COMBAT_AI_SCRIPT", "moi_mld_slspkai");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oSummon);
            if (GetLocalInt(oMeldshaper, "SoulsparkEssentiaChoice") == 1) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(nEssentia, AC_DEFLECTION_BONUS), oSummon);
            else if (GetLocalInt(oMeldshaper, "SoulsparkEssentiaChoice") == 2) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHeal, oSummon);
            else if (GetLocalInt(oMeldshaper, "SoulsparkEssentiaChoice") == 3) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia, SAVING_THROW_TYPE_ALL), oSummon);
        }
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMeldshaper, i);
    }
}

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    string sSummon     = "moi_slspk_least";

	if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_CROWN) 	   		sSummon = "moi_slspk_lesser";
	else if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_BROW)   	sSummon = "moi_slspk_medium";
	else if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_THROAT)	sSummon = "moi_slspk_greatr";

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSummonCreature(sSummon)), oMeldshaper, 9999.0);  
    DelayCommand(0.5, AugmentSoulspark(oMeldshaper, sSummon, nEssentia));
    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SOULSPARK_FAMILIAR), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SOULSPARK_FAMILIAR_ESS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_ALERTNESS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}