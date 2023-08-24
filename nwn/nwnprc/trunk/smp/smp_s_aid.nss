/*:://////////////////////////////////////////////
//:: Spell Name Aid
//:: Spell FileName SMP_S_Aid
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Clr 2, Good 2, Luck 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes (harmless)

    Aid grants the target a +1 morale bonus on attack rolls and saves against
    fear effects, plus temporary hit points equal to 1d8 + caster level (to a
    maximum of 1d8+10 temporary hit points at caster level 10th).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above, but it does not affect dead people.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Check target object.
    object oTarget = GetSpellTargetObject();

    // Invalid (IE construct etc.) races and so on.
    if(!SMP_GetIsAliveCreature(oTarget, "Aid can only be cast on a living creature") ||
        GetIsDead(oTarget)) return;

    // Make sure they are not immune to spells
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    // Get bonus HP
    int nMaxCasterBonus = SMP_LimitInteger(nCasterLevel, 10);
    int nBonusHP = SMP_MaximizeOrEmpower(8, 1, nMetaMagic, nMaxCasterBonus);

    // Get duration in minutes
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eHP = EffectTemporaryHitpoints(nBonusHP);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // Link effects
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eCessate);
    eLink = EffectLinkEffects(eLink, eHP);

    // Remove the aid from previous castings.
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_AID, oTarget);

    // Signal event for the specified creature
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_AID, FALSE);

    //Apply the VFX impact and effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
