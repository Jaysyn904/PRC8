// Silverstar: Tears of Selune permits torches/wisps only. Generic PRC
// Dancing Lights uses a humanoid light when cast at a ground location.
#include "prc_ss_inc"

void main()
{
    object oPC = OBJECT_SELF;

    if (SSGetClassLevel(oPC) < 4
    || !GetHasFeat(SS_FEAT_TEARS, oPC) || GetIsDead(oPC)) return;

    SetLocalInt(oPC, "SpellIsSLA", TRUE);
    int bAllowed = X2PreSpellCastCode();
    DeleteLocalInt(oPC, "SpellIsSLA");
    if (!bAllowed) return;

    object oTarget = PRCGetSpellTargetObject();
    location lCenter = PRCGetSpellTargetLocation();
    if (GetIsObjectValid(oTarget)) lCenter = GetLocation(oTarget);
    if (GetAreaFromLocation(lCenter) != GetArea(oPC)) return;

    int nSerial = GetLocalInt(oPC, "SS_TearsSerial") + 1;
    SetLocalInt(oPC, "SS_TearsSerial", nSerial);
    float fRange = 30.48 + 3.048 * IntToFloat(SSGetDivineCasterLevel(oPC));

    int n;
    for (n = 1; n <= 4; n++)
    {
        string sKey = "SS_TearsWisp" + IntToString(n);
        object oPrevious = GetLocalObject(oPC, sKey);
        if (GetIsObjectValid(oPrevious))
        {
            SetPlotFlag(oPrevious, FALSE);
            DestroyObject(oPrevious);
        }

        object oWisp = CreateObject(OBJECT_TYPE_CREATURE, "prc_danclights", lCenter);
        if (GetIsObjectValid(oWisp))
        {
            // Native EE events avoid the generic controller's spell-ID
            // checks. Both game server and single-player use this path.
            SetEventScript(oWisp, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "");
            SetEventScript(oWisp, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "ss_tears_hb");
            SetLocalObject(oPC, sKey, oWisp);
            SetLocalObject(oWisp, "SS_TearsCaster", oPC);
            SetLocalObject(oWisp, "SS_TearsTarget", oTarget);
            SetLocalLocation(oWisp, "SS_TearsCenter", lCenter);
            SetLocalInt(oWisp, "SS_TearsSerial", nSerial);
            SetLocalInt(oWisp, "SS_TearsIndex", n);
            SetLocalFloat(oWisp, "SS_TearsRange", fRange);
            SetPlotFlag(oWisp, TRUE);

            effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
            eLight = EffectLinkEffects(eLight,
                         EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE));
            eLight = EffectLinkEffects(eLight, EffectCutsceneGhost());
            eLight = TagEffect(eLight, "Silverstar_Tears");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLight, oWisp, 60.0);
            ExecuteScript("ss_tears_hb", oWisp);
            DelayCommand(60.0, SetPlotFlag(oWisp, FALSE));
            DelayCommand(60.0, DestroyObject(oWisp));
        }
    }
}
