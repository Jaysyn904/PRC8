/*
Forceful Speed of Thought for Zuriel (3 sub-radials sharing a 5-round cooldown):
- 19189: Quickened Empowered Maximized Magic Missile (Supernatural; ignores SR; respects Force Missile Mage bonus missiles & Shield penetration)
- 19190: Quickened Wall of Force (Borrows sp_wallofforce.nss perpendicular wave + VFX_PER_WALLBLUE 212 + 5 linked blocking segments for 1 round/EBL; destroyed by Disintegrate or either Sphere of Annihilation; dismissible by re-activating)
- 19191: Quickened Forcecage (20x20-ft SHAPE_CUBE cage with VFX_DUR_UNSUPPORTED_CAGE 508 + VFX_DUR_RESILIENT_SPHERE + 4 corner posts; immobilizes and blocks teleportation for all creatures in the cube for 2 hours/EBL; destroyed by Disintegrate or either Sphere of Annihilation; dismissible by re-activating)
Only one such effect can be in place at one time; Magic Missile cannot be used while a Wall of Force or Forcecage is in place.
*/
#include "bnd_inc_bndfunc"
#include "prc_inc_spells"
#include "prc_inc_teleport"

int HasActiveZurielForcecage(object oBinder)
{
    if (!GetLocalInt(oBinder, "ZurielForceCageActive"))
        return FALSE;

    if (GetIsObjectValid(GetLocalObject(oBinder, "ZurielForceCageObj")))
        return TRUE;

    // Verify at least one creature in the area still has this binder's ZurielForceEffect
    object oArea = GetArea(oBinder);
    if (GetIsObjectValid(oArea))
    {
        object oChk = GetFirstObjectInArea(oArea);
        while (GetIsObjectValid(oChk))
        {
            if (GetObjectType(oChk) == OBJECT_TYPE_CREATURE &&
                GetLocalObject(oChk, "ZurielForceCageCreator") == oBinder)
            {
                effect eC = GetFirstEffect(oChk);
                while (GetIsEffectValid(eC))
                {
                    if (GetEffectTag(eC) == "ZurielForceEffect")
                        return TRUE;
                    eC = GetNextEffect(oChk);
                }
            }
            oChk = GetNextObjectInArea(oArea);
        }
    }

    DeleteLocalInt(oBinder, "ZurielForceCageActive");
    DeleteLocalObject(oBinder, "ZurielForceCageTarget");
    DeleteLocalObject(oBinder, "ZurielForceCageObj");
    return FALSE;
}

void DismissZurielForcecage(object oBinder, int bNotify)
{
    object oCageObj = GetLocalObject(oBinder, "ZurielForceCageObj");
    object oPrevTarget = GetLocalObject(oBinder, "ZurielForceCageTarget");
    if (GetIsObjectValid(oCageObj))
        DestroyForceBarrierObject(oCageObj);
    else if (GetIsObjectValid(oPrevTarget))
        DestroyForceBarrierObject(oPrevTarget);
    else
    {
        DeleteLocalInt(oBinder, "ZurielForceCageActive");
        SetLocalInt(oBinder, "ZurielForceCageGen", GetLocalInt(oBinder, "ZurielForceCageGen") + 1);
    }

    // Also restore AllowTeleport on any creature whose teleport block was set
    object oArea = GetArea(oBinder);
    if (GetIsObjectValid(oArea))
    {
        object oChk = GetFirstObjectInArea(oArea);
        while (GetIsObjectValid(oChk))
        {
            if (GetObjectType(oChk) == OBJECT_TYPE_CREATURE &&
                GetLocalObject(oChk, "ZurielForceCageCreator") == oBinder)
            {
                effect eC = GetFirstEffect(oChk);
                while (GetIsEffectValid(eC))
                {
                    if (GetEffectTag(eC) == "ZurielForceEffect")
                        RemoveEffect(oChk, eC);
                    eC = GetNextEffect(oChk);
                }
                if (GetLocalInt(oChk, "ZurielForceCageTeleportBlocked"))
                {
                    AllowTeleport(oChk);
                    DeleteLocalInt(oChk, "ZurielForceCageTeleportBlocked");
                }
                DeleteLocalObject(oChk, "ZurielForceCageCreator");
            }
            oChk = GetNextObjectInArea(oArea);
        }
    }

    if (bNotify)
        FloatingTextStringOnCreature("Zuriel's Forcecage dismissed.", oBinder, FALSE);
}

void DismissZurielWallOfForce(object oBinder, int bNotify)
{
    object oWall = GetLocalObject(oBinder, "ZurielForceWallObj");
    DeleteLocalObject(oBinder, "ZurielForceWallObj");
    if (GetIsObjectValid(oWall))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), GetLocation(oWall));
        DestroyForceBarrierObject(oWall);
    }
    if (bNotify)
        FloatingTextStringOnCreature("Zuriel's Wall of Force dismissed.", oBinder, FALSE);
}

void ExpireZurielForcecage(object oBinder, int nGen)
{
    if (!GetIsObjectValid(oBinder) || GetLocalInt(oBinder, "ZurielForceCageGen") != nGen)
        return;
    DismissZurielForcecage(oBinder, FALSE);
}

void main()
{
    object oBinder = OBJECT_SELF;
    if (GetLocalInt(oBinder, "ZurielBronzeBodyActive"))
    {
        FloatingTextStringOnCreature("You cannot use Forceful Speed of Thought while Bronze Body is active!", oBinder, FALSE);
        return;
    }

    int nSpellId = PRCGetSpellId();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ZURIEL);
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = GetIsObjectValid(oTarget) ? GetLocation(oTarget) : PRCGetSpellTargetLocation();

    object oActiveWall = GetLocalObject(oBinder, "ZurielForceWallObj");
    int bWallActive = GetIsObjectValid(oActiveWall);
    int bCageActive = HasActiveZurielForcecage(oBinder);

    // Re-activating an active Wall of Force or Forcecage dismisses it immediately
    if (nSpellId == VESTIGE_ZURIEL_FORCE_WOF_SPELL && bWallActive)
    {
        DismissZurielWallOfForce(oBinder, TRUE);
        return;
    }
    if (nSpellId == VESTIGE_ZURIEL_FORCE_CAGE_SPELL && bCageActive)
    {
        DismissZurielForcecage(oBinder, TRUE);
        return;
    }

    // Enforce canonical single-active-effect rule: "Only one such effect can be in place at one time"
    if (bWallActive)
    {
        FloatingTextStringOnCreature(
            "Forceful Speed of Thought: Only one effect can be in place at one time! Dismiss your active Wall of Force first (by activating Wall of Force again).",
            oBinder, FALSE
        );
        return;
    }
    if (bCageActive)
    {
        FloatingTextStringOnCreature(
            "Forceful Speed of Thought: Only one effect can be in place at one time! Dismiss your active Forcecage first (by activating Forcecage again).",
            oBinder, FALSE
        );
        return;
    }

    if (nSpellId == VESTIGE_ZURIEL_FORCE_MM_SPELL)
    {
        if (!GetIsObjectValid(oTarget) || oTarget == oBinder || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
        {
            FloatingTextStringOnCreature("Forceful Speed of Thought (Magic Missile): You must target another creature.", oBinder, FALSE);
            return;
        }

        if (!BindAbilCooldown(oBinder, VESTIGE_ZURIEL_FORCE_MASTER_SPELL, VESTIGE_ZURIEL))
            return;

        SignalEvent(oTarget, EventSpellCastAt(oBinder, SPELL_MAGIC_MISSILE));

        float fDist = GetDistanceBetween(oBinder, oTarget);
        float fDelay = fDist / (3.0f * log(fDist) + 2.0f);
        effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
        effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
        int i;

        int nFMM = GetLevelByClass(CLASS_TYPE_FMM, oBinder);
        int nMissiles = 5 + (nFMM >= 5 ? 2 : (nFMM >= 1 ? 1 : 0));

        int bShieldBlocked = FALSE;
        if (GetHasSpellEffect(SPELL_SHIELD, oTarget))
        {
            if (nFMM <= 0 || (d20() + nFMM < 11 + GetLocalInt(oTarget, "ShieldFMM")))
                bShieldBlocked = TRUE;
        }

        // Check Shield / Globe of Invulnerability immunity to Magic Missile
        if (bShieldBlocked
            || GetHasSpellEffect(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, oTarget)
            || GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget)
            || GetLocalInt(oTarget, "IMMUNE_TO_MAGIC_MISSILE"))
        {
            for (i = 1; i <= nMissiles; i++)
            {
                DelayCommand(i * 0.1f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
            }
            FloatingTextStringOnCreature("Magic Missile absorbed by target's barrier!", oBinder, FALSE);
            return;
        }

        // Supernatural ability per Ruling 1: ignores Spell Resistance entirely
        for (i = 1; i <= nMissiles; i++)
        {
            // Canonical 3.5e Empowered + Maximized Magic Missile:
            // Maximized base (5) + 50% of rolled 1d4+1 = 5 + ((d4(1) + 1) / 2) + per-die bonus
            int nDam = 5 + ((d4(1) + 1) / 2) + SpellDamagePerDice(oBinder, 1);
            float fTime = fDelay + (i * 0.1f);
            effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
            DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 0.0f, FALSE));
            DelayCommand(i * 0.1f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        }
    }
    else if (nSpellId == VESTIGE_ZURIEL_FORCE_WOF_SPELL)
    {
        // If self-targeted, place the Wall of Force 2.5m in front of the Binder; if targeted on another creature, place it 1.5m in front of that creature
        if (oTarget == oBinder)
        {
            vector vSelfAhead = GetPosition(oBinder) + AngleToVector(GetFacing(oBinder)) * 2.5f;
            lTarget = Location(GetArea(oBinder), vSelfAhead, GetFacing(oBinder));
        }
        else if (GetIsObjectValid(oTarget))
        {
            vector vToBinder = VectorNormalize(GetPosition(oBinder) - GetPosition(oTarget));
            if (VectorMagnitude(vToBinder) < 0.05f) vToBinder = AngleToVector(GetFacing(oBinder));
            vector vFront = GetPosition(oTarget) + vToBinder * 1.5f;
            lTarget = Location(GetArea(oBinder), vFront, GetFacing(oBinder));
        }

        if (!BindAbilCooldown(oBinder, VESTIGE_ZURIEL_FORCE_MASTER_SPELL, VESTIGE_ZURIEL))
            return;

        float fDur = RoundsToSeconds(nBinderLevel);
        location lCaster = GetLocation(oBinder);
        object oArea = GetArea(oBinder);
        effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);
        effect eGlow = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE));

        // Borrow sp_wallofforce.nss perpendicular offset geometry & wave VFX
        float sep = 1.0f;
        float lenCT = GetDistanceBetweenLocations(lCaster, lTarget);
        if (lenCT < 0.1f) lenCT = 1.0f;
        float lenTX = sep;
        vector c = GetPositionFromLocation(lCaster);
        vector t = GetPositionFromLocation(lTarget);
        float height = t.z;
        float tx = t.x, ty = t.y;
        float cx = c.x, cy = c.y;
        float dx = ty - cy;
        float dy = tx - cx;

        float angle0 = asin(dx / lenCT);
        float angle4 = 90.0f - angle0;
        float addX = -sin(angle0) * lenTX;
        float addY =  sin(angle4) * lenTX;
        if (dy < 0.0f) addX = -addX;

        float fWallFacing = VectorToAngle(t - c);
        location lCenter = Location(oArea, t, fWallFacing);
        location lOff1 = Location(oArea, Vector(tx+addX,     ty+addY,     height), fWallFacing);
        location lOff2 = Location(oArea, Vector(tx-addX,     ty-addY,     height), fWallFacing);
        location lOff3 = Location(oArea, Vector(tx+addX*2.0, ty+addY*2.0, height), fWallFacing);
        location lOff4 = Location(oArea, Vector(tx-addX*2.0, ty-addY*2.0, height), fWallFacing);
        location lOff5 = Location(oArea, Vector(tx+addX*3.0, ty+addY*3.0, height), fWallFacing);
        location lOff6 = Location(oArea, Vector(tx-addX*3.0, ty-addY*3.0, height), fWallFacing);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lCenter);
        DelayCommand(0.166f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff1));
        DelayCommand(0.166f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff2));
        DelayCommand(0.33f,  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff3));
        DelayCommand(0.33f,  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff4));
        DelayCommand(0.5f,   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff5));
        DelayCommand(0.5f,   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff6));

        object oWall = CreateObject(OBJECT_TYPE_PLACEABLE, "spell_forcewall", lCenter, FALSE, "ZurielWallOfForce");
        if (!GetIsObjectValid(oWall))
            oWall = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_walliron", lCenter, FALSE, "ZurielWallOfForce");

        if (GetIsObjectValid(oWall))
        {
            SetName(oWall, "Wall of Force");
            SetPlotFlag(oWall, TRUE);
            SetLocalInt(oWall, "PRC_WALL_OF_FORCE", TRUE);
            SetLocalObject(oWall, "PRC_WALL_CASTER", oBinder);
            SetLocalObject(oWall, "PRC_WALL_ROOT", oWall);
            SetLocalObject(oWall, "PRC_WALL_SEG_0", oWall);
            SetLocalObject(oBinder, "ZurielForceWallObj", oWall);

            // Apply VFX_PER_WALLBLUE (row 212: vps_wallblue energy wall model + bnd_vest_zurwfe barrier push) and blue force glow
            effect eBlueWall = EffectLinkEffects(
                eGlow,
                EffectAreaOfEffect(212, "bnd_vest_zurwfe", "", "")
            );
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eBlueWall), oWall, fDur);
            DestroyObject(oWall, fDur);

            // Spawn linked blocking segments along the perpendicular line so pathfinding & movement are blocked across the full span
            location lSegLoc;
            int nSeg;
            for (nSeg = 1; nSeg <= 4; nSeg++)
            {
                if (nSeg == 1) lSegLoc = lOff1;
                else if (nSeg == 2) lSegLoc = lOff2;
                else if (nSeg == 3) lSegLoc = lOff3;
                else lSegLoc = lOff4;

                object oSeg = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_walliron", lSegLoc, FALSE, "ZurielWallOfForce");
                if (GetIsObjectValid(oSeg))
                {
                    SetName(oSeg, "Wall of Force");
                    SetPlotFlag(oSeg, TRUE);
                    SetLocalInt(oSeg, "PRC_WALL_OF_FORCE", TRUE);
                    SetLocalObject(oSeg, "PRC_WALL_CASTER", oBinder);
                    SetLocalObject(oSeg, "PRC_WALL_ROOT", oWall);
                    SetLocalObject(oWall, "PRC_WALL_SEG_" + IntToString(nSeg), oSeg);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlow, oSeg, fDur);
                    DestroyObject(oSeg, fDur);
                }
            }

            // Connect outer endpoints with a force beam
            object oEndL = GetLocalObject(oWall, "PRC_WALL_SEG_3");
            object oEndR = GetLocalObject(oWall, "PRC_WALL_SEG_4");
            if (GetIsObjectValid(oEndL) && GetIsObjectValid(oEndR))
            {
                ApplyEffectToObject(
                    DURATION_TYPE_TEMPORARY,
                    SupernaturalEffect(EffectBeam(VFX_BEAM_SILENT_COLD, oEndL, BODY_NODE_CHEST)),
                    oEndR, fDur
                );
            }

            FloatingTextStringOnCreature(
                "Created Zuriel's Wall of Force for " + IntToString(nBinderLevel) + " rounds (activate Wall of Force again to dismiss).",
                oBinder, FALSE
            );
        }
    }
    else if (nSpellId == VESTIGE_ZURIEL_FORCE_CAGE_SPELL)
    {
        if (!BindAbilCooldown(oBinder, VESTIGE_ZURIEL_FORCE_MASTER_SPELL, VESTIGE_ZURIEL))
            return;

        float fDur = HoursToSeconds(2 * nBinderLevel);
        int nGen = GetLocalInt(oBinder, "ZurielForceCageGen") + 1;
        SetLocalInt(oBinder, "ZurielForceCageGen", nGen);
        SetLocalInt(oBinder, "ZurielForceCageActive", TRUE);
        DelayCommand(fDur, ExpireZurielForcecage(oBinder, nGen));

        // Spawn central targetable Forcecage controller + 4 corner posts for the 20x20-ft cube
        object oArea = GetAreaFromLocation(lTarget);
        vector vCenter = GetPositionFromLocation(lTarget);
        float fHalf = FeetToMeters(10.0f); // 10 ft half-extent = 20x20-ft cube (3.048m half-extent)

        object oCageObj = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_walliron", lTarget, FALSE, "ZurielForceCage");
        if (GetIsObjectValid(oCageObj))
        {
            SetName(oCageObj, "Forcecage");
            SetPlotFlag(oCageObj, TRUE);
            SetLocalInt(oCageObj, "PRC_WALL_OF_FORCE", TRUE);
            SetLocalInt(oCageObj, "PRC_FORCECAGE", TRUE);
            SetLocalObject(oCageObj, "PRC_WALL_CASTER", oBinder);
            SetLocalObject(oBinder, "ZurielForceCageObj", oCageObj);
            // Apply 3D cage visual (508 = VFX_DUR_UNSUPPORTED_CAGE, PLC_J09) + blue force glow
            effect eCageObjVis = EffectLinkEffects(
                EffectVisualEffect(508),
                EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE)
            );
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eCageObjVis), oCageObj, fDur);
            DestroyObject(oCageObj, fDur);

            location lC0 = Location(oArea, Vector(vCenter.x - fHalf, vCenter.y - fHalf, vCenter.z), 0.0f);
            location lC1 = Location(oArea, Vector(vCenter.x + fHalf, vCenter.y - fHalf, vCenter.z), 0.0f);
            location lC2 = Location(oArea, Vector(vCenter.x + fHalf, vCenter.y + fHalf, vCenter.z), 0.0f);
            location lC3 = Location(oArea, Vector(vCenter.x - fHalf, vCenter.y + fHalf, vCenter.z), 0.0f);
            object oP0 = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_walliron", lC0, FALSE, "ZurielForceCage");
            object oP1 = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_walliron", lC1, FALSE, "ZurielForceCage");
            object oP2 = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_walliron", lC2, FALSE, "ZurielForceCage");
            object oP3 = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_walliron", lC3, FALSE, "ZurielForceCage");
            SetLocalObject(oCageObj, "PRC_CAGE_POST_0", oP0);
            SetLocalObject(oCageObj, "PRC_CAGE_POST_1", oP1);
            SetLocalObject(oCageObj, "PRC_CAGE_POST_2", oP2);
            SetLocalObject(oCageObj, "PRC_CAGE_POST_3", oP3);

            int pIdx;
            for (pIdx = 0; pIdx < 4; pIdx++)
            {
                object oPost = GetLocalObject(oCageObj, "PRC_CAGE_POST_" + IntToString(pIdx));
                if (GetIsObjectValid(oPost))
                {
                    SetName(oPost, "Forcecage");
                    SetPlotFlag(oPost, TRUE);
                    SetLocalInt(oPost, "PRC_WALL_OF_FORCE", TRUE);
                    SetLocalInt(oPost, "PRC_FORCECAGE", TRUE);
                    SetLocalObject(oPost, "PRC_WALL_CASTER", oBinder);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE)), oPost, fDur);
                    DestroyObject(oPost, fDur);
                }
            }
            if (GetIsObjectValid(oP0) && GetIsObjectValid(oP1) && GetIsObjectValid(oP2) && GetIsObjectValid(oP3))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectBeam(VFX_BEAM_SILENT_COLD, oP0, BODY_NODE_CHEST)), oP1, fDur);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectBeam(VFX_BEAM_SILENT_COLD, oP1, BODY_NODE_CHEST)), oP2, fDur);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectBeam(VFX_BEAM_SILENT_COLD, oP2, BODY_NODE_CHEST)), oP3, fDur);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectBeam(VFX_BEAM_SILENT_COLD, oP3, BODY_NODE_CHEST)), oP0, fDur);
            }
        }

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), lTarget);
        int nCaged = 0;
        // Canonical target-centered 20x20-ft cube (half-extent fHalf = 10 ft = 3.048m in X and Y, bLineOfSight = FALSE).
        // Note: In NWN, SHAPE_CUBE is a caster-originating beam, so we query SHAPE_SPHERE of radius fHalf * 1.5f (4.572m > sqrt(2)*3.048m)
        // centered at lTarget and filter by exact axis-aligned 20x20-ft cube bounds (|dx| <= fHalf && |dy| <= fHalf).
        float fSearchRad = fHalf * 1.5f;
        object oInCage = MyFirstObjectInShape(SHAPE_SPHERE, fSearchRad, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        while (GetIsObjectValid(oInCage))
        {
            vector vPos = GetPosition(oInCage);
            if (oInCage != oBinder &&
                fabs(vPos.x - vCenter.x) <= (fHalf + 0.05f) &&
                fabs(vPos.y - vCenter.y) <= (fHalf + 0.05f))
            {
                effect eCage = EffectLinkEffects(
                    EffectCutsceneImmobilize(),
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_DUR_RESILIENT_SPHERE),
                        EffectVisualEffect(508)
                    )
                );
                eCage = TagEffect(SupernaturalEffect(eCage), "ZurielForceEffect");
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCage, oInCage, fDur);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oInCage);
                SetLocalObject(oInCage, "ZurielForceCageCreator", oBinder);
                if (!GetLocalInt(oInCage, "ZurielForceCageTeleportBlocked"))
                {
                    SetLocalInt(oInCage, "ZurielForceCageTeleportBlocked", TRUE);
                    DisallowTeleport(oInCage);
                }
                if (nCaged == 0)
                    SetLocalObject(oBinder, "ZurielForceCageTarget", oInCage);
                nCaged++;
            }
            oInCage = MyNextObjectInShape(SHAPE_SPHERE, fSearchRad, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        }
        FloatingTextStringOnCreature(
            "Created Zuriel's Forcecage (" + IntToString(nCaged) + " creature(s) trapped in 20-ft cube for up to " + IntToString(2 * nBinderLevel) + " hours; activate Forcecage again to dismiss).",
            oBinder, FALSE
        );
    }
}
