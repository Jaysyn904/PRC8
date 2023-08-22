/*
9/7/20 by Stratovarius

Umbral Disciple Soulchilling Strike

For every point of essentia you invest in this ability, your melee attack deals 1 point of Strength damage to the target (Fortitude negates,
DC 10 + invested essentia + your Con modifier) in addition to its normal damage. Only one attack per round conveys this soulchilling effect. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_fork"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 
    object oShield = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
    if (nEssentia)
    {
	    effect eLink  = EffectVisualEffect(VFX_DUR_RESISTANCE);
		IPSafeAddItemProperty(oShield, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		AddEventScript(oShield, EVENT_ITEM_ONHIT, "moi_umbral", TRUE, FALSE);
		AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,   "moi_umbral", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONPLAYERUNEQUIPITEM, "moi_umbral", TRUE, FALSE);

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    }
    else
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);
}