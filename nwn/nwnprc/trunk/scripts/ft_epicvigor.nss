#include "prc_inc_spells"

void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(40550);
        return;
   }

   object oTarget = PRCGetSpellTargetObject();

   if (GetHasSpellEffect(GetSpellId(),oTarget)) return;

   int nTouch = GetLocalInt(OBJECT_SELF,"EpicVigor");

   if (!nTouch || GetHasSpellEffect(SPELL_DIVINE_VIGOR) == FALSE )
   {
       PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_DIVINE_VIGOR);
       nTouch = GetAbilityModifier(ABILITY_CHARISMA)<1 ? 1 : GetAbilityModifier(ABILITY_CHARISMA);
       DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
       ActionCastSpellAtObject(SPELL_DIVINE_VIGOR,OBJECT_SELF,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
   }

   PRCRemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());
   SetLocalInt(OBJECT_SELF,"EpicVigor",nTouch-1);

   if (nTouch<1)
   {
      DeleteLocalInt(OBJECT_SELF,"EpicVigor");
   }

   int nResistance = 30;
   int iCon = 6;
   int iSpeed =20;
   int nDuration = GetAbilityModifier(ABILITY_CHARISMA)<1 ? 1 : GetAbilityModifier(ABILITY_CHARISMA);


   effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
   effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

   effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HEAL);

   //Link Effects
   effect eCon =EffectAbilityIncrease(ABILITY_CONSTITUTION,iCon);
   effect eSpeed =EffectMovementSpeedIncrease(iSpeed);

   effect eLink = EffectLinkEffects(eCon, eDur);
          eLink = EffectLinkEffects(eLink, eSpeed);
          eLink = EffectLinkEffects(eLink, eDur2);

   if ( GetIsFriend(oTarget)|| GetFactionEqual(oTarget))
   {
       //Apply the VFX impact and effects
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

   }

   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

}
