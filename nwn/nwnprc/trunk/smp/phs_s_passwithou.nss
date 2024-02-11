/*:://////////////////////////////////////////////
//:: Spell Name Pass without Trace
//:: Spell FileName PHS_S_Passwithou
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 1, Rgr 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 3.33M
    Targets: One allied creature/level in a 3.33M-radius sphere centred on you
    Duration: 1 hour/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)
    DM Spell: Yes

    This is a DM spell. By default, you cannot naturally track someone. A DM is
    the only way you can get no one to naturally track you, and is up to a DM to
    do the spells effects. This will still apply a visual effect and duration
    visual.

    The subject or subjects can move through any type of terrain and leave
    neither footprints nor scent. Tracking the subjects is impossible by
    nonmagical means.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    DM spell only.

    This applies a duration effect, proper visual (the protection from evil
    small visual for now) and thusly will let a DM know when it goes.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PASS_WITHOUT_TRACE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetLocation(oCaster);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nAllies;

    // Duration - 1 hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Create the VFX's
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);

    // Get all targets in a sphere, 6.67M radius, all creatures, placeables amd doors.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget) && nAllies <= nCasterLevel)
    {
        // Check if allied
        if(GetFactionEqual(oTarget) || GetIsFriend(oTarget))
        {
            // Make sure they are not immune to spells
            if(PHS_TotalSpellImmunity(oTarget))
            {
                // +1 affected
                nAllies++;

                // Fire cast spell at event for the specified target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PASS_WITHOUT_TRACE, FALSE);

                // Remove previous effects
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_PASS_WITHOUT_TRACE, oTarget);

                // Apply the effects
                PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
            }
        }
        // Get next target
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    // Signal the spell cast to DM's.
    PHS_AlertDMsOfSpell("Pass without trace", FALSE, FALSE);
}
