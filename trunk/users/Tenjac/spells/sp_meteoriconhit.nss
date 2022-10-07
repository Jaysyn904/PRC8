//:://////////////////////////////////////////////
//:: Name     Meteoric Strike On Hit
//:: FileName   sp_meteoriconhit.nss
//:://////////////////////////////////////////////
/** @file Transmutation [Fire]
Level: Druid 4, Paladin 4, Cleric 5,
Components: V, S,
Casting Time: 1 swift action
Range: 0 ft.
Target: Your melee weapon
Duration: 1 round or until discharged
Saving Throw: None or Reflex half; see text
Spell Resistance: See text

Your melee weapon bursts into orange, red, and gold flames,
and shining sparks trail in its wake.
Your next successful melee attack deals extra fire damage equal 
to 1d6 points + 1d6 points per four caster levels.
In addition, the flames splash into all squares adjacent to the t
arget.
Any creatures standing in these squares take half damage from the 
explosion, with a Reflex save allowed to halve this again.
If a creature has spell resistance, it applies to this splash effect.
You are not harmed by your own meteoric strike.
You can cast meteoric strike before you make an unarmed attack.
If you do, your unarmed attack is considered armed.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/14/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"
#include "prc_alterations"
#include "prc_inc_combat"


void main()
{
	object oSpellOrigin = OBJECT_SELF;

	// route all onhit-cast spells through the unique power script (hardcoded to "prc_onhitcast")
	// in order to fix the Bioware bug, that only executes the first onhitcast spell found on an item
	// any onhitcast spell should have the check ContinueOnHitCast() at the beginning of its code
	// if you want to force the execution of an onhitcast spell script, that has the check, without routing the call
	// through prc_onhitcast, you must use ForceExecuteSpellScript(), to be found in prc_inc_spells
	if(!ContinueOnHitCastSpell(oSpellOrigin)) return;

	// DeleteLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

	// find the weapon 
	object oWeapon = PRCGetSpellCastItem(oSpellOrigin);
		
	//Get Caster level
	int nBonus = GetLocalInt(oWeapon, "MeteoricCasterLvl") / 4;

	// find the target of the spell
	object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
	
	// only do anything if we have a valid weapon and a valid living target
	if (GetIsObjectValid(oWeapon) && GetIsObjectValid(oTarget)&& !GetIsDead(oTarget))
	{
		int nDam = d6(1 + nBonus);
		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(oTarget, nDam, DAMAGE_TYPE_FIRE), oTarget); 
		
		//Burst
		nDam = nDam/2;
		location lLoc = GetLocation(oTarget);
		object oTargetB = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(5), lLoc, TRUE);
		
		while(GetIsObjectValid(oTargetB))
		{
			if(oTargetB != oPC)
			{
				if(!PRCDoResistSpell(oTargetB))
				{
					if (PRCMySavingThrow(SAVING_THROW_REFLEX, oTargetB, (PRCGetSaveDC(oTargetB, oSpellOrigin))))
					{
						nDam = nDam/2;
					}				
					
					effect eLink = EffectLinkEffects(EffectDamage(DAMAGE_TYPE_FIRE, nDam), EffectVisualEffect(VFX_COM_HIT_FIRE));
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTargetB);
				}
			}
			oTargetB = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5), lLoc, TRUE);
		}		
	}
}