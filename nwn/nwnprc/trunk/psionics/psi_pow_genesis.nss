/*
   ----------------
   Genesis

   psi_pow_genesis
   ----------------

   12/4/05 by Stratovarius
*/ /** @file

    Genesis

    Metacreativity (Creation)
    Level: Shaper 9
    Manifesting Time: 1 standard action
    Range: Close
    Target: A location for the portal
    Effect: A demiplane and a portal to it
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 17
    Metapsionics: None

    You create a finite plane with limited access: a Demiplane. Demiplanes created by this power are very small, very minor planes,
    but they are private. Upon manifesting this power, a portal will appear infront of you that the manifester and all party members
    may use to enter the plane. Once anyone exits the plane, the plane is shut until the next manifesting of this power. Exiting the
    plane will return you to where you cast the portal.
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
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        location lTarget = PRCGetSpellTargetLocation();
        object oArea = GetArea(oManifester);

        // No recursion. No-one's bothered to implement a stack for the return locations
        if(GetTag(oArea) != "Genesis")
        {
            // Apply some VFX for the portal appearance
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);

            // Create the portal
            object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, "genesisportal", lTarget, TRUE, "genesisportal");
            if(GetIsObjectValid(oPortal))
            {
            	if(DEBUG) DoDebug("Created valid Genesis portal: " + GetName(oManifester));
                SetLocalObject(oPortal, "GENESIS_CASTER", oManifester);
            }
        }
    }
}
