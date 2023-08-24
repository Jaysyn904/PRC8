//::///////////////////////////////////////////////
//:: Divine Strength
//:: NW_S2_DivStr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cleric gains +2 to strength +1 for every 3 levels
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 4, 2001
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    effect eStr;
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nCasterLvl = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nContend = GetLevelByClass(CLASS_TYPE_CLERIC) + GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD);

    int nContendSurge;
    int nFeat;
    int nSurge;

    nFeat = (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD) >= 1) ? nContend:0;
    nFeat = (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD) >= 7) ? FloatToInt(nContend*1.5):nContend;

    if(nFeat > 0)
        nSurge = (nFeat/3) + 2;

    int nModify = (nCasterLvl/3) + 2;
    int nDuration = 5 + GetAbilityModifier(ABILITY_CHARISMA);

    nContendSurge = (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD) >= 1) ? 1:0;
    nContendSurge = (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD) >= 3) ? (d4(1) + 1):1;
    nContendSurge = (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD) == 10) ? nDuration:(d4(1) + 1);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_STRENGTH, FALSE));

    //Apply effects and VFX to target
    eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
    effect eSurge = EffectAbilityIncrease(ABILITY_STRENGTH,nSurge);
    effect eLink = EffectLinkEffects(eStr, eDur);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSurge, oTarget, RoundsToSeconds(nContendSurge));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
