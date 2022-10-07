/*
31/01/21 by Stratovarius

Astral Vambraces
Descriptors: None
Classes: Incarnate, soulborn
Chakra: Arms or hands
Saving Throw: None

You form vambraces from ectoplasm, and their shimmering silver color is highlighted with glints of azure blue.

Your astral vambraces infuse you with the fortitude of an astral construct, granting you damage reduction 2/magic.

Astral vambraces are not affected by dismiss ectoplasm.

Essentia: Every point of essentia you invest in your astral vambraces increases the damage reduction by 2.

Chakra Bind (Arms)

The ectoplasm fuses closely to your arms, encasing them in silver-blue ectoplasm.

You benefit from one special ability of your choice in the Astral Construct Menu A. You can select a different ability each time you bind the astral vambraces to your arms.

Your options are:
Buff: 5 temporary hit points
Celerity: Speed increased by 10 feet
Cleave: Cleave feat
Deflection: +1 Deflection AC
Improved Bull Rush: Improved Bull Rush feat
Mobility: Mobility feat
Power Attack: Power Attack feat
Resistance: Resistance 5/- to acid, cold, electricity, fire, or sonic (pick one).

Chakra Bind (Hands)

The vambraces extend down and cover your hands in ectoplasm.

You gain two slam attacks, which act as primary natural weapons. The slam attacks deal 1d4 points of damage if you are Small, 
1d6 points of damage if you are Medium, or 1d8 points of damage if you are Large, plus your Strength bonus. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    int nBonus         = (1 + nEssentia) * 2;

    effect eLink = EffectDamageReduction(nBonus, DAMAGE_POWER_PLUS_ONE);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS) 
    {
    	int nChoice = GetLocalInt(oMeldshaper, "AstralVambraces");
    	//FloatingTextStringOnCreature("Astral Vambrace Arms Chakra nChoice "+IntToString(nChoice), oMeldshaper, FALSE);
    	if (nChoice == 1) eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(5));
    	//else if (nChoice == 2)  Handled in prc_speed
    	else if (nChoice == 3) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	else if (nChoice == 4) eLink = EffectLinkEffects(eLink, EffectACIncrease(1, AC_DEFLECTION_BONUS));
    	else if (nChoice == 5) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_BULL_RUSH), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	else if (nChoice == 6) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_MOBILITY), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	else if (nChoice == 7) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_POWERATTACK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	else if (nChoice == 8) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, 5));
    	else if (nChoice == 9) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, 5));
    	else if (nChoice == 10) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 5));
    	else if (nChoice == 11) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 5));
    	else if (nChoice == 12) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC, 5));
    }	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ASTRAL_VAMBRACES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_hdarc_slam_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        // This is correct to get the right damage profile
        sResRef += GetAffixForSize(nSize+1);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
    }    
}