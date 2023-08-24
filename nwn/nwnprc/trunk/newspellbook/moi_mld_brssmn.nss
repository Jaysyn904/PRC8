/*
1/1/20 by Stratovarius

Brass Mane

Descriptors: Sonic 
Classes: Totemist
Chakra: Throat (totem)
Saving Throw: See text

This feral mask has leonine qualities, including a coarse mane of thick, brass-colored hair. Onlookers familiar with the mighty dragonnes recognize the similarities between those fearsome desert predators and the features of the mask.

While you wear your brass mane, you gain a +4 competence bonus on Intimidate checks.

Essentia: Every point of essentia invested in this soulmeld increases the competence bonus it grants on Intimidate checks by 2. 

Chakra Bind (Throat) 

The hair of your brass mane extends down your neck, forming brassy scales that cover your throat and reach down to your breastbone. Your voice gets louder unless you make a conscious effort to keep it quiet.

Once per minute, you can loose a devastating roar. All creatures within 10 feet must succeed on a Will save or become fatigued. The range of this effect is extended by 10 feet for every point of essentia invested in the soulmeld.

Chakra Bind (Totem) 

Your face blends into the mask, your jaws growing long and sprouting huge fangs. You can make powerful bite attacks to tear the flesh of your foes.

You gain a bite attack that deals 1d8 points of damage. You can use this bite as a primary attack. Every point of essentia invested in this soulmeld grants a +1 enhancement bonus on attack rolls and damage rolls made with the bite attack.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nBonus = 2 + nEssentia * 2;  

    effect eLink = EffectSkillIncrease(SKILL_INTIMIDATE, nBonus);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BRASS_MANE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BRASS_MANE_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_hdarc_bite_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);
        
        // All natural attacks end up here
        if (nEssentia)
        {        
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	    }    
    }
}