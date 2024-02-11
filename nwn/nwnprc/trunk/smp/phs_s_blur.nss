/*:://////////////////////////////////////////////
//:: Spell Name Blur
//:: Spell FileName PHS_S_Blur
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Blur
    Illusion (Glamer)
    Level: Brd 2,Sor/Wiz 2
    Components: V
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject’s outline appears blurred, shifting and wavering. This distortion
    grants the subject concealment (20% consealment).

    A see invisibility spell does not counteract the blur effect, but a true seeing spell does.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Note: There is NO way I think to make trueseeing disable this, UNLESS it
    is in-built already!

    It just provides 20% concealment. It is impossible to adjust melee
    attackers who can only hear the target, or blind people, to ignore it, unless
    it is built in (it might be already in)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Determine duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effefcts and link
    effect eDur = EffectVisualEffect(VFX_DUR_BLUR);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // The invisibility concealment of 20%
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eConceal);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_BLUR, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BLUR, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
