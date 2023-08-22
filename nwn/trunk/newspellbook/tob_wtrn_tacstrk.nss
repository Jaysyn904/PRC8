/*
   ----------------
   Tactical Strike

   tob_wtrn_tacstrk.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Tactical Strike

    White Raven (Strike)
    Level: Crusader 2, Warblade 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    A faint numbus of sickly grey shadow surrounds your weapon.
    When you attack, this shadowy aura flows into the wound you
    inflict, sapping your opponent's strength, vitality, and energy.
    
    Make a single melee attack. If you succesfully hit the creature, all allies gain 
    a 5' boost to movement speed for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(2), GetWeaponDamageType(oWeap), "Tactical Strike Hit", "Tactical Strike Miss");
       
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		location lTarget = PRCGetSpellTargetLocation();
		
		//Cycle through the targets within the spell shape until you run out of targets.
		object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while(GetIsObjectValid(oAreaTarget))
		{
		    if (GetIsFriend(oAreaTarget, oInitiator))
		    {	
		    	// 1/6th increase: 16.6 = 17.
		    	// Not really a 5' step, I know,but oh well.
		        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectMovementSpeedIncrease(17)), oAreaTarget, 6.0);
		    }
		
		    //Select the next target within the spell shape.
		    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        	}// end while - Target loop
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