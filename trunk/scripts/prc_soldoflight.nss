#include "prc_alterations"
#include "prc_feat_const"

void  PositiFor(object oSkin, int iGood)
{
  if (iGood !=ALIGNMENT_GOOD)
  {
    if(GetLocalInt(oSkin, "ImmuPF") == FALSE) return;

    RemoveSpecificProperty(oSkin,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS,IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
    RemoveSpecificProperty(oSkin,ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL,IP_CONST_SPELLSCHOOL_NECROMANCY);

    DeleteLocalInt(oSkin,"ImmuPF");
  }
  else
  {
     if(GetLocalInt(oSkin, "ImmuPF") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySchool(IP_CONST_SPELLSCHOOL_NECROMANCY), oSkin);
    SetLocalInt(oSkin, "ImmuPF", TRUE);

  }

}

void AddFastHealing(object oSkin,int iFH,int iGood)
{

  if (iGood !=ALIGNMENT_GOOD)
  {
    if(!GetLocalInt(oSkin, "SoLFH")) return;

    SetCompositeBonus(oSkin,"SoLFH",0,ITEM_PROPERTY_REGENERATION);
  }
  else
  {
     if(GetLocalInt(oSkin, "SoLFH") == iFH) return;

     SetCompositeBonus(oSkin,"SoLFH",iFH,ITEM_PROPERTY_REGENERATION);

  }

}
void main()
{

   //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iGood = GetAlignmentGoodEvil(oPC);

    int iPosFor = GetHasFeat(FEAT_POSITIVE_FORTITUDE,oPC);

    int iFH = GetHasFeat(FEAT_SOL_FAST_HEALING_1,oPC)+GetHasFeat(FEAT_SOL_FAST_HEALING_2,oPC)+GetHasFeat(FEAT_SOL_FAST_HEALING_3,oPC);

    PositiFor(oSkin,iGood);

    if (iFH) AddFastHealing(oSkin,iFH,iGood);

 }
