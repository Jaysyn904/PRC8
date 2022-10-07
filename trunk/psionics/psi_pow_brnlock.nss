/*
   ----------------
   Brain Lock

   psi_pow_brnlock
   ----------------

   21/10/04 by Stratovarius
*/ /** @file

    Brain Lock

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Telepath 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One humanoid
    Duration: 1 round/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin

    The subject’s higher mind is locked away. He stands dazed, unable to take any mental decisions at all.

    Augment: You can augment this power in one or both of the following ways.
    1. If you spend 2 additional power points, this power can also affect an
       animal, fey, giant, magical beast, or monstrous humanoid.
    2. If you spend 4 additional power points, this power can also affect an
       aberration, dragon, elemental, or outsider in addition to the creature
       types mentioned above.
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
                                                       2, 1,
                                                       4, 1
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );
    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester);
        int nPen        = GetPsiPenetration(oManifester);
        int nRacial     = MyPRCGetRacialType(oTarget);
        int nTargetRace = FALSE;
        effect eMind    = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDaze    = EffectDazed();
        effect eLink    = EffectLinkEffects(eMind, eDaze);
        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

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
            nTargetRace = TRUE;
        }
        // First augmentation option adds animal, fey, giant, magical beast, and monstrous humanoid to possible target types
        if(manif.nTimesAugOptUsed_1 == 1 &&
           (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS ||
            nRacial == RACIAL_TYPE_FEY                ||
            nRacial == RACIAL_TYPE_GIANT              ||
            nRacial == RACIAL_TYPE_ANIMAL             ||
            nRacial == RACIAL_TYPE_MAGICAL_BEAST      ||
            nRacial == RACIAL_TYPE_BEAST
          ))
        {
            nTargetRace = TRUE;
        }
        // First augmentation option adds aberration, dragon, elemental, and outsider to possible target types
        if(manif.nTimesAugOptUsed_2 == 1 &&
           (nRacial == RACIAL_TYPE_ABERRATION ||
            nRacial == RACIAL_TYPE_DRAGON     ||
            nRacial == RACIAL_TYPE_OUTSIDER   ||
            nRacial == RACIAL_TYPE_ELEMENTAL
           ))
        {
            nTargetRace = TRUE;
        }

        // If the target was of a valid type
        if(nTargetRace)
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    //Fire cast spell at event for the specified target
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    //Make a saving throw check
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
                    }// end if - Save for negation
                }// end if - SR check
            }// end for - Twin Power
        }// end if - Type check
    }// end if - Successfull manifestation
}
