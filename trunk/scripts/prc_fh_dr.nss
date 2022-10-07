//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Foe Hunter DR
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_alterations"

void main()
{
     object oPC = OBJECT_SELF;
     object oFoe = GetLastDamager();
     
     int iFoeRace = MyPRCGetRacialType(oFoe);
     int iHatedFoe = GetLocalInt(oPC, "HatedFoe");

     int iDR = GetLocalInt(oPC, "HatedFoeDR");
     int iDamageTaken = GetTotalDamageDealt();
     
     int iHeal = 0;
          
     if(iFoeRace == iHatedFoe && iDamageTaken > 0)
     {
          // Prevents player from regaining more HP than damage taken
          if(iDamageTaken >= iDR)
          {
               iHeal = iDR;
          }
          else
          {
               iHeal = iDamageTaken;
          }
          
          effect eHeal = EffectHeal(iHeal);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
     }
}