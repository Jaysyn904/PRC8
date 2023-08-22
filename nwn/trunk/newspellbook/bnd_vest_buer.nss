/*
03/03/21 by Stratovarius

Buer, Grandmother Huntress
  
Buer grants binders superior healing as well as powers against poisons and diseases.

Vestige Level: 4th
Binding DC: 20
Special Requirement: Buer requires that her seal be drawn outdoors.

Influence: Under Buer’s influence, you are plagued by momentary memory lapses. For an instant, you might forget even a piece of information as familiar as the 
name of a friend or family member. Furthermore, since Buer abhors the needless death of living creatures other than animals and vermin, the first melee 
attack you make against such a foe must be for nonlethal damage. In addition, Buer requires that you not make any coup de grace attacks.

Granted Abilities: 
Buer grants you healing powers, the ability to ignore toxins and ailments, and skills that help you navigate the natural world.

Buer’s Knowledge: You gain a +4 bonus on Heal, Lore, and Animal Empathy checks.

Buer’s Purity: You have immunity to disease and poison.

Delay Diseases and Poisons: Each ally within 30 feet of you gains immunity to poison and disease. 

Fast Healing: You gain the fast healing 1, and the rate of healing increases with your effective binder level. You gain fast healing 2 at 10th level, fast healing 3
at 13th level, fast healing 4 at 16th level, and fast healing 5 at 19th level.

Healing Gift: As a standard action, you can cure 1d8 points of damage +1 point per effective binder level (maximum 1d8+10 points). You cannot use your healing gift
again for 5 rounds. Both uses of the ability channel positive energy and deal a corresponding amount of damage to undead.

Track: You gain the Track feat.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_BUER);
    int nBonus = 1;
    
    if (nBinderLevel >= 10) nBonus = (nBinderLevel-4)/3;

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MARK_OF_THE_HUNTER), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_KNOWLEDGE))
    {
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_HEAL, 4));
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LORE, 4));
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 4));
    }
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_PURITY))
    {
    	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
    	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
    }	
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_DELAY_DISEASE)) eLink = EffectLinkEffects(eLink, EffectAreaOfEffect(136, "bnd_vest_buerent", "", "bnd_vest_buerext"));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_FAST_HEALING)) eLink = EffectLinkEffects(eLink, EffectRegenerate(nBonus, 6.0));
	    
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_BUER))) FloatingTextStringOnCreature("You have made a poor pact, and Buer prevents you from making a coup de grace!", oBinder, FALSE);    
	
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_HEALING_GIFT)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_BUER_HEAL), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BUER_TRACK)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_TRACK), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
   
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}