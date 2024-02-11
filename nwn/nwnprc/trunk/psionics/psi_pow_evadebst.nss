/*
   ----------------
   Evade Burst

   prc_pow_evadebst
   ----------------

   22/10/04 by Stratovarius
*/ /** @file

    Evade Burst

    Psychometabolism
    Level: Psion/wilder 7, psychic warrior 3
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round/Level
    Power Points: Psion/wilder 13, psychic warrior 5
    Metapsionics: Extend

    For the duration of the power, you gain the ability to throw off faux
    ectoplasmic shells that allow you to slide out of range of a damaging
    effects that allow a Reflex save. This is equivalent to possessing the
    Evasion ability.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round. You cannot manifest this power when it isn't your turn.

    Augment: If you spend 4 additional power points, the effect is instead
             equivalent to Improved Evasion, meaning you take only half damage
             on a failed Reflex save.
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       4, 1
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nIPFeat     = manif.nTimesAugOptUsed_1 == 1 ?
                           IP_CONST_FEAT_IMPEVASION :      // Augmented
                           IP_CONST_FEAT_EVASION;          // Not augmented
        object oSkin    = GetPCSkin(oManifester);
        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nIPFeat), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}
