/*
4/1/20 by Stratovarius

Illusion Veil

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Brow 
Saving Throw: None

You shape incarnum into a wispy veil, which fades into invisibility when you wear it. When you cast an illusion spell, tendrils of incarnum surround and merge with the illusory effect, making it more vibrant and believable.

You gain a +1 insight bonus to the save DCs of your illusion spells and spell-like abilities. 

Essentia: Whenever you cast an illusion spell or use an illusion-based spell-like ability, you add 1 round to the duration for every point of essentia invested in this soulmeld at the time of casting. 

Chakra Bind (Brow) 

A dim blue glow emanates from your eyes. A brief flash, visible only to you, scans across your field of vision periodically, outlining creatures and objects while heightening your awareness.

When your illusion veil is bound to your brow chakra, you can more easily perceive false reality. You can see invisibility, as the spell. You also gain an insight bonus on saves against illusion spells equal to the number of points of essentia invested in your illusion veil. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN) eLink = EffectLinkEffects(eLink, EffectSeeInvisible());

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ILLUSION_VEIL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}