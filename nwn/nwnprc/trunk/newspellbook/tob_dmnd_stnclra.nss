/*
   ----------------
   Stance of Clarity, On Heartbeat

   tob_dmnd_stnclra.nss
   ----------------

    29/03/07 by Stratovarius
*/ /** @file

    Stance of Clarity

    Diamond Mind (Stance)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    You focus your efforts on a single opponent, studying
    his moves and preparing an attack. Your other opponents
    fade from sight as your mind locks onto your target.
    
    You gain a +2 AC bonus against the highest CR creature in the area,
    and a -2 AC penalty against all other creatures attacking him.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    int nMaxCR = 0;
    int nCurCR, nTargets;
    if(DEBUG) DoDebug("tob_dvsp_stnclra: Name: " + GetName(GetAreaOfEffectCreator()));
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    object oToughest;
    while(GetIsObjectValid(oTarget))
    {
    	// Enemies only
	if (GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
	{
		nCurCR = FloatToInt(GetChallengeRating(oTarget));
		// Update if you find something bigger
		if (nCurCR > nMaxCR) 
		{
			nMaxCR = nCurCR;
			oToughest = oTarget;
			// Make sure it doesnt get applied more than once to any given target
			// The negative is 4 to counter out the -2 overall AC of the Initiator
			if(GetHasSpellEffect(MOVE_DM_STANCE_OF_CLARITY, oTarget))  PRCRemoveEffectsFromSpell(oTarget, MOVE_DM_STANCE_OF_CLARITY);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, VersusRacialTypeEffect(EffectAttackDecrease(4), MyPRCGetRacialType(GetAreaOfEffectCreator())), oToughest, 6.0);
		}
                
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
    // And the initiator gets a -2 AC vs everything
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(2), GetAreaOfEffectCreator(), 6.0);
}