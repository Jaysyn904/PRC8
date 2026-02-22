/*
13/1/20 by Stratovarius

Worg Pelt

Descriptors: None  
Classes: Totemist 
Chakra: Feet or hands (totem) 
Saving Throw: None

You gather worg spirits around you to form a cloaklike garment. It strongly resembles the pelt of a worg, from the top of the beast’s head perched atop your own to forelegs extending down your arms and rear legs hanging behind you. The fur is dark and thick, and glassy red eyes smolder in its face.

Your worg pelt grants you a +2 competence bonus on Hide and Move Silently checks. 

Essentia: Every point of essentia that you invest in your worg pelt increases the competence bonus on Hide and Move Silently checks by 2.

Chakra Bind (Feet) 

The hind legs of your worg pelt fuse into your own legs, lengthening your feet and shins while shortening your thighs, enabling you to run on your toes like a predatory animal. Your legs are totally covered in the dark gray fur of a worg.

Your base land speed increases by 5 feet, plus an additional 5 feet for every point of essentia you invest in your worg pelt. 

Chakra Bind (Hands) 

The forelegs of your worg pelt fuse into your own arms, adding weight and bulk to your hands. Your arms and hands are completely covered in the dark gray fur of a worg.

When you hit with a bite attack you attempt to trip the opponent as a free action without making a touch attack or provoking an attack of opportunity. If the attempt fails, the opponent cannot react to trip you. 

Chakra Bind (Totem)

The head of your worg pelt becomes one with your own head. Your eyes begin to glow red and replace the glassy eyes of the pelt, while your lower jaw extends to join the upper muzzle of the pelt, granting you a fierce bite attack.

You gain a bite attack that deals 1d6 points of damage. You gain an enhancement bonus on attack rolls and damage rolls with your bite equal to the number of points of essentia you invest in it.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 19:12:16
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
    int nBonus         = 2 + (nEssentia * 2);  
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WORG_PELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Feet bind (speed) — check regular or double Feet  
    int nBoundToFeet = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_FEET)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_FEET)) == nMeldId)  
        nBoundToFeet = TRUE;  
  
    if (nBoundToFeet)  
        SetLocalInt(oMeldshaper, "WorgPeltSpeed", 5 + (nEssentia * 5));  
  
    // Totem bind (bite attack + enhancement) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        string sResRef = "prc_rdd_bite_";  
        int nSize = PRCGetCreatureSize(oMeldshaper);  
        sResRef += GetAffixForSize(nSize);  
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef);   
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);  
          
        if (nEssentia)  
        {  
            DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));  
        }  
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 2+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WORG_PELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_FEET) SetLocalInt(oMeldshaper, "WorgPeltSpeed", 5 + (nEssentia * 5)); 
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_rdd_bite_";
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
} */