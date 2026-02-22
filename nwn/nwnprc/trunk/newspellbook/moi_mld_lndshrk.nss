/*
6/1/20 by Stratovarius

Landshark Boots

Descriptors: None  
Classes: Totemist  
Chakra: Feet (totem) 
Saving Throw: None

You shape incarnum into a pair of boots that resemble the heavy clawed feet of a bulette. Leathery skin encases your legs up to your knees, and enormous claws extend from the front of your feet.

While wearing the landshark boots, you gain a +4 competence bonus on Jump checks. 

Essentia: Every point of essentia you invest in the landshark boots increases the competence bonus on Jump checks by 2. 
 
Chakra Bind (Feet)

The leathery skin of your landshark boots extends up to the middle of your thighs, and your legs thicken and grow stronger. The boots transmit vibrations from the earth into your feet, allowing you to sense the movement of nearby creatures.

You can take a move action to sense the closest creature and the direction to it. 

Chakra Bind (Totem) 

Your hands as well as your feet gain the heavy claws of a bulette, including one prominent central claw and two smaller claws on the sides. These massive claws emerge from the backs of your hands so you can bring them to bear while making a fist.

You can use the claws on your hands as natural weapons that deal 1d6 points of damage. You cannot use a shield while these claws are in place. For every point of essentia you invest in your landshark boots, you gain a +1 enhancement bonus on attack rolls and damage rolls with these claws. If you achieve a Jump check result good enough to jump over an opponent, you can attack that opponent with all four claws as a standard action. You cannot make any other attacks in the same round, whether from natural weapons or manufactured weapons. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 09:08:54
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    int nBonus         = 4 + (nEssentia * 2);  
    effect eLink       = EffectSkillIncrease(SKILL_JUMP, nBonus);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LANDSHARK_BOOTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Feet bind (sense closest creature) — check regular or double Feet  
    int nBoundToFeet = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_FEET)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_FEET)) == nMeldId)  
        nBoundToFeet = TRUE;  
  
    if (nBoundToFeet)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LANDSHARK_BOOTS_FEET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Totem bind (claws) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LANDSHARK_BOOTS_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);  
        string sResRef = "prc_claw_1d6m_";  
        int nSize = PRCGetCreatureSize(oMeldshaper);  
        sResRef += GetAffixForSize(nSize);  
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2);   
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);  
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 4+(nEssentia*2);
    effect eLink       = EffectSkillIncrease(SKILL_JUMP, nBonus);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LANDSHARK_BOOTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_FEET) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LANDSHARK_BOOTS_FEET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
    	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LANDSHARK_BOOTS_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        string sResRef = "prc_claw_1d6m_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
    }    
} */