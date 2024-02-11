#include "prc_alterations"


void main()
{
   int iWis =GetAbilityModifier(ABILITY_WISDOM)>0 ? GetAbilityModifier(ABILITY_WISDOM):0;


   effect eWis = EffectAbilityIncrease(ABILITY_WISDOM,2);
   effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_4,DAMAGE_TYPE_BLUDGEONING);

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectLinkEffects(eWis,eDmg),OBJECT_SELF,RoundsToSeconds(iWis+2));

}
