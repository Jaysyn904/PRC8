void main()
{
    object oExit = GetExitingObject();
    if(GetLocalObject(oExit, "CODI_LAST_ALTAR") != OBJECT_INVALID)
    {
        DestroyObject(GetLocalObject(oExit, "LAST_ALTAR"));
        DeleteLocalObject(oExit,"CODI_LAST_ALTAR");
    }
}

