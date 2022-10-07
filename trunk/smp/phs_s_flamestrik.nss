/*:://////////////////////////////////////////////
//:: Spell Name Flame Strike
//:: Spell FileName phs_s_flamestrik
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range, 3.3M (Medium) area, Reflex half, SR applies.
    A flame strike produces a vertical column of divine fire roaring downward.
    The spell deals 1d6 points of damage per caster level (maximum 15d6). Half
    the damage is fire damage, but the other half results directly from divine
    power and is therefore not subject to being reduced by resistance to
    fire-based attacks.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the NwN varient really.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FLAME_STRIKE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamage, nFireDam, nDivineDam;
    float fDelay;

    // Dice max of 15
    int nDice = PHS_LimitInteger(nCasterLevel, 15);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, medium (3.3) radius, objects/placeables/doors.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FLAME_STRIKE);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Roll damage for each target
                nDamage = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Divide the damage in 2
                nFireDam = nDamage/2;
                nDivineDam = nDamage/2;

                // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nFireDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nFireDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay);
                nDivineDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDivineDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DIVINE, oCaster, fDelay);

                // Need to do damage to apply for fire.
                if(nFireDam > 0)
                {
                    // Delay visuals and damage.
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nFireDam, DAMAGE_TYPE_FIRE));
                }
                // Need to do damage to apply for divine.
                if(nDivineDam > 0)
                {
                    DelayCommand(fDelay, PHS_ApplyDamageToObject(oTarget, nFireDam, DAMAGE_TYPE_DIVINE));
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
