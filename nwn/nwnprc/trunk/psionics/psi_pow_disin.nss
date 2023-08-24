/*
   ----------------
   Disintegrate, Psionic

   psi_pow_disin
   ----------------

   27/10/04 by Stratovarius
*/ /** @file

    Disintegrate, Psionic

    Psychoportation
    Level: Psion/wilder 6
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: Fortitude partial
    Power Resistance: Yes
    Power Points: 11
    Metapsionics: Empower, Maximize, Split Psionic Ray, Twin

    A thin, green ray springs from your pointing finger. You must make a
    successful ranged touch attack to hit. Any creature struck by the ray
    takes 22d6 points of damage. Any creature reduced to 0 or fewer hit points
    by this power is entirely disintegrated, leaving behind only a trace of
    fine dust. A disintegrated creature’s equipment is unaffected.

    A creature or object that makes a successful Fortitude save is partially
    affected, taking only 5d6 points of damage. If this damage reduces the
    creature or object to 0 or fewer hit points, it is entirely disintegrated.

    Only the first creature or object struck can be affected; that is, the ray
    affects only one target per manifestation.

    Augment: For every additional power point you spend, the damage this power
             deals to a subject that fails its saving throw increases by 2d6 points.
             Augmenting this power does not change the amount of damage the target
             takes if it succeeds on its saving throw.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_sp_tch"


void DoPower(struct manifestation manif, object oTarget, int nDC, int nPen, int nNumberOfDice, int nDieSize);

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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_SPLIT | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 22 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        object oSecondaryTarget = GetSplitPsionicRayTarget(manif, oTarget);

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
        if(GetIsObjectValid(oSecondaryTarget))
            PRCSignalSpellEvent(oSecondaryTarget, TRUE, manif.nSpellID, oManifester);


        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            DoPower(manif, oTarget, nDC, nPen, nNumberOfDice, nDieSize);
            if(GetIsObjectValid(oSecondaryTarget))
                DoPower(manif, oSecondaryTarget, nDC, nPen, nNumberOfDice, nDieSize);
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

void DoPower(struct manifestation manif, object oTarget, int nDC, int nPen, int nNumberOfDice, int nDieSize)
{
    // Perform the Touch Attack
    int nTouchAttack = PRCDoRangedTouchAttack(oTarget);

    // Shoot the ray
    effect eRay = EffectBeam(VFX_BEAM_DISINTEGRATE, manif.oManifester, BODY_NODE_HAND, !(nTouchAttack > 0));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7, FALSE);

    if(nTouchAttack > 0)
    {
        //Check for Power Resistance
        if(PRCMyResistPower(manif.oManifester, oTarget, nPen))
        {
            // Fort save partial
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
            {
		if (GetHasMettle(oTarget, SAVING_THROW_FORT))
		// This script does nothing if it has Mettle, bail
			return;               
                nNumberOfDice = 5;
            }

            // Roll damage
            int nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, TRUE);
            // Target-specific stuff
            nDamage = GetTargetSpecificChangesToDamage(oTarget, manif.oManifester, nDamage, TRUE, FALSE);

            // Apply the damage
            ApplyTouchAttackDamage(manif.oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
        }// end if - SR check
    }// end if - Touch attack hit
}
