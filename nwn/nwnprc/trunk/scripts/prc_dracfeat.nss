//::///////////////////////////////////////////////
//:: Draconic Feats
//:: prc_dracfeat.nss
//::///////////////////////////////////////////////
/*
    Handles most of the Draconic series of feats from 
    Races of the Dragon and Dragon Magic
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////

#include "prc_inc_natweap"
#include "prc_x2_itemprop"


//internal function to calculate the number of Draconic feats
int CalculateDraconic(object oPC)
{
      int nDraconicFeats = 0;
      
      if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC))     nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_SKIN, oPC))            nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_KNOWLEDGE, oPC))       nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_VIGOR, oPC))           nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_ARMOR, oPC))           nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_PERSUADE, oPC))        nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_CLAW, oPC))            nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_PRESENCE, oPC))        nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_POWER, oPC))           nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_RESISTANCE, oPC))      nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_SENSES, oPC))          nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_GRACE, oPC))           nDraconicFeats++;
      if(GetHasFeat(FEAT_DRACONIC_BREATH, oPC))          nDraconicFeats++;
      if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC))        nDraconicFeats++;
      if(GetHasFeat(FEAT_DRAGONFIRE_ASSAULT, oPC))       nDraconicFeats++;
      if(GetHasFeat(FEAT_DRAGONFIRE_CHANNELING, oPC))    nDraconicFeats++;
      if(GetHasFeat(FEAT_DRAGONFIRE_INSPIRATION, oPC))   nDraconicFeats++;
         
      return nDraconicFeats;
}


void main()
{

        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        int nPower = CalculateDraconic(oPC);

///////////////////////////Dragontouched//////////////////////////
        
        if(GetHasFeat(FEAT_DRAGONTOUCHED, oPC))
        {
            SetCompositeBonus(oSkin, "DT_Search", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
            SetCompositeBonus(oSkin, "DT_Spot", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
            SetCompositeBonus(oSkin, "DT_Listen", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
        }
        
///////////////////////////Draconic Heritage//////////////////////////
        
        //+2 to Hide for Black, Blue, White, and Copper heritage
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Hide", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        }
        
        //+2 to Appraise for Red heritage
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Appraise", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_APPRAISE);
        }
        
        //+2 to Move Silently for Green heritage
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Move_Silent", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
        }
        
        //+2 to Persuade(Diplomacy) for Amethyst and Crystal heritage
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Persuade", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        }
        
        //+2 to Lore for Emerald, Sapphire, and Brass Heritage.  Brass should
        //have Gather Information, using Lore as substitute.
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Lore", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        }
        
        //+2 to Jump for Topaz, standing in for the +2 to Swim they should have
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Jump", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
        }
        
        //+2 to Search for Bronze, standing in for +2 to Survival
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Search", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        }
        
        //+2 to Heal for Gold heritage
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Heal", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
        }
        
        //+2 to Bluff for Silver heritage, standing in for +2 to Disguise
        if(GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Bluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        }
///////////////////////////Draconic Skin//////////////////////////
        if(GetHasFeat(FEAT_DRACONIC_SKIN, oPC))
        {
             SetCompositeBonus(oSkin, "DH_AC", 1, ITEM_PROPERTY_AC_BONUS);
        }
/////////////////////////Draconic Knowledge///////////////////////
        if(GetHasFeat(FEAT_DRACONIC_KNOWLEDGE, oPC))
        {
             SetCompositeBonus(oSkin, "DH_Knowledge", nPower, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        }
///////////////////////////Draconic Claw//////////////////////////
        if(GetHasFeat(FEAT_DRACONIC_CLAW, oPC))
        {
             IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_CREATURE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
             string sResRef = "prc_claw_1d6m_";
             int nSize = PRCGetCreatureSize(oPC);
             sResRef += GetAffixForSize(nSize);
             AddNaturalPrimaryWeapon(oPC, sResRef, 2, TRUE);
        }        
///////////////////////////Draconic Resistance//////////////////////////
        if(GetHasFeat(FEAT_DRACONIC_RESISTANCE, oPC))
        {
            //Note: Since Damage resistance in multiples of 3 isn't possible, dropped to 2.5 and rounded to the nearest 5.

            //Acid
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC))
            {
                 switch(nPower)
                 {
                    case 1:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 2:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 3:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 4:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 5:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 6:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 7:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 8:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 9:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 10: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 11: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 12: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break; 
                    case 13: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 14: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 15: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_40), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    default: break;
                 }
            }

            //Cold
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC))
            {
                 switch(nPower)
                 {
                    case 1:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 2:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 3:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 4:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 5:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 6:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 7:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 8:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 9:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 10: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 11: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 12: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break; 
                    case 13: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 14: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 15: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_40), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    default: break;
                 }
            }
            //Electric
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC))
            {
                 switch(nPower)
                 {
                    case 1:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 2:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 3:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 4:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 5:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 6:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 7:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 8:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 9:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 10: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 11: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 12: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break; 
                    case 13: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 14: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 15: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_40), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    default: break;
                 }
            }
            //Fire
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)
            || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC))
            {
                 switch(nPower)
                 {
                    case 1:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 2:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 3:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 4:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 5:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 6:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 7:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 8:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 9:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 10: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 11: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 12: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break; 
                    case 13: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 14: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 15: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_40), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    default: break;
                 }
            }
            //Sonic
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC))
            {
                 switch(nPower)
                 {
                    case 1:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 2:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 3:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 4:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 5:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 6:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_15), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 7:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 8:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 9:  IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 10: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_25), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 11: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 12: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_30), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break; 
                    case 13: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 14: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_35), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    case 15: IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_40), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
                    default: break;
                 }
            }           
        }
///////////////////////////Draconic Senses//////////////////////////
        if(GetHasFeat(FEAT_DRACONIC_SENSES, oPC))
        {
			effect eLow		= EffectBonusFeat(FEAT_DARKVISION);
			effect eDark 	= EffectBonusFeat(FEAT_LOWLIGHTVISION);
			//effect eUltra 	= EffectUltravision();
			effect eUltra		= EffectBonusFeat(FEAT_ULTRAVISION);
			effect eLink;
				
			if(DEBUG) DoDebug("Entering Draconic Senses Branch.  nPower is: "+IntToString(nPower)+".");
            switch(nPower)
            {
				case 1:							
                case 2:	
				{
					if(DEBUG) DoDebug("Draconic Senses Branch Case 1 & 2: Lowlight vision");
					//IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
					SPApplyEffectToObject(DURATION_TYPE_PERMANENT, UnyieldingEffect(eLow), oPC); 
					break;
				}				
                case 3:
				{				
					if(DEBUG) DoDebug("Draconic Senses Branch Case 3: Lowlight vision + Darkvision");
					//IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); break;
					eLink = EffectLinkEffects(eLow, eDark);						
					SPApplyEffectToObject(DURATION_TYPE_PERMANENT, UnyieldingEffect(eLink), oPC); 
					break;
				}                         
				//;: Using Ultravision as the ability is Blindsense, not Blindsight						 
                default:	
				{
					if(DEBUG) DoDebug("Draconic Senses Branch Default: Lowlight vision + Darkvision + Ultravsion");
					//IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);							
					eLink = EffectLinkEffects(eLow, eDark);	
					eLink = EffectLinkEffects(eUltra, eLink);
					SPApplyEffectToObject(DURATION_TYPE_PERMANENT, UnyieldingEffect(eLink), oPC); 
					break;
				}
            }
			if(DEBUG) DoDebug("Draconic Senses: Adding skill bonuses.");
            SetCompositeBonus(oSkin, "DS_Spot", nPower, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
            SetCompositeBonus(oSkin, "DS_Search", nPower, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
            SetCompositeBonus(oSkin, "DS_Listen", nPower, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
        }
/////////////////////Draconic Grace and Breath radials//////////////////////////
        if(GetHasFeat(FEAT_DRACONIC_GRACE, oPC))
        {
           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRACONIC_GRACE_1_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRACONIC_GRACE_6_9), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        else if(GetHasFeat(FEAT_DRACONIC_GRACE_1_5, oPC) || GetHasFeat(FEAT_DRACONIC_GRACE_6_9, oPC))
        {
           RemoveItemProperty(oSkin, ItemPropertyBonusFeat(FEAT_DRACONIC_GRACE_1_5));
           RemoveItemProperty(oSkin, ItemPropertyBonusFeat(FEAT_DRACONIC_GRACE_6_9));
        }

        if(GetHasFeat(FEAT_DRACONIC_BREATH, oPC))
        {
           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRACONIC_BREATH_1_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRACONIC_BREATH_6_9), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        else if(GetHasFeat(FEAT_DRACONIC_BREATH_1_5, oPC) || GetHasFeat(FEAT_DRACONIC_BREATH_6_9, oPC))
        {
           RemoveItemProperty(oSkin, ItemPropertyBonusFeat(FEAT_DRACONIC_BREATH_1_5));
           RemoveItemProperty(oSkin, ItemPropertyBonusFeat(FEAT_DRACONIC_BREATH_6_9));
        }
}