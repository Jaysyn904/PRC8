// Portable synchronous line-of-effect gate used by patched PRC spell scripts.
// MP_SP_MODE: 1 = delivery endpoint, 2 = area target, 3 = breath target.
// All request locals belong to the calling bridge and are cleared on return.
#include "moonpath_inc"

void main()
{
    SetLocalInt(OBJECT_SELF, "MP_SP_BLOCK", FALSE);
    if(!MoonPathEnforcementIsEnabled())
        return;

    object oArea = GetLocalObject(OBJECT_SELF, "MP_SP_AREA");
    object oTarget = GetLocalObject(OBJECT_SELF, "MP_SP_TARGET");
    if(!GetIsObjectValid(oArea))
        return;
    if(GetIsObjectValid(oTarget) && GetArea(oTarget) != oArea)
        return;
    if(!GetIsObjectValid(MoonPathFirstSurfaceInArea(oArea)))
        return;

    vector vFrom = Vector(GetLocalFloat(OBJECT_SELF, "MP_SP_X"),
        GetLocalFloat(OBJECT_SELF, "MP_SP_Y"),
        GetLocalFloat(OBJECT_SELF, "MP_SP_Z") + 0.75f);
    vector vTo = Vector(GetLocalFloat(OBJECT_SELF, "MP_SP_TX"),
        GetLocalFloat(OBJECT_SELF, "MP_SP_TY"),
        GetLocalFloat(OBJECT_SELF, "MP_SP_TZ") + 0.75f);
    object oAnchor = MoonPathFindBlockingSurface(oArea, vFrom, vTo);
    if(!GetIsObjectValid(oAnchor) && GetIsObjectValid(oTarget))
    {
        // Match the portable weapon gate's lower occupied-volume ray.
        vTo.z -= 0.65f;
        oAnchor = MoonPathFindBlockingSurface(oArea, vFrom, vTo);
    }
    if(!GetIsObjectValid(oAnchor))
        return;

    SetLocalInt(OBJECT_SELF, "MP_SP_BLOCK", TRUE);
    MoonPathDebugEvent("SPELL gate", OBJECT_SELF, oTarget, oAnchor, TRUE,
        GetLocalInt(OBJECT_SELF, "MP_SP_MODE"),
        MoonPathDebugSurfaceTrace(oAnchor, vFrom, vTo));
}
