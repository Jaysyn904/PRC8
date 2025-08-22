/*
   Favored of the Companions.

	[EXALTED]
	You swear allegiance to Talisid or one of the Five Companions,
	the paragons of the guardinals, and in exchange gain power to
	act on their behalf.
	Benefit: Once per day, while performing an act of good, you
	may call upon your guardinal patron to gain a +1 luck bonus on
	any one roll or check.
	Special: Once you take this feat, you may not take it again,
	nor can you take either the Servant of the Heavens feat or the
	Knight of Stars feat. Your allegiance is only yours to give once.
	
*/

#include "prc_inc_skin"
#include "prc_feat_const"

void main(){

   //Declare major variables
   object oTarget;
   object oSkin = GetPCSkin(OBJECT_SELF);
   effect ePosVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

   int nBonus = 1;
   effect eBonAttack = EffectAttackIncrease(nBonus);
   effect eBonSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
   effect eBonDam = EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING);
   effect eBonSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
   effect ePosDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

   effect ePosLink = EffectLinkEffects(eBonAttack, eBonSave);
   ePosLink = EffectLinkEffects(ePosLink, eBonDam);
   ePosLink = EffectLinkEffects(ePosLink, eBonSkill);
   ePosLink = EffectLinkEffects(ePosLink, ePosDur);


   if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD){

      //Fire spell cast at event for target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRAYER, FALSE));
      //Apply VFX impact and bonus effects
      ApplyEffectToObject(DURATION_TYPE_INSTANT, ePosVis, OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePosLink, OBJECT_SELF, 9.0);
   }

}
