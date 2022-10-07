/*:://////////////////////////////////////////////
//:: Spell Name Whispering Wind
//:: Spell FileName PHS_S_WhisperWin
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Air]
    Level: Brd 2, Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: See Text
    Area: 3M-radius
    Duration: Until discharged (destination is reached)
    Saving Throw: None
    Spell Resistance: No

    You send a message or sound on the wind to a designated spot, which you have
    determined beforehand.

    A whispering wind is as gentle and unnoticed as a zephyr until it reaches
    the location. It then delivers its whisper-quiet message or other sound,
    within a normal whisper radius of around 3 meters. Note that the message is
    delivered regardless of whether anyone is present to hear it. The wind then
    dissipates. The wind travels so it may take 1 to 5 minutes to reach its
    destination.

    You can prepare the spell to bear a message of no more than twenty-five
    words, which are set up before you cast the spell, as is the location it
    is sent to.

    When the spell reaches its objective, it swirls and remains in place until
    the message is delivered. As with magic mouth, whispering wind cannot speak
    verbal components, use command words, or activate magical effects.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will:

    - Use preset words and a preset location, set up beforehand.
    - Crate a creature at the location specified, with the local variable of
      what to say, and a time to wait.
    - It will then say it, whisper, with a VFX, and go.

    Simple as that.

    Ok, so its not as good as party-chat, or "Shouting" or even talk between
    players, but it could be used sometimes, I guess.

    Oh, and the time it takes to reach there, yes, it is either too long or
    too short, but is just random - I am not going to program a time selector
    for one spell. It is pointless!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// This is delayed, and will assign oWhisper to whisper sSay, and then go, and
// also apply a vfx to show it arrived.
void DoTheTalkAndGo(object oWhisper, string sSay);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WHISPERING_WIND)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetLocalLocation(oCaster, "PHS_WHISPERING_WIND_TARGET");
    string sText = GetLocalString(oCaster, "PHS_WHISPERING_WIND_TEXT");

    // Check if the location is valid
    if(!GetIsObjectValid(GetAreaFromLocation(lTarget)))
    {
        FloatingTextStringOnCreature("*No location for the wind to head to*", oCaster, FALSE);
        return;
    }
    // Check if no text
    if(sText == "")
    {
        FloatingTextStringOnCreature("*No message for the wind to say*", oCaster, FALSE);
        return;
    }

    // Create the wind at the target location
    object oWind = CreateObject(OBJECT_TYPE_CREATURE, "phs_whisperwind", lTarget);

    // Delay the time to do the task in seconds.
    // 1 minute (60) + 0 to 4 minutes (up to 239 really).
    float fDelay = IntToFloat(Random(240)) + 60;

    // Signal event
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_WHISPERING_WIND, FALSE);

    // Tell caster it worked
    FloatingTextStringOnCreature("*You send the wind off to whisper*", oCaster, FALSE);

    // Delay until it is spoken.
    DelayCommand(fDelay, DoTheTalkAndGo(oWind, sText));
}

// This is delayed, and will assign oWhisper to whisper sSay, and then go, and
// also apply a vfx to show it arrived.
void DoTheTalkAndGo(object oWhisper, string sSay)
{
    // We apply a VFX
    PHS_ApplyVFX(oWhisper, EffectVisualEffect(VFX_IMP_WIND));

    // We assign the whisper to then say the string
    AssignCommand(oWhisper, SpeakString(sSay, TALKVOLUME_WHISPER));

    // We then delay how long until the whisper goes
    DelayCommand(1.0, PHS_CompletelyDestroyObject(oWhisper));
}
