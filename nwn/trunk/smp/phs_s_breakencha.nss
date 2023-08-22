/*:://////////////////////////////////////////////
//:: Spell Name Break Enchantment
//:: Spell FileName PHS_S_BreakEncha
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 4, Clr 5, Luck 5, Pal 4, Sor/Wiz 5
    Components: V, S
    Casting Time: 1 minute
    Range: Close (8M)
    Targets: Up to one creature per level, all within a 5M-radius sphere
    Duration: Instantaneous
    Saving Throw: See text
    Spell Resistance: No

    This spell frees victims from enchantments, transmutations, and curses. Break
    enchantment can reverse even an instantaneous effect. For each such effect,
    you make a caster level check (1d20 + caster level, maximum +15) against a DC
    of 11 + caster level of the effect. Success means that the creature is free
    of the spell, curse, or effect. For a cursed magic item, the DC is 25.

    If the spell is one that cannot be dispelled by dispel magic, break
    enchantment works only if that spell is 5th level or lower.

    If the effect comes from some permanent magic item break enchantment does
    not remove the curse from the item, but it does frees the victim from the
    item’s effects.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above.

    We have special dispelling things now to dispel all the Enchantments,
    transmutations and curses and so on.

    Also a special one for any 5th level or lower if cannot be dispelled
    by dispel magic (IE: Supernautral, Extraodinary).

    No item cursing removal yet.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nDone;
    float fDelay;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Cap caster level at 15 for this spell
    int nBonusDispelLevel = PHS_LimitInteger(nCasterLevel, 15);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // Get all cretures (duh) in a 5M sphere
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Limit creatures affected - 1 per level
    while(GetIsObjectValid(oTarget) && nDone < nCasterLevel)
    {
        // We only affect chosen allies as it is meant to stop bad things
        // (the spell schools are usually tansforming into bad spells and enchanting
        // to do bad things, like domination)
        if((GetIsFriend(oTarget) || GetFactionEqual(oTarget)) &&
        // Check master!
           (GetMaster(oTarget) != oCaster ||
            GetAssociateType(oTarget) != ASSOCIATE_TYPE_DOMINATED))
        {
            // Done by +1.
            nDone++;

            // Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Signal Spell cast at the target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BREAK_ENCHANTMENT, FALSE);

            // We (attempt to) dispel curses, the curse effect
            PHS_DispelAllEffectsOfType(oTarget, nBonusDispelLevel, EFFECT_TYPE_CURSE);

            // We then (attempt to) dispel all spells from the spell school
            // - Enchantments
            PHS_DispelAllSpellsFromSpellSchool(oTarget, nBonusDispelLevel, SPELL_SCHOOL_ENCHANTMENT, 5);

            // - Transmutations
            PHS_DispelAllSpellsFromSpellSchool(oTarget, nBonusDispelLevel, SPELL_SCHOOL_TRANSMUTATION, 5);

            // We will apply VFX regardless now.
            DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
