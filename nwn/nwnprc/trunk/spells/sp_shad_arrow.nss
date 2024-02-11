//::///////////////////////////////////////////////
//:: Name      Shadow Arrow
//:: FileName  sp_shad_arrow.nss
//:://////////////////////////////////////////////
/**@file Shadow Arrow
Necromancy
Level: Assassin 4, ranger 4
Components: V, M
Casting Time: 1 swift action
Range: Long
Target: One creature
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

This spell is cast upon a masterwork arrow or bolt, transforming
it into pure black shadow. Make a ranged touch attack with the
missile instead of a normal ranged attack. Instead of dealing
normal damage, a shadow arrow deals 1d6 points of Strength
damage. 

Material Component: Masterwork arrow or bolt.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_craft_inc"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oAmmo;
        int nType = GetBaseItemType(oWeap);
        int nCasterLvl = PRCGetCasterLevel(oPC);

        //Has to be a bow of some sort
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
        nStack--;
        SetItemStackSize(oAmmo, nStack);

        int nTouch = PRCDoRangedTouchAttack(oTarget);

        if(nTouch)
        {
                if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                {
                        ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(1), DURATION_TYPE_PERMANENT, TRUE, 0.0f, FALSE, oPC);
                }
        }

        PRCSetSchool();
}