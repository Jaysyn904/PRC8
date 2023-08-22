/*:://////////////////////////////////////////////
//:: Spell Name Forbiddance
//:: Spell FileName PHS_S_Forbiddnc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 6
    Components: V, S, M, DF
    Casting Time: 6 rounds
    Range: Medium (20M)
    Area: 60-M. cube (S)
    Duration: Permanent
    Saving Throw: See text
    Spell Resistance: Yes

    Forbiddance seals an area against all planar travel into or within it. This
    includes all teleportation spells (such as dimension door and teleport),
    plane shifting, astral travel, ethereal travel, and all summoning spells.
    Such effects simply fail automatically.

    In addition, it damages entering creatures whose alignments are different
    from yours. The effect on those attempting to enter the warded area is based
    on their alignment relative to yours (see below). A creature inside the area
    when the spell is cast takes no damage unless it exits the area and attempts
    to reenter, at which time it is affected as normal.

    Alignments identical: No effect. The creature may enter the area freely
    (although not by planar travel).
    Alignments different with respect to either law/chaos or good/evil: The
    creature takes 6d6 points of damage. A successful Will save halves the damage,
    and spell resistance applies.
    Alignments different with respect to both law/chaos and good/evil: The
    creature takes 12d6 points of damage. A successful Will save halves the
    damage, and spell resistance applies.

    Party members who know the password set when cast are automatically ignored
    and can enter without effect.

    Dispel magic does not dispel a forbiddance effect unless the dispeller’s
    level is at least as high as your caster level.

    You can’t have multiple overlapping forbiddance effects, and any cast into
    an area with one in already will not work.

    Material Component: A sprinkling of holy water and rare incenses worth at
    least 4,000 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, creates an AOE:

    - Large and permament (takes 6 rounds to cast!)
    - Party members immune to its effects (And SR + Save applieS)
    - Always blocks Planar Travel
    - Does damage to those who don't enter in the first few seconds:
      - 1 Alignment difference, (EG: N cast, LN goes in) 6d6 damage (divine?) (will half)
      - 2 alignment difference, (EG: N cast, LG goes in) 12d6 damage. (divine?) (will half)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_FORBIDDANCE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // We cannot actually cast it if it'll be in an exisiting AOE
    object oOtherAOE = GetNearestObjectByTag(PHS_AOE_TAG_PER_FORBIDDANCE, oCaster, 1);

    // check distance and validility
    if(GetIsObjectValid(oOtherAOE) &&
       GetDistanceBetweenLocations(GetLocation(oOtherAOE), lTarget) <= 60.0)
    {
        FloatingTextStringOnCreature("You cannot create another Forbiddened area which overlaps with an exsisting one", oCaster, FALSE);
        return;
    }

    // Check for holy water
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_HOLY_WATER, "Holy Water", "Forbiddance")) return;

    // Check material component
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_INCENSE_4000, "Rare Incenses worth 4000GP", "Forbiddance")) return;

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_FORBIDDANCE);
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_FORBIDDANCE);

    // Apply effect at location permamently
    PHS_ApplyLocationPermanentAndVFX(lTarget, eImpact, eAOE);
}
