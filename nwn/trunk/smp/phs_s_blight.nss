/*:://////////////////////////////////////////////
//:: Spell Name Blight
//:: Spell FileName PHS_S_Blight
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Touch Range, Fort half + SR applies.

    This spell withers a single plant of any size. An affected plant creature
    takes 1d6 points of damage per level (maximum 15d6) and may attempt a
    Fortitude saving throw for half damage. A plant that isn’t a creature
    doesn’t receive a save and immediately withers and dies.

    This spell has no effect on the soil or surrounding plant life.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.

    Subrace must be equal to Plant, of course, or the plant integer...

    PHS_PLANT

    Placeables, if the integer for "plant" is set on them, are also destroyed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nTargetType = GetObjectType(oTarget);
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam;
    // Limit to 15 dice of damage
    int nDice = PHS_LimitInteger(nCasterLevel, 15);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

    // Target type can be a placeable, or a creature.
    if(PHS_GetIsPlant(oTarget))
    {
        // Signal spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BLIGHT);

        // Spell resistance and immunity
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Check object type
            if(nTargetType == OBJECT_TYPE_PLACEABLE)
            {
                // Instant destroy - auto wither and die. We do damage to it to
                // get a nice effect from killing it (or none, of course).
                PHS_ApplyDeathByDamage(oTarget);
            }
            else //if(nTargetType == OBJECT_TYPE_CREATURE)
            {
                // 15d6 damage max.
                nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Fortitude save for half
                nDam = PHS_GetAdjustedDamage(SAVING_THROW_FORT, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE, oCaster);

                // If got damage, do it
                if(nDam > 0)
                {
                    // Apply effects, and damage
                    PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_NEGATIVE);
                }
            }
        }
    }
}
