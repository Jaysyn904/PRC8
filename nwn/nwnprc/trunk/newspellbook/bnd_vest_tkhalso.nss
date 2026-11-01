/*
Sphere of Annihilation for Tkhaluuljin
Summons a controllable Sphere of Annihilation ("sp_sphereofud").
- Controlled by PRC_TKHAL_SPHERE_DISINTEGRATE:
  * 0 (Default - Web Enhancement): 1 round per Effective Binder Level per day (non-consecutive);
    any creature contacted (other than the summoning Binder, who is immune) is instantly annihilated
    (DeathlessFrenzyCheck + SupernaturalEffect(EffectDeath) + 9999 magical damage). When the Sphere
    returns to the Binder out of combat with no enemies present, it automatically dismisses itself.
  * 1 (Unlimited Rounds + 3.5e Disintegrate): No daily round limit; deals 40d6 magical damage on
    contact with a Fortitude save vs. GetBinderDC(oBinder, VESTIGE_TKHALUULJIN, oVictim) for 5d6 damage
    (0 if the target has Mettle). When no enemies are present, the Sphere follows the Binder until
    enemies appear or the Binder targets themselves to dismiss it.
- Each round, if no explicit move order was given:
  * The Sphere rolls a DC 30 Control Check (1d20 + EBL + max(ChaMod, IntMod)).
  * If living enemies are present, it seeks out the closest living enemy (or slides 10 ft toward
    the Binder if the control check fails).
  * If no living enemies are present, it moves toward the Binder by default (at full controlled
    speed if the control check passed, or 10 ft if the control check failed).
*/
#include "bnd_inc_bndfunc"
#include "prc_inc_spells"

object FindNearestLivingEnemyOfBinder(object oBinder, object oSphere)
{
    float fSeekRange = FeetToMeters(60.0f);
    int nNth = 1;
    object oCand = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSphere, nNth);
    while (GetIsObjectValid(oCand))
    {
        if (oCand != oBinder && oCand != oSphere && GetIsEnemy(oCand, oBinder) && !GetPlotFlag(oCand))
        {
            if (GetIsInCombat(oCand)
                || GetObjectSeen(oCand, oBinder)
                || GetObjectSeen(oCand, oSphere)
                || GetDistanceBetween(oSphere, oCand) <= fSeekRange
                || GetDistanceBetween(oBinder, oCand) <= fSeekRange)
            {
                return oCand;
            }
        }
        nNth++;
        oCand = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSphere, nNth);
    }
    return OBJECT_INVALID;
}

void AnnihilateCreature(object oBinder, object oSphere, object oVictim)
{
    if (!GetIsObjectValid(oVictim) || GetIsDead(oVictim) || oVictim == oBinder || oVictim == oSphere)
        return;
    if (GetPlotFlag(oVictim))
        return;

    SetLocalInt(oSphere, "TkhalSphereHitEnemy", TRUE);

    if (GetPRCSwitch(PRC_TKHAL_SPHERE_DISINTEGRATE))
    {
        // Guard against multiple sub-round sweep triggers hitting the same surviving creature in 1 round
        string sHitLock = "TkhalSphereHitLock_" + ObjectToString(oSphere);
        if (GetLocalInt(oVictim, sHitLock))
            return;
        SetLocalInt(oVictim, sHitLock, TRUE);
        DelayCommand(5.5f, DeleteLocalInt(oVictim, sHitLock));

        AssignCommand(oSphere, SPApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectBeam(VFX_BEAM_BLACK, oSphere, BODY_NODE_CHEST),
            oVictim, 1.0f, FALSE
        ));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oVictim);

        int nDC = GetBinderDC(oBinder, VESTIGE_TKHALUULJIN, oVictim);
        int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oVictim, nDC, SAVING_THROW_TYPE_SPELL, oBinder);
        int nDmg = 0;
        if (!nSave)
        {
            nDmg = d6(40);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), oVictim);
        }
        else if (!GetHasMettle(oVictim, SAVING_THROW_FORT))
        {
            nDmg = d6(5);
        }

        if (nDmg > 0)
        {
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                PRCEffectDamage(oVictim, nDmg, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY),
                oVictim
            );
        }
        SendMessageToPC(
            oBinder,
            "Sphere of Annihilation disintegrates " + GetName(oVictim) + " for " + IntToString(nDmg) +
            " damage (" + (nSave ? "Fortitude save succeeded" : "Fortitude save failed") + " vs. DC " + IntToString(nDC) + ")!"
        );
        return;
    }

    AssignCommand(oSphere, SPApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectBeam(VFX_BEAM_BLACK, oSphere, BODY_NODE_CHEST),
        oVictim, 1.0f, FALSE
    ));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), oVictim);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oVictim);

    DeathlessFrenzyCheck(oVictim);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath(TRUE, TRUE)), oVictim);
    if (!GetIsDead(oVictim))
    {
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            PRCEffectDamage(oVictim, 9999, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY),
            oVictim
        );
    }
    SendMessageToPC(oBinder, "Sphere of Annihilation utterly destroys " + GetName(oVictim) + "!");
}

void SweepSphereContact(object oBinder, object oSphere)
{
    if (!GetIsObjectValid(oSphere)) return;
    location lSphere = GetLocation(oSphere);
    object oHit = MyFirstObjectInShape(SHAPE_SPHERE, 3.5f, lSphere, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
    while (GetIsObjectValid(oHit))
    {
        if (oHit == oBinder && !GetLocalInt(oSphere, "TkhalSphereBinderPassMsg"))
        {
            SetLocalInt(oSphere, "TkhalSphereBinderPassMsg", TRUE);
            DelayCommand(5.5f, DeleteLocalInt(oSphere, "TkhalSphereBinderPassMsg"));
            FloatingTextStringOnCreature("Tkhaluuljin's mastery protects you as the Sphere of Annihilation passes harmlessly through your space!", oBinder, FALSE);
        }
        if (oHit != oBinder && oHit != oSphere)
        {
            int nType = GetObjectType(oHit);
            if (nType == OBJECT_TYPE_CREATURE)
            {
                if (GetIsObjectValid(GetLocalObject(oHit, "ZurielForceCageCreator")))
                    DestroyForceBarrierObject(oHit);
                // Avoid annihilating friendly party members unless directed at them
                object oDirTarget = GetLocalObject(oBinder, "TkhalSphereTargetObj");
                if (GetIsEnemy(oHit, oBinder) || oHit == oDirTarget)
                    AnnihilateCreature(oBinder, oSphere, oHit);
            }
            else if (nType == OBJECT_TYPE_PLACEABLE && (GetLocalInt(oHit, "PRC_WALL_OF_FORCE") || GetLocalInt(oHit, "PRC_FORCECAGE") || GetTag(oHit) == "ZurielWallOfForce" || GetTag(oHit) == "ZurielForceCage"))
            {
                DestroyForceBarrierObject(oHit);
            }
            else if (nType == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                object oAoECreator = GetAreaOfEffectCreator(oHit);
                int bIsMobileCreatureAura = (GetIsObjectValid(oAoECreator) && GetObjectType(oAoECreator) == OBJECT_TYPE_CREATURE && GetDistanceBetween(oHit, oAoECreator) <= 0.5f);
                if (!bIsMobileCreatureAura)
                    DestroyObject(oHit);
            }
        }
        oHit = MyNextObjectInShape(SHAPE_SPHERE, 3.5f, lSphere, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
    }
}

void DismissTkhalSphere(object oBinder, string sReason, int bStartCooldown)
{
    object oSphere = GetLocalObject(oBinder, "TkhalSphereObj");
    DeleteLocalObject(oBinder, "TkhalSphereObj");
    DeleteLocalObject(oBinder, "TkhalSphereTargetObj");
    DeleteLocalLocation(oBinder, "TkhalSphereTargetLoc");
    DeleteLocalInt(oBinder, "TkhalSphereHasLocOrder");
    SetLocalInt(oBinder, "TkhalSphereGen", GetLocalInt(oBinder, "TkhalSphereGen") + 1);

    if (GetIsObjectValid(oSphere))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), GetLocation(oSphere));
        SetPlotFlag(oSphere, FALSE);
        DestroyObject(oSphere);
    }
    if (sReason != "")
        FloatingTextStringOnCreature(sReason, oBinder, FALSE);
    if (bStartCooldown)
        BindAbilCooldown(oBinder, 19186, VESTIGE_TKHALUULJIN);
}

int CheckTkhalSphereAutoDismiss(object oBinder, object oSphere)
{
    if (!GetIsObjectValid(oBinder) || !GetIsObjectValid(oSphere))
        return FALSE;
    // Only auto-dismiss when the round-per-day limit is active (PRC_TKHAL_SPHERE_DISINTEGRATE == 0)
    if (GetPRCSwitch(PRC_TKHAL_SPHERE_DISINTEGRATE))
        return FALSE;
    if (GetIsInCombat(oBinder))
        return FALSE;
    if (GetLocalInt(oBinder, "TkhalSphereHasLocOrder"))
        return FALSE;
    if (GetIsObjectValid(FindNearestLivingEnemyOfBinder(oBinder, oSphere)))
        return FALSE;

    if (GetDistanceBetween(oSphere, oBinder) <= 3.5f)
    {
        int nEBL = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
        int nRem = PRCMax(0, nEBL - GetLocalInt(oBinder, "TkhalSphereRoundsUsed"));
        DismissTkhalSphere(
            oBinder,
            "Sphere of Annihilation returns to you and dissipates (" + IntToString(nRem) + "/" + IntToString(nEBL) + " daily rounds remaining).",
            TRUE
        );
        return TRUE;
    }
    return FALSE;
}

void SubRoundSweepAndCheck(object oBinder, object oSphere, int nGen)
{
    if (!GetIsObjectValid(oBinder)
        || GetLocalInt(oBinder, "TkhalSphereGen") != nGen
        || !GetIsObjectValid(oSphere))
        return;

    SweepSphereContact(oBinder, oSphere);
    if (GetLocalInt(oSphere, "TkhalSphereAgeTicks") >= 2 || GetLocalInt(oSphere, "TkhalSphereHitEnemy"))
        CheckTkhalSphereAutoDismiss(oBinder, oSphere);
}

int RollSphereControlCheck(object oBinder, object oSphere)
{
    int nEBL = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, oBinder);
    int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oBinder);
    int nStatMod = PRCMax(nChaMod, nIntMod);

    // Talisman of the Sphere doubles the ability modifier on the control check
    if (GetIsObjectValid(GetItemPossessedBy(oBinder, "talisman_sphere"))
        || GetIsObjectValid(GetItemPossessedBy(oBinder, "Talismansphere")))
    {
        nStatMod *= 2;
    }

    // Clear previous round's temporary speed effect before applying the new round's speed
    effect eSpd = GetFirstEffect(oSphere);
    while (GetIsEffectValid(eSpd))
    {
        if (GetEffectType(eSpd) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE)
            RemoveEffect(oSphere, eSpd);
        eSpd = GetNextEffect(oSphere);
    }

    int nRoll = d20() + nEBL + nStatMod;
    int nDC = 30;
    SendMessageToPC(oBinder, "Sphere of Annihilation Control Check: " + IntToString(nRoll) + " vs. DC " + IntToString(nDC));

    if (nRoll >= nDC)
    {
        // Speed in a round is 10 ft + 5 ft per 5 points by which the check exceeds 30
        int nExtraSpeedPct = ((nRoll - nDC) / 5) * 25;
        if (nExtraSpeedPct > 0)
        {
            ApplyEffectToObject(
                DURATION_TYPE_TEMPORARY,
                EffectMovementSpeedIncrease(PRCMin(99, nExtraSpeedPct)),
                oSphere, 6.0f
            );
        }

        // If an explicit 1-round ground location order was issued, execute that move order for this round
        if (GetLocalInt(oBinder, "TkhalSphereHasLocOrder"))
        {
            DeleteLocalInt(oBinder, "TkhalSphereHasLocOrder");
            location lDest = GetLocalLocation(oBinder, "TkhalSphereTargetLoc");
            AssignCommand(oSphere, ClearAllActions());
            if (GetIsObjectValid(GetAreaFromLocation(lDest)))
                AssignCommand(oSphere, ActionForceMoveToLocation(lDest, TRUE, 6.0f));
            SweepSphereContact(oBinder, oSphere);
            return TRUE;
        }

        object oTarget = GetLocalObject(oBinder, "TkhalSphereTargetObj");
        if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget) || GetArea(oTarget) != GetArea(oSphere))
        {
            // Automatically seek out the closest living enemy of oBinder
            oTarget = FindNearestLivingEnemyOfBinder(oBinder, oSphere);
            if (GetIsObjectValid(oTarget))
                SetLocalObject(oBinder, "TkhalSphereTargetObj", oTarget);
            else
                DeleteLocalObject(oBinder, "TkhalSphereTargetObj");
        }

        AssignCommand(oSphere, ClearAllActions());
        if (GetIsObjectValid(oTarget) && !GetIsDead(oTarget))
        {
            AssignCommand(oSphere, ActionForceMoveToObject(oTarget, TRUE, 0.5f, 6.0f));
            if (GetDistanceBetween(oSphere, oTarget) <= 4.0f)
                AnnihilateCreature(oBinder, oSphere, oTarget);
        }
        else
        {
            // No enemy target and no explicit location order: move toward oBinder at full controlled speed
            float fFollowDist = GetPRCSwitch(PRC_TKHAL_SPHERE_DISINTEGRATE) ? 2.0f : 1.0f;
            if (GetDistanceBetween(oSphere, oBinder) > fFollowDist)
                AssignCommand(oSphere, ActionForceMoveToObject(oBinder, TRUE, fFollowDist, 6.0f));
        }
        SweepSphereContact(oBinder, oSphere);
        return TRUE;
    }
    else
    {
        // Failed control check: Sphere slides 10 feet toward the Binder (who is immune to their own sphere)
        DeleteLocalInt(oBinder, "TkhalSphereHasLocOrder");
        FloatingTextStringOnCreature("Control check failed! The Sphere slides 10 feet toward you.", oBinder, FALSE);
        vector vSphere = GetPosition(oSphere);
        vector vBinder = GetPosition(oBinder);
        vector vDelta = vBinder - vSphere;
        float fDist = VectorMagnitude(vDelta);
        location lSlide = GetLocation(oBinder);
        if (fDist > FeetToMeters(10.0f))
        {
            vector vStep = vSphere + VectorNormalize(vDelta) * FeetToMeters(10.0f);
            lSlide = Location(GetArea(oSphere), vStep, VectorToAngle(vDelta));
        }
        AssignCommand(oSphere, ClearAllActions());
        AssignCommand(oSphere, ActionForceMoveToLocation(lSlide, FALSE, 3.0f));
        SweepSphereContact(oBinder, oSphere);
        return FALSE;
    }
}

void TkhalSphereTick(object oBinder, object oSphere, int nGen)
{
    if (!GetIsObjectValid(oBinder)
        || GetLocalInt(oBinder, "TkhalSphereGen") != nGen
        || !GetIsObjectValid(oSphere))
        return;

    if ((!GetHasSpellEffect(VESTIGE_TKHALUULJIN, oBinder) && !GetLocalInt(oBinder, "TkhalFlight")) || GetIsDead(oBinder))
    {
        DismissTkhalSphere(oBinder, "Sphere of Annihilation dissipates.", FALSE);
        return;
    }

    int nEBL = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
    float fMaxRange = FeetToMeters(40.0f + 10.0f * IntToFloat(nEBL));
    if (GetArea(oBinder) != GetArea(oSphere) || GetDistanceBetween(oBinder, oSphere) > fMaxRange)
    {
        DismissTkhalSphere(oBinder, "Sphere of Annihilation moved beyond control range and vanished.", TRUE);
        return;
    }

    int nAge = GetLocalInt(oSphere, "TkhalSphereAgeTicks") + 1;
    SetLocalInt(oSphere, "TkhalSphereAgeTicks", nAge);

    // After the initial summon round, if the round-per-day limit is active and the Sphere has
    // returned to the Binder out of combat with no enemies present, dismiss it automatically
    // before charging another daily round.
    if (nAge >= 2 && CheckTkhalSphereAutoDismiss(oBinder, oSphere))
        return;

    int bDisintegrate = GetPRCSwitch(PRC_TKHAL_SPHERE_DISINTEGRATE);
    int nRemaining = nEBL;
    if (!bDisintegrate)
    {
        int nUsed = GetLocalInt(oBinder, "TkhalSphereRoundsUsed") + 1;
        SetLocalInt(oBinder, "TkhalSphereRoundsUsed", nUsed);
        nRemaining = nEBL - nUsed;
    }

    RollSphereControlCheck(oBinder, oSphere);
    DelayCommand(2.0f, SubRoundSweepAndCheck(oBinder, oSphere, nGen));
    DelayCommand(4.0f, SubRoundSweepAndCheck(oBinder, oSphere, nGen));

    if (!bDisintegrate)
    {
        if (nRemaining <= 0)
        {
            DelayCommand(5.8f, DismissTkhalSphere(
                oBinder,
                "Sphere of Annihilation: daily duration exhausted (" + IntToString(nEBL) + "/" + IntToString(nEBL) + " rounds used).",
                TRUE
            ));
            return;
        }

        FloatingTextStringOnCreature(
            "Sphere of Annihilation active (" + IntToString(nRemaining) + "/" + IntToString(nEBL) + " rounds remaining today)",
            oBinder, FALSE
        );
    }

    DelayCommand(6.0f, TkhalSphereTick(oBinder, oSphere, nGen));
}

void main()
{
    object oBinder = OBJECT_SELF;
    object oActiveSphere = GetLocalObject(oBinder, "TkhalSphereObj");
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = GetIsObjectValid(oTarget) ? GetLocation(oTarget) : PRCGetSpellTargetLocation();
    int bDisintegrate = GetPRCSwitch(PRC_TKHAL_SPHERE_DISINTEGRATE);

    // If a Sphere is already summoned:
    // - Targeting Self dismisses it immediately and starts the 5-round cooldown.
    // - Targeting an enemy or ground location redirects the active Sphere.
    if (GetIsObjectValid(oActiveSphere))
    {
        if (oTarget == oBinder)
        {
            if (bDisintegrate)
            {
                DismissTkhalSphere(oBinder, "Sphere of Annihilation dismissed.", TRUE);
            }
            else
            {
                int nEBL = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
                int nRem = PRCMax(0, nEBL - GetLocalInt(oBinder, "TkhalSphereRoundsUsed"));
                DismissTkhalSphere(
                    oBinder,
                    "Sphere of Annihilation dismissed (" + IntToString(nRem) + "/" + IntToString(nEBL) + " daily rounds remaining).",
                    TRUE
                );
            }
            return;
        }

        if (GetIsObjectValid(oTarget) && oTarget != oActiveSphere)
        {
            SetLocalObject(oBinder, "TkhalSphereTargetObj", oTarget);
            DeleteLocalInt(oBinder, "TkhalSphereHasLocOrder");
        }
        else
        {
            DeleteLocalObject(oBinder, "TkhalSphereTargetObj");
            SetLocalLocation(oBinder, "TkhalSphereTargetLoc", lTarget);
            SetLocalInt(oBinder, "TkhalSphereHasLocOrder", TRUE);
        }

        FloatingTextStringOnCreature("Directing Sphere of Annihilation...", oBinder, FALSE);
        RollSphereControlCheck(oBinder, oActiveSphere);
        return;
    }

    // Check 5-round cooldown before summoning a new Sphere
    if (GetLocalInt(oBinder, "Bind" + IntToString(19186)))
    {
        if (!BindAbilCooldown(oBinder, 19186, VESTIGE_TKHALUULJIN))
            return;
    }

    int nEBL = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
    int nUsed = GetLocalInt(oBinder, "TkhalSphereRoundsUsed");
    if (!bDisintegrate && nUsed >= nEBL)
    {
        FloatingTextStringOnCreature(
            "Sphere of Annihilation: All " + IntToString(nEBL) + " daily rounds have been expended until you rest.",
            oBinder, FALSE
        );
        return;
    }

    // Spawn the Sphere of Annihilation at the target location (or 3m in front of the Binder if self-targeted)
    location lSpawn = lTarget;
    if (oTarget == oBinder)
    {
        vector vPos = GetPosition(oBinder) + AngleToVector(GetFacing(oBinder)) * 3.0f;
        lSpawn = Location(GetArea(oBinder), vPos, GetFacing(oBinder));
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), lSpawn);
    object oSphere = CreateObject(OBJECT_TYPE_CREATURE, "sp_sphereofud", lSpawn, FALSE, "TkhalSphereOfAnnihilation");
    if (!GetIsObjectValid(oSphere))
        return;

    SetName(oSphere, "Sphere of Annihilation");
    SetPlotFlag(oSphere, TRUE);
    SetImmortal(oSphere, TRUE);
    DeleteLocalString(oSphere, "X2_SPECIAL_COMBAT_AI_SCRIPT");
    ChangeToStandardFaction(oSphere, STANDARD_FACTION_DEFENDER);
    // Replace Will-O'-Wisp appearance (116) with Invisible_Human_Male (298) so Will-O'-Wisp smoke/flare emitters don't render
    SetCreatureAppearanceType(oSphere, APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);

    // sp_sphere_spawn already applies VFX_DUR_SPHERE_OF_ANHILIATION on spawn; apply CutsceneGhost so it glides through creatures
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), oSphere);

    SetLocalObject(oBinder, "TkhalSphereObj", oSphere);
    if (GetIsObjectValid(oTarget) && oTarget != oBinder)
    {
        SetLocalObject(oBinder, "TkhalSphereTargetObj", oTarget);
        DeleteLocalInt(oBinder, "TkhalSphereHasLocOrder");
    }
    else
    {
        DeleteLocalObject(oBinder, "TkhalSphereTargetObj");
        DeleteLocalInt(oBinder, "TkhalSphereHasLocOrder");
    }
    SetLocalLocation(oBinder, "TkhalSphereTargetLoc", lSpawn);

    int nGen = GetLocalInt(oBinder, "TkhalSphereGen") + 1;
    SetLocalInt(oBinder, "TkhalSphereGen", nGen);

    if (bDisintegrate)
    {
        FloatingTextStringOnCreature(
            "Summoned Sphere of Annihilation (unlimited duration while bound; target yourself to dismiss).",
            oBinder, FALSE
        );
    }
    else
    {
        FloatingTextStringOnCreature(
            "Summoned Sphere of Annihilation (" + IntToString(nEBL - nUsed) + "/" + IntToString(nEBL) + " daily rounds available; target yourself to dismiss).",
            oBinder, FALSE
        );
    }
    TkhalSphereTick(oBinder, oSphere, nGen);
}
