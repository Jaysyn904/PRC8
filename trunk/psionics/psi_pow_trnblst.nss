/*
   ----------------
   Tornado Blast

   psi_pow_trnblst
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Tornado Blast

    Psychokinesis
    Level: Kineticist 9
    Manifesting Time: 1 round
    Range: Long (400 ft. + 40 ft./level)
    Area: 40-ft.-radius spread
    Duration: Instantaneous
    Saving Throw: Reflex half; see text
    Power Resistance: No
    Power Points: 17
    Metapsionics: Empower, Maximize, Twin, Widen

    You induce the formation of a slender vortex of fiercely swirling air. When
    you manifest it, a vortex of air visibly and audibly snakes out from your
    outstretched hand.

    If you want to aim the vortex at a specific creature, you can make a ranged
    touch attack to strike the creature. If you succeed, direct contact with the
    vortex deals 8d6 points of damage to the creature (no save).

    Regardless of whether your ranged touch attack hits (and even if you forgo
    the attack), all creatures in the area (including the one possibly damaged
    by direct contact) are picked up and violently dashed about, dealing 17d6
    points of damage to each one. Creatures that make a successful Reflex save
    take half damage.

    After being dashed about, each creature that was affected finds itself
    situated in a new space 1d4 x 10 feet away from its original space in a
    random direction. Walls and other barriers can restrict this relocation; in
    such a case, the creature ends up adjacent to the barrier.

    Augment: For every additional power point you spend, this power’s area
             damage (not the damage from direct contact dealt to a specific
             creature) increases by 1d6 points. For each extra 2d6 points of
             damage, this power’s save DC increases by 1.


    @todo Find better VFX
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_sp_tch"

void DoRandomMove(object oTarget);

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oBallTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oBallTarget,
                              PowerAugmentationProfile(2,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC                   = GetManifesterDC(oManifester);
        int nPen                  = GetPsiPenetration(oManifester);
        int nNumberOfDice_Explode = 17 + manif.nTimesAugOptUsed_1;
        int nNumberOfDice_Ball    = 8;
        int nDieSize              = 6;
        int nDamage, nTouchAttack;
        location lTarget          = PRCGetSpellTargetLocation();
	effect eImpact            = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	effect eExplode           = EffectVisualEffect(VFX_FNF_STORM);
        effect eDamage;
        float fRadius             = EvaluateWidenPower(manif, FeetToMeters(40.0f));
        object oExplodeTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check if a particular creature was targeted
            if(GetIsObjectValid(oBallTarget))
            {
                // Let the AI know
                PRCSignalSpellEvent(oBallTarget, TRUE, manif.nSpellID, oManifester);

                // Roll touch attack
                nTouchAttack = PRCDoRangedTouchAttack(oBallTarget);
                if(nTouchAttack > 0)
                {
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice_Ball, 0, 0, TRUE, TRUE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oBallTarget, oManifester, nDamage, TRUE, FALSE);

                    // Apply the damage and VFX. No Reflex save here, they got hit by a touch attack
                    ApplyTouchAttackDamage(oManifester, oBallTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oBallTarget);
                }// end if - Touch attack hit
            }// end if - A creature was targeted with the ball

            // Either way, shrapnel time
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
            oExplodeTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oExplodeTarget))
            {
                if(spellsIsTarget(oExplodeTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester))
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oExplodeTarget, TRUE, manif.nSpellID, oManifester);

                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice_Explode, 0, 0, TRUE, TRUE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oExplodeTarget, oManifester, nDamage, TRUE, FALSE);
                    // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oExplodeTarget, nDC, SAVING_THROW_TYPE_NONE);

                    // Apply effects if the target didn't Evade
                    if(nDamage > 0)
                    {
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oExplodeTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oExplodeTarget);

                        // Toss the target around. Only applies to creatures to avoid messing modules up
                        if(GetObjectType(oExplodeTarget) == OBJECT_TYPE_CREATURE)
                            DoRandomMove(oExplodeTarget);
                    }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - Difficulty check

                // Get next target
                oExplodeTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Explosion target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

void DoRandomMove(object oTarget)
{
    // Calculate the new location
    object oArea    = GetArea(oTarget);
    float fDistance = FeetToMeters(10.0f * d4());
    float fAngle    = IntToFloat(Random(3600)) / 10.0;
    float fFacing   = IntToFloat(Random(3600)) / 10.0;
    vector vOrigin  = GetPosition(oTarget);
    vector vAngle   = AngleToVector(fAngle);
    vector vTarget  = vOrigin + (vAngle * fDistance);

    // If there is blocking geometry on the way, determine where
    if(!LineOfSightVector(vOrigin, vTarget))
    {
        float fEpsilon    = 1.0f;          // Search precision
        float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
        float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
        fDistance         = fDistance / 2; // The search position, set to middle of the range

        do{
            // Create test vector for this iteration
            vTarget = vOrigin + (vAngle * fDistance);

            // Determine which bound to move.
            if(LineOfSightVector(vOrigin, vTarget))
                fLowerBound = fDistance;
            else
                fUpperBound = fDistance;

            // Get the new middle point
            fDistance = (fUpperBound + fLowerBound) / 2;
        }while(fabs(fUpperBound - fLowerBound) > fEpsilon);
    }// end if - The location was blocked by geometry

    // Create the final target vector
    vTarget = vOrigin + (vAngle * fDistance);

    // Move the target
    int bCommandable            = GetCommandable(oTarget);
    location lTargetDestination = Location(oArea, vTarget, fFacing);
    float fDelay                = PRCGetRandomDelay();

    // Set commandable if it isn't already
/*    if(!bCommandable)
        SetCommandable(TRUE, oTarget);*/

    // Assign jump commands
    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(oTarget, JumpToLocation(lTargetDestination));

    // Set commandability off it it was off in the beginning
/*    if(!bCommandable)
        AssignCommand(oTarget, ActionDoCommand(SetCommandable(FALSE, oTarget)));*/
/*DoDebug("DoRandomMove(): Jumping creature " + DebugObject2Str(oTarget) + "\n"
      + "Old location = " + DebugLocation2Str(GetLocation(oTarget)) + "\n"
      + "New location = " + DebugLocation2Str(lTargetDestination) + "\n"
      + "Commandability = " + DebugBool2String(bCommandable) + "\n"
        );*/
    // Do some VFX during the jump delay
    DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, oArea, vOrigin, vTarget, 0.0f,
                               FloatToInt(GetDistanceBetweenLocations(GetLocation(oTarget), lTargetDestination)), // One VFX every meter
                               fDelay
                               );
}
