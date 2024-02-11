/*
3/1/20 by Stratovarius

Fearsome Mask

Descriptors: Mind-affecting 
Classes: Soulborn
Chakra: Brown
Saving Throw: See text

You shape incarnum into a ferocious-looking mask that covers your face. It resembles a powerful outsider of your alignment, either majestic in splendor or terrible in its evil. Somewhere deep in your mind is a quivering knot of fear, but you find that you can channel that fear and use it to intimidate others.

While wearing the fearsome mask, you gain a +2 insight bonus on Intimidate checks. 

Essentia: Every point of essentia invested in this soulmeld increases the insight bonus it grants on Intimidate checks by 2. 

Chakra Bind (Brow) 

Your eyes, clearly visible through your fearsome mask, blaze with fiery wrath that strikes terror into the hearts of those that meet your gaze.

Your gaze causes enemy creatures (but not allies) to become shaken for 1 minute (Will negates). This is a free action that affects all enemies within 30 ft. This is a mind-affecting effect. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nBonus = 2 + nEssentia * 2;  

    effect eLink = EffectSkillIncrease(SKILL_INTIMIDATE, nBonus);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FEARSOME_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}