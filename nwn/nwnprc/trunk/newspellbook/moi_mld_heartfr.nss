/*
4/1/20 by Stratovarius

Heart of Fire

Descriptors: Fire 
Classes: Totemist 
Chakra: Waist (totem) 
Saving Throw: None

A rough stone of blazing red hangs at the center of a loose belt around your waist. You feel warmth spreading from the stone into your body, though it is not enough to ward off extreme cold. At the sight of a frost giant or some other creature of cold, however, that warmth surges through your body like consuming fire, eager to sear your opponents’ flesh.

You gain a +1 insight bonus on attack rolls and damage rolls against elementals. 

Essentia: Every point of essentia you invest in your heart of fire increases your insight bonus on attack rolls and damage rolls by 1. 

Chakra Bind (Waist) 

A red glow suffuses your body, concentrated in your abdomen. Rather than a blazing red stone at your waist, your heart of fire is subsumed into your flesh, filling your body with its fiery fury.

Any creature striking you with a natural weapon or unarmed strike takes 1d6 points of fire damage per point of essentia you invest in your heart of fire. Creatures grappling you take this damage every round at the end of your turn. 

Chakra Bind (Totem)

The heat of the blazing stone at your waist spreads through your body, lashing out through your attacks at any opponent you face. When you enter combat, your skin glows red with the fiery power coursing through your veins.

Your natural weapons or unarmed strikes deal an additional 1d4 points of fire damage per point of essentia you invest in your heart of fire.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = nEssentia + 1;
    effect eLink       = EffectLinkEffects(VersusRacialTypeEffect(EffectAttackIncrease(nBonus), RACIAL_TYPE_ELEMENTAL), VersusRacialTypeEffect(EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nBonus), DAMAGE_TYPE_BASE_WEAPON), RACIAL_TYPE_ELEMENTAL));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_HEART_OF_FIRE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_WAIST) 
    {       
        // Add eventhook to the armor
        IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CHEST, oMeldshaper), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        AddEventScript(GetItemInSlot(INVENTORY_SLOT_CHEST, oMeldshaper), EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);
    } 
	else if (GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_TOTEM) 
	{       
		// Add fire damage to natural weapons/unarmed strikes
		object oTarget = GetItemInSlot(INVENTORY_SLOT_ARMS, oMeldshaper);
		
		// If no gloves, apply to PC skin as fallback
		if (!GetIsObjectValid(oTarget))
		{
			oTarget = GetPCSkin(oMeldshaper);
		}
		
		// Apply fire damage based on essentia invested
		int nDamageBonus = EssentiaToD4(nEssentia);
		if (nDamageBonus != -1)
		{
			IPSafeAddItemProperty(oTarget, 
								ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamageBonus), 
								9999.0, 
								X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
	}	
/* 	else if (GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_TOTEM) 
    {       
        // Add fire damage to natural weapons based on essentia invested
        int nDamageDice = nEssentia;
        if (nDamageDice > 0)
        {
            effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_FIRE);
            // Stack the effect for each point of essentia
			int i;
            for (i = 1; i < nDamageDice; i++)
            {
                eDamage = EffectLinkEffects(eDamage, EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_FIRE));
            }
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDamage), oMeldshaper, 9999.0);
        }
    } */
}