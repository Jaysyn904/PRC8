#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"
#include "prc_inc_combat"

void SSNNegAttack(object oTarget, object oInitiator)
{
    int nLevels = GetLocalInt(oInitiator, "SSN_NEG_LEVELS");
    effect eNone, eLink, eVis;

    PerformAttackRound(oTarget, oInitiator, eNone);
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
        eVis  = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        eLink = SupernaturalEffect(EffectNegativeLevel(1));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1));

        // Heal us
        eVis  = EffectVisualEffect(VFX_IMP_HEALING_L);
        eLink = SupernaturalEffect(EffectHeal(5));
        eLink = EffectLinkEffects(eVis, eLink);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oInitiator);

        // Tally hits
        SetLocalInt(oInitiator, "SSN_NEG_LEVELS", ++nLevels);
    }
}

void BalanceLightDarkCon(object oInitiator)
{
    int nDam = GetLocalInt(oInitiator, "SSN_NEG_LEVELS");
    if(DEBUG) DoDebug("Negative attack hits: " + IntToString(nDam));
    if(nDam > 0)
    {
        // Con damage
        effect eVis  = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        effect eLink = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oInitiator);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, HoursToSeconds(1));
    }
}

void main()
{
    int nEvent = GetRunningEvent();
    int nID    = GetSpellId();
    int nCount;
    object oInitiator = OBJECT_SELF;
    object oTarget    = PRCGetSpellTargetObject();
    object oItem      = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);

    if(nID == SSN_BALANCELD_ATTACK)
    {
        if(!GetLocalInt(oInitiator, "SSN_BalanceLD_Activated"))
        {
            FloatingTextStringOnCreature("*You are not transformed by Balance of Light and Dark*", oInitiator, FALSE);
            return;
        }
        if(!GetIsUnarmed(oInitiator))
        {
            FloatingTextStringOnCreature("*You must be unarmed to use this ability*", oInitiator, FALSE);
            return;
        }
        SSNNegAttack(oTarget, oInitiator);
        return; // Skip the rest
    }

    if (GetWeaponRanged(oItem))
    {
        FloatingTextStringOnCreature("You must use a melee weapon for this ability", oInitiator, FALSE);
        return;
    } // Has to be a melee weapon
    // We aren't being called from any event, perform setup
    if(nEvent == FALSE)
    {
        if(!TakeSwiftAction(oInitiator)) return;
        effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
        effect eMindImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
        effect eDeathImmune = EffectImmunity(IMMUNITY_TYPE_DEATH);
        effect ePoisonImmune = EffectImmunity(IMMUNITY_TYPE_POISON);
        effect eHide =  EffectSkillIncrease(SKILL_HIDE, 8);
        effect eAOE = EffectVisualEffect(VFX_DUR_DARKNESS);

        effect eLink = EffectLinkEffects(eMindImmune, eCritImmune);
        eLink = EffectLinkEffects(eLink, eDeathImmune);
        eLink = EffectLinkEffects(eLink, ePoisonImmune);
        eLink = EffectLinkEffects(eLink, eHide);
        eLink = EffectLinkEffects(eLink, eAOE);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, TurnsToSeconds(1));

        // Let us use the attack
        SetLocalInt(oInitiator, "SSN_BalanceLD_Activated", TRUE);
        DelayCommand(TurnsToSeconds(1), BalanceLightDarkCon(oInitiator));
    }
}