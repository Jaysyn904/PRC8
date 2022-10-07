/*:://////////////////////////////////////////////
//:: Spell Name Bear’s Endurance, Mass
//:: Spell FileName PHS_S_BearsEndM
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 6, Drd 6, Sor/Wiz 6
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Close (10M)
    Target: One creature/level, in a 6.67M radius.
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes

    The subjects in the area gains greater vitality and stamina. The spell
    grants the subjects a +4 enhancement bonus to Constitution, which adds the
    usual benefits to hit points, Fortitude saves, Constitution checks, and so
    forth.

    Hit points gained by a temporary increase in Constitution score are not
    temporary hit points. They go away when the subject’s Constitution drops
    back to normal. They are not lost first as temporary hit points are.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    +4 In the stat, Doesn't stack with normal, and can affect up to 1 target/
    level. Friends only targeted.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt, nFriend;
    // Ability to use
    int nAbility = ABILITY_CONSTITUTION;

    // Duration - 1 minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare Effects
    effect eAbility = EffectAbilityIncrease(nAbility, 4);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAbility, eCessate);

    // Loop all allies in a huge sphere
    nCnt = 1;
    oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    // 1 target/level, nearest to location within a 5.0M radius
    while(GetIsObjectValid(oTarget) && nFriend < nCasterLevel &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= 5.0)
    {
        // Friendly check
        if(oTarget == OBJECT_SELF ||
           GetIsFriend(oTarget) ||
           GetFactionEqual(oTarget))
        {
            // Make sure they are not immune to spells
            if(!PHS_TotalSpellImmunity(oTarget))
            {
                // Check if oTarget has better effects already
                if(PHS_GetHasAbilityBonusOfPower(oTarget, nAbility, 4) != 2)
                {
                    // Add one to counter
                    nFriend++;

                    // Signal the spell cast at event
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BEARS_ENDURANCE_MASS, FALSE);

                    // Remove these abilities effects
                    PHS_RemoveAnyAbilityBonuses(oTarget, nAbility);

                    //Apply effects and VFX to target
                    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
        // Get next target
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
}
