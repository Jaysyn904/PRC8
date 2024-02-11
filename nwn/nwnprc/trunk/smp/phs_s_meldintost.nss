/*:://////////////////////////////////////////////
//:: Spell Name Meld into Stone
//:: Spell FileName PHS_S_MeldintoSt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Earth]
    Level: Clr 3, Drd 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level

    Meld into stone enables you to meld your body and possessions into a single
    block of stone that you create.

    You remain aware of the passage of time and can cast spells on yourself
    while hiding in the stone. Nothing that goes on outside the stone can be
    seen, but you can still hear what happens around you. Minor physical damage
    to the stone does not harm you (you gain 8/+1 damage resistance against
    pysical damage). If you get hit enough within the stone then it will
    collapse. You can take up to 8 damage per caster level, maximum of 80 at
    level 10.

    Any time before the duration expires, you can step out of the stone and the
    spell will dispissitate as when it is completely destroyed or dispelled.

    The following spells harm you if cast upon the stone that you are occupying:
    Stone to flesh expels you and deals you 5d6 points of damage. Stone shape
    deals you 3d6 points of damage but does not expel you. Transmute rock to mud
    expels you and then slays you instantly unless you make a DC 18 Fortitude
    save, in which case you are merely expelled. Finally, passwall expels you
    without damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This spell will:

    - Apply blindness.
    - Not allow spells to be cast on anyone but the caster
    - Make the caster immobile (if possible, else we will use a HB)
    - Apply damage reduction 8/-, against physiscal damage, for a maximum of
      8xlevel, max 80.

    So, you can cast it and prepare some spells and subsiquently gain a small
    amount of physical damage reduction.

    Simplified version.

    The PHS_SpellHookCheck() has code for MELD_INTO_STONE stuff.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MELD_INTO_STONE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Caster needs to be target
    if(oCaster != oTarget) return;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration is 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Limit to 80
    int nLimit = PHS_LimitInteger(nCasterLevel * 8, 80);

    // Declare effects
    // All "Good" effects
    effect ePhysical1 = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 8, nLimit);
    effect ePhysical2 = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 8, nLimit);
    effect ePhysical3 = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 8, nLimit);
    effect eBlind = EffectBlindness();
    // Visuals
    effect eDur = EffectVisualEffect(VFX_DUR_STONEHOLD);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(ePhysical1, ePhysical2);
    eLink = EffectLinkEffects(eLink, ePhysical3);
    eLink = EffectLinkEffects(eLink, eBlind);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_MELD_INTO_STONE, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MELD_INTO_STONE, FALSE);

    // Apply effects to the target
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
