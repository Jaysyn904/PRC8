/*:://////////////////////////////////////////////
//:: Spell Name Dispel Magic
//:: Spell FileName PHS_S_DispelMag
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Medium (20M)
    Target or Area: One creature; or 6.67-M.-radius burst
    No Save, no SR.

    Bah, see SRD - the basics are below anyway!
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
      within a 30-foot radius. (10.0M)

    - For each ongoing area or effect spell whose point of origin is within the
      area of the dispel magic spell, you can make a dispel check to dispel the
      spell.

    So, a lesser version in an area - Uses the "Best" Bioware function, and also
    can cancle spells cast by that caster, which are good (of course!) if they
    are not an ally.

    The AOE's check are seperate, and are done using the set integers with
    PHS_GetAOECasterLevel(oAOE);

    So, easy enough, kinda. The internal stuff for dispelling is in phs_inc_remove.

    Note: It is dispelled ala a normal spell, like say, Spell Turning is, as it
    follows the caster.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_DISPEL_MAGIC)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    // Max bonus of +10 from caster level
    int nMaxBonus = PHS_LimitInteger(nCasterLevel, 10);

    // Delcare effects
    effect eDispel;
    effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // If oTarget is valid, it is a targeted dispel
    if(GetIsObjectValid(oTarget))
    {
        // Signal event based on friendly rating.
        if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
        {
            // Not hostile
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC, FALSE);
        }
        else
        {
            // Hostile
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC);
        }
        // It is an "all" dispel
        eDispel = EffectDispelMagicAll(nMaxBonus);
        // Dispel the target!
        PHS_DispelMagicAll(oTarget, eDispel, eVis);
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
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC, FALSE);
                }
                else
                {
                    // Hostile
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPEL_MAGIC);
                }
                // Dispel the target!
                PHS_DispelMagicBest(oTarget, eDispel, eVis);
            }
            // Next target
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
        }
    }
}
