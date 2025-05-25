/*
    ----------------
    Overwhelming Mountain Strike

    tob_stdr_ovrmnt
    ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Overwhelming Mountain Strike

    Stone Dragon (Strike)
    Level: Crusader 4, Swordsage 4, Warblade 4
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Duration: 1 round
    Save: Fortitude Partial; see text

    Your mighty strike temporarily disorients your opponent, costing him precious seconds as he shakes off the attack.
    
    You make a single attack against an enemy. If this attack his, you do an extra 2d6 damage.
    If the target fails a Fortitude save vs 14 + Strength modifier, it is slowed.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(2), GetWeaponDamageType(oWeap), "Overwhelming Mountain Strike Hit", "Overwhelming Mountain Strike Miss");
	
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
	{
		int nDC = 13 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
		
		int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
		if (nBladeMed)
		{
			nDC += 1;
		}
	// Saving Throw
		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
		{
			effect eLink = ExtraordinaryEffect(EffectSlow());
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
		}
	}
}

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
    }
}