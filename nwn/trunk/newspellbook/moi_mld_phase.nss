/*
10/1/20 by Stratovarius

Phase Cloak

Descriptors: None 
Classes: Totemist 
Chakra: Shoulders (totem) 
Saving Throw: See text

You form incarnum into a gray and white cloak with mottled blue markings that seems to shift and flow over your back like liquid.

You gain a +4 competence bonus on Climb checks. 

Essentia: For every point of essentia you invest in your phase cloak, your competence bonus on Climb checks increases by 2.  

Chakra Bind (Shoulders) 

Your phase cloak becomes even more like a silvery gray liquid, seeming to flow like a gentle stream even when completely motionless. Its mottled blue markings also extend to the skin of your shoulders and upper torso.

Whenever you move more than five feet, you become incorporeal for half a round. 

Chakra Bind (Totem) 

A terrible spidery head extends like a hood from your phase cloak, covering your face. Eight silver-white eyes set in dark blue chitin cover your own eyes, and a huge pair of fangs dripping poison covers your mouth.

You gain a bite attack that deals 1d4 points of damage and injects a mild poison (Fortitude negates, damage 1d2 Con). Every point of essentia invested in this soulmeld grants a +1 enhancement bonus on attack rolls made with the bite attack. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nBonus = 4 + nEssentia;  

    effect eLink = EffectSkillIncrease(SKILL_CLIMB, nBonus);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PHASE_CLOAK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);
        
        // All natural attacks end up here
        int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_PHASE_CLOAK);
        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, IPOnHitSaveDC(nDC), IP_CONST_POISON_1D2_CONDAMAGE), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
        if (nEssentia)
        {        
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyAttackBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	    }    
    }
}