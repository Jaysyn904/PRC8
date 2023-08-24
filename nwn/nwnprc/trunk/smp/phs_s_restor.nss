/*:://////////////////////////////////////////////
//:: Spell Name Restoration
//:: Spell FileName PHS_S_Restor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 4, Pal 4
    Components: V, S, M
    Casting Time: 3 rounds
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell functions like lesser restoration, except that it also dispels
    negative levels and restores one experience level to a creature who has had
    a level drained. A character who has a level restored by restoration has
    exactly the minimum number of experience points necessary to restore him
    or her to his or her previous level.

    Restoration cures all temporary ability damage. It also eliminates any
    fatigue or exhaustion suffered by the target.

    Restoration does not restore levels lost due to death.

    Material Component: Diamond dust worth 100 gp that is sprinkled over the
    target.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    3 rounds casting time, 100GP diamond dust.

    Removes (no check):
    - Tempoary ability damage only
    - Fatigue and exhaustion
    - 1 level drain (not in yet)
    - All negative levels
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RESTORATION)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // Material component
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_DIAMOND_DUST_100, "Diamond dust worth 100GP", "Restoration")) return;

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Apply VFX
    PHS_ApplyVFX(oTarget, eVis);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RESTORATION, FALSE);

    // Remove fatigue and exhaustion
    PHS_RemoveFatigue(oTarget);

    // We remove all effect of ability decrease, and some other spell effects too.
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
    /*
        Removes (no check):
        - Tempoary ability damage only
        - 1 level drain (not in yet)
        - All negative levels
    */
        switch(GetEffectType(eCheck))
        {
            case EFFECT_TYPE_ABILITY_DECREASE:
            {
                // Must still be magical and temp.
                if(GetEffectSubType(eCheck) == SUBTYPE_MAGICAL &&
                   GetEffectDurationType(eCheck) == DURATION_TYPE_TEMPORARY)
                {
                    RemoveEffect(oTarget, eCheck);
                }
            }
            break;
            break;
            case EFFECT_TYPE_NEGATIVELEVEL:
            {
                RemoveEffect(oTarget, eCheck);
            }
            break;
        }
        eCheck = GetNextEffect(oTarget);
    }
}
