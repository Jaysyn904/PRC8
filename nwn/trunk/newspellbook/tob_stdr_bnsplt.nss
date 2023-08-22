/*
    ----------------
    Bone Splitting Strike

    tob_stdr_bnsplt
    ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Bone Splitting Strike

    Stone Dragon (Strike)
    Level: Crusader 4, Swordsage 4, Warblade 4
    Prerequisite: Two Stone Dragon maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Your attack slams home with a ferocious crack of shattered bones and parted flesh. 
    Your target reels backward, still alive but severly crippled.
    
    You make a single attack against an enemy. If this attack his, you do 2 Constitution damage.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Bone Splitting Strike Hit", "Bone Splitting Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 2, DURATION_TYPE_PERMANENT);    
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