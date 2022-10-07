/*:://////////////////////////////////////////////
//:: Spell Name Fire Storm
//:: Spell FileName PHS_S_FireStorm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Fire]
    Level: Clr 8, Drd 7, Fire 7
    Components: V, S
    Casting Time: 1 round
    Range: Medium (20M)
    Area: 3M (per 4 levels) /side cube, to a maximum of a 15M/side cube area.
    Duration: Instantaneous
    Saving Throw: Reflex half
    Spell Resistance: Yes

    When a fire storm spell is cast, the whole area is shot through with sheets
    of roaring flame, the area expanding as levels increase. Any creature within
    the area takes 1d6 points of fire damage per caster level (maximum 20d6).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Expands in a cube.

    It is a level 7 spell minimum - therefore, the lowest level it can be got is
    (7 + 1) = 8, * 2 = 14.

    As it is 3M per 4 levels, they must always have an area of 9M cubed. So
    need 9M (at level 12), 12M (level 16), 15M (level 20) cube AOE's.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FIRE_STORM)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam, nVFX;
    float fDelay, fSideLength;

    // Limit dice to 20d6
    int nDice = PHS_LimitInteger(nCasterLevel, 20);


    // Size based on nCasterLevel
    if(nCasterLevel >= 20)
    {
        // 15M cubed
        fSideLength = 15.0;
        nVFX = PHS_VFX_FNF_FIRESTORM_15;
    }
    else if(nCasterLevel >= 16)
    {
        // 12M cubed
        fSideLength = 12.0;
        nVFX = PHS_VFX_FNF_FIRESTORM_12;
    }
    else // if(nCasterLevel >= 20)
    {
        // 9M cubed
        fSideLength = 9.0;
        nVFX = PHS_VFX_FNF_FIRESTORM_09;
    }

    // Note:
    // nShape == SHAPE_CUBE, this is half the length of one of the sides of
    //      the cube
    // Half length = half of fSideLength
    fSideLength /= 2;

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(nVFX);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a cube, objects creatures, etc. Use fSideLength.
    oTarget = GetFirstObjectInShape(SHAPE_CUBE, fSideLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIRE_STORM);

            // Get a random delay as the VFX affects everywhere at once.
            fDelay = PHS_GetRandomDelay(0.1, 0.5);

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Roll damage for each target (Max of 20d6)
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
        oTarget = GetNextObjectInShape(SHAPE_CUBE, fSideLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
