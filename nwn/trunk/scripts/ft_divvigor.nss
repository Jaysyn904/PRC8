#include "prc_feat_const"
#include "prc_spell_const"

void main()
{

   if (!GetHasFeat(FEAT_EPIC_DIVINE_VIGOR, OBJECT_SELF))
   {
     if(GetHasFeatEffect(FEAT_DIVINE_VIGOR) == FALSE )
     {
        if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
        {
            SpeakStringByStrRef(40550);
           return;
        }
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
     }

   }
   else
   {
     effect eDur2 = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur2, OBJECT_SELF,TurnsToSeconds(5));
     return;
   }


   int nTouch = GetAbilityModifier(ABILITY_CHARISMA)<1 ? 1 : GetAbilityModifier(ABILITY_CHARISMA);
   int nResistance = 5;
   int iCon = 2;
   int iSpeed = 10;

   effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
   effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
   effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HEAL);

   //Link Effects
   effect eCon =EffectAbilityIncrease(ABILITY_CONSTITUTION,iCon);
   effect eSpeed =EffectMovementSpeedIncrease(iSpeed);

   effect eLink = EffectLinkEffects(eCon, eDur);
          eLink = EffectLinkEffects(eLink, eSpeed);
            eLink = EffectLinkEffects(eLink, eDur2);

   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nTouch));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
}
