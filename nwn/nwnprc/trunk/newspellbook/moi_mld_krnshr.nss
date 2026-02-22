/*
5/1/20 by Stratovarius

Krenshar Mask

Descriptors: Fear, mind-affecting, sonic  
Classes: Totemist  
Chakra: Brow (totem) 
Saving Throw: See text

You form incarnum into a snarling, bestial mask of exposed bone and muscle. Its basic form is somewhere between that of a large cat and a wolf, but it lacks skin, showing sharp teeth, white bone, and pink-red muscles.

While wearing your krenshar mask, you gain a +4 competence bonus on Jump and Move Silently checks. 

Essentia: Every point of essentia you invest in your krenshar mask increases your competence bonus on Jump and Move Silently checks by 2. 
 
Chakra Bind (Brow) 

Your eyes stare forth from your krenshar mask, taking on a green-blue color. The jaws of the mask move as you speak, its muscles flexing weirdly in full view—an intimidating effect, to say the least.

As a result of the mask’s frightful appearance, you gain a competence bonus on Intimidate checks equal to the bonus the mask gives on Jump and Move Silently checks. 

Chakra Bind (Totem) 

Your face becomes one with your krenshar mask, so all its muscles move to match your expressions. A ridge of skin around the edge of the mask quivers when you grow angry or enter combat, and a growling edge creeps into your voice.

You gain the ability to produce a loud screech (as a standard action) similar to that of a krenshar. In combination with the frightening aspect of the mask, this shriek causes one creature within 30 feet of you to become frightened for 1 round if it fails a Will save. This is a sonic, mind-affecting fear effect. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 19:13:53
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
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_JUMP, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));  
  
    // Brow bind (Intimidate) — check regular or double Brow  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (nBoundToBrow)  
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_KRENSHAR_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Totem bind (screech) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_KRENSHAR_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 4+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_JUMP, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_KRENSHAR_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_KRENSHAR_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */