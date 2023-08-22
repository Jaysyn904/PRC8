//::///////////////////////////////////////////////
//:: Name      Sonic Shield
//:: FileName  sp_sonic_shld.nss
//:://////////////////////////////////////////////
/**@file Sonic Shield
Evocation
Level: Bard 3, duskblade 5, sorcerer/wizard 5
Components: V,S
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level

This spell grants you a +4 deflection bonus to AC.
In addition, anyone who successfully hits you with
a melee attack takes 1d8 points of sonic damage 
and must make a Fortitude saving throw or be
knocked 5 feet away from you into an unoccupied
space of your choice. If no space of sufficient
size is available for it to enter, it instead
takes an extra 1d8 points of sonic damage.
**/
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = RoundsToSeconds(nCasterLvl);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur += fDur;

    PRCSignalSpellEvent(oPC, FALSE, SPELL_SONIC_SHIELD, oPC);

    PRCRemoveEffectsFromSpell(oPC, SPELL_SONIC_SHIELD);

    effect eLink = EffectDamageShield(0, DAMAGE_BONUS_1d8, DAMAGE_TYPE_SONIC);
           eLink = EffectLinkEffects(eLink, EffectACIncrease(4, AC_DEFLECTION_BONUS));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_ENERGY_SONIC));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);

    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if(!GetIsObjectValid(oArmor))
        oArmor = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    itemproperty ipOnHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
    IPSafeAddItemProperty(oArmor, ipOnHit, fDur);

    //Add event script
    AddEventScript(oArmor, EVENT_ITEM_ONHIT, "prc_evnt_snshld", TRUE, FALSE);

    PRCSetSchool();
}