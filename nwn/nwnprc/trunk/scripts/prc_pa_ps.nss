//::///////////////////////////////////////////////
//:: Peerless Archer - Power Shot, Improved Power Shot
//:: and Superior Power Shot
//:: Copyright (c) 2004
//:://////////////////////////////////////////////
/*
    Decreases attack by 5, 10 or 15
    and increases damage by 5, 10 or 15
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: April 09, 2004
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
     effect eDamage;
     effect eToHit;
     int nDamage, nToHit;
     int bHasBow = FALSE;
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

     if(GetBaseItemType(oWeap) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeap) == BASE_ITEM_SHORTBOW)
     {
          bHasBow = TRUE;
     }

     if (!bHasBow)
     {
         FloatingTextStringOnCreature("*No Bow Equipped*", OBJECT_SELF, FALSE);
         PRCRemoveSpellEffects(SPELL_PA_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
         PRCRemoveSpellEffects(SPELL_PA_IMP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
         PRCRemoveSpellEffects(SPELL_PA_SUP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
         return;
     }

     if(!GetHasFeatEffect(FEAT_PA_IMP_POWERSHOT) && !GetHasFeatEffect(FEAT_PA_POWERSHOT) && !GetHasFeatEffect(FEAT_PA_SUP_POWERSHOT))
     {
          int nDamageBonusType = GetWeaponDamageType(oWeap);

           switch(GetSpellId())
           {
               case SPELL_PA_POWERSHOT:
                   nDamage = DAMAGE_BONUS_5;
                   nToHit = 5;
                   break;
               case SPELL_PA_IMP_POWERSHOT:
                   nDamage = DAMAGE_BONUS_10;
                   nToHit = 10;
                   break;
               case SPELL_PA_SUP_POWERSHOT:
                   nDamage = DAMAGE_BONUS_15;
                   nToHit = 15;
                   break;
           }

          eDamage = EffectDamageIncrease(nDamage, nDamageBonusType);
          eToHit = EffectAttackDecrease(nToHit);

          effect eLink = ExtraordinaryEffect(EffectLinkEffects(eDamage, eToHit));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

          string nMes = "*Power Shot Mode Activated*";
          FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
     }
     else
     {
          PRCRemoveSpellEffects(SPELL_PA_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
          PRCRemoveSpellEffects(SPELL_PA_IMP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
          PRCRemoveSpellEffects(SPELL_PA_SUP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);

          string nMes = "*Power Shot Mode Deactivated*";
          FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
     }
}
