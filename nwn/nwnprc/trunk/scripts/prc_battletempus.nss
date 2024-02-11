#include "prc_alterations"
#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_class_const"

int FeatWeaponTempus(int iFeat)
{
     if (iFeat==FEAT_WEAPON_TEMPUS_CLUB        ) return(BASE_ITEM_CLUB);
     if (iFeat==FEAT_WEAPON_TEMPUS_DAGGER      ) return(BASE_ITEM_DAGGER);
     if (iFeat==FEAT_WEAPON_TEMPUS_MACE        ) return(BASE_ITEM_LIGHTMACE);
     if (iFeat==FEAT_WEAPON_TEMPUS_MORNINGSTAR ) return(BASE_ITEM_MORNINGSTAR);
     if (iFeat==FEAT_WEAPON_TEMPUS_QUARTERSTAFF) return(BASE_ITEM_QUARTERSTAFF);
     if (iFeat==FEAT_WEAPON_TEMPUS_SPEAR       ) return(BASE_ITEM_SHORTSPEAR);
     if (iFeat==FEAT_WEAPON_TEMPUS_SHORTSWORD  ) return(BASE_ITEM_SHORTSWORD);
     if (iFeat==FEAT_WEAPON_TEMPUS_RAPIER      ) return(BASE_ITEM_RAPIER);
     if (iFeat==FEAT_WEAPON_TEMPUS_SCIMITAR    ) return(BASE_ITEM_SCIMITAR);
     if (iFeat==FEAT_WEAPON_TEMPUS_LONGSWORD   ) return(BASE_ITEM_LONGSWORD);
     if (iFeat==FEAT_WEAPON_TEMPUS_GREATSWORD  ) return(BASE_ITEM_GREATSWORD);
     if (iFeat==FEAT_WEAPON_TEMPUS_HANDAXE     ) return(BASE_ITEM_HANDAXE);
     if (iFeat==FEAT_WEAPON_TEMPUS_BATTLEAXE   ) return(BASE_ITEM_BATTLEAXE);
     if (iFeat==FEAT_WEAPON_TEMPUS_GREATAXE    ) return(BASE_ITEM_GREATAXE);
     if (iFeat==FEAT_WEAPON_TEMPUS_HALBERD     ) return(BASE_ITEM_HALBERD);
     if (iFeat==FEAT_WEAPON_TEMPUS_LIGHTHAMMER ) return(BASE_ITEM_LIGHTHAMMER);
     if (iFeat==FEAT_WEAPON_TEMPUS_LIGHTFLAIL  ) return(BASE_ITEM_LIGHTFLAIL);
     if (iFeat==FEAT_WEAPON_TEMPUS_WARHAMMER   ) return(BASE_ITEM_WARHAMMER);
     if (iFeat==FEAT_WEAPON_TEMPUS_HEAVYFLAIL  ) return(BASE_ITEM_HEAVYFLAIL);
     if (iFeat==FEAT_WEAPON_TEMPUS_SCYTHE      ) return(BASE_ITEM_SCYTHE);
     if (iFeat==FEAT_WEAPON_TEMPUS_KATANA      ) return(BASE_ITEM_KATANA);
     if (iFeat==FEAT_WEAPON_TEMPUS_BASTARDSWORD) return(BASE_ITEM_BASTARDSWORD);
     if (iFeat==FEAT_WEAPON_TEMPUS_DIREMACE    ) return(BASE_ITEM_DIREMACE);
     if (iFeat==FEAT_WEAPON_TEMPUS_DOUBLEAXE   ) return(BASE_ITEM_DOUBLEAXE);
     if (iFeat==FEAT_WEAPON_TEMPUS_TWOBLADED   ) return(BASE_ITEM_TWOBLADEDSWORD);
     if (iFeat==FEAT_WEAPON_TEMPUS_KAMA        ) return(BASE_ITEM_KAMA);
     if (iFeat==FEAT_WEAPON_TEMPUS_KUKRI       ) return(BASE_ITEM_KUKRI);
     if (iFeat==FEAT_WEAPON_TEMPUS_SICKLE      ) return(BASE_ITEM_SICKLE);
     if (iFeat==FEAT_WEAPON_TEMPUS_DWARVENAXE  ) return(BASE_ITEM_DWARVENWARAXE);

   return BASE_ITEM_TORCH;
}

void WeaponTempus(object oPC,object oSkin)
{
  if (GetLocalInt(oSkin,"FEAT_WEAP_TEMPUS")) return;

  int iFeat;
  int iTempus=FEAT_WEAPON_TEMPUS_CLUB;
  while (!iFeat && (iTempus<FEAT_ARMY_POWER) )
  {
     // statements ...
     iFeat=GetHasFeat(iTempus, oPC);
     iTempus++;
  }

  if (iFeat)
      SetLocalInt(oSkin,"FEAT_WEAP_TEMPUS",FeatWeaponTempus(iTempus-1));
  else if (GetHasFeat(FEAT_WEAPON_TEMPUS_DWARVENAXE, oPC))
      SetLocalInt(oSkin,"FEAT_WEAP_TEMPUS",BASE_ITEM_DWARVENWARAXE);
  else if (GetHasFeat(FEAT_WEAPON_TEMPUS_SICKLE, oPC))
      SetLocalInt(oSkin,"FEAT_WEAP_TEMPUS",BASE_ITEM_SICKLE);

}

void KnowledgeLore(object oPC, object oSkin, int iLevel)
{
   if (GetLocalInt(oSkin,"Tempus_Lore")==iLevel) return;
   SetCompositeBonus(oSkin, "Tempus_Lore", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
}

void BattleForger(object oPC, object oSkin)
{
   if (GetLocalInt(oSkin,"BatForgerW")) return;
   SetCompositeBonus(oSkin, "BatForgerW", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_WEAPON);
   SetCompositeBonus(oSkin, "BatForgerA", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_ARMOR);


}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bForger = GetHasFeat(FEAT_BATTLEFORGER, oPC) ? 1 : 0;
    int level = GetLevelByClass(CLASS_TYPE_TEMPUS,oPC)+(GetAbilityModifier(ABILITY_INTELLIGENCE,oPC)>0?GetAbilityModifier(ABILITY_INTELLIGENCE,oPC):0);

    WeaponTempus(oPC, oSkin);
    KnowledgeLore(oPC, oSkin,level);
    if (bForger>0) BattleForger(oPC, oSkin);


}
