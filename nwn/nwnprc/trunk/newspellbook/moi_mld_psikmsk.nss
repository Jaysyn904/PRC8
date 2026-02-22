/*
31/1/21 by Stratovarius

Psion-Killer Mask
Descriptor: None
Classes: Totemist
Chakra: Brow (totem)
Saving Throw: None

You craft incarnum into a red crystal mask that has sharp edges along its many facets. The crystal has an inner crimson glow that seems to intensify when near psionic energies.

You can use a detect psionics effect as the power, with a range of 10 feet. You can use this ability as often as desired, but no more than once per round (as a standard action).

Essentia: For every point of essentia you invest in your psion-killer mask, the range of the detect psionics effect increases by 10 feet.

Chakra Bind (Brow)

Your psion-killer mask binds to your forehead, and your eyes replace the red glow in the mask's sockets. Colors seem somehow more alive to your sight -- particularly the colors of psionic displays and items you know to be psionic.

When using this soulmeld's detect psionics ability, you can instantly determine the number, strength, and location of each psionic aura present as if you had been concentrating for 3 rounds. 

Chakra Bind (Totem)

Your face is covered in crystal facets that now grow down to your chest and shoulders. As the crystal covers your face, you can almost taste and smell the psionic energy in the air, and if you extend your crystal tongue, the air tastes sweet and strong -- almost like a liqueur.

You can emit a crimson ray from the mouth of your psion-killer mask to make a ranged touch attack as a standard action. 

If you hit with the ray, you deal no damage but temporarily suppress the opponent's primary weapon, if any, for ten rounds.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 08:43:46
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
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONKILLER_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONKILLER_MASK_DETECT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Check if bound to Totem chakra (regular or double)  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONKILLER_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
}

/* #include "moi_inc_moifunc" 

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONKILLER_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONKILLER_MASK_DETECT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONKILLER_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */