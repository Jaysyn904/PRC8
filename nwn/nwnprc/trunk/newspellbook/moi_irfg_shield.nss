/*
5/7/20 by Stratovarius

Ironsoul Forgemaster Shield Bond

At 1st level, you create a special bond with any shield that you craft. This bond allows you to invest essentia in the shield as if it were a soulmeld. 
Doing so grants you resistance 5 per point of invested essentia against acid, cold, electricity, fire, and sonic damage. You gain this ability only 
while using the shield for defense. If you unequip the shield, you lose the soulmeld. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_fork"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMeldshaper);
    if (GetIsShield(oShield) && GetTag(oShield) == ReplaceChars(GetName(oMeldshaper), " ","") && nEssentia)
    {
		int nBonus    = (5 * nEssentia);    
	    effect eLink  = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
    	if (nEssentia) 
    	{
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, nBonus));
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, nBonus));
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nBonus));
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, nBonus));
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC, nBonus));
    	}

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    }
    else if (nEssentia == 0)
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);    
    else
    	FloatingTextStringOnCreature("You do not have a shield equipped that you crafted", oMeldshaper, FALSE);
}