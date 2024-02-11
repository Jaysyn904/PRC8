/*
   ----------------
   Fate Link

   psi_pow_fatelink
   ----------------

   15/7/05 by Stratovarius
*/ /** @file

    Fate Link

    Clairsentience
    Level: Seer 3
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: Any two living creatures that are initially no more than 30 ft. apart.
    Duration: 10 min./level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Extend

    You temporarily link the fates of any two creatures, if both fail their
    saving throws. If either linked creature experiences pain, both feel it.
    When one loses hit points, the other loses the same amount. If one takes
    nonlethal damage, so does the other. If one creature is subjected to an
    effect to which it is immune (such as a type of energy damage), the linked
    creature is not subjected to it either. If one dies, the other must
    immediately succeed on a Fortitude save against this power's save DC or gain
    two negative levels.

    No other effects are transferred by the fate link.

    Augment: For every 2 additional power points you spend, this power's save DC
    increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

//ebonfowl: new HB loop to handle damage, no more on hit
void FateLinkHB (object oTarget1, object oTarget2);

void DispelMonitor(object oManifester, object oTarget1, object oTarget2, int nSpellID, int nBeatsRemaining);

void main()
{
        if(!PsiPrePowerCastCode()) return;

        object oManifester  = OBJECT_SELF;
        object oFirstTarget = PRCGetSpellTargetObject();
        struct manifestation manif =
            EvaluateManifestation(oManifester, oFirstTarget,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           2, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_EXTEND
                                  );

        if(manif.bCanManifest)
        {
            int nDC           = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
            int nPen          = GetPsiPenetration(oManifester);
            int nHP1          = GetCurrentHitPoints(oFirstTarget);
            int nRacialType, nHP2;
            effect eVis       = EffectVisualEffect(VFX_IMP_HEAD_MIND);
            effect eDur       = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
            location lTarget  = GetLocation(oFirstTarget);
            float fRadius     = FeetToMeters(30.0f);
            float fDuration   = 600.0f * manif.nManifesterLevel;
            if(manif.bExtend) fDuration *= 2;

            // Make sure the first target is alive
            nRacialType = MyPRCGetRacialType(oFirstTarget);
            if((nRacialType != RACIAL_TYPE_CONSTRUCT || GetIsWarforged(oFirstTarget)) &&
               nRacialType != RACIAL_TYPE_UNDEAD    &&
               !GetIsDead(oFirstTarget)
               )
            {
                // Get the second target to link with the first
                object oSecondTarget = OBJECT_INVALID;
                object oTest = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oTest))
                {
                    // Reasonable targeting
                    if(oTest != oManifester  &&
                       spellsIsTarget(oTest, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)
                       )
                    {
                        // Livingness check
                        nRacialType = MyPRCGetRacialType(oTest);
                        if((nRacialType != RACIAL_TYPE_CONSTRUCT || GetIsWarforged(oTest)) &&
                           nRacialType != RACIAL_TYPE_UNDEAD    &&
                           !GetIsDead(oTest)
                           )
                        {
                            // Found the target
                            oSecondTarget = oTest;
                            // End loop
                            break;
                        }// end if - The target is alive
                    }// end if - Target validity check
                }// end while - Target loop

                nHP2 = GetCurrentHitPoints(oSecondTarget);

                // Make sure we have two valid targets
                if(GetIsObjectValid(oFirstTarget) && GetIsObjectValid(oSecondTarget))
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oFirstTarget, TRUE, manif.nSpellID, oManifester);
                    PRCSignalSpellEvent(oSecondTarget, TRUE, manif.nSpellID, oManifester);

                    // SR checks
                    if(PRCMyResistPower(oManifester, oFirstTarget, nPen) &&
                       PRCMyResistPower(oManifester, oSecondTarget, nPen)
                       )
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oFirstTarget, nDC, SAVING_THROW_TYPE_NONE) &&
                           !PRCMySavingThrow(SAVING_THROW_WILL, oSecondTarget, nDC, SAVING_THROW_TYPE_NONE)
                           )
                        {
                            // No stacking - concurrency issues
                            if(!GetLocalInt(oFirstTarget, "PRC_Power_FateLink_DC") &&
                               !GetLocalInt(oSecondTarget, "PRC_Power_FateLink_DC")
                               )
                            {
                                // Impact visuals
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSecondTarget);

                                // VFX for the monitor to look for
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oFirstTarget,  fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oSecondTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

                                // Set up the Fate Link locals
                                SetLocalInt(oFirstTarget,  "PRC_Power_FateLink_DC", nDC);
                                SetLocalInt(oSecondTarget, "PRC_Power_FateLink_DC", nDC);
                                SetLocalObject(oFirstTarget,  "PRC_Power_FateLink_LinkedTo", oSecondTarget);
                                SetLocalObject(oSecondTarget, "PRC_Power_FateLink_LinkedTo", oFirstTarget);
                                SetLocalInt(oFirstTarget,  "FateLinkHP", nHP1);
                                SetLocalInt(oSecondTarget, "FateLinkHP", nHP2);

                                //ebonfowl: Start HB
                                FateLinkHB(oFirstTarget, oSecondTarget);
                                
                                // Start end monitor
                                DelayCommand(6.0f, DispelMonitor(oManifester, oFirstTarget, oSecondTarget,  manif.nSpellID, FloatToInt(fDuration) / 6));
                            }// end if - Neither of the targets is already affected by Fate Link
                        }// end if - Targets failed their saves
                    }// end if - Targets failed SR
                }// end if - Both targets are valid
            }// end if - The first target is living
        }// end if - Successfull manifestation
}

void FateLinkHB (object oTarget1, object oTarget2)
{
    int nDC = GetLocalInt(oTarget1, "PRC_Power_FateLink_DC");
    
    effect eDrain  = EffectNegativeLevel(2);

    //Death checks
    if(GetIsDead(oTarget1))
    {
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget2, nDC, SAVING_THROW_TYPE_NONE))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget2, HoursToSeconds(24));
        }

        //Kill the HB
        SetLocalInt(oTarget2, "FateLinkStop", TRUE);
        DelayCommand(1.0, DeleteLocalInt(oTarget2, "FateLinkStop"));
    }
    if(GetIsDead(oTarget2))
    {
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget1, nDC, SAVING_THROW_TYPE_NONE))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget1, HoursToSeconds(24));
        }

        //Kill the HB
        SetLocalInt(oTarget1, "FateLinkStop", TRUE);
        DelayCommand(1.0, DeleteLocalInt(oTarget1, "FateLinkStop"));
    }

    //Now check for damage
    int nCurHP1 = GetCurrentHitPoints(oTarget1);
    int nPreHP1 = GetLocalInt(oTarget1, "FateLinkHP");
    int nCurHP2 = GetCurrentHitPoints(oTarget2);
    int nPreHP2 = GetLocalInt(oTarget2, "FateLinkHP");
    int nDamageTaken1, nDamageTaken2, nNewHP1, nNewHP2;

    //Calculate damage taken
    if (nPreHP1 > nCurHP1) nDamageTaken1 = nPreHP1 - nCurHP1;
    if (nPreHP2 > nCurHP2) nDamageTaken2 = nPreHP2 - nCurHP2;

    //This could also be done with a damage effect, but I like this way as nothing can resist it
    if (nPreHP2 > nCurHP2)
    {
        //Reduce first target's HP
        nNewHP1 = nCurHP1 - nDamageTaken2;
        SetCurrentHitPoints(oTarget1, nNewHP1);
    }

    if (nPreHP1 > nCurHP1)
    {
        //Reduce second target's HP
        nNewHP2 = nCurHP2 - nDamageTaken1;
        SetCurrentHitPoints(oTarget2, nNewHP2);
    }

    //New HP total to transfer to next HB - try and use the new HP calculation to hedge against intra-script damage
    if (nNewHP1 > 0) SetLocalInt(oTarget1, "FateLinkHP", nNewHP1);
    else SetLocalInt(oTarget1, "FateLinkHP", GetCurrentHitPoints(oTarget1));
    
    if (nNewHP2 > 0) SetLocalInt(oTarget2, "FateLinkHP", nNewHP2);
    else SetLocalInt(oTarget2, "FateLinkHP", GetCurrentHitPoints(oTarget2));

    if (!GetLocalInt(oTarget1, "FateLinkStop") && !GetLocalInt(oTarget2, "FateLinkStop"))
    DelayCommand(0.25, FateLinkHB(oTarget1, oTarget2));
}

void DispelMonitor(object oManifester, object oTarget1, object oTarget2, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget1, oManifester) ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget2, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_fatelink: Clearing");
        // Clear the effect presence marker
        DeleteLocalInt(oTarget1, "PRC_Power_FateLink_DC");
        DeleteLocalInt(oTarget2, "PRC_Power_FateLink_DC");
        DeleteLocalObject(oTarget1, "PRC_Power_FateLink_LinkedTo");
        DeleteLocalObject(oTarget2, "PRC_Power_FateLink_LinkedTo");

        //ebonfowl: kill the new HB function
        SetLocalInt(oTarget1, "FateLinkStop", TRUE);
        DelayCommand(1.0, DeleteLocalInt(oTarget1, "FateLinkStop"));
        SetLocalInt(oTarget2, "FateLinkStop", TRUE);
        DelayCommand(1.0, DeleteLocalInt(oTarget2, "FateLinkStop"));

        // Remove remaining effects
        //ebonfowl: will this remove the negative levels prematurely if one target died?  If so, this should be done with TagEffect for more control
        PRCRemoveSpellEffects(nSpellID, oManifester, oTarget1);
        PRCRemoveSpellEffects(nSpellID, oManifester, oTarget2);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget1, oTarget2, nSpellID, nBeatsRemaining));
}
