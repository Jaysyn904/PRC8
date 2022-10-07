/*
   ----------------
   Dominate, Psionic

   psi_pow_dominate
   ----------------

   16/4/05 by Stratovarius
*/ /** @file

    Dominate, Psionic

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Telepath 4
    Manifesting Time: 1 round
    Range: Medium (100 ft. + 10 ft./level)
    Target: One humanoid
    Duration: 1 round/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Extend, Twin, Widen

    The target temporarily becomes a faithful and loyal servant of the manifester.

    Augment: You can augment this power in one or more of the following ways.
    1. If you spend 2 additional power points, this power can also affect an animal, fey, giant, magical beast, or monstrous humanoid.
    2. If you spend 4 additional power points, this power can also affect an aberration, dragon, elemental, or outsider in addition to the creature types mentioned above.
    3. For every 2 additional power points you spend, this power can affect an additional target. Any additional target cannot be more than 15 feet from another target of the power.
    4. If you spend 1 additional power point, this power's duration is 1 hour rather than 1 round per manifester level. If you spend 2 additional power points, this power's duration is 1 day rather than 1 round per manifester level.
    In addition, for every 2 additional power points you spend to achieve any of these effects, this power’s save DC increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

int CheckRace(struct manifestation manif, object oTarget);

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
                              PowerAugmentationProfile(2,
                                                       2, 1,
                                                       4, 1,
                                                       2, PRC_UNLIMITED_AUGMENTATION,
                                                       1, 2
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed;
        int nPen          = GetPsiPenetration(oManifester);
        int nExtraTargets = manif.nTimesAugOptUsed_3;
        effect eMindVFX  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDominate = EffectCutsceneDominated();   // Allows multiple dominated creatures
        effect eLink;
        location lTarget = PRCGetSpellTargetLocation();
        float fRadius = EvaluateWidenPower(manif, FeetToMeters(15.0f));

        // Calculate duration
        float fDuration;
        switch(manif.nTimesAugOptUsed_4)
        {
            case 0: fDuration = RoundsToSeconds(manif.nManifesterLevel); break;
            case 1: fDuration = HoursToSeconds(1); break;
            case 2: fDuration = HoursToSeconds(24); break;

            default:
                if(DEBUG) DoDebug("psi_pow_dominate: ERROR: Unknown value in fourth augmentation: " + IntToString(manif.nTimesAugOptUsed_4));
                fDuration = 0.0f;
        }
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Main target
            if(CheckRace(manif, oTarget))
            {
                // Let the AI know
                PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    //Make a saving throw check
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        // Extra domination immunity check - using EffectCutsceneDominated(), which normally bypasses
                        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DOMINATE) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                        {
                            // Determine effect and apply it
                            eLink = EffectLinkEffects(eMindVFX, PRCGetScaledEffect(eDominate, oTarget));
                            DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel));
                        }
                    }// end if - Save
                }// end if - SR check
            }// end if - Target type check

            // Additional targets
            if(nExtraTargets)
            {
                // Get targets until out of potential targets or cannot affect any more
                int nTargetsLeft = nExtraTargets;
                object oExtraTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(nTargetsLeft > 0 && GetIsObjectValid(oExtraTarget))
                {
                    if(oExtraTarget != oManifester                                              && // Does not affect the manifester
                       oExtraTarget != oTarget                                                  && // Does not affect the same target twice
                       spellsIsTarget(oExtraTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester) && // User gets to pick targets
                       CheckRace(manif, oExtraTarget)                                              // Target type check
                       )
                    {
                        // Let the AI know
                        PRCSignalSpellEvent(oExtraTarget, TRUE, manif.nSpellID, oManifester);
                        //Check for Power Resistance
                        if(PRCMyResistPower(oManifester, oExtraTarget, nPen))
                        {
                            //Make a saving throw check
                           if(!PRCMySavingThrow(SAVING_THROW_WILL, oExtraTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                            {
                                // Extra domination immunity check - using EffectCutsceneDominated(), which normally bypasses
                                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DOMINATE) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                                {
                                    // Determine effect and apply it
                                    eLink = EffectLinkEffects(eMindVFX, PRCGetScaledEffect(eDominate, oExtraTarget));
                                    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oExtraTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel));
                                }
                            }// end if - Save
                        }// end if - SR check

                        // Use up a target slot only if we actually did something to it
                        nTargetsLeft -= 1;
                    }

                    //Select the next target within the spell shape.
                    oExtraTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                }// end while - Target loop
            }// end if - More than one target
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

int CheckRace(struct manifestation manif, object oTarget)
{
    int nRacial     = MyPRCGetRacialType(oTarget);
    int bTargetRace = FALSE;
    // Check if the target is a humanoid
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
    if((manif.nTimesAugOptUsed_1 == 1             ||
        GetLevelByClass(CLASS_TYPE_THRALLHERD, manif.oManifester) >= 7
        ) &&
       (nRacial == RACIAL_TYPE_ANIMAL             ||
        nRacial == RACIAL_TYPE_FEY                ||
        nRacial == RACIAL_TYPE_GIANT              ||
        nRacial == RACIAL_TYPE_MAGICAL_BEAST      ||
        nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS ||
        nRacial == RACIAL_TYPE_BEAST
      ))
    {
        bTargetRace = TRUE;
    }
    // First augmentation option adds aberration, dragon, elemental, and outsider to possible target types
    if((manif.nTimesAugOptUsed_2 == 1     ||
        GetLevelByClass(CLASS_TYPE_THRALLHERD, manif.oManifester) >= 9
        ) &&
       (nRacial == RACIAL_TYPE_ABERRATION ||
        nRacial == RACIAL_TYPE_DRAGON     ||
        nRacial == RACIAL_TYPE_ELEMENTAL  ||
        nRacial == RACIAL_TYPE_OUTSIDER
       ))
    {
        bTargetRace = TRUE;
    }

    return bTargetRace;
}
