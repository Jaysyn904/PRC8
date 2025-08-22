//:://////////////////////////////////////////////////////////////////
//::
//::	prc_swarm_arrows.nss
//::
//:://////////////////////////////////////////////////////////////////
/*
	Swarm Of Arrows [Epic]
	
	Prerequisites
	Dex 23, Point Blank Shot, Rapid Shot, Weapon Focus (type of bow used).
	
	Benefit
	As a full-round action, you may fire an arrow at your full base attack bonus at each opponent within 30 feet. 
*/
#include "prc_x2_itemprop"
#include "prc_inc_util"
#include "prc_inc_combat"

// Swarm of Arrows implementation
void EpicSwarmOfArrows(object oAttacker)
{
    // Get right-hand weapon and ensure it's a bow
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
    int nWeaponType = GetBaseItemType(oWeapon);

    if (IPGetIsMeleeWeapon(oWeapon) || (nWeaponType != BASE_ITEM_LONGBOW && nWeaponType != BASE_ITEM_SHORTBOW))
    {
        SendMessageToPC(oAttacker, "You must be wielding a longbow or shortbow to use Swarm of Arrows.");
        return;
    }

    // Get equipped ammo from the ammo slot
    object oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oAttacker);
    int nStack = GetItemStackSize(oAmmo);

    if (!GetIsObjectValid(oAmmo) || nStack <= 0)
    {
        SendMessageToPC(oAttacker, "You are out of arrows!");
        return;
    }

    // Get location and orientation
    location lAttacker = GetLocation(oAttacker);
    float fRadius = FeetToMeters(30.0);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lAttacker, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != oAttacker && GetIsEnemy(oTarget, oAttacker))
        {
            // Must be in range, LOS, and seen by attacker
            if (GetDistanceBetween(oAttacker, oTarget) <= fRadius
                && LineOfSightObject(oAttacker, oTarget)
                && GetObjectSeen(oTarget, oAttacker))
            {
                // Check stack size again in case arrows are running low
                if (nStack <= 0)
                {
                    SendMessageToPC(oAttacker, "You are out of arrows!");
                    return;
                }

                // Consume one arrow
                if (nStack > 1)
                {
                    SetItemStackSize(oAmmo, nStack - 1);
                    nStack = nStack - 1;
                }
                else
                {
                    DestroyObject(oAmmo);
                    nStack = 0;
                }

                // Perform a single attack using full base attack bonus
                int iBAB = GetBaseAttackBonus(oAttacker);
                DelayCommand(0.0, PerformAttack(
                    oTarget,
                    oAttacker,
                    EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT),
                    0.0,
                    iBAB,
                    0,
                    DAMAGE_TYPE_PIERCING,
                    "*Swarm of Arrows Hit!*",
                    "*Swarm of Arrows Miss*"));
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lAttacker, TRUE, OBJECT_TYPE_CREATURE);
    }
}


void main()
{
    object oUser = OBJECT_SELF;
    if (!GetHasFeat(FEAT_EPIC_SWARM_OF_ARROWS, oUser))
    {
        SendMessageToPC(oUser, "You do not have the Swarm of Arrows feat.");
        return;
    }

    EpicSwarmOfArrows(oUser);
}