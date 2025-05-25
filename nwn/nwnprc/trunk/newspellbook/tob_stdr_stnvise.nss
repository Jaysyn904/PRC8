/*
   ----------------
   Stone Vise

   tob_stdr_stnvise.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Stone Vise

    Stone Dragon (Strike)
    Level: Crusader 2, Swordsage 2, Warblade 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Saving Throw: Fort partial.

    You make a crushing blow that staggers your opponent, leaving it unable to move.
    
    Make a single melee attack. If you succesfully hit the creature, he takes an additional 1d6 damage. If he fails a 
    Reflex save against 12 + your Strength modifier, he cannot move for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(1), GetWeaponDamageType(oWeap), "Stone Vise Hit", "Stone Vise Miss");
	
	int nDC = 12 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
		
	int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
	if (nBladeMed)
	{
		nDC += 1;
	}		   
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	{
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectCutsceneParalyze()), oTarget, 6.0);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DIMENSIONLOCK), oTarget);
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