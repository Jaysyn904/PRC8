/*
   ----------------
   Energy Wave

   psi_pow_enwave
   ----------------

   25/2/05 by Stratovarius
*/ /** @file

    Energy Wave

    Psychokinesis [see text]
    Level: Psion/wilder 7
    Manifesting Time: 1 standard action
    Range: 120 ft.
    Area: Cone-shaped spread
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You create a flood of energy of the chosen type out of unstable ectoplasm
    that deals 13d6 points of damage to each creature and object in the area.
    This power originates at your hand and extends outward in a cone.

    Cold: A wave of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold wave is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a wave of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A wave of this energy type deals +1 point of damage per die.
    Sonic: A wave of this energy type deals -1 point of damage per die and
           ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power’s damage
             increases by one die (d6). For each extra two dice of damage, this
             power’s save DC increases by 1.
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
                              PowerAugmentationProfile(2,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_ENERGYWAVE_COLD, POWER_ENERGYWAVE_ELEC, POWER_ENERGYWAVE_FIRE, POWER_ENERGYWAVE_SONIC,
                           VFX_IMP_FROST_L, VFX_IMP_LIGHTNING_M, VFX_IMP_FLAME_M, VFX_IMP_SONIC);
        int nDC              = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed + enAdj.nDCMod;
        int nPen             = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice    = 13 + manif.nTimesAugOptUsed_1;
        int nDieSize         = 6;
        int nDamage;
        location lManifester = GetLocation(oManifester);
        location lTarget     = PRCGetSpellTargetLocation();
        float fWidth         = EvaluateWidenPower(manif, FeetToMeters(120.0f));
        float fDelay;
        effect eVis          = EffectVisualEffect(enAdj.nVFX2);
        effect eDamage;
        object oTarget;
        vector vOrigin = GetPosition(oManifester);
        vector vTarget = GetPositionFromLocation(lTarget);
        float fAngle   = acos((vTarget.x - vOrigin.x) / GetDistanceBetweenLocations(GetLocation(oManifester), lTarget));        
        DrawLinesInACone(manif.nManifesterLevel, fWidth, lTarget, fAngle, DURATION_TYPE_INSTANT, enAdj.nVFX1, 0.0f, 20, 1.5f);        

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Loop over targets in the cone shape
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
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
                                nDamage /= 2;
                                if (GetHasMettle(oTarget, SAVING_THROW_FORT))
				// This script does nothing if it has Mettle, bail
					nDamage = 0;  
			    }
                        }
                        else
                            // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

                        if(nDamage > 0)
                        {
                            fDelay = GetDistanceBetweenLocations(lManifester, GetLocation(oTarget)) / 20.0f;
                            eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }// end if - There was still damage remaining to be dealt after adjustments
                    }// end if - SR check
                }// end if - Target validity check

                // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
