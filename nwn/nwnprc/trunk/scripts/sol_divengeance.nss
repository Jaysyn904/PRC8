#include "prc_feat_const"


void main()
{
   if (!GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF)) 
   {
     SpeakStringByStrRef(40550);
     return;
   }
   // removed evil check since Defenders of Faith has no mention of evil being unable to use.
    
   DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);

   int iCha = GetAbilityModifier(ABILITY_CHARISMA);
       iCha = iCha < 1 ? 1: iCha;

   object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
   object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

   AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_2d6),oWeapR,RoundsToSeconds(iCha));
   AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_2d6),oWeapL,RoundsToSeconds(iCha));



}
