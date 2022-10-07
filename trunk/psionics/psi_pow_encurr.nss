/*
   ----------------
   Energy Current

   psi_pow_encurr
   ----------------

   2/8/05 by Stratovarius
*/ /** @file

    Energy Current

    Psychokinesis [see text]
    Level: Kineticist 5
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: Any two creatures no more than 15 ft. apart
    Duration: Concentration, up to 1 round/level
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 9
    Metapsionics: Empower, Extend, Maximize

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    Your body’s psionically fueled bioenergetic currents produce an arc of
    energy of the chosen type that targets a creature you designate as the
    primary foe for 9d6 points of damage in every round when the power remains
    in effect. Energy also arcs off the primary foe to strike one additional foe
    that is initially within 15 feet of the primary foe, or that subsequently
    moves within 15 feet of the primary foe while the duration lasts. Secondary
    foes take half the damage that the primary foe takes in every round while
    the duration lasts.

    Should either the primary or secondary foe fall to less than 0 hit points
    (or should a target completely evade the effect with a special ability or
    power), the energy current ’s arc randomly retargets another primary and/or
    secondary foe while the duration lasts. Targeted foes can move normally,
    possibly moving out of range of the effect, but each round they are targeted
    and remain in range they must make a saving throw to avoid taking full
    damage in that round.

    Concentrating to maintain energy current is a full-round action. If you take
    damage while maintaining energy current, you must make a successful
    Concentration check (DC 10 + damage dealt) to avoid losing your
    concentration on the power.

    Cold: A current of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold current is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a current of this energy type provides a +2 bonus
                 to the save DC and a +2 bonus on manifester level checks for
                 the purpose of overcoming power resistance.
    Fire: A current of this energy type deals +1 point of damage per die.
    Sonic: A current of this energy type deals -1 point of damage per die and
           ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.

    Augment: You can augment this power in one or both of the following ways.
    1. For every additional power point you spend, this power’s damage increases
       by one die (d6). For each extra two dice of damage, this power’s save DC
       increases by 1.
    2. For every 4 additional power points you spend, this power can affect an
       additional secondary target. Any additional secondary target cannot be
       more than 15 feet from another target of the power.

    @todo 2da
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"
#include "psi_inc_enrgypow"


const string SECONDARY_TARGETS_ARRAY = "PRC_Power_EnergyCurrent_SecondaryTargets";


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

void EnergyCurrentHB(struct manifestation manif, struct energy_adjustments enAdj,
                     object oMainTarget, int nDC, int nPen, int nNumberOfDice, int nSecondaryTargets, float fRange,
                     location lManifesterOld, int nBeatsRemaining, int bFirst);

void SecondaryTargetsCheck(object oManifester, object oMainTarget, int nSecondaryTargets, int nPen);

void DoEnergyCurrentDamage(struct manifestation manif, struct energy_adjustments enAdj,
                           object oMainTarget, int nDC, int nPen, int nNumberOfDice);


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void main()
{
    // Are we running the manifestation part or the eventhook
    if(GetRunningEvent() != EVENT_ONHIT)
    {
        // Power use hook
        if(!PsiPrePowerCastCode()) return;

        object oManifester = OBJECT_SELF;
        object oMainTarget = PRCGetSpellTargetObject();
        struct manifestation manif =
            EvaluateManifestation(oManifester, oMainTarget,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           1, PRC_UNLIMITED_AUGMENTATION,
                                                           4, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_EMPOWER | METAPSIONIC_EXTEND | METAPSIONIC_MAXIMIZE
                                  );

        if(manif.bCanManifest)
        {
            struct energy_adjustments enAdj =
                EvaluateEnergy(manif.nSpellID, POWER_ENERGYCURRENT_COLD, POWER_ENERGYCURRENT_ELEC, POWER_ENERGYCURRENT_FIRE, POWER_ENERGYCURRENT_SONIC,
                               VFX_BEAM_COLD, VFX_BEAM_LIGHTNING, VFX_BEAM_FIRE, VFX_BEAM_ODD);
            int nDC               = GetManifesterDC(oManifester) + enAdj.nDCMod + (manif.nTimesAugOptUsed_1 / 2);
            int nPen              = GetPsiPenetration(oManifester) + enAdj.nPenMod;
            int nNumberOfDice     = 9 + manif.nTimesAugOptUsed_1;
            int nSecondaryTargets = 1 + manif.nTimesAugOptUsed_2;
            effect eDurManifester = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
            float fRange          = 25.0f + (5.0f * (manif.nManifesterLevel / 2));
            float fDuration       = 6.0f * manif.nManifesterLevel;
            if(manif.bExtend) fDuration *= 2;

            // Get the OnHitCast: Unique on the manifester's armor / hide
            ExecuteScript("prc_keep_onhit_a", oManifester);

            // Hook eventscript for concentration checks due to being damaged
            AddEventScript(oManifester, EVENT_ONHIT, "psi_pow_encurr", TRUE, FALSE);

            // Apply a VFX for the dispelling check to look for
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurManifester, oManifester, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

            // Power resistance for the first main target
            if(!PRCMyResistPower(oManifester, oMainTarget, nPen))
            {
                // Set the main target to be invalid so the loop will select a new one
                oMainTarget = OBJECT_INVALID;
            }

            // Start the heartbeat
            EnergyCurrentHB(manif, enAdj, oMainTarget, nDC, nPen, nNumberOfDice, nSecondaryTargets, fRange, GetLocation(oManifester), FloatToInt(fDuration) / 6, TRUE);
        }// end if - Successfull manifestation
    }// end if - Manifesting the power
    else
    {
        object oManifester = OBJECT_SELF;
        object oItem       = GetSpellCastItem();

        // Make sure the one doing the triggering hit was someone else
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR ||
           GetBaseItemType(oItem) == BASE_ITEM_CREATUREITEM
           )
        {
            // DC 10 + damage dealt to keep the Energy Current running
            if(!GetIsSkillSuccessful(oManifester, SKILL_CONCENTRATION, (10 + GetTotalDamageDealt())))
            {
                // Set a marker that tells the HB to stop
                SetLocalInt(oManifester, "PRC_Power_EnergyCurrent_ConcentrationBroken", TRUE);
            }
        }// end if - Manifester was the one hit in the triggering attack
    }// end else - Running eventhook
}

void EnergyCurrentHB(struct manifestation manif, struct energy_adjustments enAdj,
                     object oMainTarget, int nDC, int nPen, int nNumberOfDice, int nSecondaryTargets, float fRange,
                     location lManifesterOld, int nBeatsRemaining, int bFirst)
{
    // Check expiration
    if(!GetLocalInt(manif.oManifester, "PRC_Power_EnergyCurrent_ConcentrationBroken")                   && // The manifester's concentration hasn't been broken due to damage
       nBeatsRemaining-- > 0                                                                            && // The power's duration hasn't run out yet
       !PRCGetDelayedSpellEffectsExpired(manif.nSpellID, manif.oManifester, manif.oManifester)          && // Not dispelled
       !GetBreakConcentrationCheck(manif.oManifester)                                                      // The manifester isn't doing anything that breaks their concentration
       )
    {
        location lManifester = GetLocation(manif.oManifester);
        // First, check if the primary target needs to be switched
        if(!bFirst                                                     &&  // Don't reselect even if the original primary target succeeded at it's PR
           (!GetIsObjectValid(oMainTarget)                              || // The creature no longer exists
            GetCurrentHitPoints(oMainTarget) < 0                        || // The creature's HP has gone under zero
            GetDistanceBetween(manif.oManifester, oMainTarget) > fRange    // The creature is out of the power's range
            )
           )
        {
            // Select a new main target
            // NOTE: This intentionally ignores the My*ObjectInShape wrapper
            object oTest = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lManifester, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTest))
            {
                // Target only hostiles, and only ones that the manifester can see
                if(oTest != manif.oManifester                                              &&
                   spellsIsTarget(oTest, SPELL_TARGET_SELECTIVEHOSTILE, manif.oManifester) &&
                   !GetIsDead(oTest)                                                       &&
                   GetObjectSeen(oTest, manif.oManifester)
                   )
                {
                    AddToTargetList(oTest, manif.oManifester, INSERTION_BIAS_DISTANCE, FALSE);
                }

                // Get next potential target
                oTest = GetNextObjectInShape(SHAPE_SPHERE, fRange, lManifester, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target selection loop

            // Select the hostile creature closest to the manifester
            oMainTarget = GetTargetListHead(manif.oManifester);

            // Power resistance
            if(!PRCMyResistPower(manif.oManifester, oMainTarget, nPen))
            {
                // Set the target to be invalid - No current this round
                oMainTarget = OBJECT_INVALID;
            }

            // Nuke the secondary targets array so we are forced to fully recalculate it
            array_delete(manif.oManifester, SECONDARY_TARGETS_ARRAY);
        }// end if - Main target selection

        // Make sure we have a valid primary target at this point
        if(GetIsObjectValid(oMainTarget))
        {
            // Check secondary targets array existence
            if(!array_exists(manif.oManifester, SECONDARY_TARGETS_ARRAY))
                array_create(manif.oManifester, SECONDARY_TARGETS_ARRAY);

            // If the array contains empty slots or slots with creatures that are now outside the range, reselect secondary targets
            SecondaryTargetsCheck(manif.oManifester, oMainTarget, nSecondaryTargets, nPen);

            // Run the actual damage dealing
            DoEnergyCurrentDamage(manif, enAdj, oMainTarget, nDC, nPen, nNumberOfDice);
        }// end if - The primary target is valid

        // Schedule next HB
        DelayCommand(6.0f, EnergyCurrentHB(manif, enAdj, oMainTarget, nDC, nPen, nNumberOfDice,
                                           nSecondaryTargets, fRange, lManifester, nBeatsRemaining, FALSE
                                           )
                     );
    }
    // Power expired for some reason, make sure VFX are gone
    else
    {
        if(DEBUG) DoDebug("psi_pow_encurr: Power expired");
        PRCRemoveSpellEffects(manif.nSpellID, manif.oManifester, manif.oManifester);
        DeleteLocalInt(manif.oManifester, "PRC_Power_EnergyCurrent_ConcentrationBroken");
        array_delete(manif.oManifester, SECONDARY_TARGETS_ARRAY);
    }
}

void SecondaryTargetsCheck(object oManifester, object oMainTarget, int nSecondaryTargets, int nPen)
{
    int i, nFirstEmpty = -1;
    float fRange = FeetToMeters(15.0f);
    object oTest;
    // Loop over the secondary targets array
    for(i = 0; i < nSecondaryTargets; i++)
    {
        // Check if each of the secondary targets still qualifies
        oTest = array_get_object(oManifester, SECONDARY_TARGETS_ARRAY, i);
//DoDebug("SecondaryTargetsCheck(): Testing if needs replacement: " + DebugObject2Str(oTest));
        if(!GetIsObjectValid(oTest)                              || // The creature no longer exists
           GetCurrentHitPoints(oTest) < 0                        || // The creature's HP has gone under zero
           GetDistanceBetween(oTest, oMainTarget) > fRange          // The creature is out of the power's range
           )
        {
/*DoDebug("SecondaryTargetsCheck(): Needs replacement\n"
      + "!GetIsObjectValid(oTest) = " + DebugBool2String(!GetIsObjectValid(oTest)) + "\n"
      + "GetCurrentHitPoints(oTest) < 0 = " + DebugBool2String(GetCurrentHitPoints(oTest) < 0) + "\n"
      + "GetDistanceBetween(oTest, oMainTarget) > fRange = " + DebugBool2String(GetDistanceBetween(oTest, oMainTarget) > fRange) + "\n"
        );*/
            // If one doesn't, clear the array entry and set the return value to indicate that secondary targets need to be reselected
            array_set_object(oManifester, SECONDARY_TARGETS_ARRAY, i, OBJECT_INVALID);

            // Store the first empty index, which indicates the need for reselection
            if(nFirstEmpty == -1)
                nFirstEmpty = i;
        }
    }

    // If the secondary targets need reselection, do so
    if(nFirstEmpty != -1)
    {
        // An array to store names of temporary variables in
        if(array_exists(oManifester, "PRC_Power_EnCur_Temp"))
            array_delete(oManifester, "PRC_Power_EnCur_Temp");
        array_create(oManifester, "PRC_Power_EnCur_Temp");

        string sName;

        // Store the UIDs (memory address) of the current valid secondary targets into a hash table
        for(i = 0; i < nSecondaryTargets; i++)
        {
            oTest = array_get_object(oManifester, SECONDARY_TARGETS_ARRAY, i);
            if(oTest != OBJECT_INVALID)// Do not store OBJECT_INVALID, since it wouldn't get cleared after reselection
            {
                sName = "PRC_Power_EnCur_Target_" + ObjectToString(oTest);
                SetLocalInt(oManifester, sName, TRUE);
                array_set_string(oManifester, "PRC_Power_EnCur_Temp", array_get_size(oManifester, "PRC_Power_EnCur_Temp"), sName);
            }
        }

        // Get creatures that are eligible for secondary targethood until all slots are filled
        // or there are no more eligible targets left unselected
        i = nFirstEmpty;
        location lTarget = GetLocation(oMainTarget);
        oTest = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTest) && i < nSecondaryTargets)
        {
            // Targeting limitations, yay
            if(oTest != oManifester                                                         && // Not the manifester
               oTest != oMainTarget                                                         && // Not the main target
               !GetIsDead(oTest)                                                            && // Target is alive...
               !GetLocalInt(oManifester, "PRC_Power_EnCur_Target_" + ObjectToString(oTest)) && // Not an existing secondary target
               spellsIsTarget(oTest, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)               // And the target is hostile
               )
            {
                // Power resistance
                if(!PRCMyResistPower(oManifester, oTest, nPen))
                {
                    // Set the target to be invalid - The slot will be left empty this round
                    oTest = OBJECT_INVALID;
                }

                // Store the target in the secondary target array
                array_set_object(oManifester, SECONDARY_TARGETS_ARRAY, i, oTest);

                // Find next empty slot
                while(array_get_object(oManifester, SECONDARY_TARGETS_ARRAY, ++i) != OBJECT_INVALID)
                    ;
            }

            // Get next potential target
            oTest = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Target selection loop

        // Remove the UID locals
        int nMax = nSecondaryTargets;//array_get_size(oManifester, "PRC_Power_EnCur_Temp");
        for(i = 0; i < nMax; i++)
        {
            DeleteLocalInt(oManifester, array_get_string(oManifester, "PRC_Power_EnCur_Temp", i));
            DeleteLocalInt(oManifester, "PRC_Power_EnCur_Target_"
                         + ObjectToString(array_get_object(oManifester, SECONDARY_TARGETS_ARRAY, i))
                           );
        }

        array_delete(oManifester, "PRC_Power_EnCur_Temp");
    }// end if - Reselect secondary targets
}

void DoEnergyCurrentDamage(struct manifestation manif, struct energy_adjustments enAdj,
                           object oMainTarget, int nDC, int nPen, int nNumberOfDice)
{
    int nDieSize = 6;
    int nDamage, nSecondaryDamage, i;
    effect eVis  = EffectVisualEffect(enAdj.nVFX1);
    effect eDamage;
    object oSecondaryTarget;

    // Try to affect the main target
    // Roll damage
    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, FALSE);
    // Target-specific stuff
    nDamage = GetTargetSpecificChangesToDamage(oMainTarget, manif.oManifester, nDamage, TRUE, TRUE);

    // Do save
    if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
    {
        // Cold has a fort save for half
        if(PRCMySavingThrow(SAVING_THROW_FORT, oMainTarget, nDC, enAdj.nSaveType))
                            {
				if (GetHasMettle(oMainTarget, SAVING_THROW_FORT))
				// This script does nothing if it has Mettle, bail
					nDamage = 0;
                                nDamage /= 2;
                            }
    }
    else
        // Adjust damage according to Reflex Save, Evasion or Improved Evasion
        nDamage = PRCGetReflexAdjustedDamage(nDamage, oMainTarget, nDC, enAdj.nSaveType);

    // Fire the ray
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(enAdj.nVFX2, manif.oManifester, BODY_NODE_HAND, nDamage == 0), oMainTarget, 1.7f, FALSE);

    // Let the main target's AI know it's being targeted with a hostile spell
    PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, manif.oManifester);

    // Deal damage if the target didn't Evade it
    if(nDamage > 0)
    {
        eDamage = EffectDamage(nDamage, enAdj.nDamageType);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oMainTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);

        // Secondary targets take half the amount the primary took
        nDamage /= 2;

        // Deal with the secondary targets
        for(i = 0; i < array_get_size(manif.oManifester, SECONDARY_TARGETS_ARRAY); i++)
        {
            // Get target to affect
            oSecondaryTarget = array_get_object(manif.oManifester, SECONDARY_TARGETS_ARRAY, i);
            // Determine damage
            nSecondaryDamage = nDamage;
            // Target-specific stuff
            nSecondaryDamage = GetTargetSpecificChangesToDamage(oSecondaryTarget, manif.oManifester, nSecondaryDamage, TRUE, TRUE);

            // Do save
            if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
            {
                // Cold has a fort save for half
                if(PRCMySavingThrow(SAVING_THROW_FORT, oSecondaryTarget, nDC, enAdj.nSaveType))
                    nSecondaryDamage /= 2;
            }
            else
                // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nSecondaryDamage = PRCGetReflexAdjustedDamage(nSecondaryDamage, oSecondaryTarget, nDC, enAdj.nSaveType);

            // Fire the ray
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(enAdj.nVFX2, oMainTarget, BODY_NODE_CHEST, nSecondaryDamage == 0), oSecondaryTarget, 1.7f, FALSE);

            // Let the secondary target's AI know it's being targeted with a hostile spell
            PRCSignalSpellEvent(oSecondaryTarget, TRUE, manif.nSpellID, manif.oManifester);

            // Deal damage if the target didn't Evade it
            if(nSecondaryDamage > 0)
            {
                eDamage = EffectDamage(nSecondaryDamage, enAdj.nDamageType);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oSecondaryTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSecondaryTarget);
            }// end if - There was still damage remaining to be dealt after adjustments
        }// end for - Secondary targets
    }// end if - There was still damage remaining to be dealt after adjustments
}
