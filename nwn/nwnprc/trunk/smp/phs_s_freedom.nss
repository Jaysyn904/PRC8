/*:://////////////////////////////////////////////
//:: Spell Name Freedom
//:: Spell FileName PHS_S_Freedom
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    8M range, 1 creature.
    The subject is freed from spells and effects that restrict its movement,
    including binding, entangle, imprisonment, maze, paralysis, petrification,
    sleep, slow, stunning, temporal stasis, and web. To free a creature from
    imprisonment or maze, you must not be hostile to the creature, and you must
    cast this spell at the spot where it was entombed or banished into the maze.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It will target either a placeable for Maze and Imprisonment, or a target
    for the removal of effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FREEDOM)) return;

    // Declare Major Variables
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    effect eCheck;
    object oMazePrisonPerson;
    location lTarget;

    // We check if it was a Object, or a Placeable
    if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
    {
        // It MAY be a maze or freedom location.
        oMazePrisonPerson = GetLocalObject(oTarget, PHS_MAZEPRISON_OBJECT);
        if(GetIsObjectValid(oMazePrisonPerson))
        {
            if(PHS_IsInMazeArea(oMazePrisonPerson))
            {
                // Jump the person back
                ExecuteScript("phs_s_mazed", oMazePrisonPerson);
            }
            else if(PHS_IsInPrisonArea(oMazePrisonPerson))
            {
                // Remove Imprisonment
                ExecuteScript("phs_s_mazed", oMazePrisonPerson);
            }
            else
            {
                // No valid maze area, delete the maze object.
                PHS_PermamentlyRemove(oTarget);
            }
        }
        else
        {
            // No valid target, delete the maze object.
            PHS_PermamentlyRemove(oTarget);
        }
    }
    else
    {
        // It is a Creature (Defined in spells.2da as can only be a placeable or creature)

        // Removes:
        // Binding, entangle, paralysis, petrification,
        // sleep, slow, stunning, temporal stasis, and web (entangle).

        // Remove all other effects
        eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            // Remove magical ones of the types listed above.
            if(GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
            {
                // Check spells
                // - Remove custom Slow
                switch(GetEffectSpellId(eCheck))
                {
                    case PHS_SPELL_SLOW:
                    //case PHS_SPELL_TEMPORAL_STASIS:
                        // Remove the effect
                        RemoveEffect(oTarget, eCheck);
                    break;
                    // Other effects
                    default:
                    {
                        switch(GetEffectType(eCheck))
                        {
                            case EFFECT_TYPE_ENTANGLE:
                            case EFFECT_TYPE_PARALYZE:
                            case EFFECT_TYPE_PETRIFY:
                            case EFFECT_TYPE_SLEEP:
                            case EFFECT_TYPE_SLOW:
                            case EFFECT_TYPE_MOVEMENT_SPEED_DECREASE:
                            case EFFECT_TYPE_STUNNED:
                                // Remove the effect
                                RemoveEffect(oTarget, eCheck);
                            break;
                        }
                    }
                    break;
                }
            }
            //Get next effect on the target
            eCheck = GetNextEffect(oTarget);
        }
    }
}
