/*:://////////////////////////////////////////////
//:: Spell Name Fireball
//:: Spell FileName PHS_S_Fireball
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Fire]
    Level: Sor/Wiz 3
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: 6.67-M.-radius spread
    Duration: Instantaneous
    Saving Throw: Reflex half
    Spell Resistance: Yes

    A fireball spell is an explosion of flame that detonates with a low roar and
    deals 1d6 points of fire damage per caster level (maximum 10d6) to every
    creature within the area. Unattended objects also take this damage. The
    explosion creates almost no pressure.

    Material Component: A tiny ball of bat guano and sulfur.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Mostly as the Bioware version, as it is to 3.5 standards. Reflex
    half, so reflex save - GetReflexAdjustedDamage, with SAVING_THROW_FIRE
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FIREBALL)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam;
    float fDelay;

    // Limit dice to 10d6
    int nDice = PHS_LimitInteger(nCasterLevel, 10);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_FIREBALL);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 6.67M radius, all creatures, placeables amd doors.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIREBALL);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Roll damage for each target
                nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay);

                // Need to do damage to apply visuals
                if(nDam > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_FIRE));
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
