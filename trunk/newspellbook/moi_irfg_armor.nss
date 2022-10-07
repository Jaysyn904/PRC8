/*
5/7/20 by Stratovarius

Ironsoul Forgemaster Armor Bond

At 5th level, you create a special bond with any armor that you craft. This bond allows you to invest essentia in the armor as if it were a soulmeld. 
Doing so grants you damage resistance x/-, where x is the total essentia invested. You gain this ability only while wearing the armor. 
If you unequip the armor, you lose the soulmeld. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_fork"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 
    object oShield = GetItemInSlot(INVENTORY_SLOT_CHEST, oMeldshaper);
    if (GetTag(oShield) == ReplaceChars(GetName(oMeldshaper), " ","") && nEssentia)
    {
	    effect eLink  = EffectVisualEffect(VFX_DUR_SHIELD_OF_FAITH);
    	if (nEssentia) 
    	{
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, nEssentia));
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING, nEssentia));
    		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nEssentia));
    	}

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    }
    else if (nEssentia == 0)
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);    
    else
    	FloatingTextStringOnCreature("You do not have armor equipped that you crafted", oMeldshaper, FALSE);
}