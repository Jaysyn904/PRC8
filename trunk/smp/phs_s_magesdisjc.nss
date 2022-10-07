/*:://////////////////////////////////////////////
//:: Spell Name Mage’s Disjunction
//:: Spell FileName PHS_S_MagesDisjc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Magic 9, Sor/Wiz 9
    Components: V
    Casting Time: 1 standard action
    Range: Close (8M)
    Area: All magical effects and magic items within a 13.33-M.-radius burst
    Duration: Instantaneous
    Saving Throw: Will negates (object)
    Spell Resistance: No

    All magical effects from spells and magic items within the radius of the
    spell, except for those that you carry or touch, are disjoined. That is,
    spells and spell-like effects are separated into their individual components
    (ending the effect as a dispel magic spell does), and each permanent magic
    item which is not an artifact (value of 1000 gold or less) must make a
    successful Will save or be turned into a normal item. An item in a
    creature’s possession uses its own Will save bonus or its possessor’s Will
    save bonus, whichever is higher.

    You also have a 1% chance per caster level of destroying an antimagic field.
    If the antimagic field survives the disjunction, no items within it are
    disjoined.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Target: Always Area:
    - It will remove all magical effects from everyone in the area (Using
      PHS_DisjoinMagic()).

    - For each ongoing area or effect spell whose point of origin is within the
      area of the dispel magic spell, it gets destroyed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGES_DISJUNCTION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();

    // Area of effect - apply the visual
    effect eImpact = EffectVisualEffect(VFX_IMP_DISPEL_DISJUNCTION);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // We first need to make sure that we check antimagic fields
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 13.33, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oTarget))
    {
        // First, we make sure it is a Antimagic Field
//        if(GetTag(oTarget) == PHS_AOE_TAG_PER_ANITMAGIC_FIELD)
        {
            // If it is we have a 1% chance/caster level of disjoining it
            if(d100() <= nCasterLevel)
            {
                // Destroy it
                DestroyObject(oTarget);
            }
            else
            {
                // Else, we set so that all those in it cannot have thier items
                // disjoined.

            }
        }
        // Next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_40, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT);
    }

    // Loop all targets, and AOE's in the AOE.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_40, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oTarget))
    {
        // Check object type
        if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            // Remove it if it is from a spell
            if(PHS_GetAOECasterLevel(oTarget) >= 1)
            {
                // Check if it is an antimagic field
//                if(GetTag(oTarget) != PHS_TAG_AOE_PER_ANITMAGIC_FIELD)
                {
                    SetPlotFlag(oTarget, FALSE);
                    DestroyObject(oTarget);
                }
            }
        }
        else
        {
            // Dispel anyone - only check no PvP
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // Dispel the target
                // Signal event based on friendly rating.
                if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
                {
                    // Not hostile
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGES_DISJUNCTION, FALSE);
                }
                else
                {
                    // Hostile
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGES_DISJUNCTION);
                }
                // Dispel the target!
                PHS_DisjoinMagic(oTarget, VFX_IMP_DISPEL_DISJUNCTION);
            }
        }
        // Next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 13.33, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    }
}
