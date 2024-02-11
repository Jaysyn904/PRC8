//::///////////////////////////////////////////////
// Tests:
// - Paralysis: Non-commandable is TRUE, so cannot even use Verbal spells (urg)
// - EffectCutsceneImmobilize() - Commandable, but cannot move at all, can cast.
// - EffectCutsceneParalyze() - Bypasses normal palarysis immunities. No icon. Not commandable.
//         - reports :"you cannot speak, cannot cast spells with verbal components" - a boo boo
// -

// ActionMoveXXX will not work in Entangle, Paralsis, Immobilize, and therefore
// pushback (which is logical in entanglements case) will not work.


void Send(string sMessage, object oTarget);
void Report(object oTarget);

void main()
{
    // Effect
    effect eApply = EffectDispelMagicAll(10);

    // Get target
    object oTarget = GetSpellTargetObject();

    // Message
    Send("EffectDispelMagicAll(10)", oTarget);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApply, oTarget, 30.0);

    // Delay a report
    DelayCommand(10.0, Report(oTarget));
}

void Send(string sMessage, object oTarget)
{
    if(oTarget != OBJECT_SELF) SendMessageToPC(OBJECT_SELF, sMessage);
    SendMessageToPC(oTarget, sMessage);
}

void Report(object oTarget)
{
    int bCommandable = GetCommandable(oTarget);
    int bPlot = GetPlotFlag(oTarget);
    int bDead = GetIsDead(oTarget);

    string sMessage = "STATUS: " + GetName(oTarget) + "| COM: " + IntToString(bCommandable) + "| PLOT: " + IntToString(bPlot) + "| DEAD: " + IntToString(bDead) + "|";

    SendMessageToPC(oTarget, sMessage);

    if(oTarget != OBJECT_SELF)
    {
        SendMessageToPC(OBJECT_SELF, sMessage);
    }
}
