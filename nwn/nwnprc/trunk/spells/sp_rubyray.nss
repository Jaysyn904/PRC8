//::////////////////////////////////////////////////////////
//::
/*	
	Ruby Ray of Reversal (sp_rubyray.nss)
	Abjuration
	Level: 				Sorcerer 6, Wizard 6,
	Components: 		V, S, AF,
	Casting Time: 		1 standard action
	Range: 				Medium (100 ft. + 10 ft./level)
	Target: 			One natural or magical hazard; see text
	Duration: 			Instantaneous
	Saving Throw: 		None
	Spell Resistance: 	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	From your fingertips springs a thin line of bright red 
	light to negate the hazard before you.

	Each version of this spell can target one of the hazards
	described below and "correct" it in the manner described.
	Unless specifically stated otherwise, this spell affects 
	magical and mundane hazards of the indicated type equally. 
	For example, a ruby ray of reversal can eliminate the 
	webs of a monstrous spider or the effect of a web spell.

    Any trap targeted by the ray is sprung. This version of 
	the spell can have adverse effects on creatures standing 
	within a trap's area. You must be aware of a trap to cast 
	ruby ray of reversal on it.

    The spell unties knots and causes chains, manacles, and 
	similar restraining devices to fall away. Entangle and 
	similar magical effects are dispelled. Doors (or chests, 
	drawers, cabinets, and so on) that are locked, barred, 
	or under the effect of an arcane lock spell are opened.

    A 5-foot-diameter hole is created in a wall of force, 
	forcecage, or similar spell or effect. This function of 
	the spell does not destroy the targeted effect, but 
	creatures trapped by it might be able to wriggle free.

    A creature that has been polymorphed, turned to stone, 
	or otherwise transformed from its natural state is 
	returned to its natural form.

    A magic jar spell is dispelled if a ruby ray of reversal 
	targets the crystal holding the caster's soul.

    Webs, slime, grease, and other substances that would hamper 
	movement are destroyed in a 20-foot- radius spread.

	Focus: A ruby worth at least 500 gp.
	

	- Trap object/trigger: sprung (revealed + disabled —  
		NWN can't force-fire a trap's effect).  
	- Locked door/placeable: opened (unties knots, breaks  
		arcane lock, drops restraints).  
	- Wall of force placeable (PRC_WALL_OF_FORCE flag):  
		"hole" ˜ removed so captives wriggle free.  
	- Creature: removes polymorph/petrify/entangle/trans-  
		formation effects, restoring natural form.  
	- Location/miss: clears web/grease/slime AoEs in a  
		20-ft spread.
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-07 23:47:43
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
  
// Webs, slime, grease, and other movement-hampering AoEs.  
// Tags resolved from vfx_persistent.2da LABELs at runtime.  
// Caltrops use the generic VFX_CUSTOM row (37), so they're  
// identified by the X0_L_IMPACT local their script stores.  
int GetIsHamperingAoE(object oAoE)  
{  
    string sTag = GetTag(oAoE);  
  
    if (sTag == Get2DACache("vfx_persistent", "LABEL", AOE_PER_WEB)                    // 8  
     || sTag == Get2DACache("vfx_persistent", "LABEL", AOE_PER_GREASE)                 // 32  
     || sTag == Get2DACache("vfx_persistent", "LABEL", AOE_PER_ENTANGLE)               // 9  
     || sTag == Get2DACache("vfx_persistent", "LABEL", AOE_PER_CREEPING_DOOM)          // 33  
     || sTag == Get2DACache("vfx_persistent", "LABEL", AOE_PER_STONEHOLD)              // 42  
     || sTag == Get2DACache("vfx_persistent", "LABEL", AOE_PER_SOLID_FOG)              // 179  
     || sTag == Get2DACache("vfx_persistent", "LABEL", VFX_PER_SNARE)                  // 168  
     || sTag == Get2DACache("vfx_persistent", "LABEL", VFX_PER_SLEET_STORM)            // 175  
     || sTag == Get2DACache("vfx_persistent", "LABEL", AOE_PER_PSIGREASE))             // 131  
        return TRUE;  
  
    // Caltrops: VFX_CUSTOM tag + linked impact placeable  
    if (sTag == Get2DACache("vfx_persistent", "LABEL", 37)               // VFX_CUSTOM  
     && GetIsObjectValid(GetLocalObject(oAoE, "X0_L_IMPACT")))  
        return TRUE;  
  
    return FALSE;  
}  
  
// Strips transformation/movement-hampering effects.  
void ReverseTransformation(object oTarget)  
{  
    effect e = GetFirstEffect(oTarget);  
    while (GetIsEffectValid(e))  
    {  
        int nType = GetEffectType(e);  
        if (nType == EFFECT_TYPE_POLYMORPH  
         || nType == EFFECT_TYPE_PETRIFY  
         || nType == EFFECT_TYPE_ENTANGLE  
         || nType == EFFECT_TYPE_PARALYZE  
         || nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE  
         || nType == EFFECT_TYPE_SLOW  
         || nType == EFFECT_TYPE_CUTSCENEIMMOBILIZE  
         || nType == EFFECT_TYPE_CUTSCENE_PARALYZE)  
        {  
            RemoveEffect(oTarget, e);  
        }  
        e = GetNextEffect(oTarget);  
    }  
    ApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);  
}  
  
void ClearSubstances(location lTarget)  
{  
    int nCleared = 0;  
    object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE,  
        lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);  
    while (GetIsObjectValid(oAoE))  
    {  
        if (GetIsHamperingAoE(oAoE))  
        {  
            DestroyObject(oAoE);  
            nCleared++;  
        }  
        oAoE = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE,  
            lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);  
    }  
    if (!nCleared)  
        FloatingTextStringOnCreature("*Nothing to reverse.*",  
            OBJECT_SELF, FALSE);  
}  
  
void main()  
{  
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    object oCaster  = OBJECT_SELF;  
    object oTarget  = PRCGetSpellTargetObject();  
    location lTarget = PRCGetSpellTargetLocation();  
    int nType       = GetObjectType(oTarget);  
    effect eBeam    = EffectBeam(VFX_BEAM_EVIL, oCaster, BODY_NODE_HAND);  
  
    PRCSignalSpellEvent(oTarget, FALSE, PRCGetSpellId(), oCaster);  
  
    if (GetIsObjectValid(oTarget))  
    {  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0);  
  
        // ---- Traps: sprung (must already be detected) ----  
        if (GetIsTrapped(oTarget) || GetObjectType(oTarget) == OBJECT_TYPE_TRIGGER)  
        {  
            if (GetTrapDetectedBy(oTarget, oCaster) || GetTrapDetectable(oTarget))  
            {  
                SetTrapDisabled(oTarget);  
                FloatingTextStringOnCreature("*Trap sprung.*", oCaster, FALSE);  
            }  
            else  
                FloatingTextStringOnCreature(  
                    "*You are not aware of any trap here.*", oCaster, FALSE);  
        }  
        // ---- Wall of Force: punch a hole ----  
        else if (nType == OBJECT_TYPE_PLACEABLE  
                 && GetLocalInt(oTarget, "PRC_WALL_OF_FORCE"))  
        {  
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,  
                EffectVisualEffect(VFX_IMP_DISPEL), GetLocation(oTarget));  
            SetPlotFlag(oTarget, FALSE);  
            DestroyObject(oTarget);  
            FloatingTextStringOnCreature(  
                "*A hole opens in the wall of force.*", oCaster, FALSE);  
        }  
        // ---- Locked doors/containers: opened ----  
        else if (nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE)  
        {  
            if (GetLocked(oTarget))  
            {  
                AssignCommand(oTarget, ActionUnlockObject(oTarget));  
                if (nType == OBJECT_TYPE_DOOR)  
                    AssignCommand(oTarget, ActionOpenDoor(oTarget));  
                else  
                    AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_OPEN));  
            }  
            else  
                FloatingTextStringOnCreature("*Not locked.*", oCaster, FALSE);  
        }  
        // ---- Creature: reverse transformation ----  
        else if (nType == OBJECT_TYPE_CREATURE)  
        {  
            ReverseTransformation(oTarget);  
            // To Add Later: Magic jar support
        }  
        else  
        {  
            FloatingTextStringOnCreature(  
                "*No reversible hazard there.*", oCaster, FALSE);  
        }  
    }  
    else  
    {  
        // ---- Ground target: purge webs/slime/grease ----  
        ClearSubstances(lTarget);  
    }  
  
    PRCSetSchool();  
}