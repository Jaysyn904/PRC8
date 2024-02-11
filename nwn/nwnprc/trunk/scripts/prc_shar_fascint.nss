/*
    Celebrant of Sharess Fascinate. Fascinates creatures (1/3 levels)
*/

#include "prc_inc_spells"  

void DoConcLoop(object oPC, float fDur, int nCounter, object oTarget, int nSpellId)
{
    if((nCounter == 0) || GetBreakConcentrationCheck(oPC) > 0)
    {
        PRCRemoveSpellEffects(nSpellId, oPC, oTarget);
    }
    
    else
    {
        nCounter--;
        DelayCommand(6.0f, DoConcLoop(oPC, fDur, nCounter, oTarget, nSpellId));
    }
}

void main()
{
	object oPC = OBJECT_SELF;
	DecrementRemainingFeatUses(oPC, FEAT_CELEBRANT_SHARESS_CONFUSE);
	DecrementRemainingFeatUses(oPC, FEAT_CELEBRANT_SHARESS_DOMINATE);

    //Declare major variables
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep =  EffectFascinate();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

    int nDuration = 1;
    location lTarget = GetLocation(oPC);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    int nDC = GetSkillRank(SKILL_PERFORM, oPC) + d20();
    int nClass = GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC);
    int nTargets = 1;
    if (nClass >= 4)  nTargets++;
    if (nClass >= 7)  nTargets++;
    if (nClass >= 10) nTargets++;
    int nCount;
    int nSpellId = PRCGetSpellId();

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nTargets > nCount)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && oTarget != oPC)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, nSpellId));
             
            //Make Will Save to negate effect
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
                //Start conc monitor
                DelayCommand(6.0f, DoConcLoop(oPC, HoursToSeconds(nDuration), 600, oTarget, nSpellId));
            } 
            nCount++;
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
