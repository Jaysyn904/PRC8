/*:://////////////////////////////////////////////
//:: Spell Name Speak with Plants
//:: Spell FileName PHS_S_SpeakPlant
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 4, Drd 3, Rgr 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level

    You can comprehend and communicate with plants, including both normal plants
    and plant creatures. You are able to ask questions of and receive answers
    from plants. A regular plant’s sense of its surroundings is limited, so it
    won’t be able to give (or recognize) detailed descriptions of creatures or
    answer questions about events outside its immediate vicinity.

    The spell doesn’t make plant creatures any more friendly or cooperative than
    normal. Furthermore, wary and cunning plant creatures are likely to be terse
    and evasive, while the more stupid ones may make inane comments. If a plant
    creature is friendly toward you, it may do some favor or service for you.

    Note that not all plants, and maybe even none, may respond.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    See Speak with Animals.

    Similar concept, but of course, placables (usable ones) might be affected
    instead.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SPEAK_WITH_PLANTS)) return;

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
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SPEAK_WITH_PLANTS, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SPEAK_WITH_PLANTS, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eCessate, fDuration);
}
