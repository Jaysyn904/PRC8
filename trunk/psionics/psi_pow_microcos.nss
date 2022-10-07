/*
   ----------------
   Microcosm

   prc_pow_microcos
   ----------------

   26/2/05 by Stratovarius
*/ /** @file

    Microcosm

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Psion/wilder 9
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target or Area: One creature; or one or more creatures within a 15-ft.-radius sphere
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 17
    Metapsionics: Twin, Widen

    This power enables you to warp the consciousness and senses of one or more
    creatures, sending the victim into a catatonic state. When microcosm is
    manifested, you can target either a single creature within range or a group
    of creatures all located within the power’s area.

    Single Target: If microcosm targets a single creature, that creature’s
    senses are pinched off from the real world if it currently has 100 or fewer
    hit points. The subject’s senses are all completely fabricated from within
    its own mind, though it may not realize this. In reality, the subject
    sprawls limply, drooling and mewling, and eventually dies of thirst and
    starvation without care. The subject lives within its own made-up world
    until the time of its actual death.

    Area Effect: If microcosm is manifested on an area, it sends all affected
    creatures into a shared catatonia (the world is a construct, but within the
    world, the victims can interact with each other). It affects only creatures
    that currently have 30 or fewer hit points, and only up to a total of 300
    hit points of such creatures. The power affects creatures with the lowest
    hit point totals first. (Creatures with negative hit points count as having
    0 hit points.)

    Manifesting microcosm a second time on an affected creature turns its
    sensory pathways outward once more.

    Augment: For every additional power point you spend, the number of
             individual and group hit points the power can affect increases by 10.
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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nPen          = GetPsiPenetration(oManifester);
        int bSingle       = GetIsObjectValid(oTarget);
        int nHPAffectable = (bSingle ? 100 : 300) + (10 * manif.nTimesAugOptUsed_1);
        int nHPCounter, nTestHP;
        effect eLink      =                          EffectCutsceneParalyze();
               eLink      = EffectLinkEffects(eLink, EffectKnockdown());
               eLink      = EffectLinkEffects(eLink, EffectBlindness());
               eLink      = EffectLinkEffects(eLink, EffectDeaf());
               eLink      = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE));
               eLink      = SupernaturalEffect(eLink);
        location lTarget  = PRCGetSpellTargetLocation();
        float fRadius     = EvaluateWidenPower(manif, FeetToMeters(15.0f));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            if(bSingle)
            {
                // Let the AI know
                PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                if(GetCurrentHitPoints(oTarget) <= nHPAffectable)
                {
                    // Check for Power Resistance
                   if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                    }// end if - SR check
                }// end if - Target's HP is low enough
            }// end if - Single target
            else
            {
                // Build the list of potential targets
                oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oTarget))
                {
                    if(oTarget != manif.oManifester &&                                          // Not the manifester
                       spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester) // Difficulty limitations
                       )
                    {
                        AddToTargetList(oTarget, oManifester, INSERTION_BIAS_HP, TRUE);
                    }// end if - target is valid for this

                    oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                }// end while - loop through all potential targets

                // Affect the targets
                nHPCounter = nHPAffectable;
            	while(GetIsObjectValid(oTarget = GetTargetListHead(oManifester)) && nHPCounter > 0)
            	{
            	    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Test HP limits
                    nTestHP = max(0, GetCurrentHitPoints(oTarget));
                    if(GetCurrentHitPoints(oTarget) <= 30           &&
                       GetCurrentHitPoints(oTarget) <= nHPAffectable
                       )
                    {
                        // Check for Power Resistance
                        if(PRCMyResistPower(oManifester, oTarget, nPen))
                        {
                            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                        }// end if - SR check

                        // Reduce the affectable HP count
                        nHPCounter -= nTestHP;
                    }// end if - Target's HP is low enough
                }// end while - Affect targets

                // Make sure the list is removed
                PurgeTargetList(oManifester);
            }// end else - Targeting area
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
