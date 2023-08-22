/*
   ----------------
   Distracting Ember

   tob_dw_brnbld.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    Distracting Ember

    Desert Wind (Boost)
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Effect: One Summoned Fire Elemental
    Duration: 1 Round.

    A wave of heat sweeps over the area, forms a small dust funnel, and ignites into flame next to your foe.
    
    You summon a small fire elemental.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
    	effect eSummonedMonster = EffectSummonCreature("tob_dw_distembr", VFX_FNF_SUMMON_MONSTER_1);
    	       eSummonedMonster = SupernaturalEffect(eSummonedMonster);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummonedMonster, PRCGetSpellTargetLocation(), 6.0);	
    }
}