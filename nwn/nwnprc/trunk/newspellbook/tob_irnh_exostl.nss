/*
   ----------------
   Exorcism of Steel

   tob_irnh_exostl
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Exorcism of Steel

    Iron Heart (Strike)
    Level: Warblade 3
    Prerequisite: One Iron Heart maneuver.
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creatures
    Duration: 1 minute.
    Save: Will partial, see text.

    You attack, striking not your foe, but his weapon, sending a shockwave down his arm that leaves him unable to strike with full force.
    
    You make a single melee attack. If it is successful, you attempt
    to damage the target's weapon. If you damage it successfully, it deals -4 damage.
    If the target succeeds on a will save, it deals -2 damage.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Exorcism of Steel Hit", "Exorcism of Steel Miss");
       
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		int nDC = 13 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
			
			int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
			if (nBladeMed)
			{
				nDC += 1;
			}			
			
    		int nDamage = 4;
		if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
			nDamage = 2;
		effect eDam = EffectDamageDecrease(nDamage, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eDam), oTarget, 60.0);
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