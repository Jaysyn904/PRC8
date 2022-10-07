//::///////////////////////////////////////////////
//:: Greater Magic Fang
//:: x0_s0_gmagicfang.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void CheckStillUnarmed(object oTarget)
{
    //only works if you have nothing in right & left hands
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget))
        || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
    {
        FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
        //remove other magic fang effects
        PRCRemoveSpellEffects(452, OBJECT_SELF, oTarget);
        PRCRemoveSpellEffects(453, OBJECT_SELF, oTarget);
        return; // has neither an animal companion
    }
    DelayCommand(1.0, CheckStillUnarmed(oTarget));    
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nPower = (nCasterLevel + 1) / 3;
    if (nPower > 5)
     nPower = 5;  // * max of +5 bonus
    int nDamagePower = DAMAGE_POWER_PLUS_ONE;

    switch (nPower)
    {
        case 1: nDamagePower = DAMAGE_POWER_PLUS_ONE; break;
        case 2: nDamagePower = DAMAGE_POWER_PLUS_TWO; break;
        case 3: nDamagePower = DAMAGE_POWER_PLUS_THREE; break;
        case 4: nDamagePower = DAMAGE_POWER_PLUS_FOUR; break;
        case 5: nDamagePower = DAMAGE_POWER_PLUS_FIVE; break;
    }
    //DoMagicFang(nPower, nDamagePower,nCasterLevel);
    //PRCversion
    object oTarget = PRCGetSpellTargetObject();
    //only works if you have nothing in right & left hands
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget))
        || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
    {
        FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
        return; // has neither an animal companion
    }
    //only works if target has monk levels
    //or has a creature weapon
    if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget))
        && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget))
        && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget))
        && !GetLevelByClass(CLASS_TYPE_MONK, oTarget))
    {
        FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
        return; // has neither an animal companion
    }

    //remove other magic fang effects
    PRCRemoveSpellEffects(452, OBJECT_SELF, oTarget);
    PRCRemoveSpellEffects(453, OBJECT_SELF, oTarget);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eAttack = EffectAttackIncrease(nPower);
    effect eDamage = EffectDamageIncrease(nPower);
    effect eReduction = EffectDamageReduction(nPower, nDamagePower); // * doing this because
                                                                     // * it creates a true
                                                                     // * enhancement bonus

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAttack, eDur);
    eLink = EffectLinkEffects(eLink, eDamage);
    eLink = EffectLinkEffects(eLink, eReduction);

    float fDuration = HoursToSeconds(nCasterLevel); // * Duration 1 hour/level
     if ((nMetaMagic & METAMAGIC_EXTEND))    //Duration is +100%
    {
         fDuration = fDuration * 2.0;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    DelayCommand(1.0, CheckStillUnarmed(oTarget));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
