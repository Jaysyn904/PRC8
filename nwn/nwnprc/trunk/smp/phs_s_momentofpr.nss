/*:://////////////////////////////////////////////
//:: Spell Name Moment of Prescience
//:: Spell FileName PHS_S_MomentOfPr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Luck 8, Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level or until discharged

    This spell grants you a powerful sixth sense in relation to yourself. In NwN,
    you may choose to add a 25 bonus to the next hostile spell save against an
    enemy (Only one save), or add it to one saving throw you yourself make against
    another caster. Alternativly, you can apply it for a 6 second bonus to your AC
    (Applied in Natural Armor, even when flatfooted). Once used, the spell ends.

    You can’t have more than one moment of prescience active on you at the same
    time.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This applies a visual, well, doesn't actually apply a good one until it
    comes into effect.

    Applies a cessate one here - which notably doesn't stack.

    It is checked for in the spell save DC files - PHS_INC_SAVES, which does
    all the save work.

    It can of course apply 25AC (Which is kinda a waste), but the choice is thiers
    and this uses the menu - no sub dial (for easy GetHasSpellEffect() things).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MOMENT_OF_PRESCIENCE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration 1 hour a level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);
    // For AC increases, it is 12 seconds
    float fAC = RoundsToSeconds(2);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MOMENT_OF_PRESCIENCE_APPLY);
    effect eUse = EffectVisualEffect(PHS_VFX_IMP_MOMENT_OF_PRESCIENCE_USE);
    effect eAC = EffectACIncrease(25, AC_NATURAL_BONUS);
    effect eACLink = EffectLinkEffects(eCessate, eAC);

    // Can only have one on at a time
    if(GetHasSpellEffect(PHS_SPELL_MOMENT_OF_PRESCIENCE, oTarget))
    {
        // Send message
        FloatingTextStringOnCreature("You may only have one Moment of Prescience on you at once", oTarget, FALSE);
        return;
    }

    // Get what to apply
    int nApply = PHS_GetLocalSpellSetting(oCaster, PHS_SPELL_MOMENT_OF_PRESCIENCE);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MOMENT_OF_PRESCIENCE, FALSE);

    // Check nApply
    float fApplyDuration;
    effect eApply;
    if(nApply == 2 || nApply == 1)
    {
        // +25 VS spells
        // OR
        // +25 For next spell save DC
        eApply = eCessate;
        fApplyDuration = fDuration;
    }
    else
    {
        // +25 AC for 2 rounds.
        eApply = eACLink;
        fApplyDuration = fAC;
    }

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eApply, fApplyDuration);
}
