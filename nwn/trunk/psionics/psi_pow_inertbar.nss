/*
   ----------------
   Inertial Barrier

   psi_pow_inertbar
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Inertial Barrier

    Psychokinesis
    Level: Kineticist 4, psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 7
    Metapsionics: Extend

    You create a skin-tight psychokinetic barrier around yourself that resists
    blows, cuts, stabs, and slashes. You gain damage reduction 5/-.
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
        effect eLink    =                          EffectDamageResistance(DAMAGE_TYPE_SLASHING,    5);
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    5));
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
    }
}
