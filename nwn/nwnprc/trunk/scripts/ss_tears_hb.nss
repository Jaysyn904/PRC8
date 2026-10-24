// Native creature heartbeat for Silverstar's four will-o'-wisp lights.
void main()
{
    object oWisp = OBJECT_SELF;
    object oCaster = GetLocalObject(oWisp, "SS_TearsCaster");
    int bLight = FALSE;
    effect eLoop = GetFirstEffect(oWisp);
    while (GetIsEffectValid(eLoop))
    {
        if (GetEffectTag(eLoop) == "Silverstar_Tears") bLight = TRUE;
        eLoop = GetNextEffect(oWisp);
    }
    if (!bLight || !GetIsObjectValid(oCaster) || GetIsDead(oCaster)
    || GetArea(oCaster) != GetArea(oWisp)
    || GetLocalInt(oWisp, "SS_TearsSerial") != GetLocalInt(oCaster, "SS_TearsSerial")
    || GetDistanceToObject(oCaster) > GetLocalFloat(oWisp, "SS_TearsRange"))
    {
        SetPlotFlag(oWisp, FALSE);
        DestroyObject(oWisp);
        return;
    }

    location lCenter = GetLocalLocation(oWisp, "SS_TearsCenter");
    object oTarget = GetLocalObject(oWisp, "SS_TearsTarget");
    if (GetIsObjectValid(oTarget))
    {
        if (GetArea(oTarget) != GetArea(oWisp))
        {
            SetPlotFlag(oWisp, FALSE);
            DestroyObject(oWisp);
            return;
        }
        lCenter = GetLocation(oTarget);
    }

    vector vCenter = GetPositionFromLocation(lCenter);
    int n = GetLocalInt(oWisp, "SS_TearsIndex");
    if (n == 1) vCenter.x += 1.5;
    else if (n == 2) vCenter.x -= 1.5;
    else if (n == 3) vCenter.y += 1.5;
    else vCenter.y -= 1.5;
    ClearAllActions();
    ActionMoveToLocation(Location(GetArea(oWisp), vCenter, 0.0), TRUE);
}
