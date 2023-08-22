#include "tob_inc_tobfunc"

int GetIsSupernaturalCurse(effect eEff)
{
    return GetTag(GetEffectCreator(eEff)) == "q6e_ShaorisFellTemple";
}

void DoReform(object oPC)
{
    int nType, nSubType;
    effect eBad = GetFirstEffect(oPC);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        nType = GetEffectType(eBad);
        if(nType == EFFECT_TYPE_ABILITY_DECREASE
        || nType == EFFECT_TYPE_BLINDNESS
        || nType == EFFECT_TYPE_DEAF
        || nType == EFFECT_TYPE_DISEASE
        || nType == EFFECT_TYPE_PARALYZE
        || nType == EFFECT_TYPE_POISON)
        {
            nSubType = GetEffectSubType(eBad);
            //Remove effect if it is negative.
            if(nSubType != SUBTYPE_EXTRAORDINARY
            && nSubType != SUBTYPE_SUPERNATURAL
            && !GetIsSupernaturalCurse(eBad))
                RemoveEffect(oPC, eBad);
        }
        eBad = GetNextEffect(oPC);
    }

    int nHeal = GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC);
    effect eHeal = EffectVisualEffect(VFX_IMP_HOLY_AID_DN_ORANGE);
           eHeal = EffectLinkEffects(eHeal, EffectHeal(nHeal));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);

    effect eDaze = EffectDazed();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oPC, 6.0);
}

void DoDeath(object oPC)
{
    float fDur = RoundsToSeconds(d6(1));

    effect eDeath = EffectLinkEffects(EffectCutsceneGhost(), EffectCutsceneParalyze());
           eDeath = EffectLinkEffects(eDeath, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
           eDeath = EffectLinkEffects(eDeath, EffectDamageImmunityAll());
           eDeath = EffectLinkEffects(eDeath, EffectEthereal());
           eDeath = EffectLinkEffects(eDeath, EffectSpellImmunity(SPELL_ALL_SPELLS));
           eDeath = SupernaturalEffect(eDeath);

    // Apply the effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeath, oPC, fDur);
    DelayCommand(fDur, DoReform(oPC));
}

void main()
{
    object oPC = OBJECT_SELF;
    location lTarget = GetLocation(oPC);
    float fRange = FeetToMeters(20.0);
    int nPenetr = PRCGetCasterLevel(oPC) + SPGetPenetr();
    int nDamage;

    //DoDebug("tob_jpm_emimmo: Calculating DC");
    int nDC = 19 + GetAbilityScoreForClass(GetPrimaryArcaneClass(oPC), oPC);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), lTarget);

    //Get first target in spell area
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
    //DoDebug("tob_jpm_emimmo: First target is: " + DebugObject2Str(oTarget));
    while(GetIsObjectValid(oTarget))
    {
        //DoDebug("tob_jpm_emimmo: Is target friendly? " + IntToString(GetIsReactionTypeFriendly(oTarget)));

        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC)
        {
            //DoDebug("tob_jpm_emimmo: Target is neutral or hostile");
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, FEAT_JPM_EMERALD_IMMOLATION));

            nDamage = PRCGetReflexAdjustedDamage(d6(20), oTarget, nDC, SAVING_THROW_TYPE_FIRE);

            if(nDamage > 0)
            {
                //Make SR Check
                if(!PRCDoResistSpell(oPC, oTarget, nPenetr))
                {
                    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER) // Are outsiders the only extraplanar?
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                        {
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        }
                    }
                    //Do not add random delay to damage
                    //if damage is appled after EffectEthereal() it will remove it and all other DoDeath effects
                    effect eLink = EffectDamage(nDamage/2, DAMAGE_TYPE_FIRE);
                           eLink = EffectLinkEffects(eLink, EffectDamage(nDamage/2, DAMAGE_TYPE_MAGICAL));
                           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_FLAME_M));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }
            }
        }
        //Get next target in spell area
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
        //DoDebug("tob_jpm_emimmo: Next target is: " + DebugObject2Str(oTarget));
    }
    DelayCommand(0.2, DoDeath(oPC));
}