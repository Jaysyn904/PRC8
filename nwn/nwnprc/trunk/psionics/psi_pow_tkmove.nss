/*
   ----------------
   Telekinetic Maneuver

   prc_pow_tkmove
   ----------------

   26/3/05 by Stratovarius
*/ /** @file

    Psychokinesis [Force]
    Level: Psion/wilder 4
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: 1 round / 2 levels
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Extend, Twin

    You mentally push a foe, attempting to knock it prone and disarm it. The DC
    of the discipline check for the target to resist being knocked down or
    disarmed is equal to your manifester level + you ability modified in your
    manifesting stat. The Discipline checks to avoid being knocked down and
    disarmed are rolled separately.

    Augment: For every 2 additional power points spent, the DC of the Discipline
             check is increased by 1.
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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nPen        = GetPsiPenetration(oManifester);
        int nDC         = manif.nManifesterLevel
                         + GetAbilityModifier(GetAbilityOfClass(GetManifestingClass(oManifester)), oManifester)
                         + manif.nTimesAugOptUsed_1;
        int nDisarmed   = FALSE;
        effect eKnock   = EffectKnockdown();
        object oWeapon  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        float fDuration = 6.0f * (manif.nManifesterLevel / 2);
        if(manif.bExtend) fDuration *= 2;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                // Roll to avoid disarm, if disarmable and wielding anything
                if(GetIsCreatureDisarmable(oTarget) && !GetPRCSwitch(PRC_PNP_DISARM) && GetIsObjectValid(oWeapon) && !GetIsSkillSuccessful(oTarget, SKILL_DISCIPLINE, nDC))
                {
            		AssignCommand(oTarget, ClearAllActions(TRUE));
					SetDroppableFlag(oWeapon, TRUE);
            		SetStolenFlag(oWeapon, FALSE);              
            		AssignCommand(oTarget, ActionPutDownItem(oWeapon));
                    FloatingTextStrRefOnCreature(16824069, oManifester, FALSE); // "* Target disarmed! *"
                }

                // Roll to avoid knockdown
                if(!GetIsSkillSuccessful(oTarget, SKILL_DISCIPLINE, nDC))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                }
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
