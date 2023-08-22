/*:://////////////////////////////////////////////
//:: Spell Name Touch of Fatigue
//:: Spell FileName PHS_S_TouchFatig
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Touch  Target: Creature touched Duration: 1 round/level
    Saving Throw: Fortitude negates Spell Resistance: Yes

    You channel negative energy through your touch, fatiguing the target. You must
    succeed on a touch attack to strike a target. The subject is immediately
    fatigued for the spell’s duration.

    This spell has no effect on a creature that is already fatigued. Unlike with
    normal fatigue, the effect ends as soon as the spell’s duration expires.

    Material Component: A drop of sweat.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies the fatigue using the special way.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_TOUCH_OF_FATIGUE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_TOUCH_OF_FATIGUE);

    // Apply VFX (hit or not)
    PHS_ApplyTouchVisual(oTarget, VFX_IMP_REDUCE_ABILITY_SCORE, nTouch);

    // Melee touch attack.
    if(PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE))
    {
        // Must check reaction type for PvP
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check spell resistance and immunities.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply VFX Impact and negative ability effect
                PHS_ApplyFatigue(oTarget, FALSE, DURATION_TYPE_TEMPORARY, fDuration);
            }
        }
    }
}
