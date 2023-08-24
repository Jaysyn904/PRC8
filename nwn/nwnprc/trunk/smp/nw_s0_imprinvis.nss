/*:://////////////////////////////////////////////
//:: Spell Name Invisibility, Greater
//:: Spell FileName PHS_S_InvisGreat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Glamer)
    Level: Brd 4, Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal or touch
    Target: You or creature touched
    Duration: 1 round/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell functions like invisibility, except that it doesn’t end if the
    subject attacks.

    Arcane Material Component: An eyelash encased in a bit of gum arabic.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Only difference to invisiblity is the 1 round/level, and that we
    are attempting to use the

    INVISIBILITY_TYPE_IMPROVED

    Constant to see if it won't get removed when they attack.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_INVISIBILITY_GREATER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Determine duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eInvisibility = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eInvisibility, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_INVISIBILITY_GREATER, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INVISIBILITY_GREATER, FALSE);

    // Report effects
    PHS_DebugReportEffects(oTarget);

    // Apply VNF and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);

    // Report effects
    PHS_DebugReportEffects(oTarget);
}
