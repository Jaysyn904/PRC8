/*
28/12/19 by Stratovarius

Acrobat Boots

Descriptors: None 
Classes: Incarnate 
Chakra: Feet (None)
Saving Throw: None

While wearing acrobat boots, you gain a +2 insight bonus on Balance, Jump, and Tumble checks. 

Essentia: Every point of essentia invested in the acrobat boots increases the bonus by 2. 

Chakra Bind (Feet) 

Your acrobat boots join fast to your feet and help you to leap great distances.

You always succeed on jump checks
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nBonus = 2;
    nBonus += GetEssentiaInvested(oMeldshaper) * 2;   

    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_TUMBLE, nBonus), EffectSkillIncrease(SKILL_BALANCE, nBonus));
           eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_JUMP, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ACROBAT_BOOTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}