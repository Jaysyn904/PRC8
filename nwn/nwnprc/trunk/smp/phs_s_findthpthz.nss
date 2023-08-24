/*:://////////////////////////////////////////////
//:: Spell Name Find the Path
//:: Spell FileName phs_s_findthpthZ
//:://////////////////////////////////////////////
    Attacked file(s)

    If attacked, spell cast at, damaged, or pickpocketed, we go.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Destroys ourself.
void Go(string sMessage);

void main()
{
    Go("The spell ended as it was attacked");
}

void Go(string sMessage)
{
    SendMessageToPC(GetMaster(), sMessage);
    // Else, there are no heartbeats left - we go!
    effect eGo = EffectVisualEffect(VFX_IMP_UNSUMMON);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGo, GetLocation(OBJECT_SELF));
    SetPlotFlag(OBJECT_SELF, FALSE);
    SetImmortal(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF);
}
