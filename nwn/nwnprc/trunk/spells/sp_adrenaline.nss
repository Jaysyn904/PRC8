//:://////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::///////////////////////////////////////////////
//::  
/*
	Adrenaline Surge
	Transmutation
	Level: Druid 2, Sor/Wiz 2
	Components: V, S, DF
	Casting Time: 1 action
	Range: Close (25 ft. + 5 fr./2 levels)
	Area: Your summoned creatures within a spherical 
	emanation with a radius equal to the range, centered on you
	Duration: 1 round/level
	Saving Throw: Will negates (harmless)
	Spell Resistance: Yes (harmless)

	Each of your summoned creatures within the area receives 
	a +4 enhancement bonus to Strength. This effect lasts until 
	the spell ends or the creature leaves the area.
	
*/
//::  
//::////////////////////////////////////////////// 
//::	Script:     sp_adrenaline
//::	Author:     Jaysyn
//::	Created:    2025-08-11 22:28:40
//:://////////////////////////////////////////////		
#include "x2_inc_spellhook"
#include "prc_inc_spells"


// Helper function to remove the adrenaline surge effect from the target
void RemoveAdrenalineEffect(object oTarget)
{
    if (!GetIsObjectValid(oTarget)) return;

    effect e = GetFirstEffect(oTarget);
    while (GetIsEffectValid(e))
    {
        effect eNext = GetNextEffect(oTarget);
        if (GetEffectTag(e) == "ADRENALINE_SURGE")
            RemoveEffect(oTarget, e);
        e = eNext;
    }
}

// Checks each second if the target has moved out of range
void CheckAdrenalineSurge(object oCaster, object oTarget, float fRange)
{
    if (!GetIsObjectValid(oTarget) || !GetIsObjectValid(oCaster))
        return;

    // If out of range, remove the effect early
    if (GetDistanceBetween(oTarget, oCaster) > fRange)
    {
        RemoveAdrenalineEffect(oTarget);
        return;
    }

    // Still valid — check again in 1 second
    DelayCommand(1.0, CheckAdrenalineSurge(oCaster, oTarget, fRange));
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    float fRange = 25.0 + (5.0 * IntToFloat(nCasterLevel / 2));
    float fDuration = IntToFloat(nCasterLevel) * 6.0; // in seconds
    location lCaster = GetLocation(oCaster);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lCaster, TRUE, OBJECT_TYPE_CREATURE);

    while (GetIsObjectValid(oTarget))
    {
        // Only apply to summons of this caster
        if (GetMaster(oTarget) == oCaster)
        {
            // Prevent stacking — skip if already has the effect
            int bHas = FALSE;
            effect eCheck = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eCheck))
            {
                if (GetEffectTag(eCheck) == "ADRENALINE_SURGE")
                {
                    bHas = TRUE;
                    break;
                }
                eCheck = GetNextEffect(oTarget);
            }

            if (!bHas)
            {
                effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
                eStr = TagEffect(eStr, "ADRENALINE_SURGE");

                effect eVis = EffectVisualEffect(VFX_IMP_HASTE);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr, oTarget);

                // Schedule effect removal after the full duration
                DelayCommand(fDuration, RemoveAdrenalineEffect(oTarget));

                // Start periodic range check
                DelayCommand(1.0, CheckAdrenalineSurge(oCaster, oTarget, fRange));
            }
        }

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lCaster, TRUE, OBJECT_TYPE_CREATURE);
    }
}
