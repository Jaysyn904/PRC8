/*:://////////////////////////////////////////////
//:: Spell Name Dancing Lights
//:: Spell FileName PHS_S_Danclight
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range, 1 minute duration. 4 glowing lights are created, (will-o'-wisps)
    which move around the caster. Wink out if dispelled or go over 20M away
    from the caster.
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

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DANCING_LIGHTS)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();  // Should be OBJECT_SELF.
    location lTarget = GetLocation(oTarget);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sResRef = "phs_dancinglight";
    string PHS_DANCING_LIGHT_SET = "PHS_DANCING_LIGHT_SET";
    int nCnt;
    object oLight;

    // Duration is 1 minute
    float fDuration = PHS_GetDuration(PHS_MINUTES, 1, nMetaMagic);

    // Declare effect for the caster to check for
    effect eDur = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_YELLOW);

    // Check if they have the effects
    if(GetHasSpellEffect(PHS_SPELL_DANCING_LIGHTS, oTarget))
    {
        // Check validness of the lights
        for(nCnt = 1; nCnt <= 4; nCnt++)
        {
            // Check validness of light
            if(GetIsObjectValid(GetLocalObject(oTarget, PHS_DANCING_LIGHT_SET + IntToString(nCnt))))
            {
                // Stop the script if any valid
                return;
            }
        }
    }

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DANCING_LIGHTS, oTarget);

    // Signal Event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DANCING_LIGHTS, FALSE);

    // New eDur effect on you
    PHS_ApplyDuration(oTarget, eDur, fDuration);

    // Create the 4 creatures (and set them in locals)
    for(nCnt = 1; nCnt <= 4; nCnt++)
    {
        // Create the light
        oLight = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget);
        // Set local on target (self)
        SetLocalObject(oTarget, PHS_DANCING_LIGHT_SET + IntToString(nCnt), oLight);
        // Set local on light for caster
        SetLocalObject(oLight, PHS_MASTER, oTarget);
        // Set local for the light number (1 = north, Etc, see "C" script)
        SetLocalInt(oLight, PHS_DANCING_LIGHT_SET, nCnt);
    }
}
