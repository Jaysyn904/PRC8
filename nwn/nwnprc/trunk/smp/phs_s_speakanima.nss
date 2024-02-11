/*:://////////////////////////////////////////////
//:: Spell Name Speak with Animals
//:: Spell FileName PHS_S_SpeakAnima
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 3, Drd 1, Rgr 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level

    You can comprehend and communicate with animals. You are able to ask
    questions of and receive answers from animals, although the spell doesn’t
    make them any more friendly or cooperative than normal. Furthermore, wary
    and cunning animals are likely to be terse and evasive, while the more
    stupid ones make inane comments. If an animal is friendly toward you, it
    may do some favor or service for you.

    Note that not all animals, and maybe even none, may respond.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Note:

    - This is run via. actually having a conversation script in an animals
      slot. And then checking for this spell (in a seperate file, not crated
      yet) for this spell's effects. If they have them, they talk (as above
      states) but if not, it won't fire any other nodes (or will mearly go
      "Baaa" or something).

    The script must be incorporated into every node, incase the spell
    duration runs out while it is being talked too. If not, then expect them
    to only need one casting for a long duration conversation if the animal
    is intelligent, or even just stupid.

    Thusly, this just applies some visuals :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SPEAK_WITH_ANIMALS)) return;

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
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SPEAK_WITH_ANIMALS, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SPEAK_WITH_ANIMALS, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eCessate, fDuration);
}
