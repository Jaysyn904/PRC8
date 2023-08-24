/*:://////////////////////////////////////////////
//:: Spell Name Recovery
//:: Spell FileName XXX_S_Recovery
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 2, Drd 2
    Components: S
    Casting Time: 1 standard action
    Range: Touch
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Fortitude Negates (Harmless)
    Spell Resistance: Yes (Harmless)
    Source: Various (Josh_Kablack)

    The subject recovers immediately from the effects of being Stunned and/or
    Dazed. Even if the subject had been Stunned or Dazed for multiple rounds it
    can now act normally for all of those rounds, and the spells which affected
    them cease to do so (unless a new effect causes it to be stunned again).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Recovery is pretty easy, and in line with those kind of removal spells
    quite good.

    Stomatic component only.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_RECOVERY)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();
    int nType;

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_RECOVERY, FALSE);

    // Apply visual
    SMP_ApplyVFX(oTarget, eVis);

    // We remove all effect of poison, and some other spell effects too.
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        // - Remove all stun and daze
        switch(nType)
        {
            case EFFECT_TYPE_STUNNED:
            case EFFECT_TYPE_DAZED:
            {
                RemoveEffect(oTarget, eCheck);
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
}
