/*
7/1/20 by Stratovarius

Mantle of Flame

Descriptors: Fire  
Classes: Incarnate 
Chakra: Shoulders
Saving Throw: See text

You shape incarnum into a cloak of wispy blue flame. The cloak covers your arms and almost closes in front of you, where a band of fire crosses over your heart to connect the cloak’s two edges. The fire does not harm you, though it keeps you as warm and dry as any heavy cloak in cold or rainy weather.

While you wear your mantle of flame, any creature that strikes you takes 1d6 points of fire damage.

Essentia: Every point of essentia you invest in your mantle of flame increases the damage dealt by 1d6 points.  

Chakra Bind (Shoulders)

Your mantle of flame burns particularly brightly around your shoulders, forming a high collar behind your head and neck.

As a standard action, you can briefly expand the mantle of flame to encompass all adjacent squares. Any creatures in those squares take damage as if they had attacked you with a handheld weapon (Reflex half). 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
   
    effect eLink = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTLE_OF_FLAME), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    // Add eventhook to the armor
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oMeldshaper);
    IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);    
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SHOULDERS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTLE_OF_FLAME_SHOULDERS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}