/*
25/1/21 by Stratovarius

Blademelds

Crown  	    You gain a +4 bonus on disarm checks and on Sense Motive ;
Feet        You gain a +2 bonus on Initiative ;
Hands       You gain a +1 bonus on damage ;
Arms        You gain a +2 bonus on attack rolls ;
Brow        You gain the Blind-Fight feat ;
Shoulders   You gain immunity to criticals but not sneak attacks ;
Throat      At will as a standard action, each enemy within 60 feet who can hear you shout must save or become shaken for 1 round (Will DC 10 + incarnum blade level + Con modifier). ;
Waist       You gain a +10 bonus on checks made to avoid being bull rushed, grappled, tripped, or overrun. You also gain Uncanny Dodge ;
Heart  	    You gain temporary hit points equal to twice your character level (maximum +40) ;
Soul        You break DR up to +3, and deal 1d6 damage to creatures of one opposed alignment ;
 */

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nMeld = GetSpellId();

	if (nMeld == MELD_BLADEMELD_CROWN    ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSkillIncrease(SKILL_SENSE_MOTIVE, 4)), oMeldshaper, 9999.0);  
	if (nMeld == MELD_BLADEMELD_FEET     ) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLOODED), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (nMeld == MELD_BLADEMELD_HANDS    ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_POSITIVE)), oMeldshaper, 9999.0);  
	if (nMeld == MELD_BLADEMELD_ARMS     ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAttackIncrease(2)), oMeldshaper, 9999.0);  
	if (nMeld == MELD_BLADEMELD_BROW     ) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (nMeld == MELD_BLADEMELD_SHOULDERS) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT)), oMeldshaper, 9999.0);  
    if (nMeld == MELD_BLADEMELD_THROAT   ) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLADEMELD_SHOUT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (nMeld == MELD_BLADEMELD_WAIST    ) 
    {
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), oMeldshaper, 9999.0);  
    	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
    if (nMeld == MELD_BLADEMELD_HEART    ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectTemporaryHitpoints(GetHitDice(oMeldshaper)*2)), oMeldshaper, 9999.0);  
    if (nMeld == MELD_BLADEMELD_SOUL     ) 
    {
    	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
    	if (IPGetIsMeleeWeapon(oItem))
    	{
			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(3), 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
			IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(3), 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
		}	

		effect eLink;
		if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD) eLink = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BASE_WEAPON), ALIGNMENT_EVIL);
		else if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL) eLink = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BASE_WEAPON), ALIGNMENT_CHAOTIC);		
		else if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC) eLink = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BASE_WEAPON), ALIGNMENT_LAWFUL);	
		else if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL) eLink = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BASE_WEAPON), ALIGNMENT_GOOD);		

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);	
	}	
    
    
}