/*
   ----------------
   Timeless Body

   psi_pow_timebody
   ----------------

   26/2/05 by Stratovarius
*/ /** @file

    Timeless Body

    Psychoportation
    Level: Psion/wilder 9
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round
    Power Points: 17
    Metapsionics: Extend

    Your body ignores all harmful (and helpful) effects. While timeless body is
    in effect, you are invulnerable to all attacks and powers.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink    = EffectSpellImmunity(SPELL_ALL_SPELLS);
        // Damage immunities
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
        // Specific immunities
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SILENCE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_TRAP));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
        // Visuals
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_TIMELESS_BODY));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eVis     = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        float fDuration = 6.0f;
        if(manif.bExtend) fDuration *= 2;

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }// end if - Successfull manifestation
}