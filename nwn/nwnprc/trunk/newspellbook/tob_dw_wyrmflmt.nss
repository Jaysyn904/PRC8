/*
   ----------------
   Wyrm's Flame

   tob_dw_wyrmflm.nss
   ----------------

    04/06/07 by Stratovarius
*/ /** @file

    Wyrm's Flame

    Desert Wind (Strike) [Fire]
    Level: Swordsage 8
    Prerequisite: Three Desert Wind maneuvers
    Initiation Action: 1 Standard Action
    Range: 30ft.
    Area: Cone
    Duration: Instantaneous
    Saving Throw: Reflex half

    You spin your blade in a whirling arc. With each revolution, seathing flames build upon its length.
    With a flourish, you bring your blade to a halt, pointing it at your foe, and unleashing a roaring 
    wall of flame.
    
    You create a cone of fire that does 10d6 damage.
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
        int nDC = 18 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
		
		int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
		if (nBladeMed)
		{
			nDC += 1;
		}	
		
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        //Get the first target in the radius around the caster
        oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oInitiator)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                int nDamage = d6(10);
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
            oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
}