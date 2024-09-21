#include "prc_class_const"
#include "prc_feat_const"
#include "prc_spell_const"
#include "inc_item_props"
//#include "prc_misc_const"
#include "inc_utility"

int GetIsBladesongWeapon(object oWeapon)
{
    if(!GetIsObjectValid(oWeapon))
        return FALSE;

    int nType = GetBaseItemType(oWeapon);

    return nType == BASE_ITEM_RAPIER
         || nType == BASE_ITEM_LONGSWORD
         || nType == BASE_ITEM_ELVEN_LIGHTBLADE
         || nType == BASE_ITEM_ELVEN_THINBLADE;
}

void RemoveSpellEffectSong(object oPC)
{
    effect eff = GetFirstEffect(oPC);

    while(GetIsEffectValid(eff))
    {
        if(GetEffectSpellId(eff) == SPELL_SONG_OF_FURY)
            RemoveEffect(oPC, eff);

        eff = GetNextEffect(oPC);
    }
}

void OnEquip(object oPC,object oSkin)
{
    // 1 longsword/rapier & light armour
    if(!GetIsBladesongWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))
    || GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) > 3)
    {
        if(GetHasFeatEffect(FEAT_SONG_OF_FURY, oPC))
             RemoveSpellEffectSong(oPC);

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
    }


    // Bonus Lvl BladeSinger Max Bonus Int
    int BladeLv = min(GetLevelByClass(CLASS_TYPE_BLADESINGER, oPC), GetAbilityModifier(ABILITY_INTELLIGENCE,oPC));

    SetCompositeBonus(oSkin, "BladesAC", BladeLv, ITEM_PROPERTY_AC_BONUS);

    if(GetHasFeat(FEAT_LESSER_SPELLSONG,oPC))
        SetCompositeBonus(oSkin, "BladesCon", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
}

void  OnUnEquip(object oPC,object oSkin)
{
  object oItem=GetItemLastUnequipped();

  object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
  object oWeapL=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

  if  (GetBaseAC(oArmor)>3)
  {
        if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

     SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
     SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
     return;
  }


  if (
       (GetIsObjectValid(oWeapL) && GetIsObjectValid(oWeapR) ) ||
       (!GetIsObjectValid(oWeapL) && !GetIsObjectValid(oWeapR) )
     )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
     }


  if (!(GetBaseItemType(oWeapL)==BASE_ITEM_RAPIER			||
		GetBaseItemType(oWeapR)==BASE_ITEM_RAPIER			||
		GetBaseItemType(oWeapL)==BASE_ITEM_ELVEN_THINBLADE	||
		GetBaseItemType(oWeapR)==BASE_ITEM_ELVEN_THINBLADE	||	
		GetBaseItemType(oWeapL)==BASE_ITEM_ELVEN_LIGHTBLADE	||
		GetBaseItemType(oWeapR)==BASE_ITEM_ELVEN_LIGHTBLADE	||			  
		GetBaseItemType(oWeapL)==BASE_ITEM_LONGSWORD		||
		GetBaseItemType(oWeapR)==BASE_ITEM_LONGSWORD) )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

        return;
     }



   int BladeLv=GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC);
   int Intb=GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);

   if ( BladeLv>Intb)
        BladeLv=Intb;

   SetCompositeBonus(oSkin, "BladesAC", BladeLv, ITEM_PROPERTY_AC_BONUS);

   if ( GetHasFeat(FEAT_LESSER_SPELLSONG,oPC))
     SetCompositeBonus(oSkin, "BladesCon", 5, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

}


void main()
{

  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
OnEquip(oPC,oSkin);
    //int iEquip = GetLocalInt(oPC,"ONEQUIP");

    //   if (iEquip !=1) OnEquip(oPC,oSkin);
    //   if (iEquip ==1) OnUnEquip(oPC,oSkin);

}
