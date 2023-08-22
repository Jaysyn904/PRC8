//::///////////////////////////////////////////////
//:: Name Dragonwrack
//:: FileName ft_dw_weap.nss
//:://////////////////////////////////////////////
/*
    Dragonwrack for the Vassal of Bahamut's Weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Created On: 5 april 2004
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_alterations"

void main()
{
     int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);
     object oTarget = PRCGetSpellTargetObject();
     int iDam;
     effect eDam;
     if (nVassal == 10)
     {
     iDam = d6(4);
     }
     else if (nVassal >= 7)
     {
     iDam = d6(3);
     }
     else if (nVassal >= 4)
     {
     iDam = d6(2);
     }
     eDam = EffectDamage(iDam, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
     if (MyPRCGetRacialType(oTarget)==RACIAL_TYPE_DRAGON)
     {
         if (GetAlignmentGoodEvil(oTarget)==ALIGNMENT_EVIL)
         {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
         }
     }
}