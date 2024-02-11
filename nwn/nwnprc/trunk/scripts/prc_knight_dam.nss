#include "prc_inc_spells"

int GetDSWeaponAttackBonus(object oWeap)
{
    object oPC = GetItemPossessor(oWeap);
    itemproperty ip = GetFirstItemProperty(oWeap);

    int iTotal = 0;
    int iValue = 0;

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS ||
            GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            iValue = GetItemPropertyCostTableValue(ip);
            iTotal = (iValue > iTotal) ? iValue : iTotal;
        }
        else if (GetItemPropertyType(ip) == ITEM_PROPERTY_HOLY_AVENGER &&
                 GetLevelByClass(CLASS_TYPE_PALADIN, oPC))
        {
            iValue = 5;
            iTotal = (iValue > iTotal) ? iValue : iTotal;
        }
        ip = GetNextItemProperty(oWeap);
    }

    return iTotal;
}

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    PRCRemoveEffectsFromSpell(oPC, GetSpellId());

    // thankfully damage effects actually use the IP_CONST_DAMAGEBONUS constants too! :)  Thus
    // you can apply non-bioware damage bonuses as defined in the 2da.
    int iDivBonus = GetHasFeat(DEMONSLAYING_1, oPC) ? IP_CONST_DAMAGEBONUS_1d6 : 0;
        iDivBonus = GetHasFeat(DEMONSLAYING_2, oPC) ? IP_CONST_DAMAGEBONUS_2d6 : iDivBonus;
        iDivBonus = GetHasFeat(DEMONSLAYING_3, oPC) ? IP_CONST_DAMAGEBONUS_3d6 : iDivBonus;
        iDivBonus = GetHasFeat(DEMONSLAYING_4, oPC) ? IP_CONST_DAMAGEBONUS_4d6 : iDivBonus;

    int iAttBonus = GetHasFeat(DEMONSLAYING_1, oPC) ? 1 : 0;
        iAttBonus = GetHasFeat(DEMONSLAYING_2, oPC) ? 2 : iAttBonus;
        iAttBonus = GetHasFeat(DEMONSLAYING_3, oPC) ? 3 : iAttBonus;
        iAttBonus = GetHasFeat(DEMONSLAYING_4, oPC) ? 4 : iAttBonus;

    int iAttBonusR = iAttBonus + GetDSWeaponAttackBonus(oWeap1);
    int iAttBonusL = iAttBonus + GetDSWeaponAttackBonus(oWeap2);

    effect eDam = VersusRacialTypeEffect(EffectDamageIncrease(iDivBonus, DAMAGE_TYPE_DIVINE), RACIAL_TYPE_OUTSIDER);
    effect eAttR = VersusRacialTypeEffect(EffectAttackIncrease(iAttBonusR, ATTACK_BONUS_ONHAND), RACIAL_TYPE_OUTSIDER);
    effect eAttL = VersusRacialTypeEffect(EffectAttackIncrease(iAttBonusL, ATTACK_BONUS_OFFHAND), RACIAL_TYPE_OUTSIDER);

    effect eLink = EffectLinkEffects(eAttR, eAttL);
           eLink = EffectLinkEffects(eLink, eDam);

           eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

