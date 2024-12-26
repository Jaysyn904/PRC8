/*
   ----------------
   Crisis of Breath

   psi_pow_crsbrth
   ----------------

   19/4/05 by Stratovarius
*/ /** @file

    Crisis of Breath

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Telepath 3
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One breathing humanoid
    Duration: 1 round/level
    Saving Throw: Will negates, Fortitude partial; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Extend, Twin, Widen

    You compel the subject to purge its entire store of air in one explosive
    exhalation, and thereby disrupt the subject’s autonomic breathing cycle.
    The subject’s lungs do not automatically function again while the power’s
    duration lasts.

    If the target succeeds on a Will save when crisis of breath is manifested,
    it is unaffected by this power. If it fails its Will save, it can still
    continue to breathe by remaining in place and gasping for breath.

    An affected creature can attempt to take actions normally (instead of
    consciously controlling its breathing), but each round it does so, beginning
    in the round when it failed its Will save, the subject risks blacking out
    from lack of oxygen. It must succeed on a Fortitude save at the end of any
    of its turns in which it did not consciously take a breath. The DC of this
    save increases by 1 in every consecutive round after the first one that goes
    by without a breath; the DC drops back to its original value if the subject
    spends an action to take a breath.

    If a subject fails a Fortitude save, it falls to 1 HP. In the following
    round, it drops to -1 hit points and is dying.

    Augment: You can augment this power in one or more of the following ways.
    1. If you spend 2 additional power points, this power can also affect an
       animal, fey, giant, magical beast, or monstrous humanoid.
    2. If you spend 4 additional power points, this power can also affect an
       aberration, dragon, elemental, or outsider in addition to the creature
       types mentioned above.
    3. If you spend 6 additional power points, this power can affect up to
       four creatures all within a 20-ft.-radius burst.
    In addition, for every 2 additional power points you spend to achieve any of
    these effects, this power’s save DC increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"



void RunImpact(object oTarget, location lTarget, object oManifester, int nSpellID, int nDC, int nRound = 0, int bGoingToDie = FALSE)
{
    // Check if the power has been dispelled or the manifester has died in the meantime
    if(PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester))
    {
        return;
    }

    // Make sure the target is still alive
    if(!GetIsDead(oTarget))
    {
        // Did the target start choking to death last round?
        if(bGoingToDie == TRUE)
        {
            // HP goes to -1 and we end the effect. The target may or may not have a
            // chance of survival depending on how well a module follows PnP dying rules
            int nCurHP = GetCurrentHitPoints(oTarget);
            effect eDam = EffectDamage(nCurHP + 1);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

            // DR can go screw itself
            if(GetCurrentHitPoints(oTarget) != -1)
            {
                int nDamageReduction = GetCurrentHitPoints(oTarget) + 1;
                while(GetCurrentHitPoints(oTarget) > -1)
                {
                    eDam = EffectDamage(nDamageReduction + GetCurrentHitPoints(oTarget) + 1);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

                    // And in case there is a next iteration
                    nDamageReduction += 1;
                }
            }

            return;
        }
        // Has the target moved?
        else if(GetLocation(oTarget) != lTarget)
        {
            // Adjust save by amount of rounds spent without breath
            int nDCTemp = nDC + nRound;
            nRound += 1;

            // Roll fortitude
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDCTemp, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                int nCurHP = GetCurrentHitPoints(oTarget);
                effect eDam = EffectDamage(nCurHP - 1);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                bGoingToDie = TRUE;
            }
        }
        // Not moved, reset counter
        else
            nRound = 0;

        // Schedule next check
        DelayCommand(6.0f, RunImpact(oTarget, lTarget, oManifester, nSpellID, nDC, nRound, bGoingToDie));
    }
}

int CheckRace(struct manifestation manif, object oTarget)
{
	int nRacial = MyPRCGetRacialType(oTarget);
	int bTargetRace = FALSE;
	//Verify that the Racial Type is humanoid
	if(nRacial == RACIAL_TYPE_DWARF              ||
       nRacial == RACIAL_TYPE_ELF                ||
       nRacial == RACIAL_TYPE_GNOME              ||
       nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID ||
       nRacial == RACIAL_TYPE_HALFLING           ||
       nRacial == RACIAL_TYPE_HUMAN              ||
       nRacial == RACIAL_TYPE_HALFELF            ||
       nRacial == RACIAL_TYPE_HALFORC            ||
       nRacial == RACIAL_TYPE_HUMANOID_ORC       ||
       nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN
       )
    {
        bTargetRace = TRUE;
    }
    // First augmentation option adds animal, fey, giant, magical beast, and monstrous humanoid to possible target types
    if(manif.nTimesAugOptUsed_1 == 1 &&
       (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS ||
        nRacial == RACIAL_TYPE_FEY                ||
        nRacial == RACIAL_TYPE_GIANT              ||
        nRacial == RACIAL_TYPE_ANIMAL             ||
        nRacial == RACIAL_TYPE_MAGICAL_BEAST      ||
        nRacial == RACIAL_TYPE_BEAST
      ))
    {
        bTargetRace = TRUE;
    }
    // First augmentation option adds aberration, dragon, elemental, and outsider to possible target types
    if(manif.nTimesAugOptUsed_2 == 1 &&
       (nRacial == RACIAL_TYPE_ABERRATION ||
        nRacial == RACIAL_TYPE_DRAGON     ||
        nRacial == RACIAL_TYPE_OUTSIDER   ||
        nRacial == RACIAL_TYPE_ELEMENTAL
       ))
    {
        bTargetRace = TRUE;
    }
    
    if (GetHasFeat(FEAT_BREATHLESS, oTarget)) bTargetRace = FALSE;

	return bTargetRace;
}

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
                              PowerAugmentationProfile(2,
                                                       2, 1,
                                                       4, 1,
                                                       6, 1
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed;
        int nPen     = GetPsiPenetration(oManifester);
        int bValidTarget;
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
        float fDur = 6.0f * manif.nManifesterLevel;

        if(manif.bExtend) fDur *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do the primary target if it hasn't been already affected in the previous iteration
            if(!GetLocalInt(oMainTarget, "PRC_CrisisOfBreathMarker"))
            {
                if(CheckRace(manif, oMainTarget))
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, oManifester);

                    if(PRCMyResistPower(oManifester, oMainTarget, nPen))
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oMainTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS) && !GetIsImmune(oMainTarget, IMMUNITY_TYPE_MIND_SPELLS))
                        {
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oMainTarget, fDur, TRUE, manif.nSpellID, manif.nManifesterLevel);
                            RunImpact(oMainTarget, GetLocation(oMainTarget), oManifester, manif.nSpellID, nDC);

                            // Set a marker on the target for next iteration, so the heartbeat won't get run twice
                            SetLocalInt(oMainTarget, "PRC_CrisisOfBreathMarker", TRUE);
                            DeleteLocalInt(oMainTarget, "PRC_CrisisOfBreathMarker");
                        }
                    }
                    else
                    {
                        effect eSmoke = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oMainTarget);
                    }
                }// end if - Target is of an affectable type
            }// end if - Target has no been affected yet

            if(manif.nTimesAugOptUsed_3 == 1)
            {
                location lTarget = PRCGetSpellTargetLocation();
                float fRadius = EvaluateWidenPower(manif, FeetToMeters(20.0f));
                int nExtraTargets = 4;

                //Cycle through the targets within the spell shape until you run out of targets.
                object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oAreaTarget) && nExtraTargets > 0)
                {

                    if(oAreaTarget != manif.oManifester                                             &&
                       spellsIsTarget(oAreaTarget, SPELL_TARGET_STANDARDHOSTILE, manif.oManifester) &&
                       !GetLocalInt(oAreaTarget, "PRC_CrisisOfBreathMarker")                        &&
                       CheckRace(manif, oAreaTarget)						    &&
			oAreaTarget != oMainTarget)
                    {
                        // Let the AI know
                        PRCSignalSpellEvent(oAreaTarget, TRUE, manif.nSpellID, oManifester);

                        if(PRCMyResistPower(oManifester, oAreaTarget, nPen))
                        {
                            if(!PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS) && !GetIsImmune(oAreaTarget, IMMUNITY_TYPE_MIND_SPELLS))
                            {
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAreaTarget);
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oAreaTarget, fDur, TRUE, manif.nSpellID, manif.nManifesterLevel);
                                RunImpact(oAreaTarget, GetLocation(oAreaTarget), oManifester, manif.nSpellID, nDC);

                                // Set a marker on the target for next iteration, so the heartbeat won't get run twice
                                SetLocalInt(oAreaTarget, "PRC_CrisisOfBreathMarker", TRUE);
                                DeleteLocalInt(oAreaTarget, "PRC_CrisisOfBreathMarker");
                            }
                        }
                        else
                        {
                            effect eSmoke = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oAreaTarget);
                        }

                        // Use up a target slot only if we actually did something to it
                        nExtraTargets -= 1;
                    }// end if - Target validity

                    //Select the next target within the spell shape.
                    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                }// end while - Get targest
            }// end if - The augmentation for extra targets was used
        }// end for - Twin Power
    }// end if - Successfull manifestation
}