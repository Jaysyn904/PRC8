/*
Bronze Body for Zuriel
Swift-action toggle granting canonical Tenser's Transformation (+4 enhancement bonus to
Strength, Dexterity, and Constitution, +4 natural armor bonus to AC, +5 competence bonus on
Fortitude saves, proficiency with all simple and martial weapons, base attack bonus equal to
character level / Hit Dice, and 100% arcane/spellcasting failure while active) for up to
1 round per Effective Binder Level per day (non-consecutive).
While active, Forceful Speed of Thought cannot be used. Ending or exhausting Bronze Body
starts a 5-round cooldown.
*/
#include "bnd_inc_bndfunc"

void RemoveBronzeBodyWeaponProficiencies(object oBinder)
{
    object oSkin = GetPCSkin(oBinder);
    if (!GetIsObjectValid(oSkin)) return;

    int bRemSimple = GetLocalInt(oBinder, "ZurielBBAddedSimpleProf");
    int bRemMartial = GetLocalInt(oBinder, "ZurielBBAddedMartialProf");
    DeleteLocalInt(oBinder, "ZurielBBAddedSimpleProf");
    DeleteLocalInt(oBinder, "ZurielBBAddedMartialProf");

    if (!bRemSimple && !bRemMartial) return;

    itemproperty ipTest = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ipTest))
    {
        if (GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT &&
            GetItemPropertyDurationType(ipTest) == DURATION_TYPE_TEMPORARY)
        {
            int nSub = GetItemPropertyCostTableValue(ipTest);
            if (bRemSimple && nSub == IP_CONST_FEAT_WEAPON_PROF_SIMPLE)
            {
                RemoveItemProperty(oSkin, ipTest);
                bRemSimple = FALSE;
            }
            else if (bRemMartial && nSub == IP_CONST_FEAT_WEAPON_PROF_MARTIAL)
            {
                RemoveItemProperty(oSkin, ipTest);
                bRemMartial = FALSE;
            }
        }
        ipTest = GetNextItemProperty(oSkin);
    }
}

void EndBronzeBody(object oBinder, int bStartCooldown, string sMsg = "Zuriel's Bronze Body has ended.")
{
    if (!GetLocalInt(oBinder, "ZurielBronzeBodyActive")) return;
    DeleteLocalInt(oBinder, "ZurielBronzeBodyActive");
    SetLocalInt(oBinder, "ZurielBronzeBodyGen", GetLocalInt(oBinder, "ZurielBronzeBodyGen") + 1);
    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "ZurielBronzeBodyEff")
            RemoveEffect(oBinder, eCheck);
        eCheck = GetNextEffect(oBinder);
    }
    RemoveBronzeBodyWeaponProficiencies(oBinder);
    ExecuteScript("prc_bab_caller", oBinder);
    if (bStartCooldown)
        BindAbilCooldown(oBinder, VESTIGE_ZURIEL_BRONZE_BODY_SPELL, VESTIGE_ZURIEL);
    if (sMsg != "")
        FloatingTextStringOnCreature(sMsg, oBinder, FALSE);
}

void BronzeBodyTick(object oBinder, int nGen)
{
    if (!GetIsObjectValid(oBinder)
        || !GetLocalInt(oBinder, "ZurielBronzeBodyActive")
        || GetLocalInt(oBinder, "ZurielBronzeBodyGen") != nGen)
        return;

    if (!GetHasSpellEffect(VESTIGE_ZURIEL, oBinder) || GetIsDead(oBinder))
    {
        EndBronzeBody(oBinder, FALSE, "Zuriel's Bronze Body fades.");
        return;
    }

    int nEBL = GetBinderLevel(oBinder, VESTIGE_ZURIEL);
    int nUsed = GetLocalInt(oBinder, "ZurielBronzeBodyRoundsUsed") + 1;
    SetLocalInt(oBinder, "ZurielBronzeBodyRoundsUsed", nUsed);
    int nRem = nEBL - nUsed;

    if (nRem <= 0)
    {
        DelayCommand(5.8f, EndBronzeBody(
            oBinder,
            TRUE,
            "Zuriel's Bronze Body: daily duration exhausted (" + IntToString(nEBL) + "/" + IntToString(nEBL) + " rounds used)."
        ));
        return;
    }

    DelayCommand(6.0f, BronzeBodyTick(oBinder, nGen));
}

void main()
{
    object oBinder = OBJECT_SELF;
    int nEBL = GetBinderLevel(oBinder, VESTIGE_ZURIEL);

    if (GetLocalInt(oBinder, "ZurielBronzeBodyActive"))
    {
        int nRem = PRCMax(0, nEBL - GetLocalInt(oBinder, "ZurielBronzeBodyRoundsUsed"));
        EndBronzeBody(
            oBinder,
            TRUE,
            "Zuriel's Bronze Body dismissed (" + IntToString(nRem) + "/" + IntToString(nEBL) + " daily rounds remaining)."
        );
        return;
    }

    if (GetLocalInt(oBinder, "Bind" + IntToString(VESTIGE_ZURIEL_BRONZE_BODY_SPELL)))
    {
        if (!BindAbilCooldown(oBinder, VESTIGE_ZURIEL_BRONZE_BODY_SPELL, VESTIGE_ZURIEL))
            return;
    }

    int nUsed = GetLocalInt(oBinder, "ZurielBronzeBodyRoundsUsed");
    if (nUsed >= nEBL)
    {
        FloatingTextStringOnCreature(
            "Zuriel's Bronze Body: All " + IntToString(nEBL) + " daily rounds have been expended until you rest.",
            oBinder, FALSE
        );
        return;
    }

    int nRem = nEBL - nUsed;
    float fDur = RoundsToSeconds(nRem);
    int nAtkBonus = PRCMax(0, GetHitDice(oBinder) - GetBaseAttackBonus(oBinder));

    effect eBuff = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
    eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
    eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
    eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
    eBuff = EffectLinkEffects(eBuff, EffectACIncrease(4, AC_NATURAL_BONUS));
    eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_FORT, 5));
    eBuff = EffectLinkEffects(eBuff, EffectSpellFailure(100));
    if (nAtkBonus > 0)
        eBuff = EffectLinkEffects(eBuff, EffectAttackIncrease(nAtkBonus));
    eBuff = TagEffect(SupernaturalEffect(eBuff), "ZurielBronzeBodyEff");

    object oSkin = GetPCSkin(oBinder);
    if (GetIsObjectValid(oSkin))
    {
        if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oBinder))
        {
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            SetLocalInt(oBinder, "ZurielBBAddedSimpleProf", TRUE);
        }
        if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oBinder))
        {
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            SetLocalInt(oBinder, "ZurielBBAddedMartialProf", TRUE);
        }
    }

    SetLocalInt(oBinder, "ZurielBronzeBodyActive", TRUE);
    int nGen = GetLocalInt(oBinder, "ZurielBronzeBodyGen") + 1;
    SetLocalInt(oBinder, "ZurielBronzeBodyGen", nGen);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oBinder, fDur);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oBinder);
    ExecuteScript("prc_bab_caller", oBinder);
    FloatingTextStringOnCreature(
        "Activated Zuriel's Bronze Body (" + IntToString(nRem) + "/" + IntToString(nEBL) + " daily rounds available; activate again to dismiss).",
        oBinder, FALSE
    );
    BronzeBodyTick(oBinder, nGen);
}
