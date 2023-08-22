/*
   ----------------
   Dimensional Anchor

   psi_pow_dimanch
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Dimensional Anchor

    Psychoportation
    Level: Nomad 4
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Extend, Split Psionic Ray, Twin

    A green ray springs from your outstretched hand. You must make a ranged
    touch attack to hit the target. Any creature or object struck by the ray
    is covered with a shimmering emerald field that completely blocks
    extradimensional travel. Forms of movement barred by a dimensional anchor
    include astral projection, blink, dimension door, ethereal jaunt,
    etherealness, gate, maze, plane shift, shadow walk, teleport, and similar
    spell-like or psionic abilities. The spell also prevents the use of a gate
    or teleportation circle for the duration of the spell.

    A dimensional anchor does not prevent summoned creatures from disappearing
    at the end of a summoning spell.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_sp_tch"
#include "prc_inc_teleport"

void DoPower(struct manifestation manif, object oTarget, int nDC, int nPen, effect eVis, float fDur);
void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

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
                              METAPSIONIC_EXTEND | METAPSIONIC_SPLIT | METAPSIONIC_TWIN
                              );

    if(manif.nManifesterLevel)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);
        effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
        object oSecondaryTarget = GetSplitPsionicRayTarget(manif, oTarget);
        float fDur = 60.0 * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
        if(GetIsObjectValid(oSecondaryTarget))
            PRCSignalSpellEvent(oSecondaryTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            DoPower(manif, oTarget, nDC, nPen, eVis, fDur);
            if(GetIsObjectValid(oSecondaryTarget))
                DoPower(manif, oSecondaryTarget, nDC, nPen, eVis, fDur);
        }
    }
}

void DoPower(struct manifestation manif, object oTarget, int nDC, int nPen, effect eVis, float fDur)
{
    // Perform the Touch Attach
    int nTouchAttack = PRCDoRangedTouchAttack(oTarget);

    // Shoot the ray
    effect eRay = EffectBeam(VFX_BEAM_DISINTEGRATE, manif.oManifester, BODY_NODE_HAND, !(nTouchAttack > 0));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7, FALSE);

    // Apply effect if hit
    if(nTouchAttack > 0)
    {
        //Check for Power Resistance
        if(PRCMyResistPower(manif.oManifester, oTarget, nPen))
        {
            if(!GetLocalInt(oTarget, "PRC_DimAnchPsionic"))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur, TRUE, manif.nSpellID, manif.nManifesterLevel);
                // Increase the teleportation prevention counter
                DisallowTeleport(oTarget);
                // Set a marker so the power won't apply duplicate effects
                SetLocalInt(oTarget, "PRC_DimAnchPsionic", TRUE);
                // Start the monitor
                DelayCommand(6.0f, DispelMonitor(manif.oManifester, oTarget, manif.nSpellID, (FloatToInt(fDur) / 6) - 1));

                if(DEBUG) DoDebug("psi_pow_dimanch: The anchoring will wear off in " + IntToString(FloatToInt(fDur)) + "s");
            }
        }
    }
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0) ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_dimanch: The anchoring effect has been removed");
        // Reduce the teleport prevention counter
        AllowTeleport(oTarget);
        // Clear the effect presence marker
        DeleteLocalInt(oTarget, "PRC_DimAnchPsionic");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}