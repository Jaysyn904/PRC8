//::///////////////////////////////////////////////  
//:: Shou Disciple - Martial Flurry Light  
//:://////////////////////////////////////////////  
/*  
    This is the spell cast on the Shou to apply the effects  
*/  
//:://////////////////////////////////////////////  
//:: Created By: Stratovarius  
//:: Created On: March 4, 2006  
//:://////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_inc_combat"  
  
void main()  
{  
    object oPC = PRCGetSpellTargetObject();  
  
    // Removes effects  
    PRCRemoveEffectsFromSpell(oPC, GetSpellId());  
  
      
          string nMesL = "";  
          object oArmorL = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);  
          object oWeapRL = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);  
          object oWeapLL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);  
  
          int armorTypeL = GetArmorType(oArmorL);  
          int numAddAttacksL = 0;  
          int attackPenaltyL = 0;  
  
  
          if(GetLevelByClass(CLASS_TYPE_SHOU, oPC) > 2)  
          {  
              numAddAttacksL = 1;  
              attackPenaltyL = 2;  
              if(DEBUG) DoDebug("Shou Flurry Light: Shou level is greater or equal to 3");  
          }  
  
          if(GetLevelByClass(CLASS_TYPE_MONK, oPC) && GetIsMonkWeaponOrUnarmed(oWeapRL))  
          {  
              numAddAttacksL = 0;  
              attackPenaltyL = 0;  
              nMesL = "*No Extra Attacks Gained by via Monk weapons!*";  
              if(DEBUG) DoDebug("Shou Flurry Light: Monk weapon detected");  
          }  
  
    if (GetBaseItemType(oWeapRL) == BASE_ITEM_DAGGER || GetBaseItemType(oWeapRL) == BASE_ITEM_HANDAXE ||  
    GetBaseItemType(oWeapRL) == BASE_ITEM_LIGHTHAMMER || GetBaseItemType(oWeapRL) == BASE_ITEM_LIGHTMACE ||  
    GetBaseItemType(oWeapRL) == BASE_ITEM_KUKRI || GetBaseItemType(oWeapRL) == BASE_ITEM_SICKLE ||  
    GetBaseItemType(oWeapRL) == BASE_ITEM_WHIP || GetBaseItemType(oWeapRL) == BASE_ITEM_SHORTSWORD ||  
    GetBaseItemType(oWeapRL) == BASE_ITEM_INVALID)  
    {  
        if(DEBUG) DoDebug("Shou Flurry Light: Right hand weapon is light");  
            if (GetBaseItemType(oWeapLL) == BASE_ITEM_DAGGER || GetBaseItemType(oWeapLL) == BASE_ITEM_HANDAXE ||  
            GetBaseItemType(oWeapLL) == BASE_ITEM_LIGHTHAMMER || GetBaseItemType(oWeapLL) == BASE_ITEM_LIGHTMACE ||  
            GetBaseItemType(oWeapLL) == BASE_ITEM_KUKRI || GetBaseItemType(oWeapLL) == BASE_ITEM_SICKLE ||  
            GetBaseItemType(oWeapLL) == BASE_ITEM_WHIP || GetBaseItemType(oWeapLL) == BASE_ITEM_SHORTSWORD ||  
            GetBaseItemType(oWeapLL) == BASE_ITEM_INVALID)  
            {  
                if(DEBUG) DoDebug("Shou Flurry Light: Left hand weapon is light");  
  
            //check armor type  
            if(armorTypeL < ARMOR_TYPE_MEDIUM)  
            {  
                if(DEBUG) DoDebug("Shou Flurry Light: Armour is light");  
                effect addAttL = SupernaturalEffect( EffectModifyAttacks(numAddAttacksL) );  
                effect attPenL = SupernaturalEffect( EffectAttackDecrease(attackPenaltyL) );  
                effect eLinkL = EffectLinkEffects(addAttL, attPenL);  
				eLinkL = UnyieldingEffect(eLinkL);  
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkL, oPC);  
                SetLocalInt(oPC, "HasMFlurry", 2);  
                        nMesL = "*Martial Flurry Activated*";  
                        if(DEBUG) DoDebug("Shou Flurry Light: Applied Shou Flurry Effects");  
            }  
        }  
    }  
    else  
    {  
        nMesL = "*Invalid Weapon.  Ability Not Activated!*";  
    }  
  
    FloatingTextStringOnCreature(nMesL, oPC, FALSE);  
}