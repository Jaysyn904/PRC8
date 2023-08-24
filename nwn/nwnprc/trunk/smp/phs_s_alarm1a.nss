/*:://////////////////////////////////////////////
//:: Spell Name Alarm : Auidible : On Enter
//:: Spell FileName phs_s_alarm1a
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Audible version. If enemy or neutral, signal event.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // AOE check
    if(!PHS_CheckAOECreator()) return;

    //Declare major variables
    int nCnt;
    float fDelay;
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
    // Faction stuff. It doesn't get removed until the duration runs out too.
    if(!GetFactionEqual(oTarget, oCreator))
    {
        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ALARM);
        // Speakstring for AI.
        SpeakString("NW_CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
        // Alarm activated string, which should pop up in clients text's boxes.
        SpeakString("Alarm Bells Sound");
        // 5 lots of bells.
        PlaySound("nw_bells");
        // fDelay starts as 0.0, and immediantly adds 0.2.
        for(nCnt = 1; nCnt < 5; nCnt++)
        {
            fDelay += 0.2;
            DelayCommand(fDelay, PlaySound("nw_bells"));
        }
    }
}
