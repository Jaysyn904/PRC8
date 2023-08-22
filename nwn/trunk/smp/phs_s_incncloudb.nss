/*:://////////////////////////////////////////////
//:: Spell Name Incendiary Cloud: On Exit
//:: Spell FileName PHS_S_IncnCloudB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says. No moving fog though!

    Damage is done On Heartbeat, consealment effects (Which do not stack anyway)
    are On Enter, On Exit.

    On Exit:
    Removes consealment.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_INCENDIARY_CLOUD);
}
