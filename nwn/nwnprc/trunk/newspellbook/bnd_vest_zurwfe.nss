/*
Wall of Force OnEnter barrier enforcement (borrowed from sp_otiluke_rsA.nss DoPush).
Immovable supernatural plane of force: pushes back any creature attempting to walk through the barrier.
*/
#include "prc_inc_spells"

void DoWallForcePush(object oTarget, object oWall)
{
    if (!GetIsObjectValid(oTarget) || !GetIsObjectValid(oWall) || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
        return;

    float fDistance = FeetToMeters(5.0f);
    vector vWall = GetPosition(oWall);
    vector vTargetOrigin = GetPosition(oTarget);
    vector vDelta = vTargetOrigin - vWall;
    if (VectorMagnitude(vDelta) < 0.05f)
        vDelta = AngleToVector(GetFacing(oWall));
    vector vDir = VectorNormalize(vDelta);
    vector vTarget = vTargetOrigin + (vDir * fDistance);

    if (!LineOfSightVector(vTargetOrigin, vTarget))
        vTarget = vTargetOrigin + (vDir * (fDistance * 0.5f));

    location lDest = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(oTarget, JumpToLocation(lDest));
}

void main()
{
    object oWall = GetAreaOfEffectCreator();
    object oEntering = GetEnteringObject();
    if (GetIsObjectValid(oEntering) && GetObjectType(oEntering) == OBJECT_TYPE_CREATURE)
    {
        // Sphere of Annihilation (original or Tkhaluuljin) destroys Wall of Force on contact!
        if (GetResRef(oEntering) == "sp_sphereofud" || GetTag(oEntering) == "TkhalSphereOfAnnihilation")
        {
            object oCaster = GetLocalObject(oWall, "PRC_WALL_CASTER");
            object oRoot = GetLocalObject(oWall, "PRC_WALL_ROOT");
            if (!GetIsObjectValid(oRoot)) oRoot = oWall;
            if (GetIsObjectValid(oCaster) && GetLocalObject(oCaster, "ZurielForceWallObj") == oRoot)
                DeleteLocalObject(oCaster, "ZurielForceWallObj");
            int i;
            for (i = 0; i < 7; i++)
            {
                object oSeg = GetLocalObject(oRoot, "PRC_WALL_SEG_" + IntToString(i));
                if (GetIsObjectValid(oSeg))
                {
                    SetPlotFlag(oSeg, FALSE);
                    DestroyObject(oSeg);
                }
            }
            SetPlotFlag(oRoot, FALSE);
            DestroyObject(oRoot);
            DestroyObject(OBJECT_SELF);
            return;
        }
        DoWallForcePush(oEntering, oWall);
    }
}
