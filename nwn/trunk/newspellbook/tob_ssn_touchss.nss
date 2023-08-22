/*
   ----------------
   Touch of the Shadow Sun

   tob_ssn_touchss.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file

*/
#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"
#include "prc_inc_sp_tch"
#include "prc_inc_unarmed"

int UnarmedDamageRoll(int nDamageProp)
{
    int nDie = StringToInt(Get2DACache("iprp_monstcost", "Die", nDamageProp));
    int nNum  = StringToInt(Get2DACache("iprp_monstcost", "NumDice", nDamageProp));
    int nRoll;
    
    //Potential die options
    if(nDie == 4) nRoll = d4(nNum);
    else if(nDie == 6) nRoll = d6(nNum);
    else if(nDie == 8) nRoll = d8(nNum);
    else if(nDie == 10) nRoll = d10(nNum);
    else if(nDie == 12) nRoll = d12(nNum);
    else if(nDie == 20) nRoll = d20(nNum);
    
    return nRoll;
}

void main()
{
  if (!PreManeuverCastCode())
  {
      // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
      return;
  }
  // End of Spell Cast Hook

  object oInitiator    = OBJECT_SELF;
  object oTarget       = PRCGetSpellTargetObject();
  struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
  int nDamage;
  effect eLink;
  effect ePos = EffectVisualEffect(VFX_IMP_HEALING_L);
  effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

  if(move.bCanManeuver)
  {
    if(GetLocalInt(oInitiator, "SSN_TOUCH_LIGHT"))
    {// Must do light touch this round
      // Get damage from last negative attack
      nDamage = GetLocalInt(oInitiator, "SSN_TOUCH_DMG");

      if(GetIsEnemy(oTarget, oInitiator))
      {// Must take touch attack
        int nAttackRoll = PRCDoMeleeTouchAttack(oTarget, TRUE, oInitiator);
        if(nAttackRoll > 0)
        {// Need to hit
           if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
           || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
           || GetLocalInt(oTarget, "AcererakHealing"))
           {
               ApplyTouchAttackDamage(oInitiator, oTarget, 1, nDamage, DAMAGE_TYPE_POSITIVE);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
           }
           else
           {
               eLink = EffectLinkEffects(ePos, EffectHeal(nDamage));
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
           }
        }
        else return; // Need to discharge energy to use other ability ..keep trying
      }
      else
      {// No need to do touch attack
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
        || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
        {
            eLink = EffectLinkEffects(eNeg, EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        }
        else
        {
            eLink = EffectLinkEffects(ePos, EffectHeal(nDamage));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        }
      }
      // Set dark touch next time used
      DeleteLocalInt(oInitiator, "SSN_TOUCH_LIGHT");
    }
    else
    {// Must do dark touch this round
      // Get damage
      nDamage = FindUnarmedDamage(oInitiator);
      nDamage = UnarmedDamageRoll(nDamage);
      FloatingTextStringOnCreature("nDamage before Wisdom: "+IntToString(nDamage),OBJECT_SELF, FALSE);
      nDamage += GetAbilityModifier(ABILITY_WISDOM, oInitiator);
      FloatingTextStringOnCreature("nDamage after Wisdom: "+IntToString(nDamage),OBJECT_SELF, FALSE);

      SetLocalInt(oInitiator, "SSN_TOUCH_DMG", nDamage);
      //eLink = EffectLinkEffects(eLink, GetAttackDamage(oTarget, oInitiator, OBJECT_INVALID, GetWeaponBonusDamage(OBJECT_INVALID, oTarget), GetMagicalBonusDamage(oTarget)));
      if(GetIsEnemy(oTarget, oInitiator))
      {// Must take touch attack
        int nAttackRoll = PRCDoMeleeTouchAttack(oTarget, TRUE, oInitiator);
        if(nAttackRoll > 0)// Need to hit
        {
          if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
          || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
          {
              eLink = EffectLinkEffects(ePos, EffectHeal(nDamage));
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
          }
          else
          {
              ApplyTouchAttackDamage(oInitiator, oTarget, 1, nDamage, DAMAGE_TYPE_NEGATIVE);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);
          }
        }
        else return; // Need to discharge energy to use other ability ..keep trying
      }
      else
      {// No need to do touch attack
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
        || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
        {
            eLink = EffectLinkEffects(ePos, EffectHeal(nDamage));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        }
        else
        {
            eLink = EffectLinkEffects(eNeg, EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        }
      }
      // Set light touch next time used
      SetLocalInt(oInitiator, "SSN_TOUCH_LIGHT", TRUE);
    }
  }
}