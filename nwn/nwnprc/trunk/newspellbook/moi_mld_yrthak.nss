/*
13/1/20 by Stratovarius

Yrthak Mask

Descriptors: Sonic  
Classes: Totemist 
Chakra: Brow (totem) 
Saving Throw: None

You shape incarnum into a bizarre mask, basically crocodilian in form. It lacks eyes entirely, and a weird hornlike protrusion juts from the top and front—resembling the strange yrthak in its overall appearance.

You gain a +4 competence bonus on Listen checks.

Essentia: Every point of essentia that you invest in your yrthak mask increases the competence bonus on Listen checks by 2.  

Chakra Bind (Brow) 

Your yrthak mask fuses to your forehead, though your mouth still speaks inside the mouth of the mask. Your vision dims somewhat, but you find yourself alive to the world of sounds around you—including some you had never heard before. You find that you can discern a creature’s location with great accuracy simply by listening to the sounds it makes.

You gain a limited form of blindsense. You can take a move action to pinpoint the location of the nearest creature within 10 feet of you to which you have line of effect. The range of this ability increases by 10 feet for every point of essentia you invest in your yrthak mask. Even as your other senses are heightened, your visual acuity diminishes. You take a –4 penalty on Spot checks. To your benefit, you gain a +4 bonus on saving throws against illusions. 

Chakra Bind (Totem)

Your yrthak mask becomes your actual face, and your jaws lengthen into the crocodilian maw of a yrthak. The mask is too awkward to allow you to make bite attacks, but you can focus sonic energy through the hornlike protrusion on the front of the mask, using it to stab your foes with rays of pure sound.

Once every 2 rounds, you can focus sonic energy into a ray up to 60 feet long. This is a ranged touch attack that deals 1d6 points of sonic damage to a single target for every point of invested essentia.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 4+(nEssentia*2);
    effect eLink       = EffectSkillIncrease(SKILL_LISTEN, nBonus);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) 
    {
    	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_YRTHAK_MASK_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);     
    	eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_SPOT, 4));
    }	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_YRTHAK_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_YRTHAK_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 

}