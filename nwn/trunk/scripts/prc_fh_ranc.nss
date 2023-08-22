//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Foe Hunter Rancor Attack
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: July 12, 2004
//:://////////////////////////////////////////////

#include "prc_inc_combat"

int GetRancorDice(object oPC)
{
     int iFHLevel = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC);
     int iRancorDice = FloatToInt( (( iFHLevel + 1.0 ) /2) );

     return iRancorDice;
}

int GetRancorDamage(int iNumDice)
{
     int rDam = d6(iNumDice);

     return rDam;
}

void main()
{
     object oTarget = PRCGetSpellTargetObject();

     object oPC = OBJECT_SELF;
     object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

     int iWeapRDamageType = GetWeaponDamageType(oWeapR);
     int DamagePower = GetDamagePowerConstant(oWeapR, oTarget, oPC);

     // damage vars
     int iRancDice = GetRancorDice(oPC);
     int iRancorDamage = GetRancorDamage(iRancDice);
     int bIsRangedAttack = GetWeaponRanged(oWeapR);

     if(!bIsRangedAttack)
     {
           AssignCommand(oPC, ActionMoveToLocation(GetLocation(oTarget), TRUE) );
     }

     if(GetHasFeat(FEAT_RANCOR))
     {
          string sSuccess = "*Rancor Attack Hit*";
          string sMiss = "*Rancor Attack Miss*";

          if(GetLocalInt(oPC, "HatedFoe") != MyPRCGetRacialType(oTarget) )
          {
              iRancorDamage = 0;
              sSuccess = "*Not Hated Foe: Rancor Attack Not Possible*";
          }

          effect eBonusDamage = EffectDamage(iRancorDamage, iWeapRDamageType, DamagePower);

          // gives player a few seconds to run at enemy from distance
          if(!bIsRangedAttack)
          {
               DelayCommand( 2.0, PerformAttackRound(oTarget, oPC, eBonusDamage, 0.0, 0, 0, 0, FALSE, sSuccess, sMiss) );
          }
          else
          {
               PerformAttackRound(oTarget, oPC, eBonusDamage, 0.0, 0, 0, 0, FALSE, sSuccess, sMiss);
          }
     }
}