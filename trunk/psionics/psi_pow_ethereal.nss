/*
   ----------------
   Etherealness, Psionic

   psi_pow_ethereal
   ----------------

   26/2/05 by Stratovarius
*/ /** @file

    Etherealness, Psionic

    Psychoportation
    Level: Psion/wilder 9
    Manifesting Time: 1 standard action
    Range: Touch
    Targets: You and one other touched willing creature/three levels
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: Yes (harmless)
    Power Points: 17
    Metapsionics: Extend

    You and other willing creatures joined by linked hands (along with their
    equipment) become ethereal. Besides yourself, you can bring one creature per
    three manifester levels to the Ethereal Plane. Once ethereal, the subjects
    need not stay together.

    When the power expires, all affected creatures on the Ethereal Plane return
    to material existence. Taking any hostile actions will force immediate
    return to material existence for the creature taking the hostile action.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"
#include "prc_inc_teleport"

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

    object oManifester  = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nTargetCount = manif.nManifesterLevel / 3;
        effect eLink     =                          EffectEthereal();
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SANCTUARY));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        location lTarget = PRCGetSpellTargetLocation();
        float fDuration  = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Make sure the manifester is not prevented from extra-dimensional movement. If it can't go, no-one goes
        if(GetCanTeleport(oManifester, GetLocation(oManifester), FALSE, TRUE))
        {
            // Apply effect to self
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oManifester, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

            // Determine willing friends in touch range and affect them.
            object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget) && nTargetCount > 0)
            {
                if(GetIsFriend(oTarget, oManifester))
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, FALSE, manif.nSpellID, oManifester);

                    // Make sure the target is not prevented from extra-dimensional movement
                    if(GetCanTeleport(oTarget, GetLocation(oTarget), FALSE, TRUE))
                    {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    }

                    // Use up a target slot only if we actually did something to it
                    nTargetCount -= 1;
                }// end if - Target is friendly (considered willing)

                // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end if - Manifester can move extra-dimensionally
    }// end if - Successfull manifestation
}
