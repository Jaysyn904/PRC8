/*:://////////////////////////////////////////////
//:: Spell Name Freezing Sphere
//:: Spell FileName phs_s_freezesphe
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Freezing Sphere
    Evocation [Cold]
    Level: Sor/Wiz 6
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Long (40M)
    Target, Effect, or Area: See text
    Duration: Instantaneous or 1 round/level; see text
    Saving Throw: Reflex half; see text
    Spell Resistance: Yes

    Freezing sphere creates a frigid globe of cold energy that streaks from your
    fingertips to the location you select, where it explodes in a 10-foot-radius
    burst, dealing 1d6 points of cold damage per caster level (maximum 15d6) to
    each creature in the area. An elemental (water) creature instead takes 1d8
    points of cold damage per caster level (maximum 15d8).

    You can refrain from firing the globe after completing the spell, if you wish.
    You can hold the charge for as long as 1 round per level, at the end of which
    time the freezing sphere bursts centered on you (and you receive no saving
    throw to resist its effect). Firing the globe in a later round is a standard
    action usable from your class item.

    Focus: A small crystal sphere.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Nearly the same as fireball. Note that it is possible to refrain from
    firing (NOT IN YET)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FREEZING_SPHERE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamage;
    int nAppearance;
    float fDelay;

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);

    // Are we holding it back or not?
    //if(!NOT IN YET) return;

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_FREEZING_SPHERE);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, medium (3.3) radius, objects
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FREEZING_SPHERE);

            // Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Damage - it is 1d8 for water elementals!
                nAppearance = GetAppearanceType(oTarget);

                // Elemental
                if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
                  (nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER ||
                   nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER ||
                   FindSubString(GetStringUpperCase(GetSubRace(oTarget)), "WATER ELEMENTAL") >= 0))
                {
                    // 1d8/level
                    nDamage = PHS_MaximizeOrEmpower(8, nCasterLevel, nMetaMagic);
                }
                // Not an elemental
                else
                {
                    // 1d6/level
                    nDamage = PHS_MaximizeOrEmpower(6, nCasterLevel, nMetaMagic);
                }

                // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_COLD);

                // Need to do damage to apply visuals
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_COLD));
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
