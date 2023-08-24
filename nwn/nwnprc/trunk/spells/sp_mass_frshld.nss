//::///////////////////////////////////////////////
//:: Name      Mass Fire Shield
//:: FileName  sp_mass_frshld.nss
//:://////////////////////////////////////////////
/**@file Mass Fire Shield
Evocation [Fire or Cold]
Level: Sorcerer/wizard 5, warmage 5
Components: V, S, M
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Targets: One or more allied creatures, no two of which
can be more than 30 ft. apart
Duration: 1 round/level (D)
Save: Will negates (harmless)
Spell Resistance: Yes (harmless)

This spell functions like fire shield (see
page 230 of the Player’s Handbook),
except as noted above.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
  PRCSetSchool(SPELL_SCHOOL_EVOCATION);

  if(!X2PreSpellCastCode()) return;

  object oPC = OBJECT_SELF;
  int nCasterLvl = PRCGetCasterLevel(oPC);
  location lLoc = PRCGetSpellTargetLocation();
  int nMetaMagic = PRCGetMetaMagicFeat();
  int nDam = min(15,nCasterLvl);
  float fDur = RoundsToSeconds(nCasterLvl);
  effect eVis, eShield, eReduce;
  int nSpell = GetSpellId();
  float fRadius = FeetToMeters(15.0);

  //Extend
  if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;

  if(nSpell == SPELL_MASS_FIRE_SHIELD_RED)
  {
      eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
      eShield = EffectDamageShield(nDam, DAMAGE_BONUS_1d6, ChangedElementalDamage(oPC, DAMAGE_TYPE_FIRE));
      eReduce = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
  }
  else if (nSpell == SPELL_MASS_FIRE_SHIELD_BLUE)
  {
      eVis = EffectVisualEffect(VFX_DUR_CHILL_SHIELD);
      eShield = EffectDamageShield(nDam, DAMAGE_BONUS_1d6, ChangedElementalDamage(oPC, DAMAGE_TYPE_COLD));
      eReduce = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
  }
  effect eLink = EffectLinkEffects(eShield, eVis);
         eLink = EffectLinkEffects(eLink, eReduce);

  object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
  while(GetIsObjectValid(oTarget))
  {
    if(GetIsFriend(oTarget, oPC))
    {
      SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, nSpell, nCasterLvl);
    }
    oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
  }
  PRCSetSchool();
}

