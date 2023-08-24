/*:://////////////////////////////////////////////
//:: Spell Name Stone Tell
//:: Spell FileName PHS_S_StoneTell
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Drd 6
    Components: V, S, DF
    Casting Time: 10 minutes
    Range: Personal
    Target: You
    Duration: 1 min./level

    You gain the ability to speak with stones, which relate to you who or what
    has touched them as well as revealing what is covered or concealed behind
    or under them. The stones relate complete descriptions if asked. A stone’s
    perspective, perception, and knowledge may prevent the stone from providing
    the details you are looking for.

    You can speak with natural or worked stone. Note that not all stone, and
    maybe even none, may respond.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    See Speak with Animals.

    Similar concept, but of course, placables (usable ones) might be affected
    instead.

    Also see: Speak with Plants.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_STONE_TELL)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // 1 Min/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_STONE_TELL, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STONE_TELL, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eCessate, fDuration);
}
