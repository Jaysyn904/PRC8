/*:://////////////////////////////////////////////
//:: Spell Name Ice Storm
//:: Spell FileName PHS_S_IceStorm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Cold]
    Range: Long (40M)
    Area: Everything within a 6.67-M. radius sphere
    Duration: 1 full round; see text
    Saving Throw: None
    Spell Resistance: Yes

    Great magical hailstones pound down for 1 full round, dealing 3d6 points of
    bludgeoning damage and 2d6 points of cold damage to every creature in the
    area. A -4 penalty applies to each Listen check made within the ice storm’s
    effect, and all land movement within its area is at half speed. At the end
    of the duration, the hail disappears, leaving no aftereffects (other than
    the damage dealt).

    Arcane Material Component: A pinch of dust and a few drops of water.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No save, so [Cold] doesn't apply to much

    Rest is as normal. I did do this before the crash, oh well...*goes and backs
    up now*
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ICE_STORM)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamCold, nDamBlud;
    float fDelay;

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eSlow = EffectMovementSpeedDecrease(50);
    effect eSkill = EffectSkillDecrease(SKILL_LISTEN, 4);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eSlowLink = EffectLinkEffects(eSlow, eCessate);
    effect eSkillLink = EffectLinkEffects(eSkill, eCessate);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_ICESTORM);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 6.67M radius, objects - Creatures/doors/placeables
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check and spell immunity check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
           !PHS_GeneralEverythingImmunity(oTarget))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ICE_STORM);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Roll damage for each target
                nDamCold = PHS_MaximizeOrEmpower(6, 2, nMetaMagic);
                nDamBlud = PHS_MaximizeOrEmpower(6, 3, nMetaMagic);

                // Apply effects to the currently selected target.
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamCold, DAMAGE_TYPE_COLD));
                DelayCommand(fDelay, PHS_ApplyDamageToObject(oTarget, nDamBlud, DAMAGE_TYPE_BLUDGEONING));
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
