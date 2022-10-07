/** @file psi_pow_charge

    Psionic Lion's Charge

    Psychometabolism
	Level: Psychic warrior 2
	Manifesting Time: 1 swift action
	Range: Medium (100 ft. + 10 ft./level)
	Target: One enemy
	Duration: Instantaneous
	Saving Throw: None
	Power Resistance: No
	Power Points: 3
	Metapsionics: None
	
	You gain the powerful charging ability of a lion. When you charge your target, you make a full attack at the end of the charge.
	 
	Augment: For every additional power point you spend, each of your attacks after the charge gain damage equal to the number of additional points spent.

    @author Stratovarius
    @date   Created: May 3, 2021
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_combmove"

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
                              PowerAugmentationProfile(1),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        DoCharge(oManifester, oTarget, TRUE, TRUE, manif.nTimesGenericAugUsed, -1, FALSE, 0, TRUE, TRUE, 0, TRUE);
    }
}