/*:://////////////////////////////////////////////
//:: Spell Name Wind Walk
//:: Spell FileName PHS_S_WindWalk
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Air]
    Level: Clr 6, Drd 7
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 3M
    Targets: You one allied creature per three levels in a 3M-radius sphere
    Duration: 1 hour/level (D)
    Saving Throw: No and Will negates (harmless)
    Spell Resistance: No and Yes (harmless)

    You alter the substance of your body to a cloudlike vapor (as the gaseous
    form spell) and so cannot attack, but can move through the air and fly at
    speed. In this sense, it acts similar to a Fly spell and while gaseous, you
    can fly from a point to another point.

    You may also transform other creatures from your party to be clouds with
    you, and act independantly of you, as long as they are within 3 meters at
    the time of casting.

    Wind walkers are not invisible but rather appear misty and translucent, and
    they are 80% likely to be mistaken for clouds, fog, vapors, or the like.

    As noted above, you can dismiss the spell, and you can even dismiss it for
    individual wind walkers and not others.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    To work:

    - Act like Gaseous Form, and cannot use items or anything while as a cloud
        Polymorph effect. The hide has 10/+20 DR, Immunity: Poison + critical hits.
        It has a Miss chance of 100% put on it so it always misses, and polymorph
        naturally stops spells.
    - Therefore is a polymorh, with 100% miss chance, and cutseen ghost on them.
    - Can also use a polymorph spell power, "Fly", to do the flying.

    Affects all allies in 3M of the caster. This is good enough.

    NOTE:
    - Test to see if cancling still keeps the ghost effect or not. If so, we can
      of course workaround it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_WIND_WALK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Count and limits
    int nCount = -1;// We start at -1, and so the caster = +1, so makes 0 when doing party memebers
    int nMaxCreatures = PHS_LimitInteger(nCasterLevel/3);

    // Duration - 1 hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect ePolymorph = EffectPolymorph(PHS_POLYMORPH_TYPE_WIND_WALK);
    effect eGhost = EffectCutsceneGhost();
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_NORMAL);

    // Link effects
    effect eLink = EffectLinkEffects(ePolymorph, eGhost);
    eLink = EffectLinkEffects(eLink, eMiss);

    // Loop nearby creatures.
    oTarget = oCaster;
    while(GetIsObjectValid(oTarget) && nCount < nMaxCreatures)
    {
        // Check alliance
        if(GetFactionEqual(oTarget, oCaster) || oTarget == oCaster)
        {
            // Make sure they are not immune to spells
            if(PHS_TotalSpellImmunity(oTarget))
            {
                // Signal spell cast at event
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WIND_WALK, FALSE);

                // Remove previous castings
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_WIND_WALK, oTarget);

                // Apply new effects
                PHS_ApplyPolymorphDuration(oTarget, eLink, fDuration);
            }
        }
    }


}
