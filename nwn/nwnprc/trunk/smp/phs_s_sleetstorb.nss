/*:://////////////////////////////////////////////
//:: Spell Name Sleet Storm: On Exit
//:: Spell FileName PHS_S_SleetStorB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I'll use Darkness style Invisibility + Darkness effect.

    No EffectUltravision() will be used in spells.

    The save is static, it was a DC10 Balance check, a DC10 reflex save is
    plenty large - still has a 1 in 20 chance of falling.

    13.33M is large! huge even! and it needs to be a good effect, it must
    really snow hard!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_SLEET_STORM);
}
