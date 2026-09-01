/*
    Celebrant of Sharess Fascinate. Fascinates creatures (1/3 levels)
	
	Fascinate (Sp): A celebrant of Sharess can use her flirtation ability 
	to cause one or more creatures to become fascinated with her. Each 
	creature to be fascinated must be within 90 feet of the celebrant 
	and be able to see, hear, and pay attention to her. The celebrant 
	must also be able to see the creature. The distraction of a nearby 
	combat or other danger prevents the ability from working. For every 
	three levels a celebrant attains beyond 1st, she can target one 
	additional creature with a single use of this ability (two at 4th 
	levels three at 7th level, and four at 10th level).

	To use this ability, the celebrant makes a Perform check. Her 
	check result is the DC for each affected creature's Will save 
	against the effect. If a creature's saving throw succeeds, the 
	celebrant cannot attempt to fascinate that creature again for 24 
	hours. If its saving throw fails, the creature sits quietly and 
	gazes at the celebrant, taking no other actions, for as long as 
	she continues her performance and concentration (up to a maximum 
	of 1 round per celebrant of Sharess level). While fascinated, a 
	target takes a -4 penalty on skill checks made as reactions, such 
	as Listen and Spot checks. Any potential threat (such as an ally 
	of the celebrant approaching the fascinated creature) requires 
	the celebrant to make a new Perform check and allows the creature 
	a new saving throw against a DC equal to the new Perform check 
	result. Any obvious threat (such as someone drawing a weapon, 
	casting a spell, or aiming a ranged weapon at the target) automatically 
	breaks the effect. Fascinate is an enchantment (compulsion), 
	mind-affecting ability.

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
	
	int nTargets = 1 + (nClass >= 4 ? (nClass - 1) / 3 : 0);  
	
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
