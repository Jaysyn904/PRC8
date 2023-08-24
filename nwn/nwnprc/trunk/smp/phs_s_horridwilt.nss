/*:://////////////////////////////////////////////
//:: Spell Name Horrid Wilting
//:: Spell FileName PHS_S_HorridWilt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Long (40M)
    Targets: Living enemy creatures, within a 10-M-radius sphere
    Duration: Instantaneous
    Saving Throw: Fortitude half
    Spell Resistance: Yes

    This spell evaporates moisture from the body of each subject living creature,
    dealing 1d6 points of damage per caster level (maximum 20d6). This spell is
    especially devastating to water elementals and plant creatures, which instead
    take 1d8 points of damage per caster level (maximum 20d8).

    Arcane Material Component: A bit of sponge.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Plant and water elementals are easily added extra damage - more power
    to the necromancers, eh?

    Damage is magical, as Bioware's spell. Massive radius, however!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HORRID_WILTING)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam;
    float fDelay;

    // Limit dice to 20d6/8
    int nDice = PHS_LimitInteger(nCasterLevel, 20);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_HORRID_WILTING);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 10.0M radius, objects - Creatures
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // Enemy only PvP Check and spell immunity check
        if(GetIsReactionTypeHostile(oTarget, oCaster) &&
           !PHS_GeneralEverythingImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HORRID_WILTING);

            // Make sure they are living
            if(PHS_GetIsAliveCreature(oTarget))
            {
                // Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                // Spell resistance And immunity checking.
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // If they are a plant, or water elemental, do d8 not d6 damage.
                    if(PHS_GetIsPlant(oTarget) || PHS_GetIsWaterElemental(oTarget))
                    {
                        // Roll damage - d8
                        nDam = PHS_MaximizeOrEmpower(8, nDice, nMetaMagic);
                    }
                    else
                    {
                        // Roll damage - d6
                        nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);
                    }

                    // Adjust the damage based on the Fortitude Save.
                    nDam = PHS_GetAdjustedDamage(SAVING_THROW_FORT, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay);

                    // Need to do damage to apply visuals
                    if(nDam > 0)
                    {
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_MAGICAL));
                    }
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
