//::///////////////////////////////////////////////
//:: Dragon Devotee
//:: prc_dragdev.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Dragon Devotees
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 22, 2007
//:://////////////////////////////////////////////

#include "prc_inc_template"
#include "prc_inc_natweap"

void main()
{
  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);

  int nClass = GetLevelByClass(CLASS_TYPE_DRAGON_DEVOTEE, oPC);
  int nDraDis = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC);

  //apply stat bonuses, but not if they got the half-dragon/Dragon Disciple bonus
  //Draconic template(from Dragon Devotee) is part of half-dragon template(from Dragon Disciple)
  /*if(!GetHasTemplate(TEMPLATE_HALF_DRAGON))
  {
    if(nDraDis < 10 && !GetPersistantLocalInt(oPC, "NWNX_DraDevCha"))
        SetCompositeBonus(oSkin, "Devotee_CHA", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

    if (nClass > 2 && nDraDis < 7 && !GetPersistantLocalInt(oPC, "NWNX_DraDevCon"))
        SetCompositeBonus(oSkin, "Devotee_CON", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);

    if (nClass > 4 && nDraDis < 2 && !GetPersistantLocalInt(oPC, "NWNX_DraDevStr"))
        SetCompositeBonus(oSkin, "Devotee_STR", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
  }*/

  if (GetHasFeat(FEAT_DEVOTEE_CLAWS, oPC))
  {
       IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_CREATURE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
             string sResRef = "prc_devclaw_";
             sResRef += GetAffixForSize(PRCGetCreatureSize(oPC));
             AddNaturalPrimaryWeapon(oPC, sResRef, 2, TRUE);
  }

  if (GetHasFeat(FEAT_DRACONIC_DEVOTEE, oPC))
  {
      IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
      SetCompositeBonus(oSkin, "Devotee_Spot", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
      SetCompositeBonus(oSkin, "Devotee_Intim", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
  }
}
