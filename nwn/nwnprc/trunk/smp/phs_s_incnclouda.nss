/*:://////////////////////////////////////////////
//:: Spell Name Incendiary Cloud: On Enter
//:: Spell FileName PHS_S_IncnCloudA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says. No moving fog though!

    Damage is done On Heartbeat, consealment effects (Which do not stack anyway)
    are On Enter, On Exit.

    On Enter:
    Applies consealment.
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

    //Declare major effects
    effect eConseal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConseal2 = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);

    // Link
    effect eLink = EffectLinkEffects(eConseal, eConseal2);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INCENDIARY_CLOUD);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_INCENDIARY_CLOUD);
}
