/*:://////////////////////////////////////////////
//:: Spell Name Dispel Magic, Greater
//:: Spell FileName PHS_S_DispelMagG
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 5, Clr 6, Drd 6, Sor/Wiz 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target or Area: One creature; or 6.67-M.-radius burst
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    This spell functions like dispel magic, except that the maximum caster level
    on your dispel check is +20 instead of +10.

     Some spells, as detailed in their descriptions, can’t be defeated by dispel
     magic. Dispel magic can dispel (but not counter) spell-like effects just as
     it does spells. A targeted dispel will attempt to dispel each spell's
     effect seperatly, at a DC of 11 + spell's caster level. An area dispel will
     attempt to dispel one effect from each target (checking through spells
     until one is removed or until all are checked), and all area of effects (as
     if it was another spell effect) within the 6.67M radius.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can target several things, urg...

    And more complexe then Bioware's spell, however, EffectDispelMagicAll() and
    EffectDispelMagicBest().

    Target: Creature:
    - You make a dispel check (1d20 + your caster level, maximum +10)
      against the spell or against each ongoing spell currently in effect on the
      object or creature. The DC for this dispel check is 11 + the spell’s caster
      level.
    Also dispels all "good" spell effects created by this caster on the target,
    before the dispel is made, because of the "choose to atuomatically suceed"
    check.

    Target: Area:
    - When dispel magic is used in this way, the spell affects everything
      within a 30-foot radius. (RADIUS_SIZE_COLOSSAL, 10.0M)

    - For each ongoing area or effect spell whose point of origin is within the
      area of the dispel magic spell, you can make a dispel check to dispel the
      spell.

    So, a lesser version in an area - Uses the "Best" Bioware function, and also
    can cancle spells cast by that caster, which are good (of course!) if they
    are not an ally.

    The AOE's check are seperate, and are done using the set integers with
    PHS_GetAOECasterLevel(oAOE);

    So, easy enough, kinda. The internal stuff for dispelling is in phs_inc_remove.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"


void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_DISPEL_MAGIC_GREATER)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    // Max bonus of +20 from caster level
    int nMaxBonus = PHS_LimitInteger(nCasterLevel, 20);

    // Delcare effects
    effect eDispel;
    effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // If oTarget is valid, it is a targeted dispel
    if(GetIsObjectValid(oTarget))
    {
        // Dispel anyone - only check no PvP
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Signal event based on friendly rating.
            if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
            {
                // Not hostile
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC_GREATER, FALSE);
            }
            else
            {
                // Hostile
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC_GREATER);
            }
            // It is an "all" dispel
            eDispel = EffectDispelMagicAll(nMaxBonus);
            // Dispel the target!
            PHS_DispelMagicAll(oTarget, eDispel, eVis);
        }
    }
    else
    {
        // Apply AOE visual
        effect eImpact = EffectVisualEffect(VFX_FNF_DISPEL);
        PHS_ApplyLocationVFX(lTarget, eImpact);

        // It is an "one" dispel
        eDispel = EffectDispelMagicBest(nMaxBonus);

        // Loop all targets, and AOE's in the AOE.
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
        while(GetIsObjectValid(oTarget))
        {
            // Dispel anyone - only check no PvP
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // Dispel the target
                // Signal event based on friendly rating.
                if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
                {
                    // Not hostile
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC_GREATER, FALSE);
                }
                else
                {
                    // Hostile
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC_GREATER);
                }
                // Dispel the target!
                PHS_DispelMagicBest(oTarget, eDispel, eVis);
            }
            // Next target
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
        }
    }
}
