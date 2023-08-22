/*:://////////////////////////////////////////////
//:: Spell Name Lightning Bolt
//:: Spell FileName PHS_S_LightngBlt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Electricity, 120ft line, which is 40M length. Reflex half, SR applies.

    Hits for 1d6 electrical damage/level to 10d6 max.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Taken some of Bioware's code for this - IE, to make sure they are in the
    line.

    We, however, use local objects, which should be faster.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

const string PHS_TEMP_LIGHTNING_ARRAY = "PHS_TEMP_LIGHTNING_ARRAY";

// Check if they are in the LOS of the cylinder.
int CheckIfInArray(object oTarget, int nMax, object oCaster);

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    vector vCaster = GetPosition(oCaster);
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt, nDam;
    float fDelay;
    // Max of 10d6
    int nDice = PHS_LimitInteger(nCasterLevel, 10);

    // Declare visual effects
    effect eBeam = EffectBeam(VFX_BEAM_SILENT_LIGHTNING, oCaster, BODY_NODE_HAND);
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);

    // We set the people and objects within the line to a local array, so it is
    // quicker
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 40.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vCaster);
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            nCnt++;
            SetLocalObject(oCaster, PHS_TEMP_LIGHTNING_ARRAY + IntToString(nCnt), oTarget);
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 40.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vCaster);
    }
    // New max of set array is nCnt
    int nMax = nCnt;

    // Now we do nearest to futhest, as to get the beams correct!
    nCnt = 1;
    oTarget = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oCaster, nCnt);
    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 40.0)
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Make sure they are in the array.
            if(CheckIfInArray(oTarget, nMax, oCaster))
            {
                // Apply the beam
                DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eBeam, 0.1));

                // We can now check spell resistance
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Get damage
                    nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);

                    // Reflex saving throw
                    nDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY);

                    // Do damage and VFX
                    if(nDam > 0)
                    {
                        DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_ELECTRICAL));
                    }
                }
                // Change delay and beam effects
                fDelay += 0.1;
                eBeam = EffectBeam(VFX_BEAM_SILENT_LIGHTNING, oTarget, BODY_NODE_CHEST);
            }
        }
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oCaster, nCnt);
    }

    // Delete the old array
    for(nCnt = 1; nCnt <= nMax; nCnt++)
    {
        DeleteLocalObject(oCaster, PHS_TEMP_LIGHTNING_ARRAY + IntToString(nCnt));
    }
}

// Check if they are in the LOS of the cylinder.
int CheckIfInArray(object oTarget, int nMax, object oCaster)
{
    int nCnt = 1;
    object oCheck = GetLocalObject(oCaster, PHS_TEMP_LIGHTNING_ARRAY + IntToString(nCnt));
    while(nCnt <= nMax)
    {
        if(oCheck == oTarget)
        {
            return TRUE;
        }
        nCnt++;
        oCheck = GetLocalObject(oCaster, PHS_TEMP_LIGHTNING_ARRAY + IntToString(nCnt));
    }
    return FALSE;
}
