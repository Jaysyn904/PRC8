/*
31/12/19 by Stratovarius

Bluesteel Bracers

Descriptors: None 
Classes: Incarnate, Soulborn
Chakra: Arms
Saving Throw: None

You harness the soul energy of mighty warriors past, present, and future, shaping that incarnum into bands of bright blue steel that surround your wrists and lower arms. You feel a soft tingling in your wrists that grows stronger when danger is near.

Your bluesteel bracers enhance your reactions and keep your mind in a state of constant battle readiness, granting you a +2 insight bonus on initiative checks. 

Essentia:  For every point of essentia you invest in your bluesteel bracers, you gain a +1 insight bonus on melee damage rolls. 

Chakra Bind (Arms) 

Your bluesteel bracers affix themselves to your arms, extending swirling patterns of bright metallic blue up your biceps. When danger is near, your nearby allies share your sense of it and find themselves more ready for battle.

All allies within 30 feet gain the +2 bonus on initiative granted by this soulmeld. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 08:43:46
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////

void BluesteelBracersHB(object oMeldshaper);

#include "moi_inc_moifunc"

void BluesteelBracersHB(object oMeldshaper)
{
	effect eLink     = EffectSkillDecrease(SKILL_SPOT, 2);
    location lTarget = GetLocation(oMeldshaper);
    // Use the function to get the closest creature as a target
    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oAreaTarget))
    {
        if(oAreaTarget != oMeldshaper && // Not you
           GetIsFriend(oAreaTarget, oMeldshaper)) // Only allies
        {
            IPSafeAddItemProperty(GetPCSkin(oAreaTarget), ItemPropertyBonusFeat(IP_CONST_FEAT_BLOODED), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oAreaTarget, 6.0);
        }
    //Select the next target within the spell shape.
    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    } 
    
    if(GetHasSpellEffect(MELD_BLUESTEEL_BRACERS, oMeldshaper)) DelayCommand(6.0, BluesteelBracersHB(oMeldshaper));
}

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    effect eLink       = EffectSkillDecrease(SKILL_SPOT, 2);  
  
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia), DAMAGE_TYPE_BASE_WEAPON));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLUESTEEL_BRACERS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLOODED), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Check if bound to Arms chakra (regular or double)  
    int nBoundToArms = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_ARMS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)  
        nBoundToArms = TRUE;  
      
    if (nBoundToArms)  
    {  
        BluesteelBracersHB(oMeldshaper);  
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectSkillDecrease(SKILL_SPOT, 2);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia), DAMAGE_TYPE_BASE_WEAPON));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    //IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLOODWAR_GAUNTLETS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  //::  <- Wrong?
	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLUESTEEL_BRACERS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLOODED), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS) BluesteelBracersHB(oMeldshaper);
	GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)
} */