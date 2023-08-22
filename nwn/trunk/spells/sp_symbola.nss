//::///////////////////////////////////////////////
//:: Symbol of **** : On Enter
//:: sp_symbola.nss
//:://////////////////////////////////////////////
/*
    This script triggers the Symbol effect.
*/
//:://////////////////////////////////////////////
//#include "inc_target_list"
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void ApplySymbolEffect(object oSymbol, object oCreator);

void main()
{
    object oSymbol = OBJECT_SELF;
    object oCreator = GetAreaOfEffectCreator(oSymbol);

    if(!GetIsObjectValid(oCreator) || !GetLocalInt(oSymbol, "PRC_Symbol_HP_Limit"))
    {
        DestroyObject(oSymbol);
        return;
    }

    if(GetIsEnemy(GetEnteringObject(), oCreator))
        ApplySymbolEffect(oSymbol, oCreator);
}

void ApplySymbolEffect(object oSymbol, object oCreator)
{
    int nSpellID   = GetLocalInt(oSymbol, "X2_AoE_SpellID");
    int nCasterLvl = GetLocalInt(oSymbol, "X2_AoE_Caster_Level");
    int nMetaMagic = GetLocalInt(oSymbol, "PRC_Symbol_Metamagic");
    int nPenetr = SPGetPenetrAOE(oCreator, nCasterLvl);
    location lTarget = GetLocation(oSymbol);
    float fDist = FeetToMeters(60.0);
    float fDelay, fDuration;
    int nHPLimit;
    effect eSymbol;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_MIND), GetLocation(oSymbol));//VFX_FNF_HOWL_ODD

    // make a list of valid targets
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fDist, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // Enemy & can see the symbol
        if(GetIsEnemy(oTarget, oCreator) && !PRCGetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget))
        {
            AddToTargetList(oTarget, oSymbol, INSERTION_BIAS_DISTANCE);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fDist, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    // apply symbol effect
    oTarget = GetTargetListHead(oSymbol);
    while(GetIsObjectValid(oTarget))
    {
        nHPLimit = GetLocalInt(oSymbol, "PRC_Symbol_HP_Limit");
        if(nHPLimit == -1 || nHPLimit >= GetCurrentHitPoints(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCreator, nSpellID));

            // SR check
            fDelay = PRCGetRandomDelay();
            if(!PRCDoResistSpell(oCreator, oTarget, nPenetr, fDelay))
            {
                if(nSpellID == SPELL_SYMBOL_OF_DEATH)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_DEATH, oCreator, fDelay))
                    {
                        nHPLimit -= GetCurrentHitPoints(oTarget);
                        SetLocalInt(oSymbol, "PRC_Symbol_HP_Limit", nHPLimit);

                        DeathlessFrenzyCheck(oTarget);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget));
                    }
                }
                else if(nSpellID == SPELL_SYMBOL_OF_FEAR)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_FEAR, oCreator, fDelay))
                    {
                        nHPLimit -= GetCurrentHitPoints(oTarget);
                        SetLocalInt(oSymbol, "PRC_Symbol_HP_Limit", nHPLimit);

                        eSymbol = EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
                        eSymbol = EffectLinkEffects(eSymbol, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                        fDuration = RoundsToSeconds(nCasterLvl);
                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSymbol, oTarget, fDuration));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FEAR_S), oTarget));
                    }
                }
                else if(nSpellID == SPELL_SYMBOL_OF_STUNING)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_MIND_SPELLS, oCreator, fDelay))
                    {
                        nHPLimit -= GetCurrentHitPoints(oTarget);
                        SetLocalInt(oSymbol, "PRC_Symbol_HP_Limit", nHPLimit);

                        eSymbol = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
                        fDuration = RoundsToSeconds(d6());
                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSymbol, oTarget, fDuration));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget));
                    }
                }
                else if(nSpellID == SPELL_SYMBOL_OF_INSANITY)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_MIND_SPELLS, oCreator, fDelay))
                    {
                        eSymbol = EffectLinkEffects(PRCEffectConfused(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
                        eSymbol = EffectLinkEffects(eSymbol, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                        eSymbol = SupernaturalEffect(eSymbol);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSymbol, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CONFUSION_S), oTarget));
                    }
                }
                else if(nSpellID == SPELL_SYMBOL_OF_PAIN)
                {
                    if(PRCGetIsAliveCreature(oTarget))
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_EVIL, oCreator, fDelay))
                        {
                            eSymbol = EffectLinkEffects(EffectAttackDecrease(4), EffectSavingThrowDecrease(SAVING_THROW_ALL, 4));
                            eSymbol = EffectLinkEffects(eSymbol, EffectSkillDecrease(SKILL_ALL_SKILLS, 4));
                            eSymbol = EffectLinkEffects(eSymbol, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                            fDuration = HoursToSeconds(1);
                            if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSymbol, oTarget, fDuration));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), oTarget));
                        }
                    }
                }
                else if(nSpellID == SPELL_SYMBOL_OF_PERSUASION)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_MIND_SPELLS, oCreator, fDelay))
                    {
                        eSymbol = PRCGetScaledEffect(EffectCharmed(), oTarget);
                        eSymbol = EffectLinkEffects(eSymbol, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
                        eSymbol = EffectLinkEffects(eSymbol, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                        fDuration = HoursToSeconds(nCasterLvl);
                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSymbol, oTarget, fDuration));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oTarget));
                    }
                }
                else if(nSpellID == SPELL_SYMBOL_OF_SLEEP)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_MIND_SPELLS, oCreator, fDelay))
                    {
                        eSymbol = EffectLinkEffects(EffectSleep(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
                        eSymbol = EffectLinkEffects(eSymbol, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                        fDuration = TurnsToSeconds(d6(3) * 10);
                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSymbol, oTarget, fDuration));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLEEP), oTarget));
                    }
                }
                else if(nSpellID == SPELL_SYMBOL_OF_WEAKNESS)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCreator), SAVING_THROW_TYPE_SPELL, oCreator, fDelay))
                    {
                        DelayCommand(fDelay, ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(3), DURATION_TYPE_PERMANENT, TRUE, 0.0f, TRUE, oCreator));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget));
                    }
                }
            }
        }
        oTarget = GetTargetListHead(oSymbol);
    }
}