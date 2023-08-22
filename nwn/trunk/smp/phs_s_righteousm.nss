/*:://////////////////////////////////////////////
//:: Spell Name Righteous Might
//:: Spell FileName PHS_S_RighteousM
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 5, Strength 5
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level (D)

    You seem to feel your height grow, and your weight increase. The effects are
    not visible, but you are given several bonuses to your abilities. You gain
    a +4 size bonus to Strength and a +2 size bonus to Constitution. You gain a
    +2 enhancement bonus to your natural armor. You gain damage resistance
    against a particular alignment depending on what energy your channel. If
    you channel positive energy, you gain 3/- physical damage resistance
    against evil. Negative energy provides the same against good, and neutral
    casters will use whatever they normally channel. At 12th level, the damage
    resistance becomes 6/-, and at 15th level it becomes 9/- (the maximum). You
    also have an additional penalty of -4 dodge AC, due to you being more clumsy
    due to feeling much larger then you actually are.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We cannot visually do this.

    Errata - Made so it is +4 STR, +2 Con, +2 AC, and 3/6/9 DR. More balanced.

    We can, however, give the bonuses;
    +4 Strength (stacks!)
    +2 Con (Stacks!)
    +2 AC (Natural)
    -4 AC (Dodge)
    3/-, 6/-, 9/- Damage resistance.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_RIGHTEOUS_MIGHT)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Get duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Get DR amount
    int nDR;
    if(nCasterLevel >= 15)
    {
        nDR = 9;
    }
    else if(nCasterLevel >= 12)
    {
        nDR = 6;
    }
    else
    {
        nDR = 3;
    }

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_RIGHTEOUS_MIGHT);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eStrength = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
    effect eACGood = EffectACIncrease(2, AC_NATURAL_BONUS);
    effect eACBad = EffectACDecrease(4, AC_DODGE_BONUS);
    effect eDR = EffectDamageReduction(nDR, DAMAGE_POWER_PLUS_TWENTY);

    // Damage resistance VS alignment
    if(GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL)
    {
        eDR = VersusAlignmentEffect(eDR, ALIGNMENT_ALL, ALIGNMENT_GOOD);
    }
    else
    {
        eDR = VersusAlignmentEffect(eDR, ALIGNMENT_ALL, ALIGNMENT_EVIL);
    }
    effect eLink = EffectLinkEffects(eCessate, eStrength);
    eLink = EffectLinkEffects(eLink, eCon);
    eLink = EffectLinkEffects(eLink, eACGood);
    eLink = EffectLinkEffects(eLink, eACBad);
    eLink = EffectLinkEffects(eLink, eDR);

    //Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RIGHTEOUS_MIGHT, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
