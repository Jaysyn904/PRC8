//  Clangeddin's Strike Feat
//  Created 10/30/04
//  By Vaeliorin
#include "prc_inc_combat"

void main()
{
     object oPC   = OBJECT_SELF;
     object oTarget  = PRCGetSpellTargetObject();

     if(oPC == oTarget)
     {
          SendMessageToPC(oPC,"You cannot attack yourself...");
          return;
     }


     object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

     if (GetBaseItemType(oItem) != BASE_ITEM_BATTLEAXE)
     {
         SendMessageToPC(oPC, "You must have a battleaxe equipped to use this feat");
         IncrementRemainingFeatUses(oPC, FEAT_CLANGEDDINS_STRIKE);
         return;
     }

     AssignCommand(oPC, ActionMoveToLocation(GetLocation(oTarget), TRUE) );

      effect eDamage1;
      effect eDamage2;
      effect eDamage3;

      effect eLink1;
      effect eLink2;

      int iAttackResult;

      struct BonusDamage sWeaponBonus;
      struct BonusDamage sSpellBonus;

      int iStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);

      sWeaponBonus = GetWeaponBonusDamage(oItem, oTarget);

      sSpellBonus = GetMagicalBonusDamage(oPC, oTarget);

      iAttackResult = GetAttackRoll(oTarget, oPC, oItem, 0, 0, (iStrMod + 1));

      if (iAttackResult == 2)
      {
         SendMessageToPC(oPC, "Clangeddin's Strike **Critical Hit!**");
         eDamage1 = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, TRUE, 0, 0, 0);
         //DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage2 = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, TRUE, 0, 0, 0);
         //DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage3 = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, TRUE, 0, 0, 0);
         //DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eLink1 = EffectLinkEffects(eDamage1, eDamage2);
         eLink2 = EffectLinkEffects(eLink1, eDamage3);
         DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget));

      }
      else if (iAttackResult == 1)
      {
         SendMessageToPC(oPC, "Clangeddin's Strike Hit!");
         eDamage1 = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, FALSE, 0, 0, 0);
         //DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage2 = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, FALSE, 0, 0, 0);
         //DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage3 = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, FALSE, 0, 0, 0);
         //DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eLink1 = EffectLinkEffects(eDamage1, eDamage2);
         eLink2 = EffectLinkEffects(eLink1, eDamage3);
         DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget));
      }
     else
     {
         SendMessageToPC(oPC, "Clangeddin's Strike Miss!");
     }
     AssignCommand(oPC, ActionAttack(oTarget));
}




