/*
   ----------------
   Bolt

   psi_pow_bolt
   ----------------

   29/10/04 by Stratovarius
*/ /** @file

    Bolt

    Metacreativity (Creation)
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: 0 ft.
    Effect: A stack of 99 normal bolts, arrows, or sling bullets
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Twin

    You create a stack of arrows, bolts, or sling bullets. Ammunition has a +1 enhancement bonus.
    The type of ammunition created depends on what weapon is equipped. Bows produce arrows, slings bullets,
    and all others create bolts.

    Augment: For every 3 additional power points spent, the enhancement increases by +1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       3, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oManifester);
        object oAmmo;
        float fBonusDur = 9999.9;

        // Calculate the enhancement bonus
        int nBonus = 1 + manif.nTimesAugOptUsed_1;
        int nDamageBonusConst;

        if     (nBonus == 1)  nDamageBonusConst = DAMAGE_BONUS_1;  // 1  PP
        else if(nBonus == 2)  nDamageBonusConst = DAMAGE_BONUS_2;  // 4  PP
        else if(nBonus == 3)  nDamageBonusConst = DAMAGE_BONUS_3;  // 7  PP
        else if(nBonus == 4)  nDamageBonusConst = DAMAGE_BONUS_4;  // 10 PP
        else if(nBonus == 5)  nDamageBonusConst = DAMAGE_BONUS_5;  // 13 PP
        else if(nBonus == 6)  nDamageBonusConst = DAMAGE_BONUS_6;  // 16 PP
        else if(nBonus == 7)  nDamageBonusConst = DAMAGE_BONUS_7;  // 19 PP
        else if(nBonus == 8)  nDamageBonusConst = DAMAGE_BONUS_8;  // 22 PP
        else if(nBonus == 9)  nDamageBonusConst = DAMAGE_BONUS_9;  // 25 PP
        else if(nBonus == 10) nDamageBonusConst = DAMAGE_BONUS_10; // 28 PP
        else if(nBonus == 11) nDamageBonusConst = DAMAGE_BONUS_11; // 31 PP
        else if(nBonus == 12) nDamageBonusConst = DAMAGE_BONUS_12; // 34 PP
        else if(nBonus == 13) nDamageBonusConst = DAMAGE_BONUS_13; // 37 PP
        else if(nBonus == 14) nDamageBonusConst = DAMAGE_BONUS_14; // 40 PP
        else if(nBonus == 15) nDamageBonusConst = DAMAGE_BONUS_15; // 43 PP
        else if(nBonus == 16) nDamageBonusConst = DAMAGE_BONUS_16; // 49 PP

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Create the ammo and apply the bonus
            if(GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
            {
                oAmmo = CreateItemOnObject("NW_WAMAR001", oTarget, 99);
                DelayCommand(1.0, AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, nBonus), oAmmo, fBonusDur));
            }
            else if(GetBaseItemType(oWeapon) == BASE_ITEM_SLING)
            {
                oAmmo = CreateItemOnObject("NW_WAMBU001", oTarget, 99);
                DelayCommand(1.0, AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, nBonus), oAmmo, fBonusDur));
            }
            else // Create crossbow stuff as default, since Psions can always wield one
            {
                oAmmo = CreateItemOnObject("NW_WAMBO001", oTarget, 99);
                DelayCommand(1.0, AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, nBonus), oAmmo, fBonusDur));
            }

            DelayCommand(1.0, AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nBonus), oAmmo, fBonusDur));

            // Identify the ammo
            SetIdentified(oAmmo, TRUE);
        }// end for - Twin Power
    }
}
