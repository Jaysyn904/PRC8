/*:://////////////////////////////////////////////
//:: Spell Name Ray of Exhaustion
//:: Spell FileName PHS_S_RayOfExhau
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 3
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: Fortitude partial; see text
    Spell Resistance: Yes

    A black ray projects from your pointing finger. You must succeed on a ranged
    touch attack with the ray to strike a target.

    The subject is immediately exhausted for the spell’s duration. A successful
    Fortitude save means the creature is only fatigued.

    This spell has no effect on a creature that is already exhausted. Unlike
    normal exhaustion or fatigue, the effect ends as soon as the spell’s duration
    expires.

    Material Component: A drop of sweat.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RAY_OF_EXHAUSTION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Do ray visuals
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_ODD, nTouch);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RAY_OF_EXHAUSTION);

    // Ray Touch attack
    if(PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell Resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // If fortitude, we apply only fatigue
                if(PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
                {
                    PHS_ApplyFatigue(oTarget, FALSE, DURATION_TYPE_TEMPORARY, fDuration);
                }
                else
                {
                    // Else, exhaustion
                    PHS_ApplyFatigue(oTarget, TRUE, DURATION_TYPE_TEMPORARY, fDuration);
                }
            }
        }
    }
}
