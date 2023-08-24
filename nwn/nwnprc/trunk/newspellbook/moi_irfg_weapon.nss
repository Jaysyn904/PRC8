/*
5/7/20 by Stratovarius

Ironsoul Forgemaster Weapon Bond

At 9th level, you create a special bond with any weapon that you craft. This bond allows you to invest essentia in the weapon as if it were a soulmeld. 
Doing so grants you a bonus equal to twice the invested essentia on your damage rolls. If you have at least 1 point of essentia invested in the weapon, 
it also dazes any living opponent you strike with it for 1 round (Fortitude negates, DC 10 + invested essentia + Con modifier). 
You gain this ability only while using the weapon. If you unequip the weapon, you lose the soulmeld.
*/

#include "moi_inc_moifunc"
#include "prc_inc_fork"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 
    object oShield = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
    if (GetTag(oShield) == ReplaceChars(GetName(oMeldshaper), " ","") && nEssentia)
    {
	    effect eLink  = EffectVisualEffect(VFX_DUR_RESISTANCE);
    	if (nEssentia) 
    	{
    		eLink = EffectLinkEffects(eLink, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia*2), DAMAGE_TYPE_BLUDGEONING));
			IPSafeAddItemProperty(oShield, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			AddEventScript(oShield, EVENT_ITEM_ONHIT, "moi_ironsoul", TRUE, FALSE);
            oShield = GetItemInSlot(INVENTORY_SLOT_BOLTS, oMeldshaper);
            IPSafeAddItemProperty(oShield, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oShield, EVENT_ITEM_ONHIT, "moi_ironsoul", TRUE, FALSE);
            oShield = GetItemInSlot(INVENTORY_SLOT_BULLETS, oMeldshaper);
            IPSafeAddItemProperty(oShield, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oShield, EVENT_ITEM_ONHIT, "moi_ironsoul", TRUE, FALSE);
            oShield = GetItemInSlot(INVENTORY_SLOT_ARROWS, oMeldshaper);
            IPSafeAddItemProperty(oShield, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oShield, EVENT_ITEM_ONHIT, "moi_ironsoul", TRUE, FALSE);			
    	}

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    }
    else if (nEssentia == 0)
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);
    else
    	FloatingTextStringOnCreature("You do not have a weapon equipped that you crafted", oMeldshaper, FALSE);
}