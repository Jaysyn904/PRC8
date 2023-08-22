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
}