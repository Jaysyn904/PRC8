/*
   ----------------
   Banishment, Psionic

   psi_pow_banish
   ----------------

   28/4/05 by Stratovarius
*/ /** @file

    Banishment, Psionic

    Psychoportation
    Level: Nomad 6
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Targets: One or more extraplanar creatures, no two of which can be more than 30 ft. apart
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 11
    Metapsionics: Twin

    This spell forces extraplanar creatures back to their home plane if they fails a save. Affected creatures include summons,
    outsiders, and elementals. You can banish up to 2 HD per caster level.

    Augment: For every 2 additional power points you spend, this power’s save DC
            increases by 1 and your manifester level increases by 1 for the
            purpose of overcoming power resistance.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

/**
 * This function contains the actual execution of the power. Separated from main() for easier implementation
 * of Twin Power.
 */
void DoPower(struct manifestation manif, object oMainTarget, int nDC, int nPen, int nBanishableHD, effect eVis);

int PRCCanCreatureBeDestroyed(object oTarget)
{
    if (GetPlotFlag(oTarget) == FALSE && GetImmortal(oTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}

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
    object oMainTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oMainTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        // Get more data
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nBanishableHD = 2 * manif.nManifesterLevel;
        effect eVis       = EffectVisualEffect(VFX_IMP_UNSUMMON);

        // Apply augmentation
        nDC  += manif.nTimesAugOptUsed_1;
        nPen += manif.nTimesAugOptUsed_1;

        // Let the main target know about the power use against it
        PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, oManifester);

        DoPower(manif, oMainTarget, nDC, nPen, nBanishableHD, eVis);
        if(manif.bTwin)
            DoPower(manif, oMainTarget, nDC, nPen, nBanishableHD, eVis);
    }
}

void DoPower(struct manifestation manif, object oMainTarget, int nDC, int nPen, int nBanishableHD, effect eVis)
{
    // Nuke the main target if it's still alive this iteration and a valid target for this power
    if(!GetIsDead(oMainTarget) &&
       (MyPRCGetRacialType(oMainTarget) == RACIAL_TYPE_OUTSIDER ||
        MyPRCGetRacialType(oMainTarget) == RACIAL_TYPE_ELEMENTAL
        )
       )
    {
        //Check for Power Resistance
        if (PRCMyResistPower(manif.oManifester, oMainTarget, nPen))
        {
            //Make a saving throw check
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oMainTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oMainTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);
            }
        }
    }


    // Get secondary targets
    object oMaster;
    location lLoc = PRCGetSpellTargetLocation();

    // Do some VFX
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());


    //Get the first object in the are of effect
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    // Loop until out of valid targets or HD to banish
    while(GetIsObjectValid(oTarget) && nBanishableHD > 0)
    {
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        if (oMaster == OBJECT_INVALID)
        {
            oMaster = OBJECT_SELF;  // TO prevent problems with invalid objects
            // passed into GetAssociate
        }

        // * Is the creature a summoned associate
        // * or is the creature an outsider
        // * and is there enough points in the pool
        if(// Target validity tests
           (// Special conditions
            (// It's a summon, but not an astral construct
             GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget &&
             GetStringLeft(GetTag(oTarget), 14) != "psi_astral_con"
             ) || // End - Non-AC summon
            // A familiar
            GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
            // A Bonded Summoner familiar
            GetTag(OBJECT_SELF) == "BONDFAMILIAR"                     ||
            // An animal companion
            GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget
            ) || // End - Special conditions
           // The target is an elemental or an outsider
           MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL ||
           MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER
           )// End - Target validity tests
        {
            // * March 2003. Added a check so that 'friendlies' will not be
            // * unsummoned.
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, manif.oManifester))
            {
                // Let the target know it's being done something nasty to
                SignalEvent(oTarget, EventSpellCastAt(manif.oManifester, manif.nSpellID));

                // * Must be enough points in the pool to destroy target
                if(nBanishableHD >= GetHitDice(oTarget))
                {
                    // * Make SR and will save checks
                    if(PRCMyResistPower(manif.oManifester, oTarget, nPen) &&
                      !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE)
                       )
                    {
                        //Apply the VFX and delay the destruction of the summoned monster so
                        //that the script and VFX can play.
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                        if(PRCCanCreatureBeDestroyed(oTarget) == TRUE)
                        {
                            nBanishableHD -= GetHitDice(oTarget);
                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
                            //Which is bad when you have plot-specific things being done in that
                            //OnDeath script... so lets kill it.
                            effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
                            //just to be extra-sure... :)
                            effect eDeath = EffectDeath(FALSE, FALSE);
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                            DeathlessFrenzyCheck(oTarget);
                        }
                    }
                }
            }// rep check
        }

        //Get next creature in the shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    }
}