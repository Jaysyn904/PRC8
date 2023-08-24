//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_npc"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"

const int PACKAGE_ELEMENTAL_STR = PACKAGE_ELEMENTAL ;
const int PACKAGE_ELEMENTAL_DEX = PACKAGE_FEY ;


void ElementalFamiliar()
{

// add
    location loc = GetLocation(OBJECT_SELF);
    vector vloc = GetPositionFromLocation( loc );
    vector vLoc;
    location locSummon;

    vLoc = Vector( vloc.x + (Random(6) - 2.5f),
                       vloc.y + (Random(6) - 2.5f),
                       vloc.z );
        locSummon = Location( GetArea(OBJECT_SELF), vLoc, IntToFloat(Random(361) - 180) );

//

    object oPC = OBJECT_SELF;

    string iType = GetHasFeat(FEAT_BONDED_AIR, OBJECT_SELF)   ? "AIR"  : "" ;
           iType = GetHasFeat(FEAT_BONDED_EARTH, OBJECT_SELF) ? "EARTH"  : iType ;
           iType = GetHasFeat(FEAT_BONDED_FIRE, OBJECT_SELF)  ? "FIRE"  : iType ;
           iType = GetHasFeat(FEAT_BONDED_WATER, OBJECT_SELF) ? "WATER"  : iType ;

    string iSize = GetHasFeat(FEAT_ELE_COMPANION_MED, OBJECT_SELF) ? "MED"  : "" ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_LAR, OBJECT_SELF) ? "LAR"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_HUG, OBJECT_SELF) ? "HUG"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_GRE, OBJECT_SELF) ? "GRE"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_ELD, OBJECT_SELF) ? "ELD"  : iSize ;

    string sRef = "HEN_"+iType+"_"+iSize+"2";

    object oEle = CreateLocalNPC(OBJECT_SELF,ASSOCIATE_TYPE_FAMILIAR,sRef,locSummon,1);
    effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oEle));
    SetLocalObject(OBJECT_SELF, "BONDED",oEle);

    object oCreB=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oEle);
    object oCreL=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oEle);
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oEle);
    object oHide=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oEle);


    int iPack ,iSave ;
    int iHD = GetHitDice(OBJECT_SELF);
    int iBonus = (iHD/5)+1;

    if (iType=="FIRE")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEIMMUNITY_100_PERCENT),oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT),oHide);

        iPack = PACKAGE_ELEMENTAL_DEX ;
        iSave =  IP_CONST_SAVEBASETYPE_REFLEX ;

        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iBonus),oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus*2/3),oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_1d6),oCreB);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d6),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d6),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,2),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
    else if (iType=="WATER")
    {

       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus*2/3+1),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iBonus*2/3),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

       iPack = PACKAGE_ELEMENTAL_STR ;
       iSave =  IP_CONST_SAVEBASETYPE_FORTITUDE ;

         if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
 else if (iType=="AIR")
    {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iBonus),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus*2/3),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

        iPack = PACKAGE_ELEMENTAL_DEX ;
        iSave =  IP_CONST_SAVEBASETYPE_REFLEX ;


        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,5),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
    else if (iType=="EARTH")
    {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

        iPack = PACKAGE_ELEMENTAL_STR ;
        iSave =  IP_CONST_SAVEBASETYPE_FORTITUDE ;


        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oHide);

    int Arcanlvl = GetPrCAdjustedCasterLevelByType(TYPE_ARCANE) + GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER)/2;


   if (Arcanlvl>26)
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicSpecCreature),oHide);

    if (Arcanlvl>21)
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicFocCreature),oHide);

    if (Arcanlvl>11)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapSpecCreature),oHide);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,SupernaturalEffect(EffectSpellResistanceIncrease(Arcanlvl+5)),oEle);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_BarbEndurance),oHide);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oHide);
    }
    else  if (Arcanlvl>8)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oHide);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,SupernaturalEffect(EffectSpellResistanceIncrease(Arcanlvl+5)),oEle);
    }


   int i;
   for (i = 1; i < iHD; i++)
     LevelUpHenchman( oEle,CLASS_TYPE_ELEMENTAL,TRUE,iPack);

   object oCweap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oEle);
     if  (!GetIsObjectValid(oCweap))
        oCweap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oEle);
     if  (!GetIsObjectValid(oCweap))
        oCweap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oEle);


   int iSoak =-1;

   if (iSize=="LAR" || iSize=="HUG")
      iSoak = IP_CONST_DAMAGESOAK_5_HP;
   else if (iSize=="GRE" || iSize=="ELD")
      iSoak = IP_CONST_DAMAGESOAK_10_HP;
   if (iHD>24)  iSoak++;
   if (iHD>30)  iSoak++;


   if (iSoak>=0)
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,iSoak),oHide);



    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBonus),GetItemInSlot(INVENTORY_SLOT_NECK,oEle));
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBonus),oHide);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS,iBonus),oHide);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS,iBonus),oHide);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusSavingThrow(iSave,iBonus),oHide);

//  AddHenchman(OBJECT_SELF,oEle);
}

void main()
{
    if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
    {

      object oDes =  GetLocalObject(OBJECT_SELF, "BONDED");

      AssignCommand(oDes, SetIsDestroyable(TRUE));
      DestroyObject(oDes);
      DelayCommand(0.4,ElementalFamiliar());
       return;
    }



}
