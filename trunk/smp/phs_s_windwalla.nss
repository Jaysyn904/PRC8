/*:://////////////////////////////////////////////
//:: Spell Name Wind Wall - On Enter
//:: Spell FileName PHS_S_WindWallA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Apply 80% consealment and miss chance for ranged weapons.

    This won't stack, and is against ranged weapons only.

    Oh, and push back: Small birds, and things affected by strong wind.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
    object oSelf = OBJECT_SELF;

    // Repel small flying creatures
    switch(GetAppearanceType(oTarget))
    {
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_CHICKEN:
        case APPEARANCE_TYPE_PENGUIN:
        case APPEARANCE_TYPE_RAVEN:
        // Could include:
        // - Wyrmling dragons
        // - Quasit + Mephits
        // - Pesudo dragon

        // Note: Also includes here any "Gas" things.
        case PHS_APPEARANCE_TYPE_GASEOUS_FORM:
        case PHS_APPEARANCE_TYPE_WIND_WALK_CLOUD:
        {
            // Move them back from the centre location
            PHS_PerformMoveBack(oSelf, oTarget, GetDistanceToObject(oTarget) + 1.0, GetCommandable(oTarget));
        }
        break;
    }

    //Declare major effects
    effect eConseal = EffectConcealment(80, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMiss = EffectMissChance(80, MISS_CHANCE_TYPE_VS_RANGED);
    effect eLink = EffectLinkEffects(eConseal, eMiss);

    //Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WIND_WALL);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_WIND_WALL);
}
