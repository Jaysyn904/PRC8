//////////////////////////////////////////////////
//   Colossus Strike
//   tob_stdr_colostrk.nss
//   Tenjac  9/11/07
//////////////////////////////////////////////////
/** @file Colossus Strike
Stone Dragon (Strike)
Level: Crusader 7, swordsage 7, warblade 7
Prerequisite: Two Stone Dragon maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Saving Throw: Fortitude partial

Focusing your strength with a deep, rumbling shout, you execute an attack that sends your 
opponent flying through the air.

As part of this maneuver, you make a melee attack against your foe. This attack deals an extra
6d6 points of damage, and the creature struck must succeed on a Fortitude save (DC 17 + your
Str modifier) or be hurled 1d4 squares away from you, falling prone in that square. A creature
of a smaller size category than yours gets a -2 penalty on this save; a creature of a larger
size than yours gets a +2 bonus on the save. The enemy's movement doesn't provoke attacks of 
opportunity. If an obstacle blocks the creature's movement, it instead stops in the first unoccupied 
square.

*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(6), GetWeaponDamageType(oWeap), "Colossus Strike Hit", "Colossus Strike Miss");
	
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
	{
		int nDC = 17 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
		
		int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
		if (nBladeMed)
		{
			nDC += 1;
		}
		
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oInitiator, 1.0))
		{
			float fFeet = IntToFloat(5 * d4(1));
			_DoBullRushKnockBack(oTarget, oInitiator, fFeet);
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