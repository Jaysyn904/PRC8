/*:://////////////////////////////////////////////
//:: Spell Name Alarm
//:: Spell FileName PHS_S_Alarm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 1, Rgr 1, Sor/Wiz 1
    Components: V, S, F/DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Area: 6.67M.-radius (20-ft.) emanation centered on a point in space
    Duration: 2 hours/level (D)
    Saving Throw: None
    Spell Resistance: No

    Alarm sounds a mental or audible alarm each time a creature of Tiny or
    larger size enters the warded area or touches it. A creature in your party
    does not set off the alarm as they speak the password automatically as they
    come near it. You decide at the time of casting whether the alarm will be
    mental or audible.

    Mental Alarm: A mental alarm alerts you (and only you) so long as you remain
    within the warded area. You note a single mental “ping” that awakens you
    from normal sleep but does not otherwise disturb concentration. A silence
    spell has no effect on a mental alarm.

    Audible Alarm: An audible alarm produces the sound of a hand bell, and
    anyone within hearing distance will hear it. The sound lasts for 1 round.
    Creatures within a silence spell cannot hear the ringing.

    Ethereal or astral creatures do not trigger the alarm.

    Arcane Focus: A tiny bell and a piece of very fine silver wire.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    2 version - audible (gong sounds on AOE) or message (floating text to caster).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellID = GetSpellId();

    // Duration in hours.
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 2, nMetaMagic);

    // Default to noisy
    if(nSpellID == PHS_SPELL_ALARM)
    {
        nSpellID = PHS_SPELL_ALARM_MESSAGE;
    }

    // What script shall the OnEnter be?
    // Starts as the  "PHS_SPELL_ALARM_MESSAGE" one (number 2)
    string sEnterScript = "PHS_S_Alarm2a";
    // But may change to the 1 version...for J_SPELL_ALARM_AUDIBLE.
    if(nSpellID == PHS_SPELL_ALARM_AUDIBLE)
    {
        sEnterScript = "PHS_S_Alarm1a";
    }

    // Create an Area of Effect effect
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_ALARM, sEnterScript);

    // Create an instance of the AOE Object using the Apply Effect function
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
