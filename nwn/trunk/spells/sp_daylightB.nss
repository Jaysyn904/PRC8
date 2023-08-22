///////////////////////////////////////////////////////
// Daylignt On Exit
// sp_daylightB.nss
///////////////////////////////////////////////////////

void main()
{
	object oTarget = GetExitingObject();	
        int nLight = GetLocalInt(oTarget, "PRCInLight");
        nLight--;
        SetLocalInt(oTarget, "PRCInLight", nLight);
}
