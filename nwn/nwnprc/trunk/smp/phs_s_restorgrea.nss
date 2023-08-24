/*:://////////////////////////////////////////////
//:: Spell Name Restoration, Greater
//:: Spell FileName PHS_S_RestorGreat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 7
    Components: V, S, XP
    Casting Time: 10 minutes
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell functions like lesser restoration, except that it dispels all
    negative levels afflicting the healed creature. This effect also reverses
    level drains by a force or creature, restoring the creature to the highest
    level it had previously attained.

    Greater restoration also dispels all magical effects penalizing the
    creature’s abilities, cures all temporary ability damage, and restores all
    points permanently drained from all ability scores. It also eliminates
    fatigue and exhaustion, and removes all forms of insanity, confusion, and
    similar mental effects. Greater restoration does not restore levels lost
    due to death.

    XP Cost: 500 XP.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    10 minutes casting time, 500XP cost.

    Removes (no check):
    - All ability damage
    - Fatigue and exhaustion
    - All level drain (not in yet)
    - All negative levels
    - Insanity, all Confusion effects (obviously see PHS_AIL_CONFUSION for that)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RESTORATION_GREATER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // XP cost: 500
    if(PHS_ComponentXPCheck(500, oCaster))
    {
        PHS_ComponentXPRemove(500, oCaster);
    }
    else
    {
        // Cannot do it
        FloatingTextStringOnCreature("*Greater restoration requires 500 XP*", oCaster, FALSE);
        return;
    }

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Apply VFX
    PHS_ApplyVFX(oTarget, eVis);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RESTORATION_GREATER, FALSE);

    // Remove fatigue and exhaustion
    PHS_RemoveFatigue(oTarget);

    // We remove all effect of ability decrease, and some other spell effects too.
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
    /*
        Removes (no check):
        - All ability damage
        - All level drain (not in yet)
        - All negative levels
        - Insanity, all Confusion effects (obviously see PHS_AIL_CONFUSION for that)
    */
        switch(GetEffectType(eCheck))
        {
            case EFFECT_TYPE_ABILITY_DECREASE:
            {
                // Must still be magical
                if(GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
                {
                    RemoveEffect(oTarget, eCheck);
                }
            }
            break;
            case EFFECT_TYPE_NEGATIVELEVEL:
            case EFFECT_TYPE_CONFUSED: // (Even if permanent)
            {
                RemoveEffect(oTarget, eCheck);
            }
            break;
        }
        eCheck = GetNextEffect(oTarget);
    }
}
