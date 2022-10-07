//::///////////////////////////////////////////////
//:: Name      Claws of the Savage
//:: FileName  sp_claws_savage.nss
//:://////////////////////////////////////////////
/**@file Claws of the Savage
Transmutation [Evil]
Level: Bestial 4, Blk 4, Clr 4, Drd 4
Components: V, S
Casting Time: 1 action
Range: Touch
Target: One creature
Duration: 10 minutes/level

The caster grants one creature two long claws that
replace its hands, tentacle tips, or whatever
else is appropriate. The claws deal damage based
on the creature's size.

                Creature Size      Claw Damage

                Fine                  1

                Diminutive            ld2

                Tiny                  ld3

                Small                 ld4

                Medium-size           ld6

                Large                 ld8

                Huge                  2d6

                Gargantuan            2d8

                Colossal              4d6

The creature can make attacks with both claws as if
it were proficient with them. Just as with a
creature that has natural weapons, the subject
takes no penalty for making two claw attacks. The
subject is treated as armed. Furthermore, these
claws gain a +2 enhancement bonus on attack and
damage rolls.

If the creature already has claws, those claws gain
a +2 enhancement bonus on attack and damage rolls,
and the claws' damage increases as if the creature
were two size categories larger.


Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

object GetClawWeapon (object oCreature, string sResRef, int nInventorySlot, float fDuration);

#include "prc_inc_spells"
#include "prc_inc_unarmed"

void main()
{
    //Spellhook
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oLClaw, oRClaw;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nClawSize = PRCGetCreatureSize(oTarget);
    int nBaseDamage;
    float fDuration = 600.0f * nCasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nBonus = 2;

    //eval metamagic
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        fDuration = (fDuration * 2);
    }

    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nBonus = 3;
    }

    // Determine base damage
    switch(nClawSize)
    {
        case 0: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3; break;
        case 1: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d4; break;
        case 2: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d6; break;
        case 3: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d8; break;
        case 4: nBaseDamage = IP_CONST_MONSTERDAMAGE_2d6; break;
        case 5: nBaseDamage = IP_CONST_MONSTERDAMAGE_3d6; break;
        case 6: nBaseDamage = IP_CONST_MONSTERDAMAGE_4d6; break;
        case 7: nBaseDamage = IP_CONST_MONSTERDAMAGE_6d6; break;
    }

    //Check for existing claws, if so, nBaseDamage +=2
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget)))
    {
        nBaseDamage += nBonus;
    }

    // Get the creature weapon
    oLClaw = GetClawWeapon(oPC, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_L, fDuration);
    oRClaw = GetClawWeapon(oPC, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_R, fDuration);

    // Catch exceptions here
    if (nClawSize < 0) nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3;
    else if (nClawSize > 7) nBaseDamage = IP_CONST_MONSTERDAMAGE_6d6;

    // Add the base damage
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oLClaw, fDuration);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oRClaw, fDuration);

    //Add Enhancement Bonus
    IPSafeAddItemProperty(oLClaw, ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
    IPSafeAddItemProperty(oRClaw, ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);

    //SPEvilShift(oPC);
    PRCSetSchool();
}

object GetClawWeapon (object oCreature, string sResRef, int nInventorySlot, float fDuration)
{
    int bCreatedWeapon = FALSE;
    object oCWeapon = GetItemInSlot(nInventorySlot, oCreature);

    RemoveUnarmedAttackEffects(oCreature);
    // Make sure they can actually equip them
    UnarmedFeats(oCreature);

    // Determine if a creature weapon of the proper type already exists in the slot
    if(!GetIsObjectValid(oCWeapon)                                       ||
    GetStringUpperCase(GetTag(oCWeapon)) != GetStringUpperCase(sResRef)) // Hack: The resref's and tags of the PRC creature weapons are the same
    {
        if (GetHasItem(oCreature, sResRef))
        {
            oCWeapon = GetItemPossessedBy(oCreature, sResRef);
            SetIdentified(oCWeapon, TRUE);
            ForceEquip(oCreature, oCWeapon, nInventorySlot);
        }
        else
        {
            oCWeapon = CreateItemOnObject(sResRef, oCreature);
            SetIdentified(oCWeapon, TRUE);
            ForceEquip(oCreature, oCWeapon, nInventorySlot);
            bCreatedWeapon = TRUE;
        }
    }

    // Weapon finesse or intuitive attack?
    SetLocalInt(oCreature, "UsingCreature", TRUE);
    ExecuteScript("prc_intuiatk", oCreature);
    DelayCommand(1.0f, DeleteLocalInt(oCreature, "UsingCreature"));

    // Add OnHitCast: Unique if necessary
    if(GetHasFeat(FEAT_REND, oCreature))
    IPSafeAddItemProperty(oCWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    // This adds creature weapon finesse
    ApplyUnarmedAttackEffects(oCreature);

    // Destroy the weapon if it was created by this function
    if(bCreatedWeapon)
    DestroyObject(oCWeapon, (fDuration + 6.0));

    return oCWeapon;
}