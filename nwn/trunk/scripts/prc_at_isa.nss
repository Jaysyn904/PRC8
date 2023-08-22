//::///////////////////////////////////////////////
//:: Arcane Trickster
//:://////////////////////////////////////////////
/*
    Script to Simulate the Impromptu Sneak Attack
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 11, 2004
//:: Updated by Oni5115 9/23/2004 to use new combat engine
//:://////////////////////////////////////////////
#include "prc_inc_combat"

void main()
{
     object oTarget = PRCGetSpellTargetObject();
     object oPC = OBJECT_SELF;

     if(oPC == oTarget)
     {
          SendMessageToPC(oPC,"You cannot attack yourself...");
          return;
     }

     // might need to modify the enemies bonus AC due to other class abilities
     // things like Canny Defense which are typically lost when a player loses dex bonus to AC
     int iEnemydexBonus = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);

     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     int iDamageType = GetWeaponDamageType(oWeap);
     int iDamagePower = GetDamagePowerConstant(oWeap, oTarget, oPC);
     int iSneakAttackDice = GetTotalSneakAttackDice(oPC);
     int iSneakDamage = 0;

     effect eSneakDamage;

     string sSuccess = "";
     string sMiss = "";

     iSneakDamage = d6(iSneakAttackDice);
     // gain no bonus damage if immune to criticals
     if(GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_INVALID) )
     {
          iSneakDamage = 0;
          sSuccess = "*Enemy Immune to Impromptu Sneak Attack*";
     }

     // if enemy is more than 30 feet away
     if(GetDistanceBetween(oTarget, oPC) >= FeetToMeters(30.0))
     {
          iSneakDamage = 0;
          sSuccess = "*Enemy is to far away for Impromptu Sneak Attack*";
     }

     else
     {
          sSuccess = "*Impromptu Sneak Attack Hit*";
          sMiss    = "*Impromptu Sneak Attack Missed*";
     }

     // if using a melee weapon, make them run into melee range

     eSneakDamage = EffectDamage(iSneakDamage, iDamageType, iDamagePower);
     PerformAttackRound(oTarget, oPC, eSneakDamage, 0.0, iEnemydexBonus, 0, 0, FALSE, sSuccess, sMiss);
}