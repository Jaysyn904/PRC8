#include "prc_x2_itemprop"

void main()
{
    object oAura = OBJECT_SELF;
    object oTarget = GetEnteringObject();
    object oMarshal = GetAreaOfEffectCreator();

    // Only apply to allies
    if(!GetIsFriend(oTarget, oMarshal))
        return;

    int nAuraID    = GetLocalInt(oAura, "SpellID");
    int nAuraBonus = GetLocalInt(oAura, "AuraBonus");

    effect eBonus = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    switch(nAuraID)
    {
        case SPELL_MAJAUR_MOT_ARDOR:{ //Motivate Ardor
            eBonus = EffectLinkEffects(eBonus, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nAuraBonus), DAMAGE_TYPE_SLASHING));
            break;}
        case SPELL_MAJAUR_MOT_CARE:{ //Motivate Care
            eBonus = EffectLinkEffects(eBonus, EffectACIncrease(nAuraBonus, AC_DODGE_BONUS));
            break;}
        case SPELL_MAJAUR_RES_TROOPS:{ //Resilient Troops
            eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_ALL, nAuraBonus, SAVING_THROW_TYPE_ALL));
            break;}
        case SPELL_MAJAUR_MOT_URGE:{ //Motivate Urgency
            int MarshSpeed = nAuraBonus * 15;
            if(GetHasFeat(FEAT_TYPE_ELEMENTAL, oMarshal) >= 10 && GetHasFeat(FEAT_BONDED_AIR, oMarshal))
                MarshSpeed += 30;
            if(MarshSpeed > 99) MarshSpeed = 99;
            eBonus = EffectLinkEffects(eBonus, EffectMovementSpeedIncrease(MarshSpeed));
            break;}
        case SPELL_MAJAUR_HARD_SOLDIER:{ //Hardy Soldiers
            eBonus = EffectLinkEffects(eBonus, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nAuraBonus));
            eBonus = EffectLinkEffects(eBonus, EffectDamageResistance(DAMAGE_TYPE_PIERCING, nAuraBonus));
            eBonus = EffectLinkEffects(eBonus, EffectDamageResistance(DAMAGE_TYPE_SLASHING, nAuraBonus));
            break;}
        case SPELL_MAJAUR_MOT_ATTACK:{ //Motivate Attack
            eBonus = EffectLinkEffects(eBonus, EffectAttackIncrease(nAuraBonus));
            break;}
        case SPELL_MAJAUR_STEAD_HAND:{ //Steady Hand
            if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
                eBonus = EffectLinkEffects(eBonus, EffectAttackIncrease(nAuraBonus));
            break;}
        /*case SPELL_MAJAUR_MOT_CHA:{ //Major Charisma Boost
            eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_CHARISMA, nAuraBonus));
            break;}
        case SPELL_MAJAUR_MOT_CON:{ //Major Constitution Boost
            eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_CONSTITUTION, nAuraBonus));
            break;}
        case SPELL_MAJAUR_MOT_DEX:{ //Major Dexterity Boost
            eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_DEXTERITY, nAuraBonus));
            break;}
        case SPELL_MAJAUR_MOT_INT:{ //Major Intelligence Boost
            eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nAuraBonus));
            break;}
        case SPELL_MAJAUR_MOT_STR:{ //Major Strength Boost
            eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_STRENGTH, nAuraBonus));
            break;}
        case SPELL_MAJAUR_MOT_WIS:{ //Major Wisdom Boost
            eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_WISDOM, nAuraBonus));
            break;}*/
    }

    eBonus = ExtraordinaryEffect(eBonus);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}