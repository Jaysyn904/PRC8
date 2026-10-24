// Shared Moon Path surface registry, geometry, and temporary QA feedback.
//
// The first invisible visual node of every active Moon Path is tagged
// MOONPATH_SURFACE and carries the finite ribbon geometry.  Combat hooks can
// therefore discover every active path without knowing which creature cast it.

const string MOONPATH_SURFACE_TAG = "MOONPATH_SURFACE";

const string MPATH_ANCHOR_ACTIVE = "MPA_ON";
const string MPATH_ANCHOR_CASTER = "MPA_C";
const string MPATH_ANCHOR_SERIAL = "MPA_SN";
const string MPATH_ANCHOR_SX = "MPA_SX";
const string MPATH_ANCHOR_SY = "MPA_SY";
const string MPATH_ANCHOR_SZ = "MPA_SZ";
const string MPATH_ANCHOR_EX = "MPA_EX";
const string MPATH_ANCHOR_EY = "MPA_EY";
const string MPATH_ANCHOR_EZ = "MPA_EZ";
const string MPATH_ANCHOR_WIDTH = "MPA_W";

// These two module flags deliberately isolate the temporary tester feedback
// from enforcement.  Later QA can disable the messages without removing the
// mechanics, or disable enforcement while retaining diagnostic output.
const string MPATH_DEBUG_FLAG = "MPATH_DEBUG";
const string MPATH_ENFORCE_FLAG = "MPATH_ENFORCE";
// Portable spells work without a module-load hook. Opt out explicitly rather
// than interpreting an unset legacy tester flag as disabled protection.
const string MPATH_DISABLE_FLAG = "MPATH_DISABLE";

const float MPATH_PLANE_EPSILON = 0.05f;
const float MPATH_EDGE_EPSILON = 0.05f;

string MoonPathDebugObjectName(object oObject)
{
    if(!GetIsObjectValid(oObject))
        return "<invalid>";

    string sName = GetName(oObject);
    if(sName == "")
        sName = GetTag(oObject);
    if(sName == "")
        sName = ObjectToString(oObject);
    return sName;
}

int MoonPathDebugIsEnabled()
{
    return GetLocalInt(GetModule(), MPATH_DEBUG_FLAG);
}

int MoonPathEnforcementIsEnabled()
{
    return !GetLocalInt(GetModule(), MPATH_DISABLE_FLAG);
}

string MoonPathDebugFloat(float fValue)
{
    return FloatToString(fValue, 0, 2);
}

string MoonPathDebugVector(vector vPoint)
{
    return "(" + MoonPathDebugFloat(vPoint.x) + ","
        + MoonPathDebugFloat(vPoint.y) + ","
        + MoonPathDebugFloat(vPoint.z) + ")";
}

// Produces server-log-only geometry details for QA.  This deliberately mirrors
// the finite-ribbon calculation so an ALLOWED decision says why it was allowed
// instead of forcing the tester to infer the ray from combat animations.
string MoonPathDebugSurfaceTrace(object oAnchor, vector vFrom, vector vTo)
{
    string sTrace = "ray " + MoonPathDebugVector(vFrom) + " -> "
        + MoonPathDebugVector(vTo);
    if(!GetIsObjectValid(oAnchor))
        return sTrace + "; reason=no-surface";

    vector vStart = Vector(
        GetLocalFloat(oAnchor, MPATH_ANCHOR_SX),
        GetLocalFloat(oAnchor, MPATH_ANCHOR_SY),
        GetLocalFloat(oAnchor, MPATH_ANCHOR_SZ));
    vector vEnd = Vector(
        GetLocalFloat(oAnchor, MPATH_ANCHOR_EX),
        GetLocalFloat(oAnchor, MPATH_ANCHOR_EY),
        GetLocalFloat(oAnchor, MPATH_ANCHOR_EZ));
    sTrace += "; path " + MoonPathDebugVector(vStart) + " -> "
        + MoonPathDebugVector(vEnd);

    float fDX = vEnd.x - vStart.x;
    float fDY = vEnd.y - vStart.y;
    float fDZ = vEnd.z - vStart.z;
    float fHorizontal = sqrt(fDX * fDX + fDY * fDY);
    float fLength = sqrt(fDX * fDX + fDY * fDY + fDZ * fDZ);
    if(fHorizontal <= 0.01f || fLength <= 0.01f)
        return sTrace + "; reason=invalid-surface";

    float fNX = -(fDX * fDZ) / (fHorizontal * fLength);
    float fNY = -(fDY * fDZ) / (fHorizontal * fLength);
    float fNZ = fHorizontal / fLength;
    float fFromDistance = (vFrom.x - vStart.x) * fNX
        + (vFrom.y - vStart.y) * fNY
        + (vFrom.z - vStart.z) * fNZ;
    float fToDistance = (vTo.x - vStart.x) * fNX
        + (vTo.y - vStart.y) * fNY
        + (vTo.z - vStart.z) * fNZ;
    sTrace += "; side=" + MoonPathDebugFloat(fFromDistance) + "/"
        + MoonPathDebugFloat(fToDistance);

    if(!((fFromDistance > MPATH_PLANE_EPSILON
            && fToDistance < -MPATH_PLANE_EPSILON)
        || (fFromDistance < -MPATH_PLANE_EPSILON
            && fToDistance > MPATH_PLANE_EPSILON)))
        return sTrace + "; reason=same-side-or-touch";

    float fT = fFromDistance / (fFromDistance - fToDistance);
    vector vHit = Vector(
        vFrom.x + fT * (vTo.x - vFrom.x),
        vFrom.y + fT * (vTo.y - vFrom.y),
        vFrom.z + fT * (vTo.z - vFrom.z));
    float fUX = fDX / fLength;
    float fUY = fDY / fLength;
    float fUZ = fDZ / fLength;
    float fAlong = (vHit.x - vStart.x) * fUX
        + (vHit.y - vStart.y) * fUY
        + (vHit.z - vStart.z) * fUZ;
    float fPX = -fDY / fHorizontal;
    float fPY = fDX / fHorizontal;
    float fAcross = (vHit.x - vStart.x) * fPX
        + (vHit.y - vStart.y) * fPY;
    float fHalfWidth = GetLocalFloat(oAnchor,
        MPATH_ANCHOR_WIDTH) * 0.5f;
    sTrace += "; hit=" + MoonPathDebugVector(vHit)
        + "; along=" + MoonPathDebugFloat(fAlong) + "/"
        + MoonPathDebugFloat(fLength) + "; across="
        + MoonPathDebugFloat(fAcross) + "/"
        + MoonPathDebugFloat(fHalfWidth);

    if(fAlong < -MPATH_EDGE_EPSILON
        || fAlong > fLength + MPATH_EDGE_EPSILON)
        return sTrace + "; reason=outside-length";
    if(fabs(fAcross) > fHalfWidth + MPATH_EDGE_EPSILON)
        return sTrace + "; reason=outside-width";
    return sTrace + "; reason=crossing";
}

void MoonPathDebugMessage(object oRecipient, string sMessage)
{
    if(!MoonPathDebugIsEnabled())
        return;

    string sFull = "[Moon Path Debug] " + sMessage;
    WriteTimestampedLogEntry(sFull);
    if(GetIsObjectValid(oRecipient) && GetIsPC(oRecipient))
        SendMessageToPC(oRecipient, sFull);
}

void MoonPathDebugEvent(string sKind, object oSource, object oTarget,
    object oAnchor, int bBlocked, int nDetail, string sGeometry = "")
{
    if(!MoonPathDebugIsEnabled())
        return;

    string sState = bBlocked ? "BLOCKED " : "ALLOWED ";
    string sMessage = sState + sKind + ": "
        + MoonPathDebugObjectName(oSource) + " -> "
        + MoonPathDebugObjectName(oTarget);

    object oCaster = OBJECT_INVALID;
    if(GetIsObjectValid(oAnchor))
    {
        oCaster = GetLocalObject(oAnchor, MPATH_ANCHOR_CASTER);
        sMessage += "; path serial "
            + IntToString(GetLocalInt(oAnchor, MPATH_ANCHOR_SERIAL));
    }
    if(nDetail >= 0)
        sMessage += "; detail " + IntToString(nDetail);

    string sFull = "[Moon Path Debug] " + sMessage;
    string sLog = sFull;
    if(sGeometry != "")
        sLog += "; " + sGeometry;
    WriteTimestampedLogEntry(sLog);

    if(GetIsPC(oTarget))
        SendMessageToPC(oTarget, sFull);
    if(GetIsPC(oSource) && oSource != oTarget)
        SendMessageToPC(oSource, sFull);
    if(GetIsPC(oCaster) && oCaster != oTarget && oCaster != oSource)
        SendMessageToPC(oCaster, sFull);
}

void MoonPathConfigureSurfaceAnchor(object oAnchor, object oCaster,
    int nSerial, vector vStart, vector vEnd, float fWidth)
{
    if(!GetIsObjectValid(oAnchor))
        return;

    SetLocalInt(oAnchor, MPATH_ANCHOR_ACTIVE, TRUE);
    SetLocalObject(oAnchor, MPATH_ANCHOR_CASTER, oCaster);
    SetLocalInt(oAnchor, MPATH_ANCHOR_SERIAL, nSerial);
    SetLocalFloat(oAnchor, MPATH_ANCHOR_SX, vStart.x);
    SetLocalFloat(oAnchor, MPATH_ANCHOR_SY, vStart.y);
    SetLocalFloat(oAnchor, MPATH_ANCHOR_SZ, vStart.z);
    SetLocalFloat(oAnchor, MPATH_ANCHOR_EX, vEnd.x);
    SetLocalFloat(oAnchor, MPATH_ANCHOR_EY, vEnd.y);
    SetLocalFloat(oAnchor, MPATH_ANCHOR_EZ, vEnd.z);
    SetLocalFloat(oAnchor, MPATH_ANCHOR_WIDTH, fWidth);
}

int MoonPathSurfaceIsLive(object oAnchor, object oArea)
{
    return GetIsObjectValid(oAnchor)
        && GetLocalInt(oAnchor, MPATH_ANCHOR_ACTIVE)
        && GetArea(oAnchor) == oArea;
}

object MoonPathFirstSurfaceInArea(object oArea)
{
    if(!GetIsObjectValid(oArea))
        return OBJECT_INVALID;

    int nNth = 0;
    object oAnchor = GetObjectByTag(MOONPATH_SURFACE_TAG, nNth);
    while(GetIsObjectValid(oAnchor))
    {
        if(MoonPathSurfaceIsLive(oAnchor, oArea))
            return oAnchor;
        nNth++;
        oAnchor = GetObjectByTag(MOONPATH_SURFACE_TAG, nNth);
    }
    return OBJECT_INVALID;
}

// Returns the fractional distance along vFrom -> vTo at which the segment
// crosses the finite Moon Path rectangle, or -1 when it does not cross.
float MoonPathSegmentIntersectionT(object oAnchor, vector vFrom, vector vTo)
{
    if(!GetIsObjectValid(oAnchor)
        || !GetLocalInt(oAnchor, MPATH_ANCHOR_ACTIVE))
        return -1.0f;

    float fSX = GetLocalFloat(oAnchor, MPATH_ANCHOR_SX);
    float fSY = GetLocalFloat(oAnchor, MPATH_ANCHOR_SY);
    float fSZ = GetLocalFloat(oAnchor, MPATH_ANCHOR_SZ);
    float fEX = GetLocalFloat(oAnchor, MPATH_ANCHOR_EX);
    float fEY = GetLocalFloat(oAnchor, MPATH_ANCHOR_EY);
    float fEZ = GetLocalFloat(oAnchor, MPATH_ANCHOR_EZ);

    float fDX = fEX - fSX;
    float fDY = fEY - fSY;
    float fDZ = fEZ - fSZ;
    float fHorizontalSquared = fDX * fDX + fDY * fDY;
    if(fHorizontalSquared <= 0.0001f)
        return -1.0f;

    float fHorizontal = sqrt(fHorizontalSquared);
    float fLength = sqrt(fHorizontalSquared + fDZ * fDZ);
    if(fLength <= 0.01f)
        return -1.0f;

    // N = normalize(U cross P), where U is the sloped length axis and P is
    // the horizontal width axis perpendicular to the path.
    float fNX = -(fDX * fDZ) / (fHorizontal * fLength);
    float fNY = -(fDY * fDZ) / (fHorizontal * fLength);
    float fNZ = fHorizontal / fLength;

    float fFromDistance = (vFrom.x - fSX) * fNX
        + (vFrom.y - fSY) * fNY
        + (vFrom.z - fSZ) * fNZ;
    float fToDistance = (vTo.x - fSX) * fNX
        + (vTo.y - fSY) * fNY
        + (vTo.z - fSZ) * fNZ;

    // A line along, above, or merely ending on the surface is not a crossing.
    if(!((fFromDistance > MPATH_PLANE_EPSILON
            && fToDistance < -MPATH_PLANE_EPSILON)
        || (fFromDistance < -MPATH_PLANE_EPSILON
            && fToDistance > MPATH_PLANE_EPSILON)))
        return -1.0f;

    float fT = fFromDistance / (fFromDistance - fToDistance);
    vector vHit = Vector(
        vFrom.x + fT * (vTo.x - vFrom.x),
        vFrom.y + fT * (vTo.y - vFrom.y),
        vFrom.z + fT * (vTo.z - vFrom.z));

    float fUX = fDX / fLength;
    float fUY = fDY / fLength;
    float fUZ = fDZ / fLength;
    float fAlong = (vHit.x - fSX) * fUX
        + (vHit.y - fSY) * fUY
        + (vHit.z - fSZ) * fUZ;
    if(fAlong < -MPATH_EDGE_EPSILON
        || fAlong > fLength + MPATH_EDGE_EPSILON)
        return -1.0f;

    float fPX = -fDY / fHorizontal;
    float fPY = fDX / fHorizontal;
    float fAcross = (vHit.x - fSX) * fPX
        + (vHit.y - fSY) * fPY;
    float fHalfWidth = GetLocalFloat(oAnchor,
        MPATH_ANCHOR_WIDTH) * 0.5f;
    if(fabs(fAcross) > fHalfWidth + MPATH_EDGE_EPSILON)
        return -1.0f;

    return fT;
}

object MoonPathFindBlockingSurface(object oArea, vector vFrom, vector vTo)
{
    if(!GetIsObjectValid(oArea))
        return OBJECT_INVALID;

    object oNearest = OBJECT_INVALID;
    float fNearest = 2.0f;
    int nNth = 0;
    object oAnchor = GetObjectByTag(MOONPATH_SURFACE_TAG, nNth);
    while(GetIsObjectValid(oAnchor))
    {
        if(MoonPathSurfaceIsLive(oAnchor, oArea))
        {
            float fT = MoonPathSegmentIntersectionT(oAnchor, vFrom, vTo);
            if(fT >= 0.0f && fT < fNearest)
            {
                fNearest = fT;
                oNearest = oAnchor;
            }
        }
        nNth++;
        oAnchor = GetObjectByTag(MOONPATH_SURFACE_TAG, nNth);
    }
    return oNearest;
}

vector MoonPathObjectPoint(object oObject, float fHeight)
{
    vector vPoint = GetPosition(oObject);
    vPoint.z += fHeight;
    return vPoint;
}

// Weapon attacks and spell/breath damage test both the target torso and the
// lower edge of its occupied volume.  The lower ray lets an inclined force
// surface protect a creature standing on it without widening the finite path.
object MoonPathFindAttackSurface(object oSource, object oTarget)
{
    if(!GetIsObjectValid(oSource) || !GetIsObjectValid(oTarget)
        || GetArea(oSource) != GetArea(oTarget))
        return OBJECT_INVALID;

    object oAnchor = MoonPathFindBlockingSurface(GetArea(oSource),
        MoonPathObjectPoint(oSource, 0.75f),
        MoonPathObjectPoint(oTarget, 0.75f));
    if(GetIsObjectValid(oAnchor))
        return oAnchor;

    return MoonPathFindBlockingSurface(GetArea(oSource),
        MoonPathObjectPoint(oSource, 0.75f),
        MoonPathObjectPoint(oTarget, 0.10f));
}

object MoonPathFindDamageSurface(object oSource, object oTarget)
{
    if(!GetIsObjectValid(oSource) || !GetIsObjectValid(oTarget)
        || GetArea(oSource) != GetArea(oTarget))
        return OBJECT_INVALID;

    object oAnchor = MoonPathFindBlockingSurface(GetArea(oSource),
        MoonPathObjectPoint(oSource, 0.75f),
        MoonPathObjectPoint(oTarget, 0.75f));
    if(GetIsObjectValid(oAnchor))
        return oAnchor;

    // Cone breath and ground-targeted effects can intersect the force surface
    // below the centerline even when the model-center ray does not.
    return MoonPathFindBlockingSurface(GetArea(oSource),
        MoonPathObjectPoint(oSource, 0.75f),
        MoonPathObjectPoint(oTarget, 0.10f));
}

int MoonPathGeometrySelfTest(object oAnchor)
{
    if(!GetIsObjectValid(oAnchor))
        return 0;

    float fSX = GetLocalFloat(oAnchor, MPATH_ANCHOR_SX);
    float fSY = GetLocalFloat(oAnchor, MPATH_ANCHOR_SY);
    float fSZ = GetLocalFloat(oAnchor, MPATH_ANCHOR_SZ);
    float fEX = GetLocalFloat(oAnchor, MPATH_ANCHOR_EX);
    float fEY = GetLocalFloat(oAnchor, MPATH_ANCHOR_EY);
    float fEZ = GetLocalFloat(oAnchor, MPATH_ANCHOR_EZ);
    float fDX = fEX - fSX;
    float fDY = fEY - fSY;
    float fDZ = fEZ - fSZ;
    float fHorizontal = sqrt(fDX * fDX + fDY * fDY);
    float fLength = sqrt(fDX * fDX + fDY * fDY + fDZ * fDZ);
    if(fHorizontal <= 0.01f || fLength <= 0.01f)
        return 0;

    float fNX = -(fDX * fDZ) / (fHorizontal * fLength);
    float fNY = -(fDY * fDZ) / (fHorizontal * fLength);
    float fNZ = fHorizontal / fLength;
    float fPX = -fDY / fHorizontal;
    float fPY = fDX / fHorizontal;
    float fUX = fDX / fLength;
    float fUY = fDY / fLength;
    float fUZ = fDZ / fLength;
    float fMX = (fSX + fEX) * 0.5f;
    float fMY = (fSY + fEY) * 0.5f;
    float fMZ = (fSZ + fEZ) * 0.5f;
    float fNormalOffset = 2.0f;

    vector vAbove = Vector(fMX + fNX * fNormalOffset,
        fMY + fNY * fNormalOffset, fMZ + fNZ * fNormalOffset);
    vector vBelow = Vector(fMX - fNX * fNormalOffset,
        fMY - fNY * fNormalOffset, fMZ - fNZ * fNormalOffset);
    int nPassed = 0;
    if(MoonPathSegmentIntersectionT(oAnchor, vAbove, vBelow) >= 0.0f)
        nPassed++;
    if(MoonPathSegmentIntersectionT(oAnchor, vBelow, vAbove) >= 0.0f)
        nPassed++;

    vector vParallelA = Vector(fMX - fUX + fNX * fNormalOffset,
        fMY - fUY + fNY * fNormalOffset,
        fMZ - fUZ + fNZ * fNormalOffset);
    vector vParallelB = Vector(fMX + fUX + fNX * fNormalOffset,
        fMY + fUY + fNY * fNormalOffset,
        fMZ + fUZ + fNZ * fNormalOffset);
    if(MoonPathSegmentIntersectionT(oAnchor,
        vParallelA, vParallelB) < 0.0f)
        nPassed++;

    float fOutside = GetLocalFloat(oAnchor,
        MPATH_ANCHOR_WIDTH) * 0.5f + 1.0f;
    vector vOutsideA = Vector(fMX + fPX * fOutside + fNX * fNormalOffset,
        fMY + fPY * fOutside + fNY * fNormalOffset,
        fMZ + fNZ * fNormalOffset);
    vector vOutsideB = Vector(fMX + fPX * fOutside - fNX * fNormalOffset,
        fMY + fPY * fOutside - fNY * fNormalOffset,
        fMZ - fNZ * fNormalOffset);
    if(MoonPathSegmentIntersectionT(oAnchor,
        vOutsideA, vOutsideB) < 0.0f)
        nPassed++;

    return nPassed;
}
