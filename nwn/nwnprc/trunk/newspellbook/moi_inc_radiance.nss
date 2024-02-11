/*
Incarnate Incarnum Radiance

Incarnum Radiance (Su): You can activate this ability as a free action once per day at 3rd level, twice per day at 8th level, and one additional time per day for every five levels 
thereafter (3/day at 13th level and 4/day at 18th). This effect lasts for a number of rounds equal to 3 + your Constitution modifier (minimum 1 round). 
Good: You gain a +1 bonus to AC; this bonus improves by 1 for every five levels gained (+2 at 5th level, +3 at 10th, +4 at 15th, and +5 at 20th level). 
Evil: You gain a +2 bonus on damage rolls; this bonus improves by 2 for every five levels gained (+4 at 5th level, +6 at 10th, +8 at 15th, and +10 at 20th level). 
Lawful: You gain a +1 bonus on attack rolls; this bonus improves by 1 for every five levels gained (+2 at 5th level, +3 at 10th, +4 at 15th, and +5 at 20th level). 
Chaotic: You gain a 10-foot increase to your base land speed. This increase improves by 10 feet for every five levels gained (+20 at 5th level, +30 at 10th, +40 at 15th, and +50 at 20th level). 

Share Incarnum Radiance (Su): Beginning at 7th level, when you activate your incarnum radiance, its benefit affect all allies within 30 feet of you. When you share your incarnum radiance with allies in this fashion, 
you become fatigued at the end of the power’s duration (this fatigue fades in 10 minutes). Allies who do not share your alignment cause cannot gain the benefit of your incarnum radiance. 
Beginning at 17th level, sharing your incarnum radiance with allies does not fatigue you. 
*/

#include "moi_inc_moifunc"

void IncarnumRadiance(object oMeldshaper, effect eLink, int nLevel);

void IncarnumRadiance(object oMeldshaper, effect eLink, int nLevel)
{
	float fRange = FeetToMeters(30.0);
	location lTarget = PRCGetSpellTargetLocation();	
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fRange), lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
	    if ( (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) && 
	         (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) &&
	         (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC) &&
	         (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL) &&	    
	    	  oMeldshaper != oTarget)
	    {
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
	    }
	   //Select the next target within the spell shape.
	   oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fRange), lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	// Until it ends
	if (GetHasSpellEffect(MELD_INCARNUM_RADIANCE, oMeldshaper)) IncarnumRadiance(oMeldshaper, eLink, nLevel);
}	

void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nLevel = GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper);
	int nDur = 3 + GetAbilityModifier(ABILITY_CONSTITUTION, oMeldshaper);
	int nBonus = 1 + nLevel/5;
	float fDur = RoundsToSeconds(nDur);
	effect eLink;
	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL) eLink = EffectAttackIncrease(nBonus);
	else if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC) 
	{
		nBonus = nBonus * 33;
		if (nBonus > 99) nBonus = 99;
		eLink = EffectMovementSpeedIncrease(nBonus);
	}	
	else if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD) eLink = EffectACIncrease(nBonus);
	else if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL) eLink = EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nBonus*2), DAMAGE_TYPE_BASE_WEAPON);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMeldshaper, fDur);		
		
	if (nLevel >= 7) 
	{
		IncarnumRadiance(oMeldshaper, eLink, nLevel);  
		if (17 > nLevel) DelayCommand(fDur, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), oMeldshaper, 600.0)); 
	}	
}
