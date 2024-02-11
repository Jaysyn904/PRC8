/*:://////////////////////////////////////////////
//:: Spell Name Dancing Lights
//:: Spell FileName sp_Danclight
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
Dancing Lights
Evocation [Light]
Level: Brd 0, Sor/Wiz 0
Components: V, S
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: Up to four lights, all within a 10-ft.-radius area
Duration: 1 minute (D)
Saving Throw: None
Spell Resistance: No

You create up to four glowing spheres of light (which look like will-o’-wisps).
The dancing lights must stay within a 10-foot-radius area in relation to each
other. A light winks out if the distance between you and it
exceeds the spell’s range.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Gone for the wisp version.

    4 wisps, with ghost effect, which stay around the caster if they can,
    each 1.5M from the caster in each direction (each gets a set direction).

    The distance thing easily works as dimension door, and suchlike, could be
    used.

    Oh, and why have tihs instead of the longer duration "light"? well, basically,
    it is a lot more light :-) but only 1 minute's worth (or 2 extended)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "prc_inc_spells"

void DestroyLights(object oTarget)
{
    MyDestroyObject(GetLocalObject(oTarget, "DANCING_LIGHT"));
    MyDestroyObject(GetLocalObject(oTarget, "DANCING_LIGHT_SET1"));
    MyDestroyObject(GetLocalObject(oTarget, "DANCING_LIGHT_SET2"));
    MyDestroyObject(GetLocalObject(oTarget, "DANCING_LIGHT_SET3"));
    MyDestroyObject(GetLocalObject(oTarget, "DANCING_LIGHT_SET4"));
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oLight;
    location lTarget;
    string sResRef;

    int bTargeted = FALSE;
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = TurnsToSeconds(1); // Duration is 1 minute
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    // Declare effect for the caster to check for and the light effect
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
           eLight = EffectLinkEffects(eLight, EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE));
           eLight = EffectLinkEffects(eLight, EffectCutsceneGhost());
           eLight = SupernaturalEffect(eLight);

    if(GetIsObjectValid(oTarget))
        bTargeted = TRUE;
    else
        oTarget = oCaster;

    lTarget = bTargeted ? GetLocation(oTarget) : PRCGetSpellTargetLocation();

    // Remove previous castings
    PRCRemoveEffectsFromSpell(oTarget, SPELL_DANCING_LIGHTS);
    DestroyLights(oTarget);

    // Signal Event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DANCING_LIGHTS, FALSE));

    // New eDur effect on you
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);

    if(bTargeted)
    {
        sResRef = "prc_danclights";
        string DANCING_LIGHT_SET = "DANCING_LIGHT_SET";
        int nCnt;

        // Create the 4 creatures (and set them in locals)
        for(nCnt = 1; nCnt <= 4; nCnt++)
        {
            // Create the light
            oLight = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget);
            // Set local on target (self)
            SetLocalObject(oTarget, DANCING_LIGHT_SET + IntToString(nCnt), oLight);
            // Set local on light for caster
            SetLocalObject(oLight, "Caster", oCaster);
            // Set local on light for target object
            SetLocalObject(oLight, "Target", oTarget);
            // Set local for the light number (1 = north, Etc, see "C" script)
            SetLocalInt(oLight, DANCING_LIGHT_SET, nCnt);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oLight);
            SetPlotFlag(oLight, TRUE);
            // Force first heartbeat
            ExecuteScript("sp_danclightcs", oLight);
        }
    }
    else
    {
        sResRef = "prc_danclighth";
        oLight = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget);
        SetLocalObject(oLight, "Caster", oCaster);
        SetLocalObject(oCaster, "DANCING_LIGHT", oLight);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oLight);
        SetPlotFlag(oLight, TRUE);
        // Force first heartbeat
        ExecuteScript("sp_danclightch", oLight);
        AssignCommand(oLight, ActionRandomWalk());
    }

    PRCSetSchool();
}
