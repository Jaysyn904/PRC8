//::///////////////////////////////////////////////
//:: Aura of Vitality
//:: NW_S0_AuraVital
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Transmutation
Level:            Druid 7
Components:       V, S
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Target:           One creature/3 levels, no two of
                  which are more than 30 ft. apart
Duration:         1 round/level
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)

All subjects recive a +4 morale bonus to Strength,
Dexterity and Constitution.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lCaster = GetLocation(oCaster);
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = RoundsToSeconds(CasterLvl);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2; //Duration is +100%

    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,4);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eStr, eDex);
           eLink = EffectLinkEffects(eLink, eCon);
           eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lCaster);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCaster);
    while(GetIsObjectValid(oTarget))
    {
        if(GetFactionEqual(oTarget) || GetIsReactionTypeFriendly(oTarget))
        {
            float fDelay = PRCGetRandomDelay(0.4, 1.1);
            //Signal the spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_AURA_OF_VITALITY, FALSE));
            //Apply effects and VFX to target
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_AURA_OF_VITALITY, CasterLvl));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCaster);
    }
    PRCSetSchool();
}
