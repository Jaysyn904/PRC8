/*
   ----------------
   Rising Phoenix, Feat strike
   
   tob_dw_rsngphnx.nss
   ----------------

    01/11/07 by Stratovarius
*/ /** @file

    Rising Phoenix

    Desert Wind (Stance) [Fire]
    Level: Swordsage 8
    Prerequisite: Three Desert Wind maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance
    
    Hot winds swirl about your feet, lifting you skyward as flames begin to flick below.
    
    You gain freedom of movement. If you make a full attack, the column of air becomes superheated, dealing 3d6 points of fire damage to creatures adjacent to your square. You are not harmed by this effect.
    (Use the feat added).
    This is a supernatural maneuver.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"

void main()
{
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();

    if(GetHasSpellEffect(MOVE_DW_RISING_PHOENIX, oInitiator))
    {
    	effect eNone;
	    DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, FALSE, "Rising Phoenix Hit", "Rising Phoenix Miss"));
    
        // AoE fire damage
        int nDamage;
        float fDelay;
        effect eExplode = EffectVisualEffect(807);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        effect eDam;
        //Get the spell target location as opposed to the spell target.
        location lTarget = PRCGetSpellTargetLocation();

        //Apply the fireball explosion at the location captured above.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != oInitiator)
            {
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                eDam = EffectDamage(d6(3), DAMAGE_TYPE_FIRE);
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }    
        
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }        
    }
}