/*
    ----------------
    Breath of the Black Dragon

    psi_pow_blckdrgn
    ----------------

    21/10/04 by Stratovarius
*/ /** @file

    Breath of the Black Dragon

    Psychometabolism [Acid]
    Level: Psion/wilder 6, psychic warrior 6
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Area: Cone-shaped burst centered on you
    Duration: Instantaneous
    Saving Throw: Reflex half
    Power Resistance: Yes
    Power Points: 11
    Metapsionics: Empower, Maximize, Twin, Widen

    Your mouth spews forth vitriolic acid that deals 11d6 points of acid damage
    to any targets in the area.

    Augment: For every additional power point you spend, this power’s damage
             increases by 1d6 points.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 11 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nDamage;
        effect eAcid, eVis = EffectVisualEffect(VFX_IMP_ACID_L);
        float fWidth = EvaluateWidenPower(manif, FeetToMeters(25.0f + (5.0f * (manif.nManifesterLevel / 2))));
        float fDelay;
        location lTargetLocation = GetSpellTargetLocation();
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Cone, all damageable objects
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTargetLocation, TRUE,
                                           OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE
                                           );
            while(GetIsObjectValid(oTarget))
            {
                // Does not affect the user
                if(oTarget != oManifester)
                {
			// only hostile
    			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
			{

	                    //Fire cast spell at event for the specified target
        	            PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
	
        	            //Get the distance between the target and caster to delay the application of effects
                	    fDelay = GetDistanceBetween(oManifester, oTarget) / 20.0;

	                    //Make SR check, and appropriate saving throw(s).
        	            if(PRCMyResistPower(oManifester, oTarget, nPen, fDelay))
                	    {
                        	// Roll damage
	                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
        	                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                	        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_ACID);
                        	// Target-specific stuff
	                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);

	                        // If there's still any damage left to be dealt, deal it
        	                if(nDamage > 0)
                	        {
                        	    // Apply effects to the currently selected target.
	                            eAcid = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        	                    //Apply delayed effects
                	            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,  oTarget));
	                       	    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
        	                }
                	    }// end if - SR check
			}
                }// end if - The target gotten is someone else than the manifester

                //Select the next target within the spell shape.
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTargetLocation, TRUE,
                                              OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE
                                              );
            }// end while - Target getting loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
