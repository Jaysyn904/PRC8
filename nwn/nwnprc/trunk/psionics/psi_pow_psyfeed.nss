/*
   ----------------
   Psychofeedback

   psi_pow_psyfeed
   ----------------

   18/5/05 by Stratovarius
*/ /** @file

    Psychofeedback

    Psychometabolism
    Level: Egoist 5, Psychic Warrior 5
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 Round/level
    Power Points: 9
    Metapsionics: Extend

    You can readjust your body to boost one physical ability score at the expense of one or more other scores. Select one ability
    score you would like to boost, and increase it by the same amount that you decrease one or more other scores. All score
    decreases are treated as a special form of ability damage, called ability burn, which cannot be magically or psionically healed
    - it goes away only through natural healing.

    You can boost your Strength, Dexterity or Constitution score by an amount equal to your manifester level (or any lesser amount),
    assuming you can afford to burn your other ability scores to such an extent.

    When the duration of this power expires, your ability boost also ends, but your ability burn remains until it is healed naturally.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "inc_dynconv"

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
	float fDuration = 6.0 * manif.nManifesterLevel;
	if(manif.bExtend) fDuration *= 2;

	SetLocalFloat(oManifester, "PsychoFeedDuration", fDuration);
	SetLocalInt(oManifester, "PsychoFeedManifesterLevel", manif.nManifesterLevel);

	StartDynamicConversation("psi_psychofeed", oManifester, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oManifester);
    }
}