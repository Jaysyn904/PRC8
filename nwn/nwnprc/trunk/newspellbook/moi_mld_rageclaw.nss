/*
10/1/20 by Stratovarius

Rageclaws

Descriptors: Mind-Affecting  
Classes: Totemist 
Chakra: Hands (totem) 
Saving Throw: None

You form incarnum into a pair of furred gloves tipped with short claws. These gloves fit over your hands as well as any other gloves or gauntlets you might wear. When you clench your hands into fists, you can feel a surge of anger and determination well up inside you.

When reduced to 0 hit points, you can act as if you weren’t disabled. You do not lose 1 hit point for performing a standard or otherwise strenuous action while at 0 hit points. When reduced to –1 to –9 hit points, you do not fall unconscious. You do not automatically lose 1 hit point each round when at –1 to –9 hit points. When your current hit points drop to –10 or lower, you immediately die. 

Essentia: Investing essentia in rageclaws increases the range of negative hit points at which you can continue functioning. Every point of essentia invested effectively reduces the point at which you die by 3 (such as from –10 to –13). You can continue to fight without penalty until you reach that hit point total. 

Chakra Bind (Hands) 

The fur of your rageclaws merges into your hands, and your fingers become tipped with small, dark claws instead of nails. Each blow that lands on your body causes a blood rage to swell up in you, building until you are near death and then erupting in desperate fury.

While your hit point total is below 1 hit point per hit dice, you gain a +2 morale bonus on melee attack rolls, melee weapon damage rolls, and Fortitude saves. 

Chakra Bind (Totem)

The fur of your rageclaws merges into your hands, and your fingers become tipped with long, sharp claws you can use to tear the flesh of your foes.

You can use your rageclaws as a pair of natural weapons that deal 1d6 points of damage plus your Strength modifier. When you grapple an opponent, you can attack with both claws; these attacks are not subject to the usual –4 penalty for attacking with a natural weapon in a grapple. You gain a +1 enhancement bonus on attack rolls and damage rolls with your claws for every point of essentia invested in this soulmeld. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_RAGECLAWS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_claw_1d6m_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
        
        // All natural attacks end up here
        if (nEssentia)
        {        
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	    }    
    }
}