/*:://////////////////////////////////////////////
//:: Spell Name Desecrate: On Enter
//:: Spell FileName PHS_S_DesecrateA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It removes the "alter or thingy to thier god for bonuses" and stuff, 'cause
    it is too complicated otherwise (and utterly pointless in most cases).

    Effects applied OnEnter, and removed OnExit.

    On Enter: Apply:
    - Duration effect always
    - +1 attack, +1 damage, +1 saves if undead too.
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
    effect eDamIncrease = EffectDamageIncrease(1, DAMAGE_TYPE_POSITIVE);
    effect eHitIncrease = EffectAttackIncrease(1);
    effect eSaveIncrease = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink;
    // Link approprate ones
    if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        eLink = EffectLinkEffects(eDamIncrease, eHitIncrease);
        eLink = EffectLinkEffects(eLink, eSaveIncrease);
        eLink = EffectLinkEffects(eLink, eDur);
    }
    else
    {
        eLink = eDur;
    }

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DESECRATE);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_DESECRATE);
}
