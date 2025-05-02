/*
   ----------------
   Control Object

   prc_pow_ctrlobj
   ----------------

   31/7/05 by Stratovarius
*/ /** @file

    Control Object

    Psychokinesis
    Level: Kineticist 1
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One unattended object
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You telekinetically “bring to life” an inanimate object. Though it is not
    actually alive, the object moves under your control. If it is a weapon, it
    deals the weapons damage plus your Intelligence modifier, otherwise it deals
    1d6 plus your intelligence modifier. This power only works on weapons and
    armour.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void ControlObject(object oManifester, object oItem, float fDuration)
{
        int i = 1;
        object oHench = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oManifester, i);

        while (GetIsObjectValid(oHench))
        {
            if (GetResRef(oHench) == "psi_ctrlobj")
            {
                break;
            }
            i += 1;
            oHench = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oManifester, i);
        }
        //Apply hardness to object
        effect ePhysical1 = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 10);
        effect ePhysical2 = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10);
        effect ePhysical3 = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 10);
        
        // Link effects
        effect eLink = EffectLinkEffects(ePhysical1, ePhysical2);
        eLink = EffectLinkEffects(eLink, ePhysical3);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oHench, fDuration, FALSE, -1, -1);
     
        if (GetObjectType(oItem) == OBJECT_TYPE_ITEM)
        {
            CopyItem(oItem, oHench, FALSE);
            DestroyObject(oItem);
        }
        int nWeap = GetWeaponDamageType(oItem);
        if (nWeap != -1)
        {
            ForceEquip(oHench, oItem, INVENTORY_SLOT_RIGHTHAND);
        }
        else
        {
            ForceEquip(oHench, oItem, INVENTORY_SLOT_CHEST);
        }

        int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oManifester);
        // Work around for the damage bonus
        int nDam;
        if (nInt >= 50) 	 nDam = DAMAGE_BONUS_50;
        else if (nInt == 49) nDam = DAMAGE_BONUS_49;
        else if (nInt == 48) nDam = DAMAGE_BONUS_48;
        else if (nInt == 47) nDam = DAMAGE_BONUS_47;
        else if (nInt == 46) nDam = DAMAGE_BONUS_46;
        else if (nInt == 45) nDam = DAMAGE_BONUS_45;
        else if (nInt == 44) nDam = DAMAGE_BONUS_44;
        else if (nInt == 43) nDam = DAMAGE_BONUS_43;
        else if (nInt == 42) nDam = DAMAGE_BONUS_42;
        else if (nInt == 41) nDam = DAMAGE_BONUS_41;
        else if (nInt == 40) nDam = DAMAGE_BONUS_40;
        else if (nInt == 39) nDam = DAMAGE_BONUS_39;
        else if (nInt == 38) nDam = DAMAGE_BONUS_38;
        else if (nInt == 37) nDam = DAMAGE_BONUS_37;
        else if (nInt == 36) nDam = DAMAGE_BONUS_36;
        else if (nInt == 35) nDam = DAMAGE_BONUS_35;
        else if (nInt == 34) nDam = DAMAGE_BONUS_34;
        else if (nInt == 33) nDam = DAMAGE_BONUS_33;
        else if (nInt == 32) nDam = DAMAGE_BONUS_32;
        else if (nInt == 31) nDam = DAMAGE_BONUS_31;
        else if (nInt == 30) nDam = DAMAGE_BONUS_30;
        else if (nInt == 29) nDam = DAMAGE_BONUS_29;
        else if (nInt == 28) nDam = DAMAGE_BONUS_28;
        else if (nInt == 27) nDam = DAMAGE_BONUS_27;
        else if (nInt == 26) nDam = DAMAGE_BONUS_26;
        else if (nInt == 25) nDam = DAMAGE_BONUS_25;
        else if (nInt == 24) nDam = DAMAGE_BONUS_24;
        else if (nInt == 23) nDam = DAMAGE_BONUS_23;
        else if (nInt == 22) nDam = DAMAGE_BONUS_22;
        else if (nInt == 21) nDam = DAMAGE_BONUS_21;
        else if (nInt >= 20) nDam = DAMAGE_BONUS_20;
        else if (nInt == 19) nDam = DAMAGE_BONUS_19;
        else if (nInt == 18) nDam = DAMAGE_BONUS_18;
        else if (nInt == 17) nDam = DAMAGE_BONUS_17;
        else if (nInt == 16) nDam = DAMAGE_BONUS_16;
        else if (nInt == 15) nDam = DAMAGE_BONUS_15;
        else if (nInt == 14) nDam = DAMAGE_BONUS_14;
        else if (nInt == 13) nDam = DAMAGE_BONUS_13;
        else if (nInt == 12) nDam = DAMAGE_BONUS_12;
        else if (nInt == 11) nDam = DAMAGE_BONUS_11;
        else if (nInt == 10) nDam = DAMAGE_BONUS_10;
        else if (nInt == 9) nDam = DAMAGE_BONUS_9;
        else if (nInt == 8) nDam = DAMAGE_BONUS_8;
        else if (nInt == 7) nDam = DAMAGE_BONUS_7;
        else if (nInt == 6) nDam = DAMAGE_BONUS_6;
        else if (nInt == 5) nDam = DAMAGE_BONUS_5;
        else if (nInt == 4) nDam = DAMAGE_BONUS_4;
        else if (nInt == 3) nDam = DAMAGE_BONUS_3;
        else if (nInt == 2) nDam = DAMAGE_BONUS_2;
        else if (nInt == 1) nDam = DAMAGE_BONUS_1;
        // Null line in the 2da
        else nDam = 0;

        effect eAttack = EffectAttackIncrease(nInt + GetBaseAttackBonus(oManifester));
        effect eDam = EffectDamageIncrease(nDam, DAMAGE_TYPE_BASE_WEAPON);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttack, oHench);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oHench);
}        

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
    object oItem       = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oItem,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        float fDuration = (6.0f * manif.nManifesterLevel) + 6.0f; //So the creature can do something
        if(manif.bExtend) fDuration *= 2;
        MultisummonPreSummon();
        effect eSummon = EffectSummonCreature("psi_ctrlobj", VFX_FNF_SUMMON_CELESTIAL);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetLocation(oManifester), fDuration);
        
        DelayCommand(1.0,ControlObject(oManifester, oItem, fDuration)); //Make sure the creature is summoned first
    }// end if - Successfull manifestation
}
