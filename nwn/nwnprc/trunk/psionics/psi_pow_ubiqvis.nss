/*
   ----------------
   Ubiquitous Vision

   psi_pow_ubiqvis
   ----------------

   25/3/04 by Stratovarius
*/ /** @file

    Ubiquitous Vision

    Clairsentience
    Level: Psion/wilder 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 5
    Metapsionics: Extend

    You have metaphoric “eyes in the back of your head,” and on the sides and
    top as well, granting you benefits in specific situations. In effect, you
    have a 360-degree sphere of sight, allowing you a perfect view of creatures
    that might otherwise flank you. Thus, flanking opponents gain no bonus on
    their attack rolls, and rogues are denied their sneak attack ability because
    you do not lose your Dexterity bonus (but they may still sneak attack you if
    you are caught flat-footed). Your Spot and Search checks gain a +4
    enhancement bonus.
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
        effect eLink    =                          EffectSkillIncrease(SKILL_SPOT,   4);
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 4));
			   eLink    = EffectLinkEffects(eLink, EffectBonusFeat(FEAT_PRESTIGE_DEFENSIVE_AWARENESS_2));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Uncanny Dodge II gives immunity to flanking in EE
/*         itemproperty ipUD = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1);
        IPSafeAddItemProperty(GetPCSkin(oTarget), ipUD, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        itemproperty ipUD2 = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE2);
        IPSafeAddItemProperty(GetPCSkin(oTarget), ipUD2, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); */

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }// end if - Successfull manifestation
}
