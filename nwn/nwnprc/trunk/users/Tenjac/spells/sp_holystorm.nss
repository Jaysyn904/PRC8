//:://////////////////////////////////////////////
//:: Name     Holy Storm
//:: FileName   sp_holystorm.nss
//:://////////////////////////////////////////////
/** @file 
Conjuration (Creation) [Good, Water]
Level: Cleric 3, Paladin 3,
Components: V, S, M, DF,
Casting Time: 1 standard action
Range: 20 ft.
Area: Cylinder (20-ft. radius, 20 ft. high)
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: No

You call upon the forces of good, and a heavy rain begins to fall
around you, its raindrops soft and warm.

A driving rain falls around you. It falls in a fixed area once 
created. The storm reduces hearing and visibility, resulting in a 
-4 penalty on Listen, Spot, and Search checks. It also applies a
-4 penalty on ranged attacks made into, out of, or through the 
storm. Finally, it automatically extinguishes any unprotected 
flames and has a 50% chance to extinguish protected flames 
(such as those of lanterns).

The rain damages evil creatures, dealing 2d6 points of damage 
per round (evil outsiders take double damage) at the beginning
of your turn.

Material Component: A flask of holy water (25 gp).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/9/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
                
        //VFX
        effect eVis = EffectVisualEffect(VFX_FNF_STORM);
        
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_PER_STORM, "sp_holystormA", "sp_holystormB", "sp_holystormC"), lTarget, fDur);
        
        object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_STORM");
        SetAllAoEInts(SPELL_HOLY_STORM, oAoE, PRCGetSpellSaveDC(SPELL_HOLY_STORM, SPELL_SCHOOL_CONJURATION), 0, PRCGetCasterLevel(oPC));
        
        PRCSetSchool();
}