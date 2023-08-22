/*:://////////////////////////////////////////////
//:: Spell Name See Invisibility
//:: Spell FileName PHS_S_SeeInvisib
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 3, Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level (D)

    You can see any objects or beings that are invisible within your range of
    vision, as if they were normally visible. The spell does not reveal the
    method used to obtain invisibility. It does not reveal illusions or enable
    you to see through opaque objects. It does not reveal creatures who are
    simply hiding, concealed, or otherwise hard to see.

    Material Component: A pinch of talc and a small sprinkling of powdered silver.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses EffectSeeInvisible(), which is simple and only counters EffectInvisibility()
    which is a real shame, but still useful.

    Note: Originally, the spell also countered Etherealness.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SEE_INVISIBILITY)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    effect eSee = EffectSeeInvisible();
    effect eDur = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eSee, eCessate);
    eLink = EffectLinkEffects(eLink, eDur);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SEE_INVISIBILITY, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SEE_INVISIBILITY, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
