/*
   ----------------
   Energy Missile

   psi_pow_enmiss
   ----------------

   31/7/05 by Stratovarius
*/ /** @file

    Energy Missile

    Psychokinesis [see text]
    Level: Kineticist 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Targets: Up to five creatures or objects; no two targets can be more than 15 ft. apart.
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You release a powerful missile of energy of the chosen type at your foe. The
    missile deals 3d6 points of damage to each creature or object you target, to
    the maximum of five targets. You cannot hit the same target multiple times
    with the same manifestation of this power.

    Cold: A missile of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold missile is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a missile of this energy type provides a +2 bonus
                 to the save DC and a +2 bonus on manifester level checks for
                 the purpose of overcoming power resistance.
    Fire: A missile of this energy type deals +1 point of damage per die.
    Sonic: A missile of this energy type deals -1 point of damage per die and
           ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power’s damage
             increases by one die (d6) and its save DC increases by 1.

    @todo 2da
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"
#include "psi_inc_enrgypow"

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
                              PowerAugmentationProfile(1,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_ENERGYMISSILE_COLD, POWER_ENERGYMISSILE_ELEC, POWER_ENERGYMISSILE_FIRE, POWER_ENERGYMISSILE_SONIC,
                           VFX_IMP_FROST_L, VFX_IMP_LIGHTNING_M, VFX_IMP_FLAME_M, VFX_IMP_SONIC);
        int nDC           = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed + enAdj.nDCMod;
        int nPen          = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice = 3 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nMissileCount = 5;
        int nDamage, i;
        location lTarget  = PRCGetSpellTargetLocation();
        float fRadius     = FeetToMeters(15.0f);
        float fDelay, fDistance;
        effect eMissile   = EffectVisualEffect(VFX_IMP_MIRV);
        effect eVis       = EffectVisualEffect(enAdj.nVFX2);
        effect eDamage;
        object oSelectedTarget = PRCGetSpellTargetObject();
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Determine targets by looping over the area and sorting the hostiles in there according to distance from manifester
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                // Target only hostiles, and only ones that the manifester can see
                if(oTarget != oManifester                                              &&
                   oTarget != oSelectedTarget                                          &&
                   spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester) &&
                   GetObjectSeen(oTarget, oManifester)
                   )
                {
                    AddToTargetList(oTarget, oManifester, INSERTION_BIAS_DISTANCE, FALSE);
                }

                // Get next potential target
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target selection loop

            // Hit the 5 first creatures in the list. Or a specifically selected target and 4 first
            i = 0;
            oTarget = GetIsObjectValid(oSelectedTarget) ?
                       oSelectedTarget :
                       GetTargetListHead(oManifester);
            while((i++ < nMissileCount) && GetIsObjectValid(oTarget))
            {
                // Let the AI know
                PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
                // Calculate base delay and do the missile VFX
                fDelay = 0.1f * i;
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));

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
				// This script does nothing if it has Mettle, bail
					nDamage = 0;                              
                                nDamage /= 2;
                            }
                    }
                    else
                        // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

                    if(nDamage > 0)
                    {
                        eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                        // Calculate delay
                        fDistance = GetDistanceBetween(oManifester, oTarget);
                        fDelay   += fDistance / (3.0f * log(fDistance) + 2.0f);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - SR check

                // Get next target from the list
                oTarget = GetTargetListHead(oManifester);
            }// end while - Effect application loop

            // Clear the target list, so it will be empty for the second round of a Twinned power
            PurgeTargetList(oManifester);
        }// end if - Twin Power
    }// end if - Successfull manifestation
}
