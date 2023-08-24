//::///////////////////////////////////////////////
//:: Name      Otiluke's Resilient Sphere
//:: FileName  sp_otiluke_rs.nss
//:://////////////////////////////////////////////
/**@file Otiluke's Resilient Sphere
Evocation [Force]
Level: Sor/Wiz 4
Components: V, S, M
Range: Short
Effect: Sphere, centered around a creature
Duration:       1 min./level (D)
Saving Throw:   Reflex negates
Spell Resistance:       Yes

A globe of shimmering force encloses a creature within
the diameter of the sphere. The sphere contains its 
subject for the spell’s duration. The sphere is not
subject to damage of any sort except from a rod of
cancellation, a rod of negation, a disintegrate spell,
or a targeted dispel magic spell. These effects destroy
the sphere without harm to the subject. Nothing can
pass through the sphere, inside or out, though the 
subject can breathe normally.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        effect eAoE = EffectAreaOfEffect(VFX_PER_OTILUKES_RESILIENT_SPHERE);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = (60.0 * nCasterLvl);
        
        int nMetaMagic = PRCGetMetaMagicFeat();
        if (nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        //Make SR check
	if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLvl))
	{
		//Make Forttude save
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NONE))
        	{
        		//Set local to signify the target
        		SetLocalInt(oTarget, "PRC_OTILUKES_RS_TARGET", 1);
        
        		//Paralyze the target 
        		effect eLink = EffectCutsceneParalyze();
        		       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_RESILIENT_SPHERE));
        
        
        		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oTarget, fDur, TRUE, SPELL_OTILUKES_RESILIENT_SPHERE, nCasterLvl);
        		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, SPELL_OTILUKES_RESILIENT_SPHERE, nCasterLvl);
        
                object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "VFX_PER_OTILUKES_RESILIENT_SPHERE");
                SetAllAoEInts(SPELL_OTILUKES_RESILIENT_SPHERE, oAoE, PRCGetSpellSaveDC(SPELL_OTILUKES_RESILIENT_SPHERE, SPELL_SCHOOL_EVOCATION), 0, nCasterLvl);

        		//Check for plot flag, if it's there, mark it as existing plot so we don't
        		//have poeple using ORS to remove it and kill plot chars.
        		if(GetPlotFlag(oTarget))
        		{
        		        SetLocalInt(oTarget, "PRC_OTILUKES_RS_ALREADYPLOT", 1);
        		}
        
        		else SetPlotFlag(oTarget, TRUE);
        	}
        }
}