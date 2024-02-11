//::///////////////////////////////////////////////
//:: Name      Evil Weather
//:: FileName  sp_evil_wthr.nss
//:://////////////////////////////////////////////
/**@file Evil Weather
Conjuration (Creation) [Evil] 
Level: Corrupt 8
Components: V, S, M, XP, Corrupt (see below)
Casting Time: 1 hour 
Range: Personal
Area: 1-mile/level radius, centered on caster
Duration: 3d6 minutes 
Saving Throw: None 
Spell Resistance: No
 
The caster conjures a type of evil weather. It 
functions as described in Chapter 2 of this book, 
except that area and duration are as given for this
spell. To conjure violet rain, the caster must 
sacrifice 10,000 gp worth of amethysts and spend 
200 XP. Other forms of evil weather have no material
component or experience point cost.

Corruption Cost: 3d6 points of Constitution damage.

Author:    Tenjac
Created:   3/10/2006  

// Rewritten 3/31/07 to address occaisional TMIs
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void RainOfBlood(object oObject, effect eBuff, effect eDebuff, float fDuration);
void VioletRain(object oObject);
void RainOfFrogsOrFish(object oObject);

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

        // Run the spellhook. 
        if (!X2PreSpellCastCode()) return;

        object oPC = OBJECT_SELF;
        object oArea = GetArea(oPC);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nSpell = PRCGetSpellId();
        int nWeather = GetWeather(oArea);
        float fDuration = (d6(3) * 60.0f);

        //Rain of Blood  -1 to attack, damage, saves and checks living, +1 undead
        if (nSpell == SPELL_EVIL_WEATHER_RAIN_OF_BLOOD)
        {
                FloatingTextStringOnCreature("Thick drops of blood pour from the sky.", oPC, TRUE);

                //Fog
                int nOrigSunFog = GetFogColor(FOG_TYPE_SUN,oArea);
                int nOrigMoonFog = GetFogColor(FOG_TYPE_MOON,oArea);
                int nOrigDayFogAmt = GetFogAmount(FOG_TYPE_SUN, oArea);
                int nOrigMoonFogAmt = GetFogAmount(FOG_TYPE_MOON, oArea);
                SetFogColor(FOG_TYPE_ALL, FOG_COLOR_RED, oArea);
                SetFogAmount(FOG_TYPE_ALL,1,oArea);

                //Schedule reset
                DelayCommand(fDuration, SetFogColor(FOG_TYPE_SUN, nOrigSunFog, oArea));
                DelayCommand(fDuration, SetFogColor(FOG_TYPE_MOON, nOrigMoonFog, oArea));
                DelayCommand(fDuration, SetFogAmount(FOG_TYPE_SUN, nOrigDayFogAmt, oArea));
                DelayCommand(fDuration, SetFogAmount(FOG_TYPE_MOON, nOrigMoonFogAmt, oArea));

                //Change to rain
                SetWeather(oArea, WEATHER_RAIN);
                DelayCommand(fDuration, SetWeather(oArea, nWeather));

                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_PER_RAIN_OF_BLOOD), GetLocation(oPC), fDuration);
        }

        //Violet Rain   No divine spells/abilities for 24 hours
        if (nSpell == SPELL_EVIL_WEATHER_VIOLET_RAIN)
        {
                //Notification
                FloatingTextStringOnCreature("Drops of deep violet rain fall, severing the connection to the divine of those in the area.", oPC, TRUE);

                //Fog
                int nOrigSunFog = GetFogColor(FOG_TYPE_SUN,oArea);
                int nOrigMoonFog = GetFogColor(FOG_TYPE_MOON,oArea);
                int nOrigDayFogAmt = GetFogAmount(FOG_TYPE_SUN, oArea);
                int nOrigMoonFogAmt = GetFogAmount(FOG_TYPE_MOON, oArea);
                SetFogColor(FOG_TYPE_ALL, 800080, oArea);
                SetFogAmount(FOG_TYPE_ALL,1,oArea);

                //Schedule reset
                DelayCommand(fDuration, SetFogColor(FOG_TYPE_SUN, nOrigSunFog, oArea));
                DelayCommand(fDuration, SetFogColor(FOG_TYPE_MOON, nOrigMoonFog, oArea));
                DelayCommand(fDuration, SetFogAmount(FOG_TYPE_SUN, nOrigDayFogAmt, oArea));
                DelayCommand(fDuration, SetFogAmount(FOG_TYPE_MOON, nOrigMoonFogAmt, oArea));

                //Change to rain
                SetWeather(oArea, WEATHER_RAIN);
                DelayCommand(fDuration, SetWeather(oArea, nWeather));

                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_PER_VIOLET_RAIN), GetLocation(oPC), fDuration);
        }

        //Green Fog
        if (nSpell == SPELL_EVIL_WEATHER_GREEN_FOG)
        {
                //Duration
                float fDuration = IntToFloat(d6(600));

                //Fog
                int nOrigSunFog = GetFogColor(FOG_TYPE_SUN,oArea);
                int nOrigMoonFog = GetFogColor(FOG_TYPE_MOON,oArea);
                int nOrigDayFogAmt = GetFogAmount(FOG_TYPE_SUN, oArea);
                int nOrigMoonFogAmt = GetFogAmount(FOG_TYPE_MOON, oArea);
                SetFogColor(FOG_TYPE_ALL, FOG_COLOR_GREEN, oArea);
                SetFogAmount(FOG_TYPE_ALL,1,oArea);

                //Schedule reset
                DelayCommand(fDuration, SetFogColor(FOG_TYPE_SUN, nOrigSunFog, oArea));
                DelayCommand(fDuration, SetFogColor(FOG_TYPE_MOON, nOrigMoonFog, oArea));
                DelayCommand(fDuration, SetFogAmount(FOG_TYPE_SUN, nOrigDayFogAmt, oArea));
                DelayCommand(fDuration, SetFogAmount(FOG_TYPE_MOON, nOrigMoonFogAmt, oArea));
                
                //AoE
                effect eFog = EffectAreaOfEffect(VFX_PER_GREEN_FOG);
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFog, GetLocation(oPC), fDuration);
        }

        //Rain of Frogs or Fish
        if (nSpell == SPELL_EVIL_WEATHER_RAIN_OF_FISH)
        {
                //Change to rain
                SetWeather(oArea, WEATHER_RAIN);
                DelayCommand(fDuration, SetWeather(oArea, nWeather));

                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_PER_RAIN_OF_FROGS), GetLocation(oPC), fDuration);
        }

        //SPEvilShift(oPC);
        //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
        AdjustAlignment(oPC, ALIGNMENT_EVIL, 10, FALSE);

        //Corruption cost
        int nCost = d6(3);
        DoCorruptionCost(oPC, ABILITY_CONSTITUTION, nCost, 0);
        PRCSetSchool();
}