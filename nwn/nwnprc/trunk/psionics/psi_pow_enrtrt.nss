/*
   ----------------
   Energy Retort

   psi_pow_enrtrt
   ----------------

   11/12/04 by Stratovarius
*/ /** @file

    Energy Retort

    Psychokinesis [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Personal and close (25 ft. + 5 ft./2 levels); see text
    Targets: You and creature or object attacking you; see text
    Duration: 1 min./level
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Chain, Empower, Extend, Maximize

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You weave a field of potential energy of the chosen type around your body.
    The first successful attack made against you in each round during the
    power’s duration prompts a response from the field without any effort on
    your part. The attack may be physical, the effect of a power, or the effect
    of a spell (including spell-like, supernatural, and extraordinary
    abilities). An “ectoburst” discharges from the field, targeting the source
    of the attack and dealing 4d6 points of damage of the chosen energy type.
    To be affected, a target must be within close range. The ectoburst is a
    ranged touch attack.

    Cold: A field of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold retort is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a field of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A field of this energy type deals +1 point of damage per die.
    Sonic: A field of this energy type deals -1 point of damage per die and
           ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power’s duration
             increases by 1 minute.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_sp_tch"
#include "psi_inc_enrgypow"

const string ENERGY_RETORT_VARNAME_BASE = "PRC_Power_EnergyRetort_";

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

void main()
{
    // Are we running the manifestation part or the onhit part?
    if(GetRunningEvent() != EVENT_ONHIT)
    {
        // Power use hook
        if (!PsiPrePowerCastCode())  return;

        object oManifester = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        struct manifestation manif =
                EvaluateManifestation(oManifester, oTarget,
                                      PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                               1, PRC_UNLIMITED_AUGMENTATION
                                                               ),
                                      METAPSIONIC_CHAIN | METAPSIONIC_EMPOWER | METAPSIONIC_EXTEND | METAPSIONIC_MAXIMIZE
                                      );

        if(manif.bCanManifest)
        {
            int nDC           = GetManifesterDC(oManifester);
            int nPen          = GetPsiPenetration(oManifester);
            effect eDur       = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
            float fDuration   = 60.0f * (manif.nManifesterLevel + manif.nTimesAugOptUsed_1);
            if(manif.bExtend) fDuration *= 2;

            // Get the OnHitCast: Unique on the target's armor / hide
            ExecuteScript("prc_keep_onhit_a", oTarget);

            // Hook eventscript
            AddEventScript(oTarget, EVENT_ONHIT, "psi_pow_enrtrt", TRUE, FALSE);

            // Store data for use when hit
            SetLocalManifestation(oTarget, ENERGY_RETORT_VARNAME_BASE + "Manifestation", manif);
            SetLocalInt(oTarget, ENERGY_RETORT_VARNAME_BASE + "DC", nDC);
            SetLocalInt(oTarget, ENERGY_RETORT_VARNAME_BASE + "SRPenetration", nPen);

            // Do VFX for the monitor to look for
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

            // Start effect end monitor
            DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
        }// end if - Successfull manifestation
    }// end if - Manifesting a power
    else
    {
        object oHit  = OBJECT_SELF;
        object oItem = GetSpellCastItem();

        // Make sure the one doing the triggering hit was someone else
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR ||
           GetBaseItemType(oItem) == BASE_ITEM_CREATUREITEM
           )
        {
            // Once per round lock
            if(GetLocalInt(oHit, ENERGY_RETORT_VARNAME_BASE + "UsedForRound"))
                return;
            else
            {
                SetLocalInt(oHit, ENERGY_RETORT_VARNAME_BASE + "UsedForRound", TRUE);
                DelayCommand(6.0f, DeleteLocalInt(oHit, ENERGY_RETORT_VARNAME_BASE + "UsedForRound"));
            }

            // Get data from the original manifestation
            struct manifestation manif      = GetLocalManifestation(oHit, ENERGY_RETORT_VARNAME_BASE + "Manifestation");
            object oMainTarget              = PRCGetSpellTargetObject();
            struct energy_adjustments enAdj =
                EvaluateEnergy(manif.nSpellID, POWER_ENERGYRETORT_COLD, POWER_ENERGYRETORT_ELEC, POWER_ENERGYRETORT_FIRE, POWER_ENERGYRETORT_SONIC,
                               VFX_BEAM_COLD, VFX_BEAM_LIGHTNING, VFX_BEAM_FIRE, VFX_BEAM_MIND);
            int nDC                         = GetLocalInt(oHit, ENERGY_RETORT_VARNAME_BASE + "DC") + enAdj.nDCMod;
            int nPen                        = GetLocalInt(oHit, ENERGY_RETORT_VARNAME_BASE + "SRPenetration") + enAdj.nPenMod;
            int nNumberOfDice               = 4;
            int nDieSize                    = 6;
            int nTouchAttack,
                nOriginalDamage,
                nDamage,
                i;
            effect eVis                     = EffectVisualEffect(enAdj.nVFX1);
            effect eRay,
                   eDamage;
            float fRange                    = FeetToMeters(25.0f + (5.0f * (manif.nManifesterLevel / 2)));
            object oChainTarget;

            // Test range
            if(GetDistanceBetween(oHit, oMainTarget) <= fRange)
            {
                // Determine Chain Power targets
                if(manif.bChain)
                    EvaluateChainPower(manif, oMainTarget, TRUE);

                // Let the AI know
                PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, manif.oManifester);
                if(manif.bChain)
                    for(i = 0; i < array_get_size(manif.oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                        PRCSignalSpellEvent(array_get_object(manif.oManifester, PRC_CHAIN_POWER_ARRAY, i), TRUE, manif.nSpellID, manif.oManifester);

                // Touch attack the main target
                nTouchAttack = PRCDoRangedTouchAttack(oMainTarget);

                // Shoot the ray
                eRay = EffectBeam(enAdj.nVFX2, manif.oManifester, BODY_NODE_HAND, !(nTouchAttack > 0));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oMainTarget, 1.7, FALSE);

                if(nTouchAttack > 0)
                {
                    //Check for Power Resistance
                    if(PRCMyResistPower(manif.oManifester, oMainTarget, nPen))
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, TRUE);
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

                        // Apply VFX and damage the main target, assuming there is still damage left to deal after modification
                        if(nDamage > 0)
                        {
                            // Apply the damage. Critical hits & precision damage apply
                            ApplyTouchAttackDamage(manif.oManifester, oMainTarget, nTouchAttack, nDamage, enAdj.nDamageType);

                            // Apply damage to Chain targets
                            if(manif.bChain)
                            {
                                // Halve the damage
                                nOriginalDamage = nDamage / 2;

                                for(i = 0; i < array_get_size(manif.oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                                {
                                    // Get target to affect
                                    oChainTarget = array_get_object(manif.oManifester, PRC_CHAIN_POWER_ARRAY, i);
                                    // Determine damage
                                    nDamage = nOriginalDamage;
                                    // Target-specific stuff
                                    nDamage = GetTargetSpecificChangesToDamage(oChainTarget, manif.oManifester, nDamage, TRUE, TRUE);

                                    // Do save
                                    if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                                    {
                                        // Cold has a fort save for half
                                        if(PRCMySavingThrow(SAVING_THROW_FORT, oChainTarget, nDC, enAdj.nSaveType))
                                            nDamage /= 2;
                                    }
                                    else
                                        // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                                        nDamage = PRCGetReflexAdjustedDamage(nDamage, oChainTarget, nDC, enAdj.nSaveType);

                                    // Apply VFX and damage to chained target, assuming there is still damage left to deal after modification
                                    if(nDamage > 0)
                                    {
                                        // Apply VFX and damage to chained target
                                        eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oChainTarget);
                                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oChainTarget);
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(enAdj.nVFX2, oMainTarget, BODY_NODE_CHEST), oChainTarget, 1.7, FALSE);
                                    }// end if - There was still damage remaining to be dealt after adjustments
                                }// end for - Chain targets
                            }// end if - Chain Power
                        }// end if - There is damage left to be dealt
                    }// end if - SR check
                }// end if - Touch attack hit
            }// end if - Range check
        }// end if - Manifester was the one hit in the triggering attack
    }// end else - Running OnHit event
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0) ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_enrtrt: Expired, cleaning up");
        // Clear the effect presence marker
        DeleteLocalManifestation(oTarget, ENERGY_RETORT_VARNAME_BASE + "Manifestation");
        DeleteLocalInt(oTarget, ENERGY_RETORT_VARNAME_BASE + "DC");
        DeleteLocalInt(oTarget, ENERGY_RETORT_VARNAME_BASE + "SRPenetration");
        // Remove the eventscript
        RemoveEventScript(oTarget, EVENT_ONHIT, "psi_pow_enrtrt", TRUE, FALSE);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
