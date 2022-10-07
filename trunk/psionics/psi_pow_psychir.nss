/*
   ----------------
   Psychic Chirurgery - Repair Psychic Damage

   psi_pow_psychir
   ----------------

   11/5/05 by Stratovarius
*/ /** @file

    Psychic Chirurgery - Repair Psychic Damage

    Telepathy [Mind-Affecting]
    Level: Telepath 9
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 17, XP; see text
    Metapsionics: None

    You can repair psychic damage or grant another creature knowledge of powers
    you know, depending on the version of this power you manifest.

    Repair Psychic Damage:
    You can remove any compulsions and charms affecting the subject.

    You can remove all negative levels affecting the subject.

    You can also remove all effects penalizing the subject’s ability scores,
    heal all ability damage, and remove any ability drain affecting the subject.
    Psychic chirurgery negates all forms of insanity, confusion, the effect of
    such powers as microcosm, and so on.

    Transfer Knowledge:
    If desired, you can use this power to directly transfer knowledge of a power
    you know to another psionic character. You can give a character knowledge of
    a power of any level that she can manifest, even if the power is not
    normally on the character’s power list. Knowledge of powers gained through
    psychic chirurgery does not count toward the maximum number of powers a
    character can know per level.

    XP Cost: Each time you use psychic chirurgery to implant knowledge of a
             power in another creature, you pay an XP cost equal to 1,000 x the
             level of the power implanted. If you and the subject are both
             willing to do so, you can split this cost evenly.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_remeffct"

//------------------------------------------------------------------------------
// Doesn't care who the caster was removes the effects of the spell nSpell_ID.
// will ignore the subtype as well...
// GZ: Removed the check that made it remove only one effect.
//------------------------------------------------------------------------------
void PRCRemoveAnySpellEffects(int nSpell_ID, object oTarget)
{
    //Declare major variables

    effect eAOE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            //If the effect was created by the spell then remove it
            if(GetEffectSpellId(eAOE) == nSpell_ID)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        int nEffectType;
        effect eVis = EffectVisualEffect(PSI_FNF_PSYCHIC_CHIRURGY);
        effect eTest;

        // Let the AI know - Special handling
        PRCSignalSpellEvent(oTarget, FALSE, SPELL_GREATER_RESTORATION, oManifester);

        // Check for some specific stuff and remove if present
        if(GetHasSpellEffect(POWER_DECEREBRATE, oTarget))
            PRCRemoveAnySpellEffects(POWER_DECEREBRATE, oTarget);
        if(GetHasSpellEffect(POWER_INSANITY, oTarget))
            PRCRemoveAnySpellEffects(POWER_INSANITY, oTarget);
        if(GetHasSpellEffect(POWER_MICROCOSM, oTarget))
            PRCRemoveAnySpellEffects(POWER_MICROCOSM, oTarget);

        // Loop over remaining effects, remove any negative ones
        eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            nEffectType = GetEffectType(eTest);
            if(nEffectType == EFFECT_TYPE_ABILITY_DECREASE          ||
               nEffectType == EFFECT_TYPE_AC_DECREASE               ||
               nEffectType == EFFECT_TYPE_ATTACK_DECREASE           ||
               nEffectType == EFFECT_TYPE_DAMAGE_DECREASE           ||
               nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE  ||
               nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE     ||
               nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
               nEffectType == EFFECT_TYPE_SKILL_DECREASE            ||
               nEffectType == EFFECT_TYPE_BLINDNESS                 ||
               nEffectType == EFFECT_TYPE_DEAF                      ||
               nEffectType == EFFECT_TYPE_CURSE                     ||
               nEffectType == EFFECT_TYPE_DISEASE                   ||
               nEffectType == EFFECT_TYPE_POISON                    ||
               nEffectType == EFFECT_TYPE_PARALYZE                  ||
               nEffectType == EFFECT_TYPE_CHARMED                   ||
               nEffectType == EFFECT_TYPE_DOMINATED                 ||
               nEffectType == EFFECT_TYPE_DAZED                     ||
               nEffectType == EFFECT_TYPE_CONFUSED                  ||
               nEffectType == EFFECT_TYPE_FRIGHTENED                ||
               nEffectType == EFFECT_TYPE_NEGATIVELEVEL             ||
               nEffectType == EFFECT_TYPE_SLOW                      ||
               nEffectType == EFFECT_TYPE_STUNNED
               )
            {
                if(!GetShouldNotBeRemoved(eTest))
                    RemoveEffect(oTarget, eTest);
            }

            eTest = GetNextEffect(oTarget);
        }// end while - Effect loop

        // Apply visuals
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        // Set a marker local and schedule it's removal
        SetLocalInt(oTarget, "WasRestored", TRUE);
    	DelayCommand(HoursToSeconds(1), DeleteLocalInt(oTarget, "WasRestored"));
    }// end if - Successfull manifestation
}
