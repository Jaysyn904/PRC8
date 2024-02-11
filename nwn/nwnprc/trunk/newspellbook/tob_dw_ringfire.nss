/*
   ----------------
   Ring of Fire

   tob_dw_ringfire.nss
   ----------------

    04/06/07 by Stratovarius
*/ /** @file

    Ring of Fire

    Desert Wind (Strike) [Fire]
    Level: Swordsage 6
    Prerequisite: Two Desert Wind maneuvers
    Initiation Action: 1 Standard Action
    Range: 30ft.
    Area: Burst
    Duration: Instantaneous
    Saving Throw: Reflex half

    You move in a blur, your feet wreathed in flaming energy. As you run, you leave a trail of fire behind you.
    You encircle a foe, and the ring of fire you leave behind bursts into an inferno that engulfs your enemy and 
    everything else in the area.
    
    You create a burst of fire that does 12d6 damage.
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
        location lTarget = GetLocation(oInitiator);
        int nDC = 16 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        //Get the first target in the radius around the caster
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oInitiator)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                int nDamage = d6(12);
                if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();
                //Run the damage through the various reflex save and evasion feats
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target. 
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
            //Get the next target in the specified area around the caster
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
}