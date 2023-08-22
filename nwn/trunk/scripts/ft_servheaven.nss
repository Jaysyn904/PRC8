/*
   Servant of the Heavens

   Gain +1 Attack, damage, saves, skill checks for 9 seconds

   Original: Prayer
   Modified By: Starlight
   Modified On: 2004-5-13
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
