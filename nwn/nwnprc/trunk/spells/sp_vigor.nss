/*
Vigor, Lesser

Conjuration (Healing)
Level:            Cleric 1, Druid 1
Components:       V, S,
Casting Time:     1 standard action
Range:            Touch
Target:           Living creature touched
Duration:         10 rounds + 1 round/level (max 15 rounds)
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)

With a touch of your hand, you boost the subject's life energy, granting him or her the fast healing ability for the duration of the spell.
The subject heals 1 hit point per round of such damage until the spell ends and is automatically stabilized if he or she begins dying from hit point loss during that time.
Lesser vigor does not restore hit points lost from starvation, thirst, or suffocation, nor does it allow a creature to regrow or attach lost body parts.
The effects of multiple vigor spells do not stack; only the highest-level effect applies.
Applying a second vigor spell of equal level extends the first spell's duration by the full duration of the second spell.


Vigor

Conjuration (Healing)
Level:            Cleric 3, Druid 3
Components:       V, S,
Casting Time:     1 standard action
Range:            Touch
Target:           Living creature touched
Duration:         10 rounds + 1 round/level (max 25 rounds)
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)

This spell is the same as lesser vigor, except that it grants fast healing at the rate of 2 hit points per round.


Vigor, Greater

Conjuration (Healing)
Level:            Cleric 5, Druid 5
Components:       V, S,
Casting Time:     1 standard action
Range:            Touch
Target:           Living creature touched
Duration:         10 rounds + 1 round/level (max 35 rounds)
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)

This spell is the same as lesser vigor, except that it grants fast healing at the rate of 4 hit points per round.


//Greater Vigor replaces Monstrous Regeneration
*/
#include "prc_sp_func"

int GetHasGreaterEffect(object oTarget, int nSpellID)
{
    switch(nSpellID)
    {
        case SPELL_LESSER_VIGOR:
            return GetHasSpellEffect(SPELL_MASS_LESSER_VIGOR, oTarget)
                 || GetHasSpellEffect(SPELL_VIGOR, oTarget)
                 || GetHasSpellEffect(SPELL_VIGOROUS_CIRCLE, oTarget)
                 || GetHasSpellEffect(SPELL_MONSTROUS_REGENERATION, oTarget);
//        case SPELL_MASS_LESSER_VIGOR:
//            return GetHasSpellEffect(SPELL_VIGOR, oTarget)
//                 || GetHasSpellEffect(SPELL_VIGOROUS_CIRCLE, oTarget)
//                 || GetHasSpellEffect(SPELL_MONSTROUS_REGENERATION, oTarget);
        case SPELL_VIGOR:
            return GetHasSpellEffect(SPELL_VIGOROUS_CIRCLE, oTarget)
                 || GetHasSpellEffect(SPELL_MONSTROUS_REGENERATION, oTarget);
//        case SPELL_VIGOROUS_CIRCLE:
//            return GetHasSpellEffect(SPELL_MONSTROUS_REGENERATION, oTarget);
    }
    return FALSE;
}

void PreventStacking(object oTarget, int nSpellID)
{
    if(nSpellID == SPELL_LESSER_VIGOR)
    {
        PRCRemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
    }
//    else if(nSpellID == SPELL_MASS_LESSER_VIGOR)
//    {
//        PRCRemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
//        PRCRemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
//    }
    else if(nSpellID == SPELL_VIGOR)
    {
        PRCRemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_VIGOR);
    }
//    else if(nSpellID == SPELL_VIGOROUS_CIRCLE)
//    {
//        PRCRemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
//        PRCRemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
//        PRCRemoveEffectsFromSpell(oTarget, SPELL_VIGOR);
//        PRCRemoveEffectsFromSpell(oTarget, SPELL_VIGOROUS_CIRCLE);
//    }
    else if(nSpellID == SPELL_MONSTROUS_REGENERATION)
    {
        PRCRemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_VIGOROUS_CIRCLE);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_MONSTROUS_REGENERATION);
    }
}

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    if(!PRCGetIsAliveCreature(oTarget))
    {
        FloatingTextStringOnCreature("This spell affects only living creatures!", oCaster, FALSE);
        return FALSE;
    }

    int nSpellID = PRCGetSpellId();

    if(GetHasGreaterEffect(oTarget, nSpellID))
    {
        FloatingTextStringOnCreature(GetName(oTarget) + GetStringByStrRef(16790104), oCaster, FALSE);// already has a greater effect. Spell ineffective.
        return FALSE;
    }

    int nRegen, nDur;
    switch(nSpellID)
    {
        case SPELL_LESSER_VIGOR:           nRegen = 1; nDur = PRCMin(15, 10 + nCasterLevel); break;
        case SPELL_VIGOR:                  nRegen = 2; nDur = PRCMin(25, 10 + nCasterLevel); break;
        case SPELL_MONSTROUS_REGENERATION: nRegen = 4; nDur = PRCMin(35, 10 + nCasterLevel); break;
    }

    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        nDur *= 2;

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eLink = EffectLinkEffects(EffectRegenerate(nRegen, 6.0),
                                     EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    PreventStacking(oTarget, nSpellID);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));

    //Apply effects and VFX
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur), TRUE, nSpellID, nCasterLevel);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}