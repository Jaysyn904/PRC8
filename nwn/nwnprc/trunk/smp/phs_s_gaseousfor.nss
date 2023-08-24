/*:://////////////////////////////////////////////
//:: Spell Name Gaseous Form
//:: Spell FileName PHS_S_GaseousFor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Air 3, Brd 3, Sor/Wiz 3
    Components: S, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Willing corporeal creature touched
    Duration: 2 min./level (D)
    Saving Throw: None
    Spell Resistance: No

    The subject and all its gear become insubstantial, misty, and translucent.
    Its material armor (including natural armor) becomes worthless, though its
    size, Dexterity, deflection bonuses, and armor bonuses from force effects
    (such as spells) still apply. The subject gains damage reduction 10/+20 and
    becomes immune to poison and critical hits. It can’t attack or cast spells
    while in gaseous form. The subject also loses supernatural abilities while
    in gaseous form. If it has a touch spell ready to use, that spell is
    discharged harmlessly when the gaseous form spell takes effect.

    The creature is subject to the effects of wind, and it can’t enter water or
    other liquid. It also can’t manipulate objects or activate items, even those
    carried along with its gaseous form. Continuously active items remain active,
    though in some cases their effects may be moot.

    Arcane Material Component: A bit of gauze and a wisp of smoke.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Polymorph effect. The hide has 10/+20 DR, Immunity: Poison + critical hits.
    It has a Miss chance of 100% put on it so it always misses, and polymorph
    naturally stops spells.

    Items can't be used in polymorph. The good thing aobut this is the Ghost
    ability - using EffectCutseenGhost(), and you keep all of your normal things.

    Might need to add to the spellhook to stop item useage (any) with this
    applied.

    Oh, subject to Wind Wall too, as it states in the spell.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_GASEOUS_FORM)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration - 2 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 2, nMetaMagic);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect ePolymorph = EffectPolymorph(PHS_POLYMORPH_TYPE_GASEOUS_FORM, TRUE);
    effect eGhost = EffectCutsceneGhost();
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_NORMAL);

    // Link effects
    effect eLink = EffectLinkEffects(ePolymorph, eGhost);
    eLink = EffectLinkEffects(eLink, eMiss);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GASEOUS_FORM, FALSE);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_GASEOUS_FORM, oTarget);

    // Apply new effects
    PHS_ApplyPolymorphDuration(oTarget, eLink, fDuration);
}
