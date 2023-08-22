/*
   ----------------
   Energy Wall

   psi_pow_enwall
   ----------------

   26/3/05 by Stratovarius
*/ /** @file

    Energy Wall

    Metacreativity (Creation) [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Area: An opaque sheet of energy 10m long and 2m wide
    Duration: 1d4 rounds + 1 round/level
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: No
    Power Points: 5
    Metapsionics: Extend, Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You create an immobile sheet of energy of the chosen type formed out of
    unstable ectoplasm. The wall sends forth waves of energy, dealing 2d6 points
    of damage to creatures entering the wall. In addition, anyone that remains
    within the energy wall takes 2d6 points of damage +1 point per manifester
    level (maximum +20).

    If you manifest the wall so that it appears where creatures are, each
    creature takes damage as if passing through the wall.

    Cold: A sheet of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold wall is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a sheet of this energy type provides a +2 bonus to
                 the save DC.
    Fire: A sheet of this energy type deals +1 point of damage per die.
    Sonic: A sheet of this energy type deals -1 point of damage per die
           and ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.
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
                              METAPSIONIC_EXTEND | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester);
        int nAoEIndex    = manif.bWiden ? AOE_PER_ENERGYWALL_WIDENED : AOE_PER_ENERGYWALL;
        location lTarget = PRCGetSpellTargetLocation();
        effect eAoE;
        object oAoE;
        float fDuration  = RoundsToSeconds((manif.bMaximize ? 4 : d4()) + manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Create AoE
            eAoE = EffectAreaOfEffect(nAoEIndex);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lTarget, fDuration);

            // Get an object reference to the newly created AoE
            oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
            while(GetIsObjectValid(oAoE))
            {
                // Test if we found the correct AoE
                if(GetTag(oAoE) == Get2DACache("vfx_persistent", "LABEL", nAoEIndex) &&
                   !GetLocalInt(oAoE, "PRC_EnergyWall_Inited")
                   )
                {
                    break;
                }
                // Didn't find, get next
                oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
            }
            if(DEBUG) if(!GetIsObjectValid(oAoE)) DoDebug("ERROR: Can't find area of effect for Energy Wall!");

            // Store manifestation data for use in the wall's scripts
            SetLocalManifestation(oAoE, "PRC_Power_EnergyWall_Manifestation", manif);
            SetLocalInt(oAoE, "PRC_Power_EnergyWall_DC", nDC);

            SetLocalInt(oAoE, "PRC_EnergyWall_Inited", TRUE);
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
