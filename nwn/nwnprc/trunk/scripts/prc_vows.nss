//
//Sacred Vow, Vow of Obedience by Aser
//
//x - moved to prc_feats.nss

#include "prc_alterations"

///Sacred Vow +2 on Persuade /////////
/*void Sacred_Vow(object oPC ,object oSkin ,int iLevel)
{
   if(GetLocalInt(oSkin, "SacredVow") == iLevel) return;

    SetCompositeBonus(oSkin, "SacredPer", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
}

///Vow of Obedience +4 on Will Saves /////////
void Vow_Obed(object oPC ,object oSkin ,int iLevel)
{
   if(GetLocalInt(oSkin, "VowObed") == iLevel) return;

    SetCompositeBonus(oSkin, "VowObed", iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_WILL);
}*/

void main()
{
/*    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
  //  int bSacVow,bVowObed;

    int bSacVow = GetHasFeat(FEAT_SAC_VOW, oPC) ? 2 : 0;
    int bVowObed = GetHasFeat(FEAT_VOW_OBED, oPC) ? 4 : 0;

   if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
    {
    if(bSacVow > 0) Sacred_Vow(oPC, oSkin,bSacVow);
    }
     else
      {
       Sacred_Vow(oPC, oSkin,0);
      }

   if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD
        && GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
    {
    if(bVowObed > 0) Vow_Obed(oPC, oSkin,bVowObed);
    }
     else
      {
      Vow_Obed(oPC, oSkin,0);
      }
*/
}