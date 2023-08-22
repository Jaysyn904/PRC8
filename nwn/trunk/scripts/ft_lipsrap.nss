#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
   object oTarget=PRCGetSpellTargetObject();

   effect eAtk=EffectAttackIncrease(2);

   effect eDamB=EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_BLUDGEONING);
   effect eDamP=EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_PIERCING);
   effect eDamS=EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_SLASHING);
   effect eSkill=EffectSkillIncrease(SKILL_ALL_SKILLS,2);
   effect eSave=EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
   effect eSaveEnch=EffectSavingThrowIncrease(SAVING_THROW_ALL,4,SAVING_THROW_TYPE_MIND_SPELLS);

   effect eLink=EffectLinkEffects(eAtk,eDamB);
          eLink=EffectLinkEffects(eLink,eDamP);
          eLink=EffectLinkEffects(eLink,eDamS);
          eLink=EffectLinkEffects(eLink,eSkill);
          eLink=EffectLinkEffects(eLink,eSave);
          eLink=EffectLinkEffects(eLink,eSaveEnch);

   //Make SR check
   if (!PRCDoResistSpell(OBJECT_SELF, oTarget))
   {
      if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS))
      {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, RoundsToSeconds(1));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget);
      }
   }

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
}
