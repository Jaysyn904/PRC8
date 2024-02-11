//:://////////////////////////////////////////////
//:: Name     Forceward
//:: FileName   sp_forceward.nss
//:://////////////////////////////////////////////
/** @file Abjuration
Level: Cleric 3 (Helm), Paladin 3, Knight of the Weave 3,
Components: V, S, DF,
Casting Time: 1 full round
Range: 10 ft.
Area: 10-ft.-radius emanation centered on you
Duration: 1 minute/level
Saving Throw: Will negates
Spell Resistance: Yes

You create an unmoving, transparent sphere of force 
centered on your location.
The sphere illuminates its interior and everything 
within 5 feet of its edge.
You and your allies may enter the sphere at will.
Any other creature that tries to enter the sphere must 
make a Will saving throw, otherwise it cannot pass into
the area defined by the sphere.
A creature may leave the area freely, although it must
make a Will save to enter again, even if the creature 
is you or one of your allies.
Creatures within the area when the spell is cast are not
forced out.
The forceward does not prevent spells or objects from 
entering the forceward, so it is possible for two creatures
on opposite sides of the forceward's edge to fight without
penalties (although creatures using unarmed attacks or 
natural weapons still have tomake Will saves every round
for their attacks to have a chance of entering the forceward).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 07/04/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        location lLoc = GetLocation(oPC);
        
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_PER_FORCEWARD), lLoc, fDur);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_ORANGE_15), lLoc, fDur);
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 3.048f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
        	SetLocalInt(oTarget, "PRCForcewardEntry", 1)
        	oTarget = MyNextObjectInShape(SHAPE_SPHERE, 3.048f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        }
        
        PRCSetSchool();
}