/*:://////////////////////////////////////////////
//:: Spell Name Detect Poison
//:: Spell FileName PHS_S_DetectPois
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Close (8M) Target: One creature touched

    You determine whether a creature, has been poisoned or is poisonous (can
    inflict poison). You can determine the exact type of poison, if magical,
    with a DC 20 Wisdom check. Natural poisons cannot be identified.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Detects poisons by checking effects.

    The type?

    Not sure how to add that actually, as unless it is from a spell file, it
    cannot be specifically got :-(
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DETECT_POISON)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eCheck;
    // If iPoisonId is 0, no poison. If -1, natural, if anything else, spell applied.
    int nPoisonId;

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DETECT_POISON, FALSE);

    // Apply effects
    PHS_ApplyVFX(oTarget, eVis);

    // Check effects
    eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Get if poison. We can only have 1 at once.
        if(GetEffectType(eCheck) == EFFECT_TYPE_POISON)
        {
            // Check if we know the spell ID
            nPoisonId = GetEffectSpellId(eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
    // If there is poison, check if we know or can know where it is from.
    if(nPoisonId == -1)
    {
        SendMessageToPC(oCaster, "The target is affected with a natural poison.");
    }
    else if(nPoisonId == 0)
    {
        SendMessageToPC(oCaster, "The target is not affected with any poison.");
    }
    else
    {
        if(PHS_AbilityCheck(oCaster, ABILITY_WISDOM, 20))
        {
            SendMessageToPC(oCaster, "The target is not affected with poison from the spell " + PHS_ArrayGetSpellName(nPoisonId));
        }
        else
        {
            SendMessageToPC(oCaster, "The target is affected with some kind of magically-applied poison.");
        }
    }
}
