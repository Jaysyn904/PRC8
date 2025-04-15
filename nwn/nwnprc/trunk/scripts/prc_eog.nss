//::///////////////////////////////////////////////
//:: Eye of Gruumsh
//:://////////////////////////////////////////////
/*
    Script to modify skin of Eye of Gruumsh
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: July 19, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"


//:: Ritual Scarring Natural AC bonus now handled in cls_stat_eog.2da

/* void ApplyRitualScarringDefense(object oPC, object oSkin)
{
    int iEOGLevel = GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH, oPC);
    int ACBonus = 0;
    
    // For levels 3 and above, scale the bonus indefinitely:
    // Level 3-5: bonus = 1; Level 6-8: bonus = 2; Level 9-11: bonus = 3; etc.
    if (iEOGLevel >= 3)
    {
        ACBonus = iEOGLevel / 3;
    }
    
    itemproperty ipACBonus = ItemPropertyACBonus(ACBonus);
    
    SetCompositeBonus(oSkin, "RitualScarringDefenseBonus", ACBonus, ITEM_PROPERTY_AC_BONUS);   
    SetLocalInt(oPC, "HasRitualScarring", 2);
}
 */
/* void ApplyRitualScarringDefense(object oPC, object oSkin)
{       
     int ACBonus = 0;
     int iEOGLevel = GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH, oPC);
     
     if(iEOGLevel >= 3 && iEOGLevel < 6)
     {
          ACBonus = 1; 
     }     
     else if(iEOGLevel >= 6 && iEOGLevel < 9)
     {
          ACBonus = 2;
     }          
     else if(iEOGLevel >= 9)
     {
          ACBonus = 3;  
     }

     itemproperty ipACBonus = ItemPropertyACBonus(ACBonus);
     
     SetCompositeBonus(oSkin, "RitualScarringDefenseBonus", ACBonus, ITEM_PROPERTY_AC_BONUS);   
     SetLocalInt(oPC, "HasRitualScarring", 2);
} */

/* void RemoveRitualScarringDefense(object oPC, object oSkin)
{     
     SetCompositeBonus(oSkin, "RitualScarringDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
     SetLocalInt(oPC, "HasRitualScarring", 1);
} */

void ApplySightOfGruumsh(object oPC, object oSkin)
{ 
     SetCompositeBonus(oSkin, "SightOfGruumshFortBonus", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
     SetCompositeBonus(oSkin, "SightOfGruumshRefBonus",  2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
     SetCompositeBonus(oSkin, "SightOfGruumshWillBonus", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);

     SetLocalInt(oPC, "HasSightOfGruumsh", 2);     
}

void RemoveSightOfGruumsh(object oPC, object oSkin)
{     
     SetCompositeBonus(oSkin, "SightOfGruumshFortBonus", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
     SetCompositeBonus(oSkin, "SightOfGruumshRefBonus",  0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
     SetCompositeBonus(oSkin, "SightOfGruumshWillBonus", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);

     SetLocalInt(oPC, "HasSightOfGruumsh", 1);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    
    string nMes = "";

    // On Error Remove effects
    // This typically occurs On Load
    // Because the variables are not yet set.
    if(GetLocalInt(oPC, "HasRitualScarring") == 0 || GetLocalInt(oPC, "HasSightOfGruumsh") == 0 )
    {
         //RemoveRitualScarringDefense(oPC, oSkin);
         RemoveSightOfGruumsh(oPC, oSkin);
         
         if(GetHasFeat(FEAT_SIGHT_OF_GRUUMSH, oPC) )
         {
              ApplySightOfGruumsh(oPC, oSkin);
         }
    }
    // Apply effects
    else
    {
          // Is only called if Sight Of Gruumsh has been previously removed
          // this prevents it from being called every level up since it never changes once you get it.
          if(GetLocalInt(oPC, "HasSightOfGruumsh") == 1 && GetHasFeat(FEAT_SIGHT_OF_GRUUMSH, oPC) )
          {
               ApplySightOfGruumsh(oPC, oSkin);
          }

          /*// Is called anytime Ritual might have been upgraded
          // specifically set this way for level up
          if(GetLocalInt(oPC, "HasRitualScarring") != 0 && GetHasFeat(FEAT_RITUAL_SCARRING, oPC) )
          {
               RemoveRitualScarringDefense(oPC, oSkin);
               ApplyRitualScarringDefense(oPC, oSkin);
          }*/
     }
}
