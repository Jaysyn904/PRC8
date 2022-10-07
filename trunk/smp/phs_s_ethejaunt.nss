/*:://////////////////////////////////////////////
//:: Spell Name Ethereal Jaunt
//:: Spell FileName PHS_S_EtheJaunt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 7, Sor/Wiz 7
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes (Harmless)

    You become ethereal, along with your equipment. For the duration of the
    spell, you are in a place called the Ethereal Plane, which overlaps the
    normal, physical, Material Plane. When the spell expires, or you decide to
    cancle it by attacking or casting any spell, you return to material existence.

    An ethereal creature is invisible, insubstantial and can move through solid
    creatures, and only magcal force and abjurations will an ethereal creature.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    One-person (self) EffectEthereal().

    Also has EffectCutseenGhost and immunity to some damage types. Of course,
    when a spell is cast (any spell - its simpler that way) or attacks are
    made, it cancles the ethrealness.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ETHEREAL_JAUNT)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Determine duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effefcts and link
    effect eDur = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    effect eEthereal = EffectEthereal();
    effect eGhost = EffectCutsceneGhost();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eEthereal);
    eLink = EffectLinkEffects(eLink, eGhost);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ETHEREAL_JAUNT, oTarget);

    //Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ETHEREAL_JAUNT, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
