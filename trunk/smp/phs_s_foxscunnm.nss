/*:://////////////////////////////////////////////
//:: Spell Name Fox’s Cunning, MassEag
//:: Spell FileName PHS_S_FoxsCunnM
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 6, Sor/Wiz 6
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature/level, no two of which can be more than 10M. apart
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes

    The transmuted creatures becomes smarter. The spell grants a +4 enhancement
    bonus to Intelligence, adding the usual benefits to Intelligence-based skill
    checks and other uses of the Intelligence modifier. Wizards (and other
    spellcasters who rely on Intelligence) affected by this spell do not gain
    any additional bonus spells for the increased Intelligence, but the save
    DCs for spells they cast while under this spell’s effect do increase. This
    spell doesn’t grant extra skill points.

    Arcane Material Component: A few hairs, or a pinch of dung, from a fox.
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
    if(!PHS_SpellHookCheck(PHS_SPELL_FOXS_CUNNING_MASS)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt, nFriend;
    // Ability to use
    int nAbility = ABILITY_INTELLIGENCE;

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
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FOXS_CUNNING_MASS, FALSE);

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
