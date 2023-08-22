/*
   ----------------
   Charging Minotaur

   tob_stdr_crgmtr
   ----------------

   30/03/07 by Stratovarius
*/ /** @file

    Charging Minotaur

    Stone Dragon (Strike)
    Level: Crusader 1, Swordsage 1, Warblade 1
    Initiation Action: 1 Full-Round Action
    Range: Melee Attack
    Target: One Creature

    You charge at your foe, blasting him with such power that he stumbles back.
    
    Make a Bull Rush attack as part of a charge. You take no AoOs for this action.
    If you succeed on the strength check, you deal 2d6 + Str bludgeoning damage,
    and the target is pushed back 5 feet, and possibly more.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

void Damage(object oInitiator, object oTarget)
{
    if (GetLocalInt(oInitiator, "Bullrush"))
    {
        // Deal the damage
        effect eDamage = EffectDamage(d6(2) + GetAbilityModifier(ABILITY_STRENGTH, oInitiator), DAMAGE_TYPE_BLUDGEONING);
        effect eLink = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_COM_BLOOD_REG_RED));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
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
    	// Charge and Bull rush are all taken care of in this function
	    DoCharge(oInitiator, oTarget, FALSE, FALSE, 0, -1, TRUE, 0, FALSE, FALSE);  
        DelayCommand(1.5, Damage(oInitiator, oTarget));
    }
}