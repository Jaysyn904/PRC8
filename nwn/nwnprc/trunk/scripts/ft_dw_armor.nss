//::///////////////////////////////////////////////
//:: Name Dragonwrack
//:: FileName ft_dw_armor.nss
//:://////////////////////////////////////////////
/*
    Dragonwrack for the Vassal of Bahamut's Armor
*/
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Created On: 5 april 2004
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_inc_racial"
#include "prc_inc_nwscript"

void main()
{
     int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);
     object oTarget = PRCGetSpellTargetObject();
     int iDam;
     effect eDam;
     if (nVassal == 10)
     {
     iDam = d6(2);
     }
     else if (nVassal >= 4)
     {
     iDam = d6(1);
     }
     eDam = EffectDamage(iDam);
     if (MyPRCGetRacialType(oTarget)==RACIAL_TYPE_DRAGON)
     {
         if (GetAlignmentGoodEvil(oTarget)==ALIGNMENT_EVIL)
         {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
         }
     }
}