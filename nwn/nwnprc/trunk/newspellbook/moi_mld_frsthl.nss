/*
3/1/20 by Stratovarius

Frost Helm

Descriptors: Cold, sonic
Classes: Totemist
Chakra: Crown (totem)
Saving Throw: See text

Incarnum forms into a bluewhite helm resembling the bizarre head of a frost worm. It floats above the top of your head, its strange lumpy shape rising to a tall nodule at the front and top.

While wearing a frost helm, you gain the Cold Endurance feat.

Essentia: If you invest essentia in your frost helm, it also protects you from cold damage. You gain resistance to cold equal to 5 times the number of points of essentia you invest in this soulmeld. 

Chakra Bind (Crown) 

Your frost helm fuses to the top of your head, actually opening a breathing channel in the strange nodule at the helm’s crown.

As a standard action, you can project a ray of cold energy from your forehead, reminiscent of a frost worm’s breath weapon. You must make a ranged touch attack to hit a creature with this ray. If you hit, the ray deals 1d6 points of cold damage plus an additional 1d6 points for every point of essentia you invest in your frost helm. 

Chakra Bind (Totem) 

Your frost helm fuses to your head and seems to spread downward, changing the appearance of your upper face to resemble the head of a frost worm. Your eyes meld into the helm’s strange nodule, your cheeks twist into lumpy protrusions, and the skin of your face grows thick and blue-white.

As a standard action, you can produce a trilling sound that stuns opponents within 20 feet. You can target one creature plus one additional creature per point of essentia you invest in your frost helm. Targets must succeed on a Will save or be stunned for 1d4 rounds.  
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 10:13:58
//::
//:: Double Chakra Bind support added
//:: Double Totem bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_FROST_HELM);  
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, nEssentia * 5));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_COLD_ENDURANCE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FROST_HELM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Crown bind (cold ray) — check regular or double Crown  
    int nBoundToCrown = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_CROWN)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_CROWN)) == nMeldId)  
        nBoundToCrown = TRUE;  
  
    if (nBoundToCrown)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FROST_HELM_CROWN), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
  
    // Totem bind (stun) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FROST_HELM_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_FROST_HELM);
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, nEssentia * 5));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_COLD_ENDURANCE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FROST_HELM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper, MELD_FROST_HELM) == CHAKRA_CROWN) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FROST_HELM_CROWN), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper, MELD_FROST_HELM) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FROST_HELM_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */