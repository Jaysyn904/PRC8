/*
20/1/21 by Stratovarius

Necrocarnum Vestments

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Heart, Waist
Saving Throw: See text

Necrocarnum twists and writhes into the shape of long, flowing vestments. These vestments cling tightly to your shoulders, but drape loosely over the rest of your body, obscuring other
garments behind an ever-shifting screen of terror. As with all necrocarnum melds, faint forms seem to swim in the depths of this shadowy vestment. These tortured apparitions seem wracked
by incomprehensible agony, their elongated faces wrenched open in eternal screams.

When you have necrocarnum vestments shaped, you gain resistance to cold 5 as the energies of necrocarnum deaden your flesh to the effects of cold.

Essentia: For every point of essentia invested in thenecrocarnum vestments, you gain 3 temporary hit points.

Chakra Bind (Heart)
When you have necrocarnum vestments bound to your heart chakra, you are immune to stunning and death effects.

Chakra Bind (Waist)
When you have necrocarnum vestments bound to your waist chakra, any living creature adjacent to you at the end of your turn takes 1d6 points of cold damage (Fortitude negates).
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 13:54:11
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_VESTMENTS);  
    effect eLink       = EffectDamageResistance(DAMAGE_TYPE_COLD, 5);  
  
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(nEssentia * 3));  
      
    // Heart bind (stun/death immunity) — check regular or double Heart  
    int nBoundToHeart = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HEART)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HEART)) == nMeldId)  
        nBoundToHeart = TRUE;  
  
    if (nBoundToHeart)  
    {  
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));  
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));  
    }  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_VESTMENTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_VESTMENTS);
    effect eLink = EffectDamageResistance(DAMAGE_TYPE_COLD, 5);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(nEssentia * 3));
    
    if (GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_VESTMENTS) == CHAKRA_HEART) 
    {
    	EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
    	EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_VESTMENTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */