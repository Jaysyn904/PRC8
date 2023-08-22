//::///////////////////////////////////////////////
//:: [Dive Attack]
//:: [avar_dive.nss]
//:://////////////////////////////////////////////
/*
    -2 AC +2 attack, double damage with peircing weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Sept. 24, 2004
//:://////////////////////////////////////////////

#include "prc_inc_combat"
//#include "prc_inc_util"
#include "prc_inc_skills"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if(!GetIsObjectValid(oTarget))
    {
       FloatingTextStringOnCreature("Invalid Target for Dive Attack", oPC, FALSE);
       return;
    }

    // PnP rules use feet, might as well convert it now.
    float fDistance = MetersToFeet(GetDistanceBetween(oPC, oTarget));
    if(fDistance >= 7.0)
    {
        // perform the jump
        if(PerformJump(oPC, GetLocation(oTarget), FALSE))
        {
             effect eACpen = EffectACDecrease(2);
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACpen, oPC, 6.0);

             // get weapon information
             object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
             int iWeaponType = GetBaseItemType(oWeap);
             int iNumSides = StringToInt(Get2DACache("baseitems", "DieToRoll", iWeaponType));
             int iNumDice = StringToInt(Get2DACache("baseitems", "NumDice", iWeaponType));
             int iCritMult = GetWeaponCritcalMultiplier(oPC, oWeap);
             // deal double the damage
             if(GetWeaponDamageType(oWeap) == DAMAGE_TYPE_PIERCING)
                  iNumDice *= 2;

             struct BonusDamage sWeaponBonusDamage = GetWeaponBonusDamage(oWeap, oTarget);
             struct BonusDamage sSpellBonusDamage = GetMagicalBonusDamage(oPC, oTarget);

             // perform attack roll
             string sMes = "*Dive Attack Miss*";
             int iAttackRoll = GetAttackRoll(oTarget, oPC, oWeap, 0, 0, 2, TRUE, 3.1);
             int bIsCritical = iAttackRoll == 2;

             effect eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, 0, bIsCritical, iNumDice, iNumSides, iCritMult);

             if(iAttackRoll)
             {
                 sMes = "*Dive Attack Hit*";
                 DelayCommand(3.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
             }
             DelayCommand(3.3, FloatingTextStringOnCreature(sMes, oPC, FALSE));
        }
    }
    else
    {
        FloatingTextStringOnCreature("Too close for Dive Attack", oPC, FALSE);
    }
}
