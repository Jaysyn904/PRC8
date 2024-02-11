/*
   ----------------
   Energy Bolt

   psi_pow_enbolt
   ----------------

   6/11/04 by Stratovarius

    Psychokinesis [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: 120 ft.
    Area: 120-ft. line
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You release a powerful stroke of energy of the chosen type that deals 5d6
    points of damage to every creature or object within the area. The beam
    begins at your fingertips.

    Cold: A bolt of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold bolt is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a bolt of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A bolt of this energy type deals +1 point of damage per die.
    Sonic: A bolt of this energy type deals -1 point of damage per die and
           ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power’s damage
             increases by one die (d6). For each extra two dice of damage,
             this power’s save DC increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"
#include "psi_inc_enrgypow"


float GetVFXLength(location lManifester, float fLength, float fAngle);

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
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(2,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_ENERGYBOLT_COLD, POWER_ENERGYBOLT_ELEC, POWER_ENERGYBOLT_FIRE, POWER_ENERGYBOLT_SONIC,
                           VFX_BEAM_COLD, VFX_BEAM_LIGHTNING, VFX_BEAM_FIRE, VFX_BEAM_MIND);
        int nDC              = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed + enAdj.nDCMod;
        int nPen             = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice    = 5 + manif.nTimesAugOptUsed_1;
        int nDieSize         = 6;
        int nDamage;
        location lManifester = GetLocation(oManifester);
        location lTarget     = PRCGetSpellTargetLocation();
        vector vOrigin       = GetPosition(oManifester);
        float fLength        = EvaluateWidenPower(manif, FeetToMeters(120.0f));
        float fDelay;
        effect eVis          = EffectVisualEffect(enAdj.nVFX1);
        effect eDamage;
        object oTarget;

        // Do VFX. This is moderately heavy, so it isn't duplicated by Twin Power
        float fAngle             = GetRelativeAngleBetweenLocations(lManifester, lTarget);
        float fSpiralStartRadius = FeetToMeters(1.0f);
        float fRadius            = FeetToMeters(5.0f);
        float fDuration          = 4.5f;
        float fVFXLength         = GetVFXLength(lManifester, fLength, GetRelativeAngleBetweenLocations(lManifester, lTarget));
        // A tube of beams, radius 5ft, starting 1m from manifester and running for the length of the line
        BeamGengon(DURATION_TYPE_TEMPORARY, enAdj.nVFX2, lManifester, fRadius, fRadius,
                   1.0f, fVFXLength, // Start 1m from the manifester, end at LOS end
                   8, // 8 sides
                   fDuration, "prc_invisobj",
                   0.0f, // Drawn instantly
                   0.0f, 0.0f, 45.0f, "y", fAngle, 0.0f,
                   -1, -1, 0.0f, 1.0f, // No secondary VFX
                   fDuration
                   );
        // A spiral inside the tube, starting from the manifester with with radius 1ft and ending with radius 5ft at the end of the line
        BeamPolygonalSpring(DURATION_TYPE_TEMPORARY, enAdj.nVFX2, lManifester, fSpiralStartRadius, fRadius,
                            0.0f, fVFXLength, // Start at the manifester, end at LOS end
                            5, // 5 sides per revolution
                            fDuration, "prc_invisobj",
                            fVFXLength / 5, // Revolution per 5 meters
                            0.0f, // Drawn instantly
                            0.0f, "y", fAngle, 0.0f,
                            -1, -1, 0.0f, 1.0f, // No secondary VFX
                            fDuration
                            );

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Loop over targets in the line shape
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester)
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
                    // Make an SR check
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, FALSE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);

                        // Do save
                        if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                        {
                            // Cold has a fort save for half
                            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, enAdj.nSaveType))
                            {
                                if (GetHasMettle(oTarget, SAVING_THROW_FORT))
                                    nDamage = 0;
                                nDamage /= 2;
                            }
                        }
                        else
                            // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

                        if(nDamage > 0)
                        {
                            fDelay = GetDistanceBetweenLocations(lManifester, GetLocation(oTarget)) / 20.0f;
                            eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                            DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                            DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }// end if - There was still damage remaining to be dealt after adjustments
                    }// end if - SR check
                }// end if - Target validity check

               // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

float GetVFXLength(location lManifester, float fLength, float fAngle)
{
    float fLowerBound = 0.0f;
    float fUpperBound = fLength;
    float fVFXLength  = fLength / 2;
    vector vVFXOrigin = GetPositionFromLocation(lManifester);
    vector vAngle     = AngleToVector(fAngle);
    vector vVFXEnd;
    int bConverged    = FALSE;
    while(!bConverged)
    {
        // Create the test vector for this loop
        vVFXEnd = vVFXOrigin + (fVFXLength * vAngle);

        // Determine which bound to move.
        if(LineOfSightVector(vVFXOrigin, vVFXEnd))
            fLowerBound = fVFXLength;
        else
            fUpperBound = fVFXLength;

        // Get the new middle point
        fVFXLength = (fUpperBound + fLowerBound) / 2;

        // Check if the locations have converged
        if(fabs(fUpperBound - fLowerBound) < 2.5f)
            bConverged = TRUE;
    }

    return fVFXLength;
}
