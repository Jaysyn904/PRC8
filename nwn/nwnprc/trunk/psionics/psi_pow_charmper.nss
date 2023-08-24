/*
   ----------------
   Charm, Psionic

   psi_pow_charmper
   ----------------

   21/10/04 by Stratovarius
*/ /** @file

    Charm, Psionic

    Telepathy (Charm) [Mind-Affecting]
    Level: Telepath 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One humanoid
    Duration: 1 hour/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin

    In the eyes of the target humanoid, the personal reputation of the
    manifester is improved by 50%.

    Augment: You can augment this power in one or more of the following ways.

    1. If you spend 2 additional power points, this power can also affect an
       animal, fey, giant, magical beast, or monstrous humanoid.
    2. If you spend 4 additional power points, this power can also affect an
       aberration, dragon, elemental, or outsider in addition to the creature
       types mentioned above.
    3. If you spend 4 additional power points, this power’s duration
       increases to one day per level.
    In addition, for every 2 additional power points you spend to achieve any
    of these effects, this power’s save DC increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

int CheckRace(struct manifestation manif, object oTarget);

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
                              PowerAugmentationProfile(2,
                                                       2, 1,
                                                       4, 1,
                                                       4, 1
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC        = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed;
        int nPen       = GetPsiPenetration(oManifester);
        int bValidType = CheckRace(manif, oTarget);

        // Determine duration
        float fDuration;
        if(manif.nTimesAugOptUsed_3 == 1)
            fDuration = HoursToSeconds(24 * manif.nManifesterLevel);
        else
            fDuration = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // If the target is of valid type
        if(bValidType)
        {
            // Create effects
            /*
            effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            effect eCharm = EffectCharmed();
                   eCharm = PRCGetScaledEffect(eCharm, oTarget); // Game difficulty adjustments
            effect eLink = EffectLinkEffects(eMind, eCharm);
            */

            effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
            effect eCharm = EffectCharmed();
            eCharm = PRCGetScaledEffect(eCharm, oTarget);
            effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

            //Link persistant effects
            effect eLink = EffectLinkEffects(eMind, eCharm);
            eLink = EffectLinkEffects(eLink, eDur);

            // Fire cast spell at event for the specified target
            PRCSignalSpellEvent(oTarget, FALSE, manif.nSpellID, oManifester);

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                // Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Make a saving throw check
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
                    }// end if - Failed save
                }// end if - SR check
            }// end for - Twin Power
        }// end if - Target is of correct type
    }// end if - Successfull manifestation
}

int CheckRace(struct manifestation manif, object oTarget)
{
    int nRacial     = MyPRCGetRacialType(oTarget);
    int bTargetRace = FALSE;
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
        bTargetRace = TRUE;
    }
    // First augmentation option adds animal, fey, giant, magical beast, and monstrous humanoid to possible target types
    if((manif.nTimesAugOptUsed_1 == 1             ||
        GetLevelByClass(CLASS_TYPE_THRALLHERD, manif.oManifester) >= 7
        ) &&
       (nRacial == RACIAL_TYPE_ANIMAL             ||
        nRacial == RACIAL_TYPE_FEY                ||
        nRacial == RACIAL_TYPE_GIANT              ||
        nRacial == RACIAL_TYPE_MAGICAL_BEAST      ||
        nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS ||
        nRacial == RACIAL_TYPE_BEAST
      ))
    {
        bTargetRace = TRUE;
    }
    // First augmentation option adds aberration, dragon, elemental, and outsider to possible target types
    if((manif.nTimesAugOptUsed_2 == 1     ||
        GetLevelByClass(CLASS_TYPE_THRALLHERD, manif.oManifester) >= 9
        ) &&
       (nRacial == RACIAL_TYPE_ABERRATION ||
        nRacial == RACIAL_TYPE_DRAGON     ||
        nRacial == RACIAL_TYPE_ELEMENTAL  ||
        nRacial == RACIAL_TYPE_OUTSIDER
       ))
    {
        bTargetRace = TRUE;
    }

    return bTargetRace;
}