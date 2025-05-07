#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_ipfeat_const"

// Runescarred Berserker
/*
const int FEAT_RIT_SCAR             = 2369;
const int FEAT_SPAWNFROST           = 2371;
const int FEAT_RIT_DR               = 2370;
*/
////Resistance Cold////
void ResCold(object oPC ,object oSkin ,int iLevel)
{
  //if(GetLocalInt(oSkin, "RuneCold") == iLevel) return;
  RemoveSpecificProperty(oSkin,ITEM_PROPERTY_DAMAGE_RESISTANCE,IP_CONST_DAMAGETYPE_COLD,GetLocalInt(oSkin, "RuneCold"));
  AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,iLevel),oSkin);
  SetLocalInt(oSkin, "RuneCold",iLevel);
}

///Ritual Scarring /////////
void RitScar(object oPC ,object oSkin, int iACBonus)
{
   if(GetLocalInt(oSkin, "RitScarAC") == iACBonus) return;

   SetCompositeBonus(oSkin, "RitScarAC", iACBonus, ITEM_PROPERTY_AC_BONUS);
}

/* void RitScar(object oPC ,object oSkin, int iLevel)
{
   if(GetLocalInt(oSkin, "RitScarAC") == iLevel) return;

    SetCompositeBonus(oSkin, "RitScarAC", iLevel,ITEM_PROPERTY_AC_BONUS);

} */

void RitDR(object oPC, object oSkin, int iDRAmount)
{
    // Remove previous DR
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION, GetLocalInt(oSkin, "RitScarDR"), IP_CONST_DAMAGEREDUCTION_20, 1, "RitScarDR");

    // Apply new DR
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20, GetDamageSoakConstant(iDRAmount)), oSkin);
    SetLocalInt(oSkin, "RitScarDR", iDRAmount);
}

/* void RitDR(object oPC, object oSkin, int iLevel)
{
   //if(GetLocalInt(oSkin, "RitScarDR") == iLevel) return;
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION, GetLocalInt(oSkin, "RitScarDR"), iLevel, 1, "RitScarDR");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20, iLevel), oSkin);
    SetLocalInt(oSkin, "RitScarDR", iLevel);
} */

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
	
	int nClassLevel = GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);

	// AC bonus: starts at 3rd level, +1 every 3 levels after
	int bRitScar = (nClassLevel >= 3) ? ((nClassLevel - 3) / 3 + 1) : 0;
	if (bRitScar > 0) RitScar(oPC, oSkin, bRitScar);

	// DR bonus: starts at 4th level, +1 every 3 levels after
	int bRitDR = (nClassLevel >= 4) ? ((nClassLevel - 4) / 3 + 1) : 0;
	if (bRitDR > 0) RitDR(oPC, oSkin, bRitDR);

/*     int bRitDR = GetHasFeat(FEAT_RIT_DR, oPC) ? IP_CONST_DAMAGESOAK_1_HP : 0;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 7)
     {
     bRitDR = IP_CONST_DAMAGESOAK_2_HP;
     }
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 10)
     {
     bRitDR = IP_CONST_DAMAGESOAK_3_HP;
     }

     int bRitScar=GetHasFeat(FEAT_RIT_SCAR, oPC) ? 1 : 0;
         bRitScar=GetHasFeat(FEAT_RIT_SCAR_2, oPC) ? 2 : bRitScar;
         bRitScar=GetHasFeat(FEAT_RIT_SCAR_3, oPC) ? 3 : bRitScar; */
     /*if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 6)
     {
     bRitScar = 2;
     }

     if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 9)
     {
     bRitScar = 3;
     }
     */
    int bResCold=GetHasFeat(FEAT_SPAWNFROST, oPC) ? IP_CONST_DAMAGERESIST_5 : 0;

    if (bResCold>0) ResCold(oPC,oSkin,bResCold);
    //if (bRitScar>0) RitScar(oPC, oSkin,bRitScar);
    if (bRitDR>0) RitDR(oPC, oSkin,bRitDR);

    //rest part to regenerate spells
    if(GetLocalInt(oPC,"ONREST"))
    {
        int nLevel1;
        int nLevel2;
        int nLevel3;
        int nLevel4;
        int nLevel5;
        switch(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC))
        {
            case  1: nLevel1 = 1; break; 
            case  2: nLevel1 = 2; break; 
            case  3: nLevel1 = 2; nLevel2 = 1; break; 
            case  4: nLevel1 = 3; nLevel2 = 2; break; 
            case  5: nLevel1 = 3; nLevel2 = 2; nLevel3 = 1; break; 
            case  6: nLevel1 = 3; nLevel2 = 3; nLevel3 = 2; break; 
            case  7: nLevel1 = 4; nLevel2 = 3; nLevel3 = 2; nLevel4 = 1; break; 
            case  8: nLevel1 = 4; nLevel2 = 3; nLevel3 = 3; nLevel4 = 2; break; 
            case  9: nLevel1 = 4; nLevel2 = 4; nLevel3 = 3; nLevel4 = 2; nLevel5 = 1; break; 
            case 10: nLevel1 = 4; nLevel2 = 4; nLevel3 = 3; nLevel4 = 3; nLevel5 = 2; break; 
        }
        SetLocalInt(oPC, "Runescar_slot_1", nLevel1);
        SetLocalInt(oPC, "Runescar_slot_2", nLevel2);
        SetLocalInt(oPC, "Runescar_slot_3", nLevel3);
        SetLocalInt(oPC, "Runescar_slot_4", nLevel4);
        SetLocalInt(oPC, "Runescar_slot_5", nLevel5);
    }

}