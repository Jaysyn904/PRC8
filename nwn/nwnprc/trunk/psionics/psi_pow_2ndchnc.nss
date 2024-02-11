/*
   ----------------
   Second Chance

   psi_pow_2ndchnc
   ----------------

   16/7/05 by Stratovarius
*/ /** @file

    Second Chance

    Clairsentience
    Level: Seer 5
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 9
    Metapsionics: Extend

    You take a hand in influencing the probable outcomes of your immediate
    environment. You see the many alternative branches that reality could take
    in the next few seconds, and with this foreknowledge you gain the ability to
    reroll the first failed saving throw each round. You must take the result of
    the reroll, even if it’s worse than the original roll.
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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        float fDur = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDur *= 2;

        effect eDur = EffectVisualEffect(VFX_DUR_SPELLTURNING);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDur, TRUE, -1, manif.nManifesterLevel);

        SetLocalInt(oTarget, "PRC_Power_SecondChance_Active", TRUE);
        DelayCommand(fDur, DeleteLocalInt(oTarget, "PRC_Power_SecondChance_Active"));
    }
}