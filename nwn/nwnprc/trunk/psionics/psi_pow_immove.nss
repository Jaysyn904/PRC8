/*
   ----------------
   Immovability

   psi_pow_immove
   ----------------

   13/12/05 by Stratovarius
*/ /** @file

    Immovability

    Psychometabolism
    Level: Psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: Concentration
    Power Points: 7
    Metapsionics: None

    You are almost impossible to move. Your weight does not vary; instead, you
    mentally attach yourself to the underlying fabric of the plane. You gain a
    +20 bonus on Discipline skill checks. You can’t voluntarily move to a new
    location unless you stop concentrating, which ends the power.

    You cannot apply your Dexterity bonus to Armor Class; however, your anchored
    body gains damage reduction 15/-.

    You cannot make physical attacks or perform any other large-scale movements
    (you can make smallscale movements, such as breathing, turning your head,
    moving your eyes, talking, and so on). Powers with the teleportation
    descriptor manifested on you automatically fail.


    Implementation note: To end concentrating on the power, use the control feat
    again. If the power is active, that will end it instead of manifesting it.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"
#include "prc_inc_teleport"

void DispelMonitor(object oManifester, object oTarget, int nSpellID);

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

    // Special - remove effect if already active instead of manifesting
    if(GetHasSpellEffect(PRCGetSpellId(), oTarget))
    {
        // Remove effects
        PRCRemoveSpellEffects(PRCGetSpellId(), oManifester, oTarget);
        // Restore teleportability
        AllowTeleport(oTarget);
    }
    else
    {
        struct manifestation manif =
            EvaluateManifestation(oManifester, oTarget,
                                  PowerAugmentationProfile(),
                                  METAPSIONIC_NONE
                                  );

        if(manif.bCanManifest)
        {
            effect eLink =                          EffectCutsceneImmobilize();
                   eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISCIPLINE, 20));
                   eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 15));
                   eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    15));
                   eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    15));
                   eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SANCTUARY));
                   eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_STONEHOLD));

            // Apply effect link
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, TRUE, manif.nSpellID, manif.nManifesterLevel);

            // Forbid teleportation
            DisallowTeleport(oTarget);

            // @todo Start concentration

            // Start monitor HB
            DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID));
        }// end if - Successfull manifestation
    }// end else - Manifesting the power
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID)
{
    // Has the power been dispelled or cancelled since the last HB
    if(PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_immove: Power expired, clearing");

        // @todo Lose concentration

        // Remove effects
        PRCRemoveSpellEffects(nSpellID, oManifester, oTarget);

        // Restore teleportability
        AllowTeleport(oTarget);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID));
}
