/*
5/1/20 by Stratovarius

Lamia Belt

Descriptors: Evil  
Classes: Totemist  
Chakra: Waist (totem) 
Saving Throw: None

You form incarnum into a belt of golden-brown fur at your waist. If you touch it with your bare skin, you sometimes catch mental echoes of cruelty and anger. When you enter combat, some part of your mind is less interested in defeating your opponents than in causing them pain.

While you wear your lamia belt, you gain a +4 competence bonus on Bluff and Hide checks. 

Essentia: For every point of essentia you invest in your lamia belt, your competence bonus on Hide and Bluff checks increases by 2. 
 
Chakra Bind (Waist) 

Instead of a physical belt of fur, your lamia belt manifests as fur sprouting from your skin, from your waist down to your knees. Your legs also become slightly more muscular.

You gain an enhancement bonus of +10 feet to your land speed, and you gain the benefit of the Spring Attack feat. 

Chakra Bind (Totem) 

The lower part of your body below your lamia belt takes on the shape of a lion, with four legs ending in sharp claws, a long, tufted tail, and coarse golden-brown fur. The upper portion of your body is unchanged, though perhaps a spark of evil grows stronger in your heart.

 You can make two claw attacks as natural secondary attacks after attacking with a weapon or another natural attack (such as a bite). These attacks take a –5 penalty from your full base attack bonus and deal 1d4 points of damage.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 4+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, nBonus), EffectSkillIncrease(SKILL_BLUFF, nBonus));
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SHOULDERS) 
    {
    	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_SPRINGATTACK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	SetLocalInt(oMeldshaper, "LamiaBeltSpeed", TRUE);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LAMIA_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_claw_1d6l_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumSecondaryAttackL", sResRef);
    }
}