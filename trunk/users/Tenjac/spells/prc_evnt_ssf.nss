//:://////////////////////////////////////////////
//:: Name     Smite of Sacred Fire
//:: FileName   sp_smitesacfire.nss
//:://////////////////////////////////////////////
/** @file Evocation [Good]
Level: Paladin 2,
Components: V, DF,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round/level; see text

You must cast this spell in the same round when you 
attempt a smite attack. If the attack hits, you deal 
an extra 2d6 points of damage to the target of the 
smite. Whether or not you succeed on the smite attempt,
during each subsequent round of the spell?s duration,
you deal an extra 2d6 points of damage on any successful 
melee attack against the target you attempted to smite. 
The spell ends prematurely after any round when you do not
attempt a melee attack against the target you previously 
attempted to smite, or if you fail to hit with any of 
your attacks in a round.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/25/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{	
	object oSpellOrigin = OBJECT_SELF;
	// find the weapon 
	object oWeapon = PRCGetSpellCastItem(oSpellOrigin);
	// find the target of the spell
	object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
	
	//Hit in the last round
	if(GetHasSpellEffect(SPELL_SMITE_SACRED_FIRE_HIT))
	{
		//Target of the original smite
		if(GetLocalInt(oTarget, "PRCSSFTarget"));
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_DIVINE, d6(2)), oTarget);
			ActionCastSpellOnSelf(SPELL_SMITE_SACRED_FIRE_HIT);
		}
	}
	
	else //We've missed; effect ends, make sure this doesn't trigger the first time
	{		
		effect eToDispel = GetFirstEffect(oSpellOrigin);
		
		while(GetIsEffectValid(eToDispel))
		{
			if(GetEffectSpellId(eToDispel) == SPELL_SMITE_OF_SACRED_FIRE)
			{
				RemoveEffect(oSpellOrigin, eToDispel);
			}
			eToDispel = GetNextEffect(oSpellOrigin);
		}
	}
}
		        
		
	


