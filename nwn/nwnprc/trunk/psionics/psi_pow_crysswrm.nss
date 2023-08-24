/*
    ----------------
    Swarm of Crystals

    psi_pow_crysswrm
    ----------------

    9/11/04 by Stratovarius
*/ /** @file

    Swarm of Crystals

    Metacreativity (Creation)
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: 30 ft.
    Area: Cone-shaped spread
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin, Widen

    Thousands of tiny crystal shards spray forth in an arc from your hand. These
    razorlike crystals slice everything in their path. Anyone caught in the cone
    takes 3d4 points of slashing damage.

    Augment: For every additional power point you spend, this power’s damage
             increases by 1d4 points.
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
        int nNumberOfDice = 3 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 4;
        int nDamage, i;
        effect eDamage;
        effect eSpikes    = EffectVisualEffect(VFX_IMP_WALLSPIKE);
        effect eDart      = EffectVisualEffect(NORMAL_DART);
        float fWidth      = EvaluateWidenPower(manif, FeetToMeters(30.0f));
        float fDelay;
        location lTarget  = PRCGetSpellTargetLocation();
        object oTarget;

        vector vOrigin = GetPosition(oManifester);
        vector vTarget = GetPositionFromLocation(lTarget);
        float fAngle   = acos((vTarget.x - vOrigin.x) / GetDistanceBetweenLocations(GetLocation(oManifester), lTarget));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do VFX - Doesn't seem to work with darts
            //DrawLinesInACone(10, fWidth, lTarget, fAngle, DURATION_TYPE_INSTANT, NORMAL_DART, 0.0f, 20, 1.5f);

            // Loop over targets
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE,
                                           OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&                                          // No hurting self
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester) // Game difficulty limitations
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);
                    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);

                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    	            //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSpikes, oTarget);
    	            if(GetObjectType(oTarget) != OBJECT_TYPE_PLACEABLE) // Placeables do not like the VFX, either
        	            for(i = 0; i < 15; i++)
        	                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDart, oTarget);
    	        }// end if - Targeting check

    	        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE,
    	                                      OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
