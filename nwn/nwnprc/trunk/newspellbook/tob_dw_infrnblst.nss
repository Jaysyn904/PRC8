/*
   ----------------
   Inferno Blast

   tob_dw_infrnblst.nss
   ----------------

    01/11/07 by Stratovarius
*/ /** @file

    Inferno Blast

    Desert Wind (Strike) [Fire]
    Level: Swordsage 9
    Prerequisite: Five Desert Wind maneuvers
    Initiation Action: 1 Full-round action
    Range: 60ft.
    Area: Burst
    Duration: Instantaneous
    Saving Throw: Reflex half

    Hot winds swirl around you, and a faint aroma of brimstone sweeps over the area.
    A flickering yellow aura surrounds you and grows in intensity, shedding tremendous
    heat and light. Creatures around you stumble back from the heat. With a howling
    roar, you unleash a hellish blast of fire that melts steel and warps stone.
    
    You create a blast of fire that deals 100 damage to all creatures in the area.
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
        int nDC = 19 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        //Get the first target in the radius around the caster
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oInitiator)
            {
                SignalEvent(oTarget, EventSpellCastAt(oInitiator, GetSpellId()));
                int nDamage = 100;
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
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
}