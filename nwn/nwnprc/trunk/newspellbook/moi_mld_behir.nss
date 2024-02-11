/*
31/12/19 by Stratovarius

Behir Gorget

Descriptors: Electricity 
Classes: Totemist 
Chakra: Throat (totem) 
Saving Throw: See text

Incarnum forms a large, deep blue collar around your neck, like part of a suit of plate armor. The color is darker on the back and fades to pale blue in the front, 
and bands of gray-brown line the top and bottom. The gorget tapers to a sharp point above your breastbone.

Your behir gorget gives you a +4 bonus to resist being bull rushed or tripped. 

Essentia: You gain resistance to electricity equal to 5 times the number of points of essentia you invest in this soulmeld. 

Chakra Bind (Throat) 

Your armored collar merges into your throat, and your neck lengthens very slightly. You can feel a constant tingling in the sides of your neck, and tiny sparks occasionally 
spit from your mouth when you speak — particularly when you get excited or angry.

You gain the ability to project a line of electricity as a standard action. Once per minute, you can emit a line of acid that is 5 feet long plus 5 feet per point of invested essentia. 
Targets in the line take 2d6 points of electricity damage plus 1d6 points for every point of invested essentia. They can reduce this damage by half with a successful Reflex save. 

Chakra Bind (Totem) 

As you bind your behir gorget to your totem chakra, its hard blue plating spreads up your neck to incorporate your entire head. Your face lengthens, and your jaw grows monstrous. 
Sharp teeth fill your mouth, allowing you to bite your foes savagely in combat. Sparks crackle in your mouth whenever you open it to bite—or even to speak.

You gain a bite attack that deals 1d8 points of damage. You can use this bite as a primary attack. Every point of essentia invested in this soulmeld adds 1d4 points of electricity damage to your bite damage.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 

    effect eLink = EffectVisualEffect(VFX_DUR_PROTECTION_ENERGY_ELECT);
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 5 * nEssentia));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BEHIR_GORGET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BEHIR_GORGET_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_hdarc_bite_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);
        
        int nDamage = EssentiaToD4(nEssentia);
        
        // All natural attacks end up here
        if (nEssentia)
        {        
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	    }    
    }
}