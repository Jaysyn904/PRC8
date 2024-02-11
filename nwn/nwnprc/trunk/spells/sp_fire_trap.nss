//::///////////////////////////////////////////////
//:: Name      Fire Trap
//:: FileName  sp_fire_trap.nss
//:://////////////////////////////////////////////
/**@file Fire Trap
Abjuration [Fire]
Level: Drd 2, Sor/Wiz 4 
Components: V, S, M 
Range: Touch 
Target: Area
Duration: Permanent until discharged (D) 
Saving Throw: Reflex half; see text 
Spell Resistance: Yes

Fire trap creates a fiery explosion when an intruder
enters the area that the trap protects.

When casting fire trap, you select a point as the spell’s 
center. When someone other than you gets too close to that 
point, a fiery explosion fills the area within a 5-foot radius around
the spell’s center. The flames deal 1d4 points of fire damage +1
point per caster level (maximum +20). 

An unsuccessful dispel magic spell does not detonate the 
spell.

Underwater, this ward deals half damage and creates a 
large cloud of steam.

Material Component: A half-pound of gold dust (cost 25 gp)
sprinkled on the warded object.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_ABJURATION);
        
        object oPC = OBJECT_SELF;
        location lTarget = PRCGetSpellTargetLocation();
        effect eAoE = EffectAreaOfEffect(AOE_PER_FIRE_TRAP);
        
        ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAoE, lTarget);
        
        PRCSetSchool();
}        