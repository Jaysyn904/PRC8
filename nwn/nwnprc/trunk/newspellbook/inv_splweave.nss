#include "inv_inc_invfunc"

//internal function for delayed damage
void DoDelayedBlast(object oTarget, int nDamageType = DAMAGE_TYPE_FIRE, int nVFX = VFX_IMP_FLAME_M)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), nDamageType), oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), oTarget);
}

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetLocalObject(oCaster, "SPELLWEAVE_TARGET");
    DeleteLocalObject(oCaster, "SPELLWEAVE_TARGET");

    //check if target is valid
    if(!GetIsObjectValid(oTarget))
        return;

    //At this point we know that we can apply essence effect
    int nEssence = GetLocalInt(oCaster, "BlastEssence");
    int nInvLevel = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nDC = 10 + (GetLocalInt(oCaster, "EssenceData") & 0xF) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    effect eEssence;

    int DmgType = GetLocalInt(oCaster, "archmage_mastery_elements");
    // Eldritch Disciple/Theurge and Archmage class combo is not possible in NWN
    // so delete damage info in case we've changed it
    DeleteLocalInt(oCaster, "archmage_mastery_elements");

    if(nEssence == INVOKE_PENETRATING_BLAST)
    {
        eEssence = EffectSpellResistanceDecrease(5);
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
    }
    else if(nEssence == INVOKE_HINDERING_BLAST)
    {
        eEssence = EffectSlow();
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
    }
    else if(nEssence == INVOKE_BINDING_BLAST)
    {
        eEssence = EffectStunned();
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
    }
    else if(nEssence == INVOKE_BEWITCHING_BLAST)
    {
        eEssence = PRCEffectConfused();
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
    }
    else if(nEssence == INVOKE_BESHADOWED_BLAST)
    {
        eEssence = EffectBlindness();
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
    }
    else if(nEssence == INVOKE_FRIGHTFUL_BLAST)
    {
        eEssence = EffectShaken();
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
    }
    else if(nEssence == INVOKE_NOXIOUS_BLAST)
    {
        eEssence = EffectDazed();
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
    }
    else if(nEssence == INVOKE_SICKENING_BLAST)
    {
        eEssence = EffectSickened();
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, 60.0);
    }
    //damage changing essences
    else if(nEssence == INVOKE_HELLRIME_BLAST && DmgType == DAMAGE_TYPE_COLD)
    {
        eEssence = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(10));
    }
    else if(nEssence == INVOKE_UTTERDARK_BLAST && DmgType == DAMAGE_TYPE_NEGATIVE)
    {
        eEssence = EffectNegativeLevel(2);
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, HoursToSeconds(1));
    }
    else if(nEssence == INVOKE_BRIMSTONE_BLAST && DmgType == DAMAGE_TYPE_FIRE)
    {
        if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            SetLocalInt(oTarget, "BrimstoneFire", TRUE);
            int nDuration = nInvLevel / 5;
            DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oTarget, "BrimstoneFire"));
    
            int i;
            float fRound = RoundsToSeconds(1);
            for(i = 1; i <= nDuration; i++)
            {
                DelayCommand(fRound * i, DoDelayedBlast(oTarget));
            }
        }
    }
    else if(nEssence == INVOKE_VITRIOLIC_BLAST && DmgType == DAMAGE_TYPE_ACID)
    {
        //Apply secondary effect from essence invocations
        int nDuration = nInvLevel / 5;

        int i;
        float fRound = RoundsToSeconds(1);
        for(i = 1; i <= nDuration; i++)
        {
            DelayCommand(fRound * i, DoDelayedBlast(oTarget, DAMAGE_TYPE_ACID, VFX_IMP_ACID_S));
        }
    }
}
