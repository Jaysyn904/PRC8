/*
prc_bab_caller

This is a function to evaluate and apply SetBaseAttackBonus
after taking all the PRC sources into account and choosing one appropriately

Run from prc_inc_function EvalPRCFeats()

as of PRC 3.1c EvalPRCFeats() is called on Equip / Unequip and level up events
prc_bab_caller is occasionally called from other sources (such as casting tensers or divine power)

*/

#include "prc_alterations"
#include "prc_inc_combat"

void main()
{
	object oPC = OBJECT_SELF;

	// initialize nAttackCount to -1
	// at the end of the function we check whether nAttackCount is still -1
	// if it is, we must restore the Base Attack Count (Bonus) to "normal", as there are no "special" circumstances (any more) that increase the # of (base) attacks
	// if it is different from -1, there are "special" circumstances that require us to use SetBaseAttackBonus to modify the # attacks
	int nAttackCount = -1;

	//delete this local so GetMainHandAttacks() does a full calculation
	DeleteLocalInt(oPC, "OverrideBaseAttackCount");

	//find out the number of (class derived) mainhand attacks, including unarmed
	// note that we calculate the "normal" # of mainhand attacks from *unaugmented* BAB, *ignoring* cross-bow special rules!
	int nBAB = GetMainHandAttacks(oPC, 0, TRUE);

	//now look for any permanent or temporary effects that could change the "normal" attack #
	if(GetIsUsingPrimaryNaturalWeapons(oPC))
	{
		//creature weapon test
		//get the value
		nAttackCount = GetLocalInt(oPC, NATURAL_WEAPON_ATTACK_COUNT);
		if (DEBUG) DoDebug("prc_bab_caller: Using primary natural weapons, # attacks = " + IntToString(nAttackCount));
	}
	else if(GetLocalInt(oPC, "HadrimoiPerfectSymmetry"))
	{
		nAttackCount = PRCMax(nBAB, 3);
		if (DEBUG) DoDebug("prc_bab_caller: Using hadrimoi perfect symmetry, # attacks = " + IntToString(nAttackCount));	
	}
	else
	{
		// Once we're here, we know the we aren't using natural weapons
		// This cleans off the bonus attacks from natural weapons
    	GetObjectToApplyNewEffect("WP_PrimaryNaturalWeapEffect", oPC, TRUE);
    	SetLocalInt(oPC, "PrimaryNaturalWeapEffect", TRUE);
    	
		//monk correction; only if we are wielding a monk weapon (or are unarmed)
		if(GetHasMonkWeaponEquipped(oPC))
		{
			nAttackCount = nBAB;
			if (DEBUG) DoDebug("prc_bab_caller: detected monk unarmed # attacks = " + IntToString(nAttackCount));
		}

		//temporary type ones (divine power, tensers transformation)
		int nDPAttackCount = 0;
		int nTTAttackCount = 0;

		if(nBAB < 4 && GetHasSpellEffect(SPELL_DIVINE_POWER, oPC) )
		{
			nDPAttackCount = GetLocalInt(oPC, "AttackCount_DivinePower");
			if (DEBUG) DoDebug("prc_bab_caller: detected Spell Divine Power, # attacks = " + IntToString(nDPAttackCount));
		}

		if(nBAB < 5 && GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION, oPC)) // motu99: changed to five, because Tensers can lead to 5 attacks per round
		{
			// recalculate # attacks (whenever the PC changes from armed to unarmed combat, his Tenser's attack # might change)
			// this cannot happen for Divine Power, because here we get the # attacks a FIGHTER with the same HD would have
			// maximum of 6 attacks (if wielding monk weapons and bioware's implementation), otherwise 5 maximum
			nTTAttackCount = GetMainHandAttacks(oPC, GetLocalInt(oPC, "CasterLvl_TensersTrans")/2, TRUE);
			if (DEBUG) DoDebug("prc_bab_caller: detected Spell Tensers Transformation, # attacks = " + IntToString(nTTAttackCount));
		}

		int nMax = PRCMax(nDPAttackCount, nTTAttackCount);

		// we only consider any changes in # attacks, if Tenser's or DP *increases* our "normal" attack count!
		// this makes sure, that we won't call SetBaseAttackBonus needlessly
		if(	nBAB < nMax)
		{
			// only set nAttackCount if tenser's or DP give higher # attacks than any other specials found before
			if(nMax > nAttackCount)
			{
				nAttackCount = nMax;
				if (DEBUG) DoDebug("prc_bab_caller: DP/Tensers # attacks = " + IntToString(nAttackCount));
			}
		}
	}
	
	//offhand calculations
/*
// motu99: currently the functionality of PerformAttack() does not allow us to include bonus
// attacks in the PTWF feat. But as soon as this is possible, we should use them

	// now find out any bonus attacks (for the PTWF-feat)
	struct BonusAttacks sBonusAttacks = GetBonusAttacks(oPC);
	int iLastAttackMode = GetLastAttackMode(oPC);
	if(iLastAttackMode ==  COMBAT_MODE_FLURRY_OF_BLOWS || iLastAttackMode ==  COMBAT_MODE_RAPID_SHOT )
	{
		sBonusAttacks.iNumber++;
		sBonusAttacks.iPenalty += 2;
	}

	// add the bonus attacks to the main hand attacks
	if (nAttackCount == -1)
		nBAB += sBonusAttacks.iNumber;
	else
		nAttackCount += sBonusAttacks.iNumber;
*/
	
	// now call the function to calculate offhand-attacks, with # main hand attacks as second parameter (this speeds up the PTWF calculation)
	// order matters, don't move this down!
	int nOffhand = GetOffHandAttacks(oPC, nAttackCount == -1 ? nBAB : nAttackCount);

	if(nOffhand <= 2)
		DeleteLocalInt(oPC, "OffhandOverflowAttackCount");
	else
		SetLocalInt(oPC, "OffhandOverflowAttackCount", nOffhand-2);

	// any changes in the number of (normal) main hand attacks? (from primary natural weapons, monk levels, or spells, such as Tensers or Divine Power)
	if(nAttackCount == -1)
	{	// if there is no reason for such changes (any more), restore base attack count (bonus) and delete local ints
		if (DEBUG) DoDebug("prc_bab_caller: restoring base attack bonus of "+ GetName(oPC));
		RestoreBaseAttackBonus(oPC);
		DeleteLocalInt(oPC, "OverflowBaseAttackCount");
		
		// set the local "OverrideBaseAttackCount" to nBAB, so that subsequent calculations are faster.
		// note that this local holds the "normal" main hand attacks (ignoring cross-bow special rules)
		SetLocalInt(oPC, "OverrideBaseAttackCount", nBAB);
	}
	else // otherwise calculate overflow attack count
	{
		int nOverflowAttackCount = 0;

		// all attacks summed up in nAttackCount (natural primary, main hand, monk unarmed, etc.) are performed by aurora engine
		// as long as the engine can handle them: max is 12 attacks, 3 flurries of 4, for both on and off hands
		// the aurora engine can also handle up to two offhand attacks

		//calculate the number of main hand attacks the aurora engine can at most handle, including the up to 2 offhand attacks
		int nCap = 12 - PRCMin(nOffhand,2);
		// apply the cap and calculate the number of overflow (main hand) attacks, that aurora engine can't handle (usually this will never happen)
		if(nAttackCount > nCap)
		{
			nOverflowAttackCount = nAttackCount-nCap;
			nAttackCount = nCap;
			SetLocalInt(oPC, "OverflowBaseAttackCount", nOverflowAttackCount);
		}
		else
			DeleteLocalInt(oPC, "OverflowBaseAttackCount");
		
		if (DEBUG) DoDebug("prc_bab_caller: setting base attack bonus of " + GetName(oPC) + " to # attacks = " + IntToString(nAttackCount));
		SetBaseAttackBonus(nAttackCount, oPC);
		SetLocalInt(oPC, "OverrideBaseAttackCount", nAttackCount);
	}
}
