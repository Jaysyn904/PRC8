//:://////////////////////////////////////////////
//:: Name     Stabilize
//:: FileName   sp_stabilize.nss
//:://////////////////////////////////////////////
/** @file Conjuration (Healing)
Level: Cleric 2, Paladin 2,
Components: V, S, DF,
Casting Time: 1 swift action
Area: 50-ft.-radius burst centered on you
Duration: Instantaneous
Saving Throw: Will negates (harmless); see text
Spell Resistance: Yes (harmless)

This spell, designed to work on the battlefield, 
allows you to stabilize the dying all around you.
A burst of positive energy spreads out from you, 
healing 1 point of damage to all living creatures 
in the affected area, whether allied or not. This 
spell deals 1 point of damage to undead creatures,
which are allowed a Will saving throw to negate 
the effect.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/25/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        location lLoc = GetLocation(oPC);
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(50), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
        	if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
        	{
        		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_DIVINE), oTarget);
        		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_POSITIVE, 1), oTarget);
        	}
        	
        	else
        	{
        		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_HEAL), oTarget);
        		SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(1), oTarget);
        	}
       		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(50), lLoc, FALSE, OBJECT_TYPE_CREATURE);
       	}
PRCSetSchool();
}