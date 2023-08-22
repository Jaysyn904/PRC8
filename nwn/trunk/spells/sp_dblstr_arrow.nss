//::///////////////////////////////////////////////
//:: Name      Doublestrike Arrow
//:: FileName  sp_dblstr_arrow.nss
//:://////////////////////////////////////////////
/**@file Doublestrike Arrow
Transmutation
Level: Ranger 4
Components: V, S, M
Casting Time: 1 swift action
Range: Long
Target: Two creatures within a 30 foot radius of each other.
Duration: 1 round
Saving Throw: None
Spell Resistance: No

When you cast this spell, you fire 1 masterwork or
magical arrow or bolt and enable it to strike two targets
instead of one. After striking or missing the first
target, the arrow swerves and continues on course to 
the second target, which must be within 30 feet of the original.
The attacker makes a separate attack roll against each target
(using the same attack bonus). 

A doublestrike missile cannot hit the same target twice, and it
is destroyed even if it misses its intended targets.

Material Component: Arrow or bolt.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_craft_inc"
#include "prc_inc_combat"

void main()
{
        if(!X2PreSpellCastCode()) return;
                
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        object oAmmo;
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        int nType = GetBaseItemType(oWeapon);
        effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
        
        if(nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
        {
                oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
        }
        
        else if (nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
        {
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
        }
        
        else
        {
                PRCSetSchool();
                return;
        } 
        
        //Check for Masterwork or magical
        string sMaterial = GetStringLeft(GetTag(oAmmo), 3);
        
        if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oAmmo)))
        {
                PRCSetSchool();
                return;
        }       
        
        int nStack = GetItemStackSize(oAmmo);
        
        //if last arrow, give an extra arrow
        if(nStack == 1)
        {
                SetItemStackSize(oAmmo, nStack + 1);
        }
        
        else DelayCommand(1.0, SetItemStackSize(oAmmo, nStack - 1));
        
        //Hit the first
        PerformAttack(oTarget, oPC, eVis);
        
        object oTarget2 = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oTarget), OBJECT_TYPE_CREATURE);
        
        //Not the same creature
        if(oTarget2 == oTarget) oTarget2 = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oTarget), OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget2))
        {
                if(!GetIsReactionTypeFriendly(oTarget))
                {
                        //Hit the Second
                        PerformAttack(oTarget, oPC, eVis);
                        break;
                        oTarget2 = OBJECT_INVALID;
                }
                
                else oTarget2 = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oTarget), OBJECT_TYPE_CREATURE);
        }
        
        PRCSetSchool();
}