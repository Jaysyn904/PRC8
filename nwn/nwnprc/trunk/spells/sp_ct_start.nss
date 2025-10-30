int StartingConditional()
{
    object oPC = GetPCSpeaker();

    // Get the target's name and set it as the approrpriate custom item.
    SetCustomToken(161838401, GetName(GetLocalObject(oPC, "SP_CREATETATOO_TARGET")));

    // Get the caster level and calculate SR from that and set it as the
    // appropriate conversation custom item.
    int nCasterLevel = GetLocalInt(oPC, "SP_CREATETATOO_LEVEL");
    int nSR = 10 + (nCasterLevel / 6);
    string s = IntToString(nSR);
    SetCustomToken(161838402, s);

    return TRUE;
}
