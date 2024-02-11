/*
   ----------------
   Vanguard Strike

   tob_dvsp_vngstrk
   ----------------

   29/03/07 by Stratovarius
*/ /** @file

    Vanguard Strike

    Devoted Spirit (Strike)
    Level: Crusader 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You batter aside your foe's defenses with a vicious, overwhelming attack, 
    leaving him vulnerable to your allies blows.
    
    You make a single attack against an enemy. If you hit, that enemy takes a -4 AC penalty for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Vanguard Strike Hit", "Vanguard Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		effect eLink = EffectLinkEffects(EffectACDecrease(4), EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_WEAKNESS));
		       eLink = ExtraordinaryEffect(eLink);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
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