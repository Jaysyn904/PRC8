/*:://////////////////////////////////////////////
//:: Spell Name Consecrate: On Enter
//:: Spell FileName PHS_S_ConsecratA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It removes the "alter or thingy to thier god for bonuses" and stuff, 'cause
    it is too complicated otherwise (and utterly pointless in most cases).

    Effects applied OnEnter, and removed OnExit.

    On Enter: Apply:
    - Duration effect always
    - -1 attack, damage, saves if undead too.
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
    effect eDamReduce = EffectDamageDecrease(1, DAMAGE_TYPE_POSITIVE);
    effect eHitReduce = EffectAttackIncrease(1);
    effect eSaveReduce = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink;
    // Link approprate ones
    if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        eLink = EffectLinkEffects(eDamReduce, eHitReduce);
        eLink = EffectLinkEffects(eLink, eSaveReduce);
        eLink = EffectLinkEffects(eLink, eDur);
    }
    else
    {
        eLink = eDur;
    }

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CONSECRATE);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_CONSECRATE);
}
