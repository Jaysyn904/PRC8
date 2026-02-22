/*
7/1/20 by Stratovarius

Mauling Gauntlets

Descriptors: None  
Classes: Soulborn 
Chakra: Arms, hands
Saving Throw: None

Incarnum forms gauntlets that surround your hands (including any gloves or gauntlets you already wear) and extend up your arms to your elbows. The metal gleams a burnished blue. Spikes and blades jut out in various places from these gauntlets, each one whispering an ancient battle cry in your mind.

While wearing mauling gauntlets, you gain a +2 morale bonus on Strength checks (but not on Strength-based skill checks), such as those to bull rush an opponent. 

Essentia: Every point of essentia you invest in your mauling gauntlets increases the morale bonus by 2.  

Chakra Bind (Arms) 

Your mauling gauntlets extend winding bands of blue steel up past your elbows, almost to your shoulders. In places, these bands of metal seem fused with your skin.

Your mauling gauntlets double the critical threat range of any melee weapon you wield. 

Chakra Bind (Hands) 

Rather than actual gauntlets, this soulmeld transforms your hands into hard blue metal. Whenever you bend your fingers, echoes of the battlefield flit through your mind, until they form a constant undertone of war chants and battle cries inspiring you to greater accomplishments in battle.

You gain a morale bonus on unarmed strike damage equal to the morale bonus on Strength checks granted by the mauling gauntlets. You also gain the benefit of the Improved Unarmed Strike feat.  
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 14:57:34
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
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MAULING_GAUNTLETS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Hands bind (IUS) — check regular or double Hands  
    int nBoundToHands = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HANDS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HANDS)) == nMeldId)  
        nBoundToHands = TRUE;  
  
    if (nBoundToHands)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_UNARMED_STRIKE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Arms bind (keen) — check regular or double Arms  
    int nBoundToArms = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_ARMS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)  
        nBoundToArms = TRUE;  
  
    if (nBoundToArms)  
    {  
        // Apply keen to equipped melee weapons with a tag for future use  
        object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);  
        if (GetIsObjectValid(oWeapR) && IPGetIsMeleeWeapon(oWeapR))  
        {  
            itemproperty ipKeen = ItemPropertyKeen();  
            ipKeen = TagItemProperty(ipKeen, "moi_MaulingGauntletsKeen");  
            IPSafeAddItemProperty(oWeapR, ipKeen, 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
        }  
        object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMeldshaper);  
        if (GetIsObjectValid(oWeapL) && IPGetIsMeleeWeapon(oWeapL))  
        {  
            itemproperty ipKeen = ItemPropertyKeen();  
            ipKeen = TagItemProperty(ipKeen, "moi_MaulingGauntletsKeen");  
            IPSafeAddItemProperty(oWeapL, ipKeen, 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
        }  
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
   
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MAULING_GAUNTLETS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_UNARMED_STRIKE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */