#include "prc_alterations"

int isSimple(object oItem)
{
    if(DEBUG) DoDebug("prc_intuiatk: Running isSimple()");
      int iType= GetBaseItemType(oItem);

      switch (iType)
      {
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SHORTSPEAR:
        //case BASE_ITEM_HEAVYCROSSBOW:
          return 1;
          break;
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_SICKLE:
        //case BASE_ITEM_SLING:
        //case BASE_ITEM_DART:
        //case BASE_ITEM_LIGHTCROSSBOW:
          return 2;
          break;

      }
      return 0;
}

int isLight(object oItem)
{
    if(DEBUG) DoDebug("prc_intuiatk: Running isLight()");
     // weapon finesse works with dagger, handaxe, kama,
     // kukri, light hammer, mace, rapier, short sword,
     // whip, and unarmed strike.
     int iType = GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_WHIP:
            return TRUE;
            break;
     }
     return FALSE;
}

void main()
{
    if(DEBUG) DoDebug("prc_intuiatk: Running main()");
   //object oPC = PRCGetSpellTargetObject();
   object oPC = OBJECT_SELF; // This should only be called via ExecuteScript on the target, so...
   object oSkin = GetPCSkin(oPC);

   if (GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC) || GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(FEAT_RAVAGEGOLDENICE)))
   {
    if(DEBUG) DoDebug("prc_intuiatk: PC has Ravage: Golden Ice");
       int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
       object oItem;

       if (iEquip == 1)
            oItem = GetItemLastUnequipped();
       else
            oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);


       if (iEquip == 1||GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
       {
          if (GetBaseItemType(oItem)==BASE_ITEM_GLOVES)
             RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
       }
       else
       {
         oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
         AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oItem);
       }

        object oCweapB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
        object oCweapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
        object oCweapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
        RemoveSpecificProperty(oCweapB,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapL,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapR,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);

        if (GetAlignmentGoodEvil(oPC)== ALIGNMENT_GOOD)
        {
			itemproperty ip1 = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2);
				         ip1 = TagItemProperty(ip1,"GoldenIce");
			AddItemProperty(DURATION_TYPE_PERMANENT,ip1,oCweapB);
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip1,oCweapL);
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip1,oCweapR);
        }


   }

   if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC) || GetHasFeat(FEAT_WEAPON_FINESSE, oPC) || GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(FEAT_INTUITIVE_ATTACK)))
   {
    if(DEBUG) DoDebug("prc_intuiatk: PC has Intuitive Attack or WepFinesse");
	
      // shorthand - IA is intuitive attack and WF is weapon finesse
      object oItem ;
      int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
      int iStr = GetAbilityModifier(ABILITY_STRENGTH,oPC);
      int iDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
      int iWis = GetAbilityModifier(ABILITY_WISDOM,oPC);
      int iIABonus = 0;
      int iWFBonus = 0;
      int bHasIA = GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC) || GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(FEAT_INTUITIVE_ATTACK));
      int bHasWF = GetHasFeat(FEAT_WEAPON_FINESSE, oPC);
      int bUseIA = FALSE;
      int bUseWF = FALSE;
      int bIsSimpleR = isSimple(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
      int bIsSimpleL = isSimple(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
      int bIsLightR = isLight(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
      int bIsLightL = isLight(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
      int bXBowEq = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_LIGHTCROSSBOW ||
                    GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_HEAVYCROSSBOW;
      int bUnarmed = GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == FALSE;
      int bCreWeap = bUnarmed && GetLocalInt(oPC, "UsingCreature") == TRUE;

    if(DEBUG) DoDebug("prc_intuiatk: Finished setting up ints");

      // Initialize all these values to 0:
      SetCompositeAttackBonus(oPC, "IntuitiveAttackR", 0, ATTACK_BONUS_ONHAND);
      SetCompositeAttackBonus(oPC, "IntuitiveAttackL", 0, ATTACK_BONUS_OFFHAND);
      SetCompositeAttackBonus(oPC, "IntuitiveAttackUnarmed", 0);
      SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", 0);

      // only consider Weapon Finesse if Dex is higher than Str
      if (bHasWF && iDex > iStr)
      {
          bUseWF = TRUE;
          iWFBonus = iDex - iStr;
          if(DEBUG) DoDebug("prc_intuiatk: Dex is greater than Str");
      }

      // only consider Intuitive Attack if Wis is higher than Str and character is good
      if (bHasIA && iWis > iStr && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
      {
          bUseIA = TRUE;
          iIABonus = iWis - iStr;
          if(DEBUG) DoDebug("prc_intuiatk: Wis is greater than Str + PC is Good");
      }

      // do not consider Intuitive Attack if the character is using a crossbow and the zen archery feat.
      if (GetHasFeat(FEAT_ZEN_ARCHERY, oPC) && bXBowEq)
      {
          bUseIA = FALSE;
          if(DEBUG) DoDebug("prc_intuiatk: PC is using a crossbow");
      }

      // If the character only has intuitive attack, add appropriate bonuses.
      if (bUseIA && !bUseWF)
      {
        if(DEBUG) DoDebug("prc_intuiatk: PC has only Intuitive Attack");
          if (bIsSimpleR)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iIABonus, ATTACK_BONUS_ONHAND);
          else if (bUnarmed)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackUnarmed", iIABonus);

          if (bIsSimpleL)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackL", iIABonus, ATTACK_BONUS_OFFHAND);
      }
      // If the character has both intuitive attack and weapon finesse, things can get hairy:
      else if (bUseWF && bUseIA)
      {
        if(DEBUG) DoDebug("prc_intuiatk: PC has both IA and WF");
          int iMod = (iWis > iDex) ? (iWis - iDex) : (0);

          if (bIsSimpleR && !bIsLightR)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iIABonus, ATTACK_BONUS_ONHAND);
          else if (bIsSimpleR && bIsLightR)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iMod, ATTACK_BONUS_ONHAND);

          if (bIsSimpleL && !bIsLightL)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackL", iIABonus, ATTACK_BONUS_OFFHAND);
          else if (bIsSimpleL && bIsLightL)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackL", iMod, ATTACK_BONUS_OFFHAND);

          if (bCreWeap)
          {
            if(DEBUG) DoDebug("prc_intuiatk: PC using creature weapon");

              if (iMod > 0)
                  SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", iIABonus); // This will be added by SPELL_UNARMED_ATTACK_PEN
//              else
//                  SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", iWFBonus); // This will be added by SPELL_UNARMED_ATTACK_PEN
          }
          else if (!bCreWeap && bUnarmed)
          {
            if(DEBUG) DoDebug("prc_intuiatk: PC has no creature weapon and is unarmed");
              SetCompositeAttackBonus(oPC, "IntuitiveAttackUnarmed", iMod);
          }
      }
      // If the character has only weapon finesse and a creature weapon
      else if (bUseWF && !bUseIA && bCreWeap)
      {
          //1.67 Bioware fixed this so it should be disabled
//          SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", iWFBonus); // This will be added by SPELL_UNARMED_ATTACK_PEN
      }
   }
   if(DEBUG) DoDebug("prc_intuiatk: Exiting");
}
