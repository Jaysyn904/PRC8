/*
    x0_s0_magicfang

    +1 enhancement bonus to attack and damage rolls.
    Also applys damage reduction +1; this allows the creature
    to strike creatures with +1 damage reduction.

    Checks to see if a valid summoned monster or animal companion
    exists to apply the effects to. If none exists, then
    the spell is wasted.

    By: Brent Knowles
    Created: September 6, 2002
    Modified: Jun 29, 2006

    Flaming_Sword: cleaned up, added greater magic fang
*/

#include "prc_sp_func"


void CheckStillUnarmed(object oTarget)
{
    //only works if you have nothing in right & left hands
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget))
        || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
    {
        FloatingTextStrRefOnCreature(8962, oTarget, FALSE);
        //remove other magic fang effects
        PRCRemoveSpellEffects(452, OBJECT_SELF, oTarget);
        PRCRemoveSpellEffects(453, OBJECT_SELF, oTarget);
        return; // has neither an animal companion
    }
    DelayCommand(1.0, CheckStillUnarmed(oTarget));
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    int bNorm = (nSpellID == 452);

    int nPower = bNorm ? 1 : (nCasterLevel + 1) / 3;    //magic fang
    if (nPower > 5)
     nPower = 5;  // * max of +5 bonus
    int nDamagePower;

    switch (nPower)
    {
        case 1: nDamagePower = DAMAGE_POWER_PLUS_ONE; break;
        case 2: nDamagePower = DAMAGE_POWER_PLUS_TWO; break;
        case 3: nDamagePower = DAMAGE_POWER_PLUS_THREE; break;
        case 4: nDamagePower = DAMAGE_POWER_PLUS_FOUR; break;
        case 5: nDamagePower = DAMAGE_POWER_PLUS_FIVE; break;
    }

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget))
        || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
    {
        FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
        return TRUE; // has neither an animal companion
    }
    //only works if target has monk levels
    //or has a creature weapon
    if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget))
        && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget))
        && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget))
        && !GetLevelByClass(CLASS_TYPE_MONK, oTarget))
    {
        FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
        return TRUE; // has neither an animal companion
    }

    //remove other magic fang effects
    PRCRemoveSpellEffects(452, OBJECT_SELF, oTarget);
    PRCRemoveSpellEffects(453, OBJECT_SELF, oTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eLink = EffectLinkEffects(EffectAttackIncrease(nPower), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nPower));
    eLink = EffectLinkEffects(eLink, EffectDamageReduction(nPower, nDamagePower));

    float fDuration = bNorm ? TurnsToSeconds(nCasterLevel) : HoursToSeconds(nCasterLevel); // * Duration 1 hour/level
    if ((nMetaMagic & METAMAGIC_EXTEND))    //Duration is +100%
        fDuration = fDuration * 2.0;

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    DelayCommand(1.0, CheckStillUnarmed(oTarget));

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}