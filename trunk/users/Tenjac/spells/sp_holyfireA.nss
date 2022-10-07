//:://////////////////////////////////////////////
//:: Name     Holy Fire On Enter
//:: FileName   sp_holyfireA.nss
//:://////////////////////////////////////////////
/** @file Evocation [Fire, Good]
Level: Cleric 2, Paladin 3,
Components: V, S, DF,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round

All undead within range of your next turning attempt
(if you make it before this spell's duration expires)
are especially vulnerable to the attempt. Whether you
succeed in turning them or not, the undead take hit 
point damage equal to the result of your turning damage
roll. This damage is half fire and half sacred energy.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/21/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	object oTarget = GetEnteringObject();
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_YELLOW_ORANGE), oTarget, 6.0f);
}