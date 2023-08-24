/*
10/1/20 by Stratovarius

Planar Chasuble

Descriptors: None  
Classes: Incarnate 
Chakra: Brow or soul 
Saving Throw: None

Incarnum forms an ornate vestment draped over your shoulders, covering any other clothing, armor, or vestments you are wearing. The chasuble is little more than a large circle with a hole in the center for your head, but raw incarnum is woven like blue thread into intricate patterns down its front.

You also gain resistance 10 to a specific energy type, based on your alignment. Chaotic incarnates gain resistance to electricity 10, evil incarnates gain resistance to acid 10, good incarnates gain resistance to cold 10, and lawful incarnates gain resistance to fire 10. 

Essentia: Every point of essentia invested in your planar chasuble increases the resistance to the specified energy type by 5 points. 

Chakra Bind (Brow) 

When you activate your incarnum radiance, the glow surrounding you also courses through the incarnum threads in your planar chasuble.

The bonus granted by your incarnum radiance class feature increases by 1. 

Chakra Bind (Soul) 

The embroidered patterns formed by raw incarnum in the front of your planar chasuble constantly shift and seem to depict living scenes from planes beyond the material world.

Once per week you can cast gate.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 10 + (5 * nEssentia);
	int nType;
    
   	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC)
   		nType = DAMAGE_TYPE_ELECTRICAL;
   	else if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)
   		nType = DAMAGE_TYPE_ACID;
   	else if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
   		nType = DAMAGE_TYPE_COLD;
   	else if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL)
   		nType = DAMAGE_TYPE_FIRE;    
    
    effect eLink = EffectDamageResistance(nType, nBonus);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SOUL) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PLANAR_CHASUBLE_SOUL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PLANAR_CHASUBLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
}