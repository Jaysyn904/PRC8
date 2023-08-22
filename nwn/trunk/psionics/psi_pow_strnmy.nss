/*
   ----------------
   Strength of my Enemy

   psi_pow_strnmy
   ----------------

   14/12/05 by Stratovarius
*/ /** @file

    Strength of My Enemy

    Psychometabolism
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 3
    Metapsionics: Extend

    You gain the ability to siphon away your enemy’s strength for your own use.
    One of your natural or manufactured weapons becomes the instrument of your
    desire, and deals 1 point of Strength damage on each successful hit. You
    gain that point of Strength as an enhancement bonus to your Strength score.
    Strength you siphon from different foes is tracked separately - the total
    siphoned from each individual foe is considered a separate enhancement bonus
    to your Strength (maximum +8), and you gain only the highest total.

    Augment: For every 3 additional power points you spend, the maximum
             enhancement bonus you can add to your Strength increases by 2.
*/

#include "prc_inc_spells"
#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"

const string STRNMY_ARRAY = "PRC_Power_StrengthOfMyEnemy_Array";

void DispelMonitor(object oManifester, object oTarget, object oWeapon, int nSpellID);
void CleanUpArray(object oCreature);

void main()
{
    // Determine whether this script call is about manifesting the power or an OnHit
    if(GetRunningEvent() != EVENT_ONHIT)
    {
        // Spellhook
        if (!PsiPrePowerCastCode()){ return; }

        object oManifester = OBJECT_SELF;
        object oTarget     = PRCGetSpellTargetObject();
        struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       3, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

        if(manif.bCanManifest)
        {
            int nMaxBonus   = 8 + (2* manif.nTimesAugOptUsed_1);
            int nDuration   = manif.nManifesterLevel;
            if(manif.bExtend) nDuration *= 2;
            effect eVis     =                         EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
                   eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE));
            effect eDur     = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
            float fDuration = 6.0f * nDuration;
            object oWeapon;

            // Target checks
            if(!IPGetIsMeleeWeapon(oTarget))
            {
                // If the target was the manifester, get either their primary hand weapon or first creature weapon
                if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
                {
                    object oTemp = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
                    if(IPGetIsMeleeWeapon(oTemp))
                        oWeapon = oTemp;
                    else if(GetIsObjectValid(oTemp =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget)))
                        oWeapon = oTemp;
                    else if(GetIsObjectValid(oTemp =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget)))
                        oWeapon = oTemp;
                    else if(GetIsObjectValid(oTemp =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget)))
                        oWeapon = oTemp;
                    // No creature weapon, either
                    else
                        oWeapon = OBJECT_INVALID;
                }
                else
                    oWeapon = OBJECT_INVALID;
            }
            // Target was a weapon
            else
            {
                oWeapon = oTarget;
                oTarget = GetItemPossessor(oWeapon);
            }

            // At this point, the target should be either the weapon, or an invalid object
            if(!GetIsObjectValid(oWeapon))
            {
                // "Target is not valid for Strength of my Enemy!"
                FloatingTextStrRefOnCreature(16826668, oManifester, FALSE);
                return;
            }

            // Concurrent instances of the power not allowed
            if(!GetLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_Duration"))
            {
                // Add onhit itemproperty to the weapon
                IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
                                      fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE
                                      );

                // Add a marker local to the weapon
                SetLocalInt(oWeapon, "PRC_Power_StrengthOfMyEnemy_Active", TRUE);

                // Add eventscript
                AddEventScript(oTarget, EVENT_ONHIT, "psi_pow_strnmy", TRUE, FALSE);

                // Store manifestation data in local vars
                SetLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_Duration", nDuration);
                SetLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_MaxBonus", nMaxBonus);
                SetLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_ManifLvl", manif.nManifesterLevel);

                // Initialise highest strength bonus granted tracker
                // First, if, for some reason, the array exists already, perform cleanup
                if(array_exists(oTarget, STRNMY_ARRAY))
                    CleanUpArray(oTarget);
                // Create the array
                array_create(oTarget, STRNMY_ARRAY);
                // Init the current bonus tracking variable to 0
                SetLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_CurBonus", 0);

                // Apply VFX
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                // Start dispelling monitor
                DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, oWeapon, manif.nSpellID));
            }
        }// end if - Successfull manifestation
    }// end if - Manifesting the power
    else
    {
        object oManifester = OBJECT_SELF;
        object oWeapon     = GetSpellCastItem();
        object oTarget     = PRCGetSpellTargetObject();

        // Make sure the item triggering OnHit was the Strength of my Enemy weapon
        if(GetLocalInt(oWeapon, "PRC_Power_StrengthOfMyEnemy_Active"))
        {
            // No point in doing any of this if the target is immune
            if(GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE))
                return;

            // Get data
            int nMaxBonus          = GetLocalInt(oManifester, "PRC_Power_StrengthOfMyEnemy_MaxBonus");
            int nManifesterLevel   = GetLocalInt(oManifester, "PRC_Power_StrengthOfMyEnemy_ManifLvl");
            int nCurrentBonus      = GetLocalInt(oManifester, "PRC_Power_StrengthOfMyEnemy_CurBonus");
            int nGainedFromCurrent = GetLocalInt(oManifester, "PRC_Power_SomE_STRGainedFrom_" + ObjectToString(oTarget));

            // Make an array entry in the tracking array for the current target if it doesn't have one already
            if(nGainedFromCurrent == 0)
                array_set_object(oManifester, STRNMY_ARRAY, array_get_size(oManifester, STRNMY_ARRAY), oTarget);

            // Apply the damage
            ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);

            // Keep track of how many times we've drained the person, which is one more than previous
            nGainedFromCurrent = min(nGainedFromCurrent + 1, nMaxBonus); // Do not allow the value to exceed the max bonus. It probably doesn't matter, but it's ugly :P
            SetLocalInt(oManifester, "PRC_Power_SomE_STRGainedFrom_" + ObjectToString(oTarget), nGainedFromCurrent);

            // Check ff the amount gained from current target is greater than the current bonus, but not higher than the maximum
            if(nGainedFromCurrent > nCurrentBonus &&
               nGainedFromCurrent <= nMaxBonus
               )
            {
                // Apply Strength bonus for a duration equal to the remaining duration of this power, with accuracy of +-6s
                float fDuration = 6.0f * GetLocalInt(oManifester, "PRC_Power_StrengthOfMyEnemy_Duration");
                effect eStr     = EffectAbilityIncrease(ABILITY_STRENGTH, nGainedFromCurrent);
                effect eVis     = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oManifester, fDuration, TRUE, POWER_STRENGTH_OF_MY_ENEMY, nManifesterLevel);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oManifester);

                // Update the highest bonus tracker
                SetLocalInt(oManifester, "PRC_Power_StrengthOfMyEnemy_CurBonus", nGainedFromCurrent);
            }// end if - We need to increase the STR bonus in effect
        }// end if - OnHit triggered by the corrent item
    }// end else - Running OnHit
}

void DispelMonitor(object oManifester, object oTarget, object oWeapon, int nSpellID)
{
    int nRoundsRemain = GetLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_Duration");

    if(PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester) || // Has the power expired somehow since last check
       nRoundsRemain <= 0                                                 // Or is it running out of duration now
       )
    {
        if(DEBUG) DoDebug("psi_pow_strnmy: Power expired, clearing");

        // Remove effects
        PRCRemoveSpellEffects(nSpellID, oManifester, oTarget);

        // Unhook event
        RemoveEventScript(oTarget, EVENT_ONHIT, "psi_pow_strnmy", TRUE, FALSE);

        // Clear locals
        DeleteLocalInt(oWeapon, "PRC_Power_StrengthOfMyEnemy_Active");
        DeleteLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_Duration");
        DeleteLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_MaxBonus");
        DeleteLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_ManifLvl");
        DeleteLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_CurBonus");
        CleanUpArray(oTarget);
    }
    else
    {
        // Decrement rounds remaining and schedule next HB
        SetLocalInt(oTarget, "PRC_Power_StrengthOfMyEnemy_Duration", nRoundsRemain - 1);
        DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, oWeapon, nSpellID));
    }
}

void CleanUpArray(object oCreature)
{
    int i, max = array_get_size(oCreature, STRNMY_ARRAY);
    for(i = 0; i < max; i++)
        DeleteLocalInt(oCreature, "PRC_Power_SomE_STRGainedFrom_" + ObjectToString(array_get_object(oCreature, STRNMY_ARRAY, i)));

    array_delete(oCreature, STRNMY_ARRAY);
}
