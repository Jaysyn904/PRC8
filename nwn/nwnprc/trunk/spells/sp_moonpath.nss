#include "sp_moon_inc"
#include "moonpath_inc"

// Mystara-local visualeffects.2da row.  The matching beam ProgFX and model
// live in the Moon Path VFX overlay for myh8_2da.hak.
const int VFX_BEAM_MOON_PATH = 10100;

const string MOONPATH_CONTROLLER_PREFIX = "MPC_";
const string MOONPATH_PROTECTION_PREFIX = "MPS_";
// The independent surface watcher requests teardown of this exact casting.
const string MOONPATH_CLEANUP_REQUEST = "PRC_MoonPathCleanup";

const float MOONPATH_FEET_TO_METERS = 0.3048f;
const float MOONPATH_WIDTH = 3.048f; // Fixed 10-foot NWN ribbon.
const float MOONPATH_INTERVAL = 0.5f;
const float MOONPATH_VERTICAL_TOLERANCE = 1.5f;
const float MOONPATH_VISUAL_SEGMENT = 10.0f;
const float MOONPATH_GROUND_SAMPLE = 0.5f;
const float MOONPATH_GROUND_TOLERANCE = 1.0f;
const float MOONPATH_CROSSING_MARGIN = 1.5f;

const string MOONPATH_PORTAL_FLAG = "PRC_MoonPathPortal";
const string MOONPATH_PORTAL_CASTER = "PRC_MoonPathCaster";
const string MOONPATH_PORTAL_SERIAL = "PRC_MoonPathSerial";
const string MOONPATH_PORTAL_DESTINATION = "PRC_MoonPathDestination";

int MoonPathStartsWith(string sText, string sPrefix)
{
    return GetStringLeft(sText, GetStringLength(sPrefix)) == sPrefix;
}

string MoonPathStateKey(int nSerial)
{
    return "MP" + IntToString(nSerial) + "_";
}

string MoonPathCasterKey(object oCaster)
{
    string sKey = GetObjectUUID(oCaster);
    if(sKey != "")
        return sKey;

    return ObjectToString(oCaster);
}

string MoonPathProtectionTag(object oCaster, int nSerial)
{
    return MOONPATH_PROTECTION_PREFIX + MoonPathCasterKey(oCaster)
        + "_" + IntToString(nSerial);
}

int MoonPathSurfaceSupportsRibbon(object oArea, vector vPoint,
    float fFacing)
{
    location lPoint = Location(oArea, vPoint, fFacing);
    int nSurface = GetSurfaceMaterial(lPoint);
    if(nSurface <= 0
        || StringToInt(Get2DAString("surfacemat", "Walk", nSurface)) == 0)
        return FALSE;

    float fGround = GetGroundHeight(lPoint);
    return fabs(fGround - vPoint.z) <= MOONPATH_GROUND_TOLERANCE;
}

// Returns 0 when ordinary ground supports the entire ribbon, 1 when a
// crossing is needed, and -1 when no safe landing exists at the far end.
int MoonPathFindCrossing(object oCaster, int nSerial, object oArea,
    vector vStart, vector vEnd)
{
    string sKey = MoonPathStateKey(nSerial);
    float fDX = vEnd.x - vStart.x;
    float fDY = vEnd.y - vStart.y;
    float fDZ = vEnd.z - vStart.z;
    float fHorizontal = sqrt(fDX * fDX + fDY * fDY);
    float fFacing = VectorToAngle(Vector(fDX, fDY, 0.0f));
    int nSamples = FloatToInt(fHorizontal / MOONPATH_GROUND_SAMPLE) + 1;
    int bFoundGap = FALSE;
    int bInsideGap = FALSE;
    float fLastSupported = 0.0f;
    float fBeforeGap = 0.0f;
    float fAfterGap = -1.0f;
    int i;

    if(!MoonPathSurfaceSupportsRibbon(oArea, vStart, fFacing)
        || !MoonPathSurfaceSupportsRibbon(oArea, vEnd, fFacing))
        return -1;

    for(i = 0; i <= nSamples; i++)
    {
        float fT = IntToFloat(i) / IntToFloat(nSamples);
        vector vSample = Vector(
            vStart.x + fT * fDX,
            vStart.y + fT * fDY,
            vStart.z + fT * fDZ);
        int bSupported = MoonPathSurfaceSupportsRibbon(oArea, vSample,
            fFacing);

        if(bSupported)
        {
            if(bInsideGap)
            {
                fAfterGap = fT;
                bInsideGap = FALSE;
            }
            fLastSupported = fT;
        }
        else if(!bInsideGap)
        {
            if(!bFoundGap)
                fBeforeGap = fLastSupported;
            bFoundGap = TRUE;
            bInsideGap = TRUE;
        }
    }

    if(!bFoundGap)
        return 0;
    if(bInsideGap || fAfterGap < 0.0f)
        return -1;

    float fMarginT = MOONPATH_CROSSING_MARGIN / fHorizontal;
    float fPortalA = fBeforeGap - fMarginT;
    float fPortalB = fAfterGap + fMarginT;
    if(fPortalA < 0.0f)
        fPortalA = 0.0f;
    if(fPortalB > 1.0f)
        fPortalB = 1.0f;

    vector vPortalA = Vector(
        vStart.x + fPortalA * fDX,
        vStart.y + fPortalA * fDY,
        vStart.z + fPortalA * fDZ);
    vector vPortalB = Vector(
        vStart.x + fPortalB * fDX,
        vStart.y + fPortalB * fDY,
        vStart.z + fPortalB * fDZ);
    if(!MoonPathSurfaceSupportsRibbon(oArea, vPortalA, fFacing)
        || !MoonPathSurfaceSupportsRibbon(oArea, vPortalB, fFacing))
        return -1;

    // Put each endpoint exactly on its supporting walkmesh. The bridge itself
    // remains the straight line between the original spell endpoints.
    vPortalA.z = GetGroundHeight(Location(oArea, vPortalA, fFacing));
    vPortalB.z = GetGroundHeight(Location(oArea, vPortalB, fFacing));

    SetLocalInt(oCaster, sKey + "X", TRUE);
    SetLocalFloat(oCaster, sKey + "AX", vPortalA.x);
    SetLocalFloat(oCaster, sKey + "AY", vPortalA.y);
    SetLocalFloat(oCaster, sKey + "AZ", vPortalA.z);
    SetLocalFloat(oCaster, sKey + "BX", vPortalB.x);
    SetLocalFloat(oCaster, sKey + "BY", vPortalB.y);
    SetLocalFloat(oCaster, sKey + "BZ", vPortalB.z);
    return 1;
}

void MoonPathUsePortal(object oPortal)
{
    object oTraveler = GetLastUsedBy();
    object oCaster = GetLocalObject(oPortal, MOONPATH_PORTAL_CASTER);
    int nSerial = GetLocalInt(oPortal, MOONPATH_PORTAL_SERIAL);
    string sKey = MoonPathStateKey(nSerial);

    if(!GetIsObjectValid(oTraveler)
        || GetObjectType(oTraveler) != OBJECT_TYPE_CREATURE
        || GetIsDead(oTraveler)
        || !GetIsObjectValid(oCaster)
        || !GetLocalInt(oCaster, sKey + "X")
        || GetArea(oTraveler) != GetArea(oPortal))
        return;

    location lDestination = GetLocalLocation(oPortal,
        MOONPATH_PORTAL_DESTINATION);
    if(!GetIsObjectValid(GetAreaFromLocation(lDestination))
        || GetAreaFromLocation(lDestination) != GetArea(oTraveler))
        return;

    string sCooldown = "MPX_" + ObjectToString(oCaster) + "_"
        + IntToString(nSerial);
    if(GetLocalInt(oTraveler, sCooldown))
        return;

    SetLocalInt(oTraveler, sCooldown, TRUE);
    DelayCommand(1.0f, DeleteLocalInt(oTraveler, sCooldown));
    AssignCommand(oTraveler, JumpToLocation(lDestination));
}

int MoonPathHasTaggedEffect(object oTarget, string sTag)
{
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectTag(eTest) == sTag
            && GetEffectType(eTest) == EFFECT_TYPE_SANCTUARY)
            return TRUE;

        eTest = GetNextEffect(oTarget);
    }

    return FALSE;
}

void MoonPathRemoveTaggedEffects(object oTarget, string sTag)
{
    if(!GetIsObjectValid(oTarget))
        return;

    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectTag(eTest) == sTag)
            {
                RemoveEffect(oTarget, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oTarget);
        }
    }
}

int MoonPathCreatureIsOnRibbon(object oCaster, object oTarget, int nSerial)
{
    if(!GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget))
        return FALSE;

    string sKey = MoonPathStateKey(nSerial);
    object oArea = GetLocalObject(oCaster, sKey + "A");
    if(!GetIsObjectValid(oArea) || GetArea(oTarget) != oArea)
        return FALSE;

    vector vTarget = GetPosition(oTarget);
    float fStartX = GetLocalFloat(oCaster, sKey + "SX");
    float fStartY = GetLocalFloat(oCaster, sKey + "SY");
    float fStartZ = GetLocalFloat(oCaster, sKey + "SZ");
    float fEndX = GetLocalFloat(oCaster, sKey + "EX");
    float fEndY = GetLocalFloat(oCaster, sKey + "EY");
    float fEndZ = GetLocalFloat(oCaster, sKey + "EZ");

    float fDX = fEndX - fStartX;
    float fDY = fEndY - fStartY;
    float fLengthSquared = fDX * fDX + fDY * fDY;
    if(fLengthSquared <= 0.01f)
        return FALSE;

    float fT = ((vTarget.x - fStartX) * fDX
        + (vTarget.y - fStartY) * fDY) / fLengthSquared;
    if(fT < 0.0f || fT > 1.0f)
        return FALSE;

    float fClosestX = fStartX + fT * fDX;
    float fClosestY = fStartY + fT * fDY;
    float fOffsetX = vTarget.x - fClosestX;
    float fOffsetY = vTarget.y - fClosestY;
    float fHalfWidth = MOONPATH_WIDTH * 0.5f;
    if((fOffsetX * fOffsetX + fOffsetY * fOffsetY)
        > (fHalfWidth * fHalfWidth))
        return FALSE;

    float fPathZ = fStartZ + fT * (fEndZ - fStartZ);
    return fabs(vTarget.z - fPathZ) <= MOONPATH_VERTICAL_TOLERANCE;
}

void MoonPathApplyProtection(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel, int nSerial, float fDuration)
{
    int nDC = 15 + GetAbilityModifier(ABILITY_WISDOM, oCaster);
    effect eProtection = EffectSanctuary(nDC);
    eProtection = EffectLinkEffects(eProtection,
        EffectVisualEffect(VFX_DUR_SANCTUARY));
    eProtection = SetEffectSpellId(eProtection, nSpellID);
    eProtection = SetEffectCasterLevel(eProtection, nCasterLevel);
    eProtection = SetEffectCreator(eProtection, oCaster);
    eProtection = TagEffect(eProtection,
        MoonPathProtectionTag(oCaster, nSerial));

    if(fDuration < 1.0f)
        fDuration = 1.0f;

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eProtection, oTarget,
        fDuration, TRUE, nSpellID, nCasterLevel, oCaster);
}

void MoonPathBreakSanctuary(object oCaster, int nSerial)
{
    string sKey = MoonPathStateKey(nSerial);
    string sTag = MoonPathProtectionTag(oCaster, nSerial);
    int nTargets = GetLocalInt(oCaster, sKey + "N");
    int i;

    SetLocalInt(oCaster, sKey + "B", TRUE);
    for(i = 0; i < nTargets; i++)
    {
        object oTarget = GetLocalObject(oCaster, sKey + "S"
            + IntToString(i));
        MoonPathRemoveTaggedEffects(oTarget, sTag);
        DeleteLocalInt(oCaster, sKey + "P" + IntToString(i));
    }
}

void MoonPathPulse(object oCaster, effect eController, int nSerial)
{
    if(!GetIsObjectValid(oCaster))
        return;

    string sKey = MoonPathStateKey(nSerial);
    // A queued interval must not restore protection after rest or dismissal.
    if(!GetIsObjectValid(GetLocalObject(oCaster, sKey + "A")))
        return;
    string sTag = MoonPathProtectionTag(oCaster, nSerial);
    int nTargets = GetLocalInt(oCaster, sKey + "N");
    int bBroken = GetLocalInt(oCaster, sKey + "B");
    int i;

    // A physical attack by any designated subject ends sanctuary for the
    // entire casting. Native sanctuary removal catches hostile spell actions
    // while a subject is standing on the ribbon.
    if(!bBroken)
    {
        for(i = 0; i < nTargets; i++)
        {
            object oTest = GetLocalObject(oCaster, sKey + "S"
                + IntToString(i));
            string sProtected = sKey + "P" + IntToString(i);
            if(GetIsObjectValid(oTest)
                && GetLocalInt(oCaster, sProtected)
                && MoonPathCreatureIsOnRibbon(oCaster, oTest, nSerial)
                && GetCurrentAction(oTest) == ACTION_ATTACKOBJECT)
            {
                MoonPathBreakSanctuary(oCaster, nSerial);
                bBroken = TRUE;
                break;
            }

            if(GetIsObjectValid(oTest)
                && GetLocalInt(oCaster, sKey + "P" + IntToString(i))
                && MoonPathCreatureIsOnRibbon(oCaster, oTest, nSerial)
                && !MoonPathHasTaggedEffect(oTest, sTag))
            {
                MoonPathBreakSanctuary(oCaster, nSerial);
                bBroken = TRUE;
                break;
            }
        }
    }

    float fProtectionDuration = GetLocalFloat(oCaster, sKey + "D");
    int nSpellID = GetEffectSpellId(eController);
    int nCasterLevel = GetEffectCasterLevel(eController);

    for(i = 0; i < nTargets; i++)
    {
        object oTarget = GetLocalObject(oCaster, sKey + "S"
            + IntToString(i));
        string sProtected = sKey + "P" + IntToString(i);
        int bOnPath = MoonPathCreatureIsOnRibbon(oCaster, oTarget, nSerial);

        if(bOnPath && !bBroken)
        {
            if(!MoonPathHasTaggedEffect(oTarget, sTag))
                MoonPathApplyProtection(oCaster, oTarget, nSpellID,
                    nCasterLevel, nSerial,
                    fProtectionDuration + MOONPATH_INTERVAL);
            SetLocalInt(oCaster, sProtected, TRUE);
        }
        else
        {
            MoonPathRemoveTaggedEffects(oTarget, sTag);
            DeleteLocalInt(oCaster, sProtected);
        }
    }
}

object MoonPathCreateVisualNode(object oCaster, int nSerial, int nNode,
    location lNode)
{
    string sKey = MoonPathStateKey(nSerial);
    string sNodeTag = "MPath" + IntToString(nSerial) + "_"
        + IntToString(nNode);
    if(nNode == 0)
        sNodeTag = MOONPATH_SURFACE_TAG;
    object oNode = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lNode,
        FALSE, sNodeTag);
    if(!GetIsObjectValid(oNode))
        return OBJECT_INVALID;

    SetPlotFlag(oNode, TRUE);
    SetUseableFlag(oNode, FALSE);
    SetLocalObject(oCaster, sKey + "V" + IntToString(nNode), oNode);

    // The node owns this failsafe, so it still fires if the caster logs out
    // before the controller's normal cleanup callback can run.
    float fNodeLifetime = GetLocalFloat(oCaster, sKey + "D") + 1.0f;
    AssignCommand(oNode,
        DelayCommand(fNodeLifetime, DestroyObject(OBJECT_SELF)));
    return oNode;
}

object MoonPathCreateVisualRibbon(object oCaster, int nSerial, object oArea,
    vector vStart, vector vEnd)
{
    string sKey = MoonPathStateKey(nSerial);
    float fDX = vEnd.x - vStart.x;
    float fDY = vEnd.y - vStart.y;
    float fDZ = vEnd.z - vStart.z;
    float fLength = sqrt(fDX * fDX + fDY * fDY + fDZ * fDZ);
    float fHorizontal = sqrt(fDX * fDX + fDY * fDY);
    float fFacing = VectorToAngle(Vector(fDX, fDY, 0.0f));
    float fPerpX = -fDY / fHorizontal;
    float fPerpY = fDX / fHorizontal;
    float fHalfWidth = MOONPATH_WIDTH * 0.5f;
    int nSegments = FloatToInt(fLength / MOONPATH_VISUAL_SEGMENT) + 1;
    int nNode = 0;
    object oSurface = OBJECT_INVALID;
    int nLane;
    int i;

    // Five evenly spaced bands make the full 10-foot corridor read as one
    // calm moonlit bridge instead of three disconnected beam lines.
    for(nLane = -2; nLane <= 2; nLane++)
    {
        object oPrevious = OBJECT_INVALID;
        float fLaneOffset = IntToFloat(nLane) * fHalfWidth * 0.5f;

        for(i = 0; i <= nSegments; i++)
        {
            float fT = IntToFloat(i) / IntToFloat(nSegments);
            vector vNode = Vector(
                vStart.x + fT * fDX + fLaneOffset * fPerpX,
                vStart.y + fT * fDY + fLaneOffset * fPerpY,
                vStart.z + fT * fDZ);
            object oNode = MoonPathCreateVisualNode(oCaster, nSerial, nNode,
                Location(oArea, vNode, fFacing));

            if(nNode == 0 && GetIsObjectValid(oNode))
            {
                oSurface = oNode;
                MoonPathConfigureSurfaceAnchor(oSurface, oCaster, nSerial,
                    vStart, vEnd, MOONPATH_WIDTH);
                SetLocalObject(oCaster, sKey + "R", oSurface);
            }

            if(GetIsObjectValid(oPrevious) && GetIsObjectValid(oNode))
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    EffectBeam(VFX_BEAM_MOON_PATH, oPrevious,
                        BODY_NODE_CHEST), oNode);

            oPrevious = oNode;
            nNode++;
        }
    }

    SetLocalInt(oCaster, sKey + "VN", nNode);
    return oSurface;
}

int MoonPathCreateCrossingPortals(object oCaster, int nSerial,
    object oArea, vector vStart, vector vEnd)
{
    string sKey = MoonPathStateKey(nSerial);
    if(!GetLocalInt(oCaster, sKey + "X"))
        return TRUE;

    vector vPortalA = Vector(
        GetLocalFloat(oCaster, sKey + "AX"),
        GetLocalFloat(oCaster, sKey + "AY"),
        GetLocalFloat(oCaster, sKey + "AZ"));
    vector vPortalB = Vector(
        GetLocalFloat(oCaster, sKey + "BX"),
        GetLocalFloat(oCaster, sKey + "BY"),
        GetLocalFloat(oCaster, sKey + "BZ"));
    float fFacing = VectorToAngle(Vector(
        vEnd.x - vStart.x, vEnd.y - vStart.y, 0.0f));
    float fReverseFacing = fFacing + 180.0f;
    if(fReverseFacing >= 360.0f)
        fReverseFacing -= 360.0f;

    location lPortalA = Location(oArea, vPortalA, fFacing);
    location lPortalB = Location(oArea, vPortalB, fReverseFacing);
    int nNode = GetLocalInt(oCaster, sKey + "VN");
    object oPortalA = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_portal",
        lPortalA, FALSE, "MPathX" + IntToString(nSerial) + "A");
    object oPortalB = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_portal",
        lPortalB, FALSE, "MPathX" + IntToString(nSerial) + "B");

    if(!GetIsObjectValid(oPortalA) || !GetIsObjectValid(oPortalB))
    {
        if(GetIsObjectValid(oPortalA))
            DestroyObject(oPortalA);
        if(GetIsObjectValid(oPortalB))
            DestroyObject(oPortalB);
        return FALSE;
    }

    SetPlotFlag(oPortalA, TRUE);
    SetPlotFlag(oPortalB, TRUE);
    SetUseableFlag(oPortalA, TRUE);
    SetUseableFlag(oPortalB, TRUE);
    SetName(oPortalA, "Cross Moon Path");
    SetName(oPortalB, "Cross Moon Path");
    SetEventScript(oPortalA, EVENT_SCRIPT_PLACEABLE_ON_USED, "sp_moonpath");
    SetEventScript(oPortalB, EVENT_SCRIPT_PLACEABLE_ON_USED, "sp_moonpath");

    SetLocalInt(oPortalA, MOONPATH_PORTAL_FLAG, TRUE);
    SetLocalInt(oPortalB, MOONPATH_PORTAL_FLAG, TRUE);
    SetLocalObject(oPortalA, MOONPATH_PORTAL_CASTER, oCaster);
    SetLocalObject(oPortalB, MOONPATH_PORTAL_CASTER, oCaster);
    SetLocalInt(oPortalA, MOONPATH_PORTAL_SERIAL, nSerial);
    SetLocalInt(oPortalB, MOONPATH_PORTAL_SERIAL, nSerial);
    SetLocalLocation(oPortalA, MOONPATH_PORTAL_DESTINATION,
        Location(oArea, vPortalB, fFacing));
    SetLocalLocation(oPortalB, MOONPATH_PORTAL_DESTINATION,
        Location(oArea, vPortalA, fReverseFacing));

    effect eMarker = EffectLinkEffects(
        EffectVisualEffect(VFX_DUR_AURA_WHITE),
        EffectVisualEffect(VFX_DUR_LIGHT_WHITE_5));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMarker, oPortalA);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMarker, oPortalB);

    SetLocalObject(oCaster, sKey + "V" + IntToString(nNode), oPortalA);
    SetLocalObject(oCaster, sKey + "V" + IntToString(nNode + 1), oPortalB);
    SetLocalInt(oCaster, sKey + "VN", nNode + 2);

    // Each endpoint can still remove itself if its caster logs out before the
    // removable spell controller gets a chance to run normal cleanup.
    float fPortalLifetime = GetLocalFloat(oCaster, sKey + "D") + 1.0f;
    AssignCommand(oPortalA,
        DelayCommand(fPortalLifetime, DestroyObject(OBJECT_SELF)));
    AssignCommand(oPortalB,
        DelayCommand(fPortalLifetime, DestroyObject(OBJECT_SELF)));
    return TRUE;
}

void MoonPathCleanup(object oCaster, int nSerial)
{
    if(!GetIsObjectValid(oCaster))
        return;

    string sKey = MoonPathStateKey(nSerial);
    if(!GetIsObjectValid(GetLocalObject(oCaster, sKey + "A")))
        return;
    // Invalidate first: removal callbacks and the duration failsafe may both
    // arrive for this serial, and neither may revive or clean a newer cast.
    DeleteLocalObject(oCaster, sKey + "A");
    string sTag = MoonPathProtectionTag(oCaster, nSerial);
    int nTargets = GetLocalInt(oCaster, sKey + "N");
    int nNodes = GetLocalInt(oCaster, sKey + "VN");
    int i;

    object oSurface = GetLocalObject(oCaster, sKey + "R");
    if(GetIsObjectValid(oSurface))
    {
        if(MoonPathDebugIsEnabled())
            MoonPathDebugMessage(oCaster, "surface serial "
                + IntToString(nSerial) + " unregistered.");
        DeleteLocalInt(oSurface, MPATH_ANCHOR_ACTIVE);
        ExecuteScript("moonpath_watch", oSurface);
    }
    DeleteLocalObject(oCaster, sKey + "R");

    for(i = 0; i < nTargets; i++)
    {
        object oTarget = GetLocalObject(oCaster, sKey + "S"
            + IntToString(i));
        MoonPathRemoveTaggedEffects(oTarget, sTag);
        DeleteLocalObject(oCaster, sKey + "S" + IntToString(i));
        DeleteLocalInt(oCaster, sKey + "P" + IntToString(i));
    }

    for(i = 0; i < nNodes; i++)
    {
        object oNode = GetLocalObject(oCaster, sKey + "V"
            + IntToString(i));
        if(GetIsObjectValid(oNode))
            DestroyObject(oNode);
        DeleteLocalObject(oCaster, sKey + "V" + IntToString(i));
    }

    DeleteLocalFloat(oCaster, sKey + "SX");
    DeleteLocalFloat(oCaster, sKey + "SY");
    DeleteLocalFloat(oCaster, sKey + "SZ");
    DeleteLocalFloat(oCaster, sKey + "EX");
    DeleteLocalFloat(oCaster, sKey + "EY");
    DeleteLocalFloat(oCaster, sKey + "EZ");
    DeleteLocalFloat(oCaster, sKey + "D");
    DeleteLocalInt(oCaster, sKey + "N");
    DeleteLocalInt(oCaster, sKey + "VN");
    DeleteLocalInt(oCaster, sKey + "B");
    DeleteLocalInt(oCaster, sKey + "X");
    DeleteLocalFloat(oCaster, sKey + "AX");
    DeleteLocalFloat(oCaster, sKey + "AY");
    DeleteLocalFloat(oCaster, sKey + "AZ");
    DeleteLocalFloat(oCaster, sKey + "BX");
    DeleteLocalFloat(oCaster, sKey + "BY");
    DeleteLocalFloat(oCaster, sKey + "BZ");

    // Rest can be observed by the surface watcher before the engine strips
    // the caster's effect. Remove the controller as part of the same teardown.
    MoonPathRemoveTaggedEffects(oCaster, MOONPATH_CONTROLLER_PREFIX
        + MoonPathCasterKey(oCaster) + "_" + IntToString(nSerial));
}

int MoonPathIsDesignated(object oCaster, string sKey, int nTargets,
    object oTarget)
{
    int i;
    for(i = 0; i < nTargets; i++)
    {
        if(GetLocalObject(oCaster, sKey + "S" + IntToString(i)) == oTarget)
            return TRUE;
    }

    return FALSE;
}

void MoonPathDesignateSubjects(object oCaster, int nCasterLevel, int nSpellID,
    int nSerial)
{
    string sKey = MoonPathStateKey(nSerial);
    object oArea = GetArea(oCaster);
    int nTargets = 0;

    // The spell normally lets the caster choose. NWN has no multi-select step,
    // so designate the caster first, then allies already on the ribbon, then
    // other allies in the area up to the caster-level limit.
    if(GetObjectType(oCaster) == OBJECT_TYPE_CREATURE && nTargets < nCasterLevel)
    {
        SetLocalObject(oCaster, sKey + "S" + IntToString(nTargets), oCaster);
        MoonSpellSignal(oCaster, oCaster, nSpellID, FALSE);
        nTargets++;
    }

    object oTarget = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oTarget) && nTargets < nCasterLevel)
    {
        if(oTarget != oCaster
            && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE
            && !GetIsDead(oTarget)
            && MoonPathCreatureIsOnRibbon(oCaster, oTarget, nSerial)
            && spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
        {
            SetLocalObject(oCaster, sKey + "S" + IntToString(nTargets),
                oTarget);
            MoonSpellSignal(oCaster, oTarget, nSpellID, FALSE);
            nTargets++;
        }

        oTarget = GetNextObjectInArea(oArea);
    }

    oTarget = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oTarget) && nTargets < nCasterLevel)
    {
        if(oTarget != oCaster
            && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE
            && !GetIsDead(oTarget)
            && !MoonPathIsDesignated(oCaster, sKey, nTargets, oTarget)
            && spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
        {
            SetLocalObject(oCaster, sKey + "S" + IntToString(nTargets),
                oTarget);
            MoonSpellSignal(oCaster, oTarget, nSpellID, FALSE);
            nTargets++;
        }

        oTarget = GetNextObjectInArea(oArea);
    }

    SetLocalInt(oCaster, sKey + "N", nTargets);
}

void main()
{
    int nCleanupSerial = GetLocalInt(OBJECT_SELF, MOONPATH_CLEANUP_REQUEST);
    if(nCleanupSerial > 0)
    {
        DeleteLocalInt(OBJECT_SELF, MOONPATH_CLEANUP_REQUEST);
        MoonPathCleanup(OBJECT_SELF, nCleanupSerial);
        return;
    }

    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE
        && GetLocalInt(OBJECT_SELF, MOONPATH_PORTAL_FLAG))
    {
        MoonPathUsePortal(OBJECT_SELF);
        return;
    }

    // Dispatch on the native event before inspecting metadata. A removing
    // effect can lose its tag/validity; it must never fall through and cast a
    // fresh path. The surface watcher recovers a missing removal callback.
    int nEvent = GetLastRunScriptEffectScriptType();
    effect eRun = GetLastRunScriptEffect();
    if(GetIsEffectValid(eRun)
        && MoonPathStartsWith(GetEffectTag(eRun),
            MOONPATH_CONTROLLER_PREFIX))
    {
        if(GetIsEffectValid(eRun)
            && MoonPathStartsWith(GetEffectTag(eRun),
                MOONPATH_CONTROLLER_PREFIX))
        {
            int nSerial = StringToInt(GetEffectString(eRun, 0));
            if(nSerial > 0)
            {
                if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED
                    || GetIsResting(OBJECT_SELF))
                    MoonPathCleanup(OBJECT_SELF, nSerial);
                else
                    MoonPathPulse(OBJECT_SELF, eRun, nSerial);
            }
        }
        return;
    }

    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    location lStart = GetLocation(oCaster);
    location lEnd = PRCGetSpellTargetLocation();
    object oArea = GetAreaFromLocation(lStart);
    if(!GetIsObjectValid(oArea) || GetAreaFromLocation(lEnd) != oArea)
    {
        FloatingTextStringOnCreature("Moon Path must remain in one area.",
            oCaster, FALSE);
        PRCSetSchool();
        return;
    }

    vector vStart = GetPositionFromLocation(lStart);
    vector vEnd = GetPositionFromLocation(lEnd);
    float fDX = vEnd.x - vStart.x;
    float fDY = vEnd.y - vStart.y;
    float fDZ = vEnd.z - vStart.z;
    float fHorizontal = sqrt(fDX * fDX + fDY * fDY);
    float fLength = sqrt(fHorizontal * fHorizontal + fDZ * fDZ);
    float fMaximumLength = IntToFloat(nCasterLevel) * 15.0f
        * MOONPATH_FEET_TO_METERS;
    float fMaximumRange = (100.0f
        + IntToFloat(nCasterLevel) * 10.0f) * MOONPATH_FEET_TO_METERS;
    float fMaximum = fMaximumLength;
    if(fMaximumRange < fMaximum)
        fMaximum = fMaximumRange;

    if(fLength < 1.0f)
    {
        FloatingTextStringOnCreature(
            "Moon Path needs two distinct endpoints.", oCaster, FALSE);
        PRCSetSchool();
        return;
    }
    if(fLength > fMaximum + 0.1f)
    {
        FloatingTextStringOnCreature(
            "Moon Path exceeds its range or 15-feet-per-level length limit.",
            oCaster, FALSE);
        PRCSetSchool();
        return;
    }
    if(fHorizontal < 0.1f || fabs(fDZ) > fHorizontal + 0.1f)
    {
        FloatingTextStringOnCreature(
            "Moon Path stairs cannot be steeper than 45 degrees.",
            oCaster, FALSE);
        PRCSetSchool();
        return;
    }

    vector vSightStart = Vector(vStart.x, vStart.y, vStart.z + 0.5f);
    vector vSightEnd = Vector(vEnd.x, vEnd.y, vEnd.z + 0.5f);
    if(!LineOfSightVector(vSightStart, vSightEnd))
    {
        FloatingTextStringOnCreature(
            "A straight Moon Path cannot pass through an obstruction.",
            oCaster, FALSE);
        PRCSetSchool();
        return;
    }

    float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(nCasterLevel));
    int nSerial = GetLocalInt(oCaster, "PRC_MoonPathSerial") + 1;
    SetLocalInt(oCaster, "PRC_MoonPathSerial", nSerial);
    string sStateKey = MoonPathStateKey(nSerial);

    SetLocalObject(oCaster, sStateKey + "A", oArea);
    SetLocalFloat(oCaster, sStateKey + "SX", vStart.x);
    SetLocalFloat(oCaster, sStateKey + "SY", vStart.y);
    SetLocalFloat(oCaster, sStateKey + "SZ", vStart.z);
    SetLocalFloat(oCaster, sStateKey + "EX", vEnd.x);
    SetLocalFloat(oCaster, sStateKey + "EY", vEnd.y);
    SetLocalFloat(oCaster, sStateKey + "EZ", vEnd.z);
    SetLocalFloat(oCaster, sStateKey + "D", fDuration);

    int nCrossing = MoonPathFindCrossing(oCaster, nSerial, oArea,
        vStart, vEnd);
    if(nCrossing < 0)
    {
        FloatingTextStringOnCreature(
            "Moon Path needs safe walking ground at both ends.",
            oCaster, FALSE);
        MoonPathCleanup(oCaster, nSerial);
        PRCSetSchool();
        return;
    }

    MoonPathDesignateSubjects(oCaster, nCasterLevel, nSpellID, nSerial);
    object oSurface = MoonPathCreateVisualRibbon(oCaster, nSerial, oArea,
        vStart, vEnd);
    if(!GetIsObjectValid(oSurface))
    {
        FloatingTextStringOnCreature(
            "Moon Path could not register its force surface.",
            oCaster, FALSE);
        MoonPathCleanup(oCaster, nSerial);
        PRCSetSchool();
        return;
    }

    if(MoonPathDebugIsEnabled())
    {
        int nGeometryPassed = MoonPathGeometrySelfTest(oSurface);
        string sResult = "FAIL.";
        if(nGeometryPassed == 4)
            sResult = "PASS.";
        MoonPathDebugMessage(oCaster, "surface serial "
            + IntToString(nSerial) + " registered; geometry self-test "
            + IntToString(nGeometryPassed) + "/4 " + sResult
            + " path " + MoonPathDebugVector(vStart) + " -> "
            + MoonPathDebugVector(vEnd));
    }
    if(!MoonPathCreateCrossingPortals(oCaster, nSerial, oArea,
        vStart, vEnd))
    {
        FloatingTextStringOnCreature(
            "Moon Path could not create its crossing points.",
            oCaster, FALSE);
        MoonPathCleanup(oCaster, nSerial);
        PRCSetSchool();
        return;
    }

    // Native interval effects survive single-player saves and require neither
    // NWNX nor a module heartbeat. The anchor dies with this exact casting.
    effect eArrowController = SupernaturalEffect(EffectRunScript(
        "moonpath_watch", "moonpath_watch", "moonpath_watch", 0.1f));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArrowController, oSurface,
        fDuration);

    string sControllerTag = MOONPATH_CONTROLLER_PREFIX
        + MoonPathCasterKey(oCaster) + "_" + IntToString(nSerial);
    effect eController = EffectRunScript("sp_moonpath", "sp_moonpath",
        "sp_moonpath", MOONPATH_INTERVAL, IntToString(nSerial));
    eController = SetEffectSpellId(eController, nSpellID);
    eController = SetEffectCasterLevel(eController, nCasterLevel);
    eController = SetEffectCreator(eController, oCaster);
    eController = TagEffect(eController, sControllerTag);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eController, oCaster,
        fDuration, TRUE, nSpellID, nCasterLevel, oCaster);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_HOLY_10), oCaster);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_HOLY_10), lEnd);

    // Fallback only. Normal cleanup is driven by the removable controller.
    DelayCommand(fDuration + 0.25f, MoonPathCleanup(oCaster, nSerial));
    PRCSetSchool();
}
