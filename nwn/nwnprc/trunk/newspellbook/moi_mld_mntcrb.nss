/*
7/1/20 by Stratovarius

Manticore Belt

Descriptors: None  
Classes: Incarnate 
Chakra: Brow
Saving Throw: None

Incarnum forms a belt of spotted fur around your waist. At your back, short spines emerge from the belt. You note a marked increase in your appetite while you wear the belt.

While wearing your manticore belt, you gain a +2 enhancement bonus on Jump and Spot checks. 

Essentia: For every point of essentia you invest in your manticore belt, your enhancement bonus on Jump and Spot checks increases by 2.  

Chakra Bind (Waist)

Your manticore belt sprouts a pair of large, draconic wings. Though they are perched at your waist and flap awkwardly, these wings give you a reasonable ability of flight.

You can jump unlimited distances, and you gain the Spring Attack feat. 
 
Chakra Bind (Totem)

A long, thick tail emerges from the back of your manticore belt, writhing and lashing at your command. At its tip is a cluster of spikes. Like a manticore, you can propel those spikes at your foes.

As a standard action, you can snap your tail to loose a volley of spikes equal to the number of points of essentia you invest in your manticore belt. Make a ranged attack roll for each spike using your full base attack bonus. A successful hit deals 1d6 points of damage plus one-half your Strength modifier. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 12:21:10
//::
//:: Double Chakra Bind support added
//:: Double Totem bind support added
//::
//:: Updated on: 2026-05-01 12:04:32
//::
//:: Fixed Bonus feats hanging stay around after 
//:: reshaping soulmelds.
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"  
  
void main()    
{    
    object oMeldshaper = PRCGetSpellTargetObject();     
    int nMeldId        = PRCGetSpellId();    
    int nEssentia      = GetEssentiaInvested(oMeldshaper);    
    int nBonus = 2 + (nEssentia * 2);         
    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, nBonus), EffectSkillIncrease(SKILL_JUMP, nBonus));    
    
    // Check for Waist bind and add Spring Attack if bound  
    int nBoundToWaist = FALSE;    
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_WAIST)) == nMeldId ||    
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_WAIST)) == nMeldId)    
        nBoundToWaist = TRUE;    
    
    if (nBoundToWaist)    
    {
        eLink = EffectLinkEffects(eLink, EffectBonusFeat(FEAT_SPRING_ATTACK)); 
	}    
    
    // Tag the effect link for easy removal  
    eLink = TagEffect(eLink, "SOULMELD_MANTICORE_BELT_FEATS");  
    eLink = SupernaturalEffect(eLink);  
      
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMeldshaper, 9999.0);    
       
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
        
    // Totem bind (spike volley) — check regular or double Totem    
    int nBoundToTotem = FALSE;    
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||    
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)    
        nBoundToTotem = TRUE;    
    
    if (nBoundToTotem)    
    {    
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
    }    
}

/* #include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    int nBonus = 2 + (nEssentia * 2);       
    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, nBonus), EffectSkillIncrease(SKILL_JUMP, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Waist bind (Spring Attack) — check regular or double Waist  
    int nBoundToWaist = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_WAIST)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_WAIST)) == nMeldId)  
        nBoundToWaist = TRUE;  
  
    if (nBoundToWaist)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_SPRINGATTACK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
      
    // Totem bind (spike volley) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
} */

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    int nBonus = 2 + (nEssentia * 2);     
    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, nBonus), EffectSkillIncrease(SKILL_JUMP, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_WAIST) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_SPRINGATTACK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
} */