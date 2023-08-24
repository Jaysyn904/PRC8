#include "inc_newspellbook"
#include "prc_inc_core"

void FavoriteEnemy(object oPC)
{
   ActionCastSpellOnSelf(SPELL_UR_FAVORITE_ENEMY);
}

void Grace(object oPC, object oSkin,int bGrace)
{
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
   int iBase = GetBaseAC(oArmor);
   int iMax = 3;
   if (GetHasFeat(FEAT_UR_ARMOREDGRACE,oPC)) iMax = 5;

   if  (GetBaseAC(oArmor)>iMax )
     SetCompositeBonus(oSkin,"URGrace",0,ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_REFLEX);
   else
     SetCompositeBonus(oSkin,"URGrace",bGrace,ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_REFLEX);

}

void BonusFeat(object oPC, object oSkin)
{
    if (GetHasFeat(FEAT_UR_FAST_MOVEMENT,oPC) && !GetHasFeat(FEAT_BARBARIAN_ENDURANCE,oPC) )
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_BarbEndurance),oSkin);
    if (GetHasFeat(FEAT_UNCANNYX_DODGE_1,oPC) && !GetHasFeat(FEAT_UNCANNY_DODGE_1,oPC) )
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1),oSkin);
    if (GetHasFeat(FEAT_UR_OWL_TOTEM,oPC) && !GetHasFeat(FEAT_ALERTNESS,oPC) )
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ALERTNESS),oSkin);
    if (GetHasFeat(FEAT_UR_OWL_TOTEM,oPC) && !GetHasFeat(FEAT_LOWLIGHTVISION,oPC) )
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION),oSkin);


}

void ViperTotem(object oSkin)
{
    if(GetLocalInt(oSkin, "URImmu") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oSkin);
    SetLocalInt(oSkin, "URImmu", TRUE);
}

void Snare(object oSkin)
{
   SetCompositeBonus(oSkin, "URSnare", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_TRAP);
}

void ApplyTwoWeaponDefense(object oPC, object oSkin)
{
     int ACBonus = 0;
     int tempestLevel = GetLevelByClass(CLASS_TYPE_TEMPEST, oPC);

     if(tempestLevel < 4)
     {
          ACBonus = 1;
     }
     else if(tempestLevel >= 4 && tempestLevel < 7)
     {
          ACBonus = 2;
     }
     else if(tempestLevel >= 7)
     {
          ACBonus = 3;
     }

     itemproperty ipACBonus = ItemPropertyACBonus(ACBonus);

     SetCompositeBonus(oSkin, "TwoWeaponDefenseBonus", ACBonus, ITEM_PROPERTY_AC_BONUS);

}

void RemoveTwoWeaponDefense(object oPC, object oSkin)
{
     SetCompositeBonus(oSkin, "TwoWeaponDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
}

void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iClass = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC);

    if (iClass>=2) FavoriteEnemy(oPC);

    int bGrace = GetHasFeat(FEAT_UR_GRACE1, oPC) ? 1 : 0;
        bGrace = GetHasFeat(FEAT_UR_GRACE2, oPC) ? 2 : bGrace;
        bGrace = GetHasFeat(FEAT_UR_GRACE3, oPC) ? 3 : bGrace;
        bGrace = GetHasFeat(FEAT_UR_GRACE4, oPC) ? 4 : bGrace;

    if (GetHasFeat(FEAT_UR_SNAREMASTERY,oPC)) Snare(oSkin);
    if (GetHasFeat(FEAT_UR_VIPER_TOTEM,oPC)) ViperTotem(oSkin);
    if (bGrace>0) Grace(oPC,oSkin,bGrace);
    BonusFeat( oPC, oSkin);
    //if (GetHasFeat(FEAT_UR_CAMOUFLAGE,oPC)) SetCompositeBonus(oSkin, "URCamouf", 5, ITEM_PROPERTY_SKILL_BONUS,SKILL_HIDE);


    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    int iEquip = GetLocalInt(oPC,"ONEQUIP");


    if (GetHasFeat(FEAT_TWO_WEAPON_DEFENSE,oPC))
    {
       int iType = GetBaseItemType(oWeapR);
       int iSize = StringToInt(Get2DACache("baseitems", "DieToRoll", iType));
       if(oWeapR == OBJECT_INVALID ||iType != 4 &&( oWeapL == OBJECT_INVALID ||
            GetBaseItemType(oWeapL) == BASE_ITEM_LARGESHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_TOWERSHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_SMALLSHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_TORCH))
       {

           SetCompositeBonus(oSkin, "TwoWeaponDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
           string nMes = "*Two-Weapon Defense Disabled Due To Invallid Weapon*";
           FloatingTextStringOnCreature(nMes, oPC, FALSE);
       }
       else
       {
      	  int iAC = GetHasFeat(FEAT_TWO_WEAPON_DEFENSE2,oPC) ? 2 : 1;
  	      iAC = GetHasFeat(FEAT_TWO_WEAPON_DEFENSE3,oPC) ? 3 : iAC;
          SetCompositeBonus(oSkin, "TwoWeaponDefenseBonus", iAC, ITEM_PROPERTY_AC_BONUS);
          string nMes = "*Two-Weapon Defense Activated*";
          FloatingTextStringOnCreature(nMes, oPC, FALSE);
       }
    }

}