/*:://////////////////////////////////////////////
//:: Spell Name Magic Circle against Evil - On Exit
//:: Spell FileName PHS_S_MagicCirEB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE placed on the target.

    The On Enter will do pushback and apply effects. It applies it to ALL creatures.

    Only outsiders and summoned creatures will be affected by the pushback.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL);
}
