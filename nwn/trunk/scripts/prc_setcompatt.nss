
#include "prc_inc_spells"

void main()
{
    object oCastingObject = OBJECT_SELF;
    object oPC = PRCGetSpellTargetObject();

    string sBonus = GetLocalString(oCastingObject, "SET_COMPOSITE_STRING");

    int iVal     = GetLocalInt(oCastingObject, "SET_COMPOSITE_VALUE");
    int iSubType = GetLocalInt(oCastingObject, "SET_COMPOSITE_SUBTYPE");

    int iTotalR = GetLocalInt(oPC, "CompositeAttackBonusR");
    int iTotalL = GetLocalInt(oPC, "CompositeAttackBonusL");
    int iCur = GetLocalInt(oPC, sBonus);
    int iAB, iAP, iHand;

    PRCRemoveEffectsFromSpell(oPC, GetSpellId());

    switch (iSubType)
    {
        case ATTACK_BONUS_MISC:
            iTotalR -= iCur;
            iTotalL -= iCur;
            if (iTotalR + iVal > 20) iVal = 20 - iTotalR;
            if (iTotalL + iVal > 20) iVal = 20 - iTotalL;
            iTotalR += iVal;
            iTotalL += iVal;
            break;
        case ATTACK_BONUS_ONHAND:
            iTotalR -= iCur;
            if (iTotalR + iVal > 20) iVal = 20 - iTotalR;
            iTotalR += iVal;
            break;
        case ATTACK_BONUS_OFFHAND:
            iTotalL -= iCur;
            if (iTotalL + iVal > 20) iVal = 20 - iTotalL;
            iTotalL += iVal;
            break;
    }

    if (iTotalR > iTotalL)
    {
        iAB = iTotalR;
        iAP = iTotalR - iTotalL;
        iHand = ATTACK_BONUS_OFFHAND;
    }
    else
    {
        iAB = iTotalL;
        iAP = iTotalL - iTotalR;
        iHand = ATTACK_BONUS_ONHAND;
    }

    effect eAttack;
    if (iAB > 0)
        eAttack = EffectAttackIncrease(iAB);
    else if (iAB < 0)
        eAttack = EffectAttackDecrease(-1*iAB);

    eAttack = EffectLinkEffects(eAttack, EffectAttackDecrease(iAP, iHand));

    eAttack = ExtraordinaryEffect(eAttack);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, 9999.0);

    SetLocalInt(oPC, "CompositeAttackBonusR", iTotalR);
    SetLocalInt(oPC, "CompositeAttackBonusL", iTotalL);
    SetLocalInt(oPC, sBonus, iVal);
    UpdateUsedCompositeNamesList(oPC, "PRC_ComAttBon", sBonus);
}