/*
13/1/20 by Stratovarius

Winter Mask

Descriptors: Cold
Classes: Totemist
Chakra: Throat (totem)
Saving Throw: See text

You shape incarnum into a snow-white mask resembling the head of a wolf. A snarling muzzle filled with sharp teeth protrudes from the front of the mask, and eyes like blue ice crystals stare out in defiance.

You must make a successful melee touch attack. The target is fatigued unless it succeeds on a Fortitude save. 

Essentia: Your touch attack also deals 1d4 points of cold damage for every point of essentia you invest in your winter mask. 

Chakra Bind (Throat) 

White fur spreads down from your winter mask to cover your throat. Your mouth is filled with a pleasant cold, like sucking a piece of ice on a hot day.

You gain the ability to breathe a cone of cold. Once every 1d4 rounds, you can emit a 15-foot-long cone of cold. Targets in the cone take 2d6 points of cold damage plus 2d6 additional points of damage for every point of invested essentia (Reflex half). 

Chakra Bind (Totem) 

Your face blends into that of your winter mask, merging with its lupine features. Your eyes appear in the mask’s eye sockets, and they become the pale ice-blue of a winter wolf’s eyes. Your jaws become the powerful maw of a winter wolf as well, and frost clings to the white fur around your muzzle as you breathe.

You gain a bite attack that deals 1d6 points of damage. Every point of essentia invested in this soulmeld adds 1d4 points of cold damage to your bite damage.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WINTER_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WINTER_MASK_TOUCH), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_THROAT) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WINTER_MASK_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_rdd_bite_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);
        
        int nDamage = EssentiaToD4(nEssentia);
        
        // All natural attacks end up here
        if (nEssentia)
        {        
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
    	}
    }	
}