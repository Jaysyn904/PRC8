/*:://////////////////////////////////////////////
//:: Spell Name Owl’s Wisdom, Mass
//:: Spell FileName PHS_S_OwlsWisM
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 6, Drd 6, Sor/Wiz 6
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One ally/level in a 5M.-radius
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes

    The transmuted creatures becomes wiser. The spell grants a +4 enhancement
    bonus to Wisdom, adding the usual benefit to Wisdom-related skills. Clerics,
    druids, paladins, and rangers (and other Wisdom-based spellcasters) who
    receive owl’s wisdom do not gain any additional bonus spells for the
    increased Wisdom, but the save DCs for their spells increase.

    Arcane Material Component: A few feathers, or a pinch of droppings, from
    an owl.
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
    if(!PHS_SpellHookCheck(PHS_SPELL_OWLS_WISDOM_MASS)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt, nFriend;
    // Ability to use
    int nAbility = ABILITY_WISDOM;

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
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_OWLS_WISDOM_MASS, FALSE);

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
