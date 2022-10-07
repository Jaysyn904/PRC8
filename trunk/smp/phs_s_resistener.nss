/*:://////////////////////////////////////////////
//:: Spell Name Resist Energy
//:: Spell FileName PHS_S_ResistEner
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 2, Drd 2, Fire 3, Pal 2, Rgr 1, Sor/Wiz 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 10 min./level
    Saving Throw: Fortitude negates (harmless)
    Spell Resistance: Yes (harmless)

    This abjuration grants a creature limited protection from damage of whichever
    one of five energy types you select: acid, cold, electricity, fire, or sonic.
    The subject gains energy resistance 10 against the energy type chosen,
    meaning that each time the creature is subjected to such damage (whether
    from a natural or magical source), that damage is reduced by 10 points
    before being applied to the creature’s hit points. The value of the energy
    resistance granted increases to 20 points at 7th level and to a maximum of
    30 points at 11th level. The spell protects the recipient’s equipment as
    well.

    Resist energy absorbs only damage. The subject could still suffer unfortunate
    side effects.

    Note: Resist energy overlaps (and does not stack with) protection from
    energy. If a character is warded by protection from energy and resist
    energy, the protection spell absorbs damage until its power is exhausted.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This, unlike Protection From Energy, doesn't run out until the duration
    does.

    Unlike Protection From Energy, it can't all be absorbed at once. This can
    increase to 30 points of energy damage resistance at level 11.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RESIST_ENERGY)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellId = GetSpellId();

    // Duration - 10 Mins/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    int nDamageMax;
    // 30 DR at level 11+
    if(nCasterLevel >= 11)
    {
        nDamageMax = 30;
    }
    // 20 DR at 7+
    else if(nCasterLevel >= 7)
    {
        nDamageMax = 20;
    }
    // 10 DR otherwise.
    else
    {
        nDamageMax = 10;
    }

    // What damage type?
    int nDamageType = DAMAGE_TYPE_FIRE;

    // Check spell
    if(nSpellId == PHS_SPELL_RESIST_ENERGY_ACID)
    {
        nDamageType = DAMAGE_TYPE_ACID;
    }
    else if(nSpellId == PHS_SPELL_RESIST_ENERGY_COLD)
    {
        nDamageType = DAMAGE_TYPE_COLD;
    }
    else if(nSpellId == PHS_SPELL_RESIST_ENERGY_ELECTRICAL)
    {
        nDamageType = DAMAGE_TYPE_ELECTRICAL;
    }
    else if(nSpellId == PHS_SPELL_RESIST_ENERGY_SONIC)
    {
        nDamageType = DAMAGE_TYPE_SONIC;
    }
    // Default to fire
    else // if(nSpellId == PHS_SPELL_RESIST_ENERGY_FIRE)
    {
        nDamageType = DAMAGE_TYPE_FIRE;
    }

    // Delcare effects
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_PROTECTION_ENERGY);
    // Unlike "Protection from Energy", it is unlimited amount, but only takes 10 off.
    effect eDamageResistance = EffectDamageResistance(nDamageType, nDamageMax);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eDamageResistance);
    eLink = EffectLinkEffects(eLink, eCessate);

    // We don't remove previous castings except of the same spell.
    PHS_RemoveSpellEffectsFromTarget(nSpellId, oTarget);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RESIST_ENERGY, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
