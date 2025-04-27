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
//:: Updated By: Jaysyn
//:: Updated On: 2025-04-26 21:11:16
//:://////////////////////////////////////////////

/* 	Dragonwrack (Su): Evil dragons that strike a vassal of Bahamut or 
	are struck by him suffer grievous wounds. At 4th level, a vassal 
	of Bahamut deals +2d6 points of damage with each successful 
	melee attack made against an evil creature of the dragon type. 
	Furthermore, any such creature that strikes the vassal with a 
	natural weapon or melee weapon takes 1d6 points of damage. At 
	7th level, the vassal deals +3d6 points of damage to evil dragons 
	an at 10th level, the damage increases to +4d6 points and 2d6 
	points, respectively. */
	

#include "prc_class_const"
#include "prc_alterations"

void main()
{
    int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);
    object oTarget = PRCGetSpellTargetObject();
    int iDam = 0;
    effect eDam;

    // Only start dealing bonus damage at 4th level
    if (nVassal >= 4)
    {
        iDam = d6(2 + ((nVassal - 4) / 3)); // 2d6 at 4th level, +1d6 every 3 levels
    }

    if (iDam > 0 && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_DRAGON)
    {
        if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
        {
            eDam = EffectDamage(iDam, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }
}


/* void main()
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
} */