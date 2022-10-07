/*:://////////////////////////////////////////////
//:: Spell Name Protection from Energy
//:: Spell FileName PHS_S_ProtEnergy
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    12 points of damage/caster level (to 120) temp. immunity implies a hell
    of a lot of resistance at once, so a limit of 100 will do.

    Must choose one of acid, cold, electricity, fire or sonic
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Protection from energy can be done as the spell.

    There will be 5 ones - it won't protect against all, but a specific type,
    as the spell states.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PROTECTION_FROM_ENERGY)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellId = GetSpellId();

    // Duration - 10 Mins/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Damage is 12 * Caster level, max of 120.
    int nDamageMax = PHS_LimitInteger(nCasterLevel * 12, 120);

    // What damage type?
    int nDamageType = DAMAGE_TYPE_FIRE;

    // Check spell
    if(nSpellId == PHS_SPELL_PROTECTION_FROM_ENERGY_ACID)
    {
        nDamageType = DAMAGE_TYPE_ACID;
    }
    else if(nSpellId == PHS_SPELL_PROTECTION_FROM_ENERGY_COLD)
    {
        nDamageType = DAMAGE_TYPE_COLD;
    }
    else if(nSpellId == PHS_SPELL_PROTECTION_FROM_ENERGY_ELECTRICAL)
    {
        nDamageType = DAMAGE_TYPE_ELECTRICAL;
    }
    else if(nSpellId == PHS_SPELL_PROTECTION_FROM_ENERGY_SONIC)
    {
        nDamageType = DAMAGE_TYPE_SONIC;
    }
    // Default to fire
    else // if(nSpellId == PHS_SPELL_PROTECTION_FROM_ENERGY_FIRE)
    {
        nDamageType = DAMAGE_TYPE_FIRE;
    }

    // Delcare effects
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_PROTECTION_ENERGY);
    // Can be used up all at once, up to 120 at once!
    effect eDamageResistance = EffectDamageResistance(nDamageType, nDamageMax, nDamageMax);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eDamageResistance);
    eLink = EffectLinkEffects(eLink, eCessate);

    // We don't remove previous castings except of the same spell.
    PHS_RemoveSpellEffectsFromTarget(nSpellId, oTarget);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PROTECTION_FROM_ENERGY, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
