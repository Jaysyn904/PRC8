/*
   ----------------
   Firesnake

   tob_dw_frsnk.nss
   ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Firesnake

    Desert Wind (Strike) [Fire]
    Level: Swordsage 4
    Prerequisite: Two Desert Wind Maneuvers
    Initiation Action: 1 Standard Action
    Range: 60ft.
    Area: Line
    Duration: Instantaneous
    Saving Throw: Reflex half

    You drive your weapon into the ground, causing a gout of fire to jet into the air.
    The fire flows back to the ground and creeps ahead like a serpent, sweeping over
    your enemies and roasting them where they stand.
    
    You create a line of fire that does 6d6 damage.
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
    	location lTarget = PRCGetSpellTargetLocation();
    	float fLength = FeetToMeters(60.0);
    	vector vOrigin = GetPosition(oInitiator);
    	int nDC = 14 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
    	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
            // Loop over targets in the line shape
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oInitiator &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oInitiator)
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, move.nMoveId, oInitiator);
                        // Roll damage
                        int nDamage = d6(6);
                        if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();

                        // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

                        if(nDamage > 0)
                        {
                            float fDelay = GetDistanceBetweenLocations(GetLocation(oInitiator), lTarget) / 20.0f;
                            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                            DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                            DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - Target validity check

               // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            }// end while - Target loop
            
            // Do some VFX
            DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oInitiator, 0.55));
            DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_SPELLF_FLAME, GetArea(oInitiator), GetPosition(oInitiator), GetPositionFromLocation(lTarget), 0.0,
                                       FloatToInt(GetDistanceBetweenLocations(GetLocation(oInitiator), lTarget)), // One VFX every meter
                                       0.5
                                       );           
    }
}