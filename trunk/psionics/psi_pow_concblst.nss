/*
   ----------------
   Concussion Blast

   psi_pow_concblst
   ----------------

   6/11/04 by Stratovarius
*/ /** @file

    Concussion Blast

    Psychokinesis [Force]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    A subject you select is pummeled with telekinetic force for 1d6 points of
    force damage. Concussion blast always affects a subject within range that
    you can see, even if the subject is in melee or has cover or concealment
    (you cannot use this power against creatures with total cover or total
    concealment).

    Augment: You can augment this power in one or both of the following ways.
    1. For every 2 additional power points you spend, this power’s damage
       increases by 1d6 points.
    2. For every 2 additional power points you spend, this power can affect an
       additional target. Any additional target cannot be more than 15 feet
       from another target of the power.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void DoPower(struct manifestation manif, object oMainTarget, int nDC, int nPen, int nExtraTargets,
             int nNumberOfDice, int nDieSize, effect eVis);

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
    object oMainTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oMainTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );
    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nExtraTargets = manif.nTimesAugOptUsed_2;
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        effect eVis       = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);

        // Hit the main target
        PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, oManifester);

        DoPower(manif, oMainTarget, nDC, nPen, nExtraTargets, nNumberOfDice, nDieSize, eVis);
        if(manif.bTwin)
            DoPower(manif, oMainTarget, nDC, nPen, nExtraTargets, nNumberOfDice, nDieSize, eVis);
    }// end if - Successfull manifestation
}

void DoPower(struct manifestation manif, object oMainTarget, int nDC, int nPen, int nExtraTargets,
             int nNumberOfDice, int nDieSize, effect eVis)
{
    int nDamage;
    effect eDamage;

    //Check for Power Resistance
    if(PRCMyResistPower(manif.oManifester, oMainTarget, nPen))
    {
        // Roll damage
        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
        // Target-specific stuff
        nDamage = GetTargetSpecificChangesToDamage(oMainTarget, manif.oManifester, nDamage, TRUE, FALSE);
        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

        // Apply damage
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oMainTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);
    }

    if(nExtraTargets > 0)
    {
        location lTarget = PRCGetSpellTargetLocation();

        //Cycle through the targets within the spell shape until you run out of targets.
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget) && nExtraTargets > 0)
        {
            if(oAreaTarget != manif.oManifester                                             && // Do not affect self
               oAreaTarget != oMainTarget                                                   && // Do not affect the main target twice
               spellsIsTarget(oAreaTarget, SPELL_TARGET_SELECTIVEHOSTILE, manif.oManifester)   // Pick only hostiles
               )
            {
                //Fire cast spell at event for the specified target
                PRCSignalSpellEvent(oAreaTarget, TRUE, manif.nSpellID, manif.oManifester);

                if(PRCMyResistPower(manif.oManifester, oAreaTarget, nPen))
                {
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oAreaTarget, manif.oManifester, nDamage, TRUE, FALSE);
                    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oAreaTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAreaTarget);
                }

                // Use up a target slot only if we actually did something to it
                nExtraTargets -= 1;
            }

            //Select the next target within the spell shape.
            oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Target loop
    }// end if - The power has other targets besides the primary one
}