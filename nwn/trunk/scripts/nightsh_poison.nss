//::///////////////////////////////////////////////
//:: Poison Weapon spellscript
//:: x2_s2_poisonwp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell allows to add temporary poison properties
    to a melee weapon or stack of arrows

    The exact details of the poison are loaded from
    a 2da defined in prc_x2_itemprop X2_IP_POSIONWEAPON_2DA
    taken from the row that matches the last three letters
    of GetTag(GetSpellCastItem())

    Example: if an item is given the poison weapon property
             and its tag ending on 004, the 4th row of the
             2da will be used (1d2IntDmg DC14 18 seconds)

             Rows 0 to 99 are bioware reserved

    Non Assassins have a chance of poisoning themselves
    when handling an item with this spell

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
#include "prc_ipfeat_const"
#include "prc_class_const"

int GetIsSlashingWeapon(object oItem)
{
    int iWeapType = StringToInt(Get2DACache("baseitems", "WeaponType", GetBaseItemType(oItem)));

    if (iWeapType == 3 || iWeapType == 4) // slashing or slashing & piercing
        return TRUE;
    else
        return FALSE;
}

void main()
{

  object oItem   = GetSpellCastItem();
  object oPC     = OBJECT_SELF;
  object oTarget = PRCGetSpellTargetObject();
  string sTag    = GetTag(oItem);

  if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
  {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  }
  int nType = GetBaseItemType(oTarget);
  if (!GetIsSlashingWeapon(oTarget))
  {
       FloatingTextStringOnCreature("You may only target slashing melee weapons.", oPC);         //"Invalid target "
       return;
  }

    float nDuration = HoursToSeconds(2);

    itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_NIGHTSHADEPOISON,2);
   IPSafeAddItemProperty(oTarget, ip,nDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
   IPSafeAddItemProperty(oTarget, ItemPropertyLimitUseByClass(CLASS_TYPE_NIGHTSHADE),nDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);

   effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);

       FloatingTextStrRefOnCreature(83361,oPC);         //"Weapon is coated with poison"
       IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID),nDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,FALSE);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));


}
