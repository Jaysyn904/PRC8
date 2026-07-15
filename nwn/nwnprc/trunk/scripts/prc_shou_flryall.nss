//::///////////////////////////////////////////////  
//:: Shou Disciple - Martial Flurry All  
//:://////////////////////////////////////////////  
/*  
    This is the spell cast on the Shou to apply the effects  
*/  
//:://////////////////////////////////////////////  
//:: Created By: Stratovarius  
//:: Created On: March 4, 2006  
//:://////////////////////////////////////////////  
#include "prc_alterations"  
#include "prc_inc_combat"  
  
void main()  
{  
    string nMesA = "";  
    object oPC = PRCGetSpellTargetObject();  
  
    //check armor type  
    if(GetArmorType(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) < ARMOR_TYPE_MEDIUM)  
    {  
        if(GetLevelByClass(CLASS_TYPE_SHOU, oPC) > 4 && isNotShield(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))  
        && !(GetLevelByClass(CLASS_TYPE_MONK, oPC) && GetIsMonkWeaponOrUnarmed(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))))  
        {  
            effect eLinkA = EffectLinkEffects(EffectModifyAttacks(1), EffectAttackDecrease(2));  
                   eLinkA = SupernaturalEffect(eLinkA);  
                   eLinkA = UnyieldingEffect(eLinkA);  
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkA, oPC);  
            nMesA = "*Martial Flurry Activated*";  
        }  
        else  
            nMesA = "*Invalid Weapon.  Ability Not Activated!*";  
    }  
    else  
        nMesA = "*Your armour is to heavy to use this ability*";  
  
    FloatingTextStringOnCreature(nMesA, oPC, FALSE);  
}