/*
Vigor, Mass Lesser

Conjuration (Healing)
Level: Cleric 3, Druid 3,
Components: V, S,
Casting Time: 1 standard action
Range: 20 ft.
Target: One creature/two levels, no two of which can be more than 30 ft. apart
Duration: 10 rounds + 1 round/level (max 25 rounds)
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You invoke healing energy over a group of creatures, granting each the fast healing ability for the duration of the spell.
Each subject heals 1 hit point per round of such damage until the spell ends and is automatically stabilized if he or she begins dying from hit point loss during that time.
Mass lesser vigor does not restore hit points lost from starvation, thirst, or suffocation, nor does it allow a creature to regrow or attach lost body parts.
The effects of multiple vigor spells do not stack; only the highest-level effect applies.
Applying a second vigor spell of equal level extends the first spell's duration by the full duration of the second spell.


Vigorous Circle

Conjuration (Healing)
Level: Cleric 6, Druid 6,
Components: V, S,
Casting Time: 1 standard action
Range: 20 ft.
Target: One creature/two levels, no two of which can be more than 30 ft. apart
Duration: 10 rounds + 1 round/level (max 40 rounds)
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

This spell is the same as mass lesser vigor, except that it grants fast healing at the rate of 3 hit points per round.

*/
#include "prc_inc_spells"

int GetHasGreaterEffect(object oTarget, int nSpellID)
{
    switch(nSpellID)
    {
        case SPELL_MASS_LESSER_VIGOR:
            return GetHasSpellEffect(SPELL_VIGOR, oTarget)
                 || GetHasSpellEffect(SPELL_VIGOROUS_CIRCLE, oTarget)
                 || GetHasSpellEffect(SPELL_MONSTROUS_REGENERATION, oTarget);
        case SPELL_VIGOROUS_CIRCLE:
            return GetHasSpellEffect(SPELL_MONSTROUS_REGENERATION, oTarget);
    }
    return FALSE;
}

void PreventStacking(object oTarget, int nSpellID)
{
    if(nSpellID == SPELL_MASS_LESSER_VIGOR)
    {
        PRCRemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
    }
    else if(nSpellID == SPELL_VIGOROUS_CIRCLE)
    {
        PRCRemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_VIGOR);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_VIGOROUS_CIRCLE);
    }
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lCaster = GetLocation(oCaster);
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMaxTargets = nCasterLevel / 2;
    int nRegen, nDur;
    float fDelay;
    int nSpellID = PRCGetSpellId();

    switch(nSpellID)
    {
        case SPELL_MASS_LESSER_VIGOR: nRegen = 1; nDur = PRCMin(25, 10 + nCasterLevel); break;
        case SPELL_VIGOROUS_CIRCLE:   nRegen = 3; nDur = PRCMin(40, 10 + nCasterLevel); break;
    }

    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        nDur *= 2; //Duration is +100%

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eLink = EffectLinkEffects(EffectRegenerate(nRegen, 6.0),
                                     EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lCaster);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCaster, TRUE);
    while(GetIsObjectValid(oTarget) && nMaxTargets)
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
        {
            if(!GetHasGreaterEffect(oTarget, nSpellID) && PRCGetIsAliveCreature(oTarget))
            {
                fDelay = PRCGetRandomDelay(0.4, 1.1);
                //Signal the spell cast at event
                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));

                PreventStacking(oTarget, nSpellID);

                //Apply effects and VFX to target
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur), TRUE, nSpellID, nCasterLevel));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                nMaxTargets--;
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCaster, TRUE);
    }
    PRCSetSchool();
}
