/*:://////////////////////////////////////////////
//:: Spell Name Remove Fear
//:: Spell FileName PHS_S_RemoveFear
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Remove Fear
    Abjuration
    Level: Brd 1, Clr 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Targets: One allied creature plus one additional creature per four levels within a 5M-radius (15ft) sphere
    Duration: 10 minutes; see text
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    You instill courage in the subject, granting it a +4 morale bonus against
    fear effects for 10 minutes. If the subject is under the influence of a fear
    effect when receiving the spell, that effect is suppressed for the duration
    of the spell.

    Remove fear counters and dispels cause fear.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Note:
    - If we can, I'll get the fear heartbeat to be surpressed if under the influence
    of this, so it doens't need to dispel the fear effect.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_REMOVE_FEAR)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    // Limimt people affected 1, +1 per 4 caster levels.
    int nLimit = 1 + PHS_LimitInteger(nCasterLevel / 4);
    int nDone = 0;

    // Duration = 10 minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, 10, nMetaMagic);

    // Delcare effects
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    // Link effects
    effect eLink = EffectLinkEffects(eSave, eCessate);

    // Loop all targets from the target location - up to 1 + 1 per four levels.
    int nCnt = 1;
    object oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    while(GetIsObjectValid(oTarget) && nDone < nLimit &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= RADIUS_SIZE_LARGE)
    {
        // Check if friendly
        if(GetIsFriend(oTarget, oCaster))
        {
            // Add one to those done
            nDone++;

            // Remove previous castings
            PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_REMOVE_FEAR, oTarget);

            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_REMOVE_FEAR, FALSE);

            // Apply effects
            PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
        }
        nCnt++;
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
}
