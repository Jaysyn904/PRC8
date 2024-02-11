void main()
{
    object oExit = GetExitingObject();
    if(GetImmortal(oExit))
    {
        if(GetLocalInt(oExit,"IMPLICABLE_FOE_ON"))
        {
            SetImmortal(oExit, FALSE);
            DeleteLocalInt(oExit, "IMPLICABLE_FOE_ON");
        }
    }
}

