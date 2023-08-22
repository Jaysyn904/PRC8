/*:://////////////////////////////////////////////
//:: Spell Name Control Weather
//:: Spell FileName PHS_S_ControlWea
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Air 7, Clr 7, Drd 7, Sor/Wiz 7
    Components: V, S
    Casting Time: 10 minutes; see text
    Range: The current area
    Area: The current area; see text
    Duration: 4d12 hours; see text
    Saving Throw: None
    Spell Resistance: No

    You change the weather in the local area. It takes 10 minutes to cast
    the spell and then the effects manifest. You can call forth various weather,
    including changing it to Snow, Rain, or making the weather clear.

    Apart from the few spells that rely upon cirtain weather conditions, this
    spell provides purely visual effects.

    A druid casting this spell doubles the duration.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Not sure about the "10 minutes later" stuff...that is around 5 hours
    at 2 minutes/hour! :-)

    Maybe change it - it is, of course, purely cosmetic!

    Subdials:
    Rain
    Snow
    Clear
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Put in nCastTimes to stop the change back in weather if this is cast
// again. Note that it just resets to area settings.
void SetWeatherBack(object oArea, int nCastTimes);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CONTROL_WEATHER)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oArea = GetArea(oCaster);
    int nWeather = GetWeather(oArea);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCastTimes;

    // Doesn't work belowground...
    if(!GetIsAreaAboveGround(oArea))
    {
        SendMessageToPC(oCaster, "You cannot cast Control Weather underground.");
        return;
    }
    // ...or indoors.
    if(GetIsAreaInterior(oArea))
    {
        SendMessageToPC(oCaster, "You cannot cast Control Weather inside.");
        return;
    }
    // ...or with invalid weather (turned off?)
    if(nWeather == WEATHER_INVALID)
    {
        SendMessageToPC(oCaster, "You cannot cast Control Weather here.");
        return;
    }

    // Duration - 4d12 hours
    float fDuration = PHS_GetRandomDuration(PHS_HOURS, 12, 4, nMetaMagic);

    // Double duration for druids
    if(GetLastSpellCastClass() == CLASS_TYPE_DRUID)
    {
        fDuration *= 2;
    }

    // Rain, snow or clear?
    switch(GetSpellId())
    {
        case PHS_SPELL_CONTROL_WEATHER_RAIN:
        {
            // Change to rain
            if(nWeather == WEATHER_RAIN)
            {
                SendMessageToPC(oCaster, "It is already raining, Control Weather has no effect.");
                return;
            }
            else
            {
                // Add one to the times it has been cast on this area
                nCastTimes = PHS_IncreaseStoredInteger(oArea, "PHS_CONTROL_WEATHER_CAST_TIMES");
                // Set and delay the changing back
                SetWeather(oArea, WEATHER_RAIN);
                DelayCommand(fDuration, SetWeatherBack(oArea, nCastTimes));
            }
        }
        break;
        case PHS_SPELL_CONTROL_WEATHER_SNOW:
        {
            // Change to snow
            if(nWeather == WEATHER_SNOW)
            {
                SendMessageToPC(oCaster, "It is already raining, Control Weather has no effect.");
                return;
            }
            else
            {
                // Add one to the times it has been cast on this area
                nCastTimes = PHS_IncreaseStoredInteger(oArea, "PHS_CONTROL_WEATHER_CAST_TIMES");
                // Set and delay the changing back
                SetWeather(oArea, WEATHER_SNOW);
                DelayCommand(fDuration, SetWeatherBack(oArea, nCastTimes));
            }
        }
        break;
        // All other (Clear/Non-subdial)
        default:
        //case PHS_SPELL_CONTROL_WEATHER_CLEAR:
        {
            // Change to clear
            if(nWeather == WEATHER_CLEAR)
            {
                SendMessageToPC(oCaster, "It is already raining, Control Weather has no effect.");
                return;
            }
            else
            {
                // Add one to the times it has been cast on this area
                nCastTimes = PHS_IncreaseStoredInteger(oArea, "PHS_CONTROL_WEATHER_CAST_TIMES");
                // Set and delay the changing back
                SetWeather(oArea, WEATHER_CLEAR);
                DelayCommand(fDuration, SetWeatherBack(oArea, nCastTimes));
            }
        }
        break;
    }
}

// Put in nCastTimes to stop the change back in weather if this is cast
// again. Note that it just resets to area settings.
void SetWeatherBack(object oArea, int nCastTimes)
{
    // Check nCastTimes
    if(GetLocalInt(oArea, "PHS_CONTROL_WEATHER_CAST_TIMES") == nCastTimes)
    {
        // Reset the weather
        SetWeather(oArea, WEATHER_USE_AREA_SETTINGS);
    }
}
