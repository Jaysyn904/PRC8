/*
20/1/21 by Stratovarius

Necrocarnum Touch

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Arms
Saving Throw: See text

Jet black shadows wreathe your hands and forearms, coiling and twisting with a life of their own. These insubstantial coils of energy hint at evil and agony, seeming to draw light and hope out of the
surrounding area.

The coiling energy makes the movements of your hands and arms hard to follow. While you have necrocarnum touch shaped, you gain a +4 bonus on Pickpocket checks.

Essentia: Whenever you invest essentia in necrocarnum touch, you can make a melee touch attack as a standard action. This attack deals 1d8 points of damage for every point
of essentia that you invest in the soulmeld, but only on living creatures (Fortitude half).

Chakra Bind (Arms) 

While necrocarnum touch is bound to your arms chakra, you can fire a ray of pure necrocarnum as a standard action. This ray requires a ranged touch attack to hit and has a range of
30 feet. If it strikes a living creature, it deals 1d8 points of damage for every point of essentia that you invest in the soulmeld (Fortitude half).
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 08:44:53
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"  
  
void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);   
  
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE), EffectSkillIncrease(SKILL_PICK_POCKET, 4));  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
      
    if (nEssentia) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_TOUCH_ESS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Check if bound to Arms chakra (regular or double)  
    int nBoundToArms = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_ARMS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)  
        nBoundToArms = TRUE;  
  
    if (nBoundToArms)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_TOUCH_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
      
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_TOUCH), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE), EffectSkillIncrease(SKILL_PICK_POCKET, 4));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    
    if (nEssentia) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_TOUCH_ESS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_TOUCH_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_TOUCH), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */