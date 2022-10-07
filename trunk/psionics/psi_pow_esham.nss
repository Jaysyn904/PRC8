/*
   ----------------
   Ectoplasmic Shambler

   psi_pow_esham
   ----------------

   23/2/04 by Stratovarius
*/ /** @file

    Ectoplasmic Shambler

    Metacreativity (Creation)
    Level: Psion/wilder 5
    Manifesting Time: 1 round
    Range: Long (400 ft. + 40 ft./level)
    Effect: One ectoplasmic manifestation of 10m radius
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 9
    Metapsionics: Extend, Twin, Widen

    You fashion an ephemeral mass of pseudo-living ectoplasm called an
    ectoplasmic shambler. As the consistency of the ectoplasmic shambler is
    that of thick mist, those within the shambler are blinded. In addition,
    manifesting powers (or casting spells) within the shambler is difficult
    due to the constant turbulence felt by those caught in the shambler’s form.

    Creatures enveloped by the shambler, regardless of Armor Class, take 1 point
    of damage for every two manifester levels you have in each round they become
    or remain within the roiling turbulence of the shambler. Anyone trying to
    manifest a power must make a Concentration check (DC 15 + power’s or spell’s
    level) to successfully manifest a power or cast a spell inside the shambler.
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
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nAoEIndex    = manif.bWiden ? AOE_PER_ESHAMBLER_WIDENED : AOE_PER_ESHAMBLER;
        location lTarget = PRCGetSpellTargetLocation();
        effect eImpact   = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);
        effect eAoE;
        object oAoE;
        float fDuration  = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do impact VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

            // Create AoE
            eAoE = EffectAreaOfEffect(nAoEIndex);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lTarget, fDuration);

            // Get an object reference to the newly created AoE
            oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
            while(GetIsObjectValid(oAoE))
            {
                // Test if we found the correct AoE
                if(GetTag(oAoE) == Get2DACache("vfx_persistent", "LABEL", nAoEIndex) &&
                   !GetLocalInt(oAoE, "PRC_EctoShambler_Inited")
                   )
                {
                    break;
                }
                // Didn't find, get next
                oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
            }
            if(DEBUG) if(!GetIsObjectValid(oAoE)) DoDebug("ERROR: Can't find area of effect for Ectoplasmic Shambler!");

            // Store data for use in the AoE scripts
            SetLocalInt(oAoE, "PRC_EctoShambler_Damage", manif.nManifesterLevel / 2);

            SetLocalInt(oAoE, "PRC_EctoShambler_Inited", TRUE);
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
