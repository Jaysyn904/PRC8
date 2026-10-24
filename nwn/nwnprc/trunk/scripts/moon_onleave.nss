// Moon controller cleanup before the stock PRC 4.947 client-leave handler.
void main()
{
    object oPC = GetExitingObject();
    if(GetIsObjectValid(oPC) && GetIsPC(oPC))
    {
        SetLocalInt(oPC, "PRC_MOONBLADE_LOGOUT_CLEANUP", TRUE);
        ExecuteScript("sp_moonblade", oPC);
        DeleteLocalInt(oPC, "PRC_MOONBLADE_LOGOUT_CLEANUP");

        SetLocalInt(oPC, "PRC_MOONBEAM_LOGOUT_CLEANUP", TRUE);
        ExecuteScript("sp_moonbeam", oPC);
        DeleteLocalInt(oPC, "PRC_MOONBEAM_LOGOUT_CLEANUP");

        // Mirror the tested Moon handoff: save only after temporary Moon
        // activation feats and the Moon Blade item have been removed.
        if(!GetIsDM(oPC))
            ExportSingleCharacter(oPC);
    }

    ExecuteScript("prc_onleave", OBJECT_SELF);
}
