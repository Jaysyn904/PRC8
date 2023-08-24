/*
   ----------------
   Stone Dragon's Fury

   tob_stdr_stndrgf
   ----------------

   18/08/07 by Stratovarius
*/ /** @file

    Stone Dragon's Fury

    Stone Dragon's (Strike)
    Level: Crusader 3, Swordsage 3, Warblade 3
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    With a mighty war cry, you slam your weapon into a slight crack or other fault in an object.
    The object shudders for a moment before it collapses into broken shards.
    
    You deal an extra 4d6 damage to objects or constructs with this strike.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
	int nDam;
	if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetObjectType(oTarget) == OBJECT_TYPE_DOOR || GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
		nDam = d6(4);
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, nDam, GetWeaponDamageType(oWeap), "Stone Dragon's Fury Hit", "Stone Dragon's Fury Miss"));
    }
}