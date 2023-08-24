/*
   ----------------
   Time Hop, Mass

   psi_pow_timehopm
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Time Hop, Mass

    Psychoportation
    Level: Nomad 8
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Targets: All willing creatures in range
    Duration: 1 hour; see text
    Power Points: 15
    Metapsionics: None

    As time hop, except you affect all willing subjects in range, including
    yourself.

    Augment: For each additional power point spent, the duration of this power
             increases by 1 hour.
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
    object oMainTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        effect eLink      =                          EffectCutsceneParalyze();
               eLink      = EffectLinkEffects(eLink, EffectCutsceneGhost());
               eLink      = EffectLinkEffects(eLink, EffectEthereal());
               eLink      = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_ALL_SPELLS));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
        object oTarget;
        location lTarget  = PRCGetSpellTargetLocation();
        float fRadius     = FeetToMeters(25.0f + (5.0f * (manif.nManifesterLevel / 2)));
        float fDuration   = HoursToSeconds(1 + manif.nTimesAugOptUsed_1);

        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget == oManifester                                      || // Target self
               spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oManifester)   // Only target allies
               )
            {
                // Let the AI know
                PRCSignalSpellEvent(oTarget, FALSE, manif.nSpellID, oManifester);

                // Apply effect. Not dispellable
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, FALSE);
            }// end if - Targeting check

            // Select the next target within the spell shape.
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Target loop
    }// end if - Successfull manfiestation
}
