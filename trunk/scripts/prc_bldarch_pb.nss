//::///////////////////////////////////////////////
//:: Poison Blood spellscript
//:: prc_bldarch_pb
//:: Copyright (c) 2004 PRC Consortium.
//:://////////////////////////////////////////////
/*

    Restrictions
    ... only weapons and ammo can be poisoned
    ... restricted to piercing / slashing  damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-11
//:: Updated On: 2003-08-21
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
  object oTarget = PRCGetSpellTargetObject();
  object oPC     = GetItemPossessor(oTarget);

  if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
  {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  }
  int nType = GetBaseItemType(oTarget);
  if (!IPGetIsMeleeWeapon(oTarget) &&
      !IPGetIsProjectile(oTarget)   &&
       nType != BASE_ITEM_SHURIKEN &&
       nType != BASE_ITEM_DART &&
       nType != BASE_ITEM_THROWINGAXE)
  {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  }

  if (IPGetIsBludgeoningWeapon(oTarget))
  {
       FloatingTextStrRefOnCreature(83367,oPC);         //"Weapon does not do slashing or piercing damage "
       return;
  }

  //if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19)) // 19 == itempoison
  //{
  //      FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
  //      return;
  //}

   int bHasFeat = GetHasFeat( FEAT_BLARCH_POISON_BLOOD , oPC);
   if (!bHasFeat) // without blood archer feat, they cannot use ability
   {
           FloatingTextStringOnCreature("Poison Blood ability failed.", oPC, FALSE);
           return;
   }

   // duration, made it longer since it felt way too short.
   // now lasts 2d6 + class level rounds per use.
   int nDuration = (d6(2) +  GetLevelByClass(CLASS_TYPE_BLARCHER, oPC)) * 6;
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), IntToFloat(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

   if (IPGetHasItemPropertyByConst(ITEM_PROPERTY_ONHITCASTSPELL, oTarget))
   {
       // If weapon is poisoned, add proper effects
       FloatingTextStringOnCreature("Poison blood activated.", oPC);
       IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), IntToFloat(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);

       // Visual Effects and damage to player for using the ability
       // made damage equal to the duration to make it a little more balanced.
       // still might be overpowered.
       effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP, FALSE);
       effect eDam = EffectDamage((nDuration/6), DAMAGE_TYPE_DIVINE);

       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
   }
   else
   {
       // Inform the player that no poison was added
       FloatingTextStringOnCreature("No poison applied to weapon.", oPC, FALSE);
   }
}