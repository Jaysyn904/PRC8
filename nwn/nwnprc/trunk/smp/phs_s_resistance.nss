/*:://////////////////////////////////////////////
//:: Spell Name Resistance
//:: Spell FileName PHS_S_Resistance
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 0, Clr 0, Drd 0, Pal 1, Sor/Wiz 0
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 minute
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    You imbue the subject with magical energy that protects it from harm,
    granting it a +1 resistance bonus on saves.

    Arcane Material Component: A miniature cloak.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Removed permamcy comment for now.

    Not adding permancy until got permamency spell running, if ever.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RESISTANCE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Duration = 1 minute
    float fDuration = PHS_GetDuration(PHS_MINUTES, 1, nMetaMagic);

    // Delcare effects
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    // Link effects
    effect eLink = EffectLinkEffects(eSave, eCessate);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_RESISTANCE, oTarget);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RESISTANCE, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
