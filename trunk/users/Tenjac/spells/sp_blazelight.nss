//:://////////////////////////////////////////////
//:: Name     Blaze of Light
//:: FileName   sp_blazelight.nss
//:://////////////////////////////////////////////
/** @file Evocation [Light]
Level: Paladin 1, Druid 2,
Components: V, S,
Casting Time: 1 standard action
Range: 60 ft.
Area: Cone
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

A cone of bright light shines forth from just above the caster's head.
All creatures within the cone that fail a Fortitude saving throw are dazzled for 1 minute.
Sightless creatures are not affected by blaze of light.
A light spell (one with the light descriptor) counters and dispels a darkness spell
(one with the darkness descriptor) of an equal or lower level.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/10/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        float fDur =  60.0f;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
        float fRadius = FeetToMeters(60);
        location lLoc = PRCGetSpellTargetLocation();
        effect eDazzled = EffectLinkEffects(EffectAttackDecrease(1), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
        eDazzled = EffectLinkEffects(eDazzled, EffectSkillDecrease(SKILL_SPOT, 1));
        eDazzled = EffectLinkEffects(eDazzled, EffectSkillDecrease(SKILL_SEARCH, 1));
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRadius, lLoc, TRUE);
        
        while(GetIsObjectValid(oTarget))
        {
        	//Resist
        	if(!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl) && (oTarget != OBJECT_SELF))
        	{
        		//Fort Save
        		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oPC), SAVING_THROW_TYPE_SPELL, oPC))
        		{
        			//Not blind
        			if(!GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget))
        			{
        				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzled, oTarget, fDur);
        			}
        		}
        	}
        	MyNextObjectInShape(SHAPE_SPELLCONE, fRadius, lLoc, TRUE);
        }        
        PRCSetSchool();
}