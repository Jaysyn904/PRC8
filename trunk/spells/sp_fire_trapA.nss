//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Fire Trap
Abjuration [Fire]
Level: Drd 2, Sor/Wiz 4 
Components: V, S, M 
Casting Time: 10 minutes 
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
#include "prc_add_spell_dc"

void main()
{
        object oTarget = GetEnteringObject();
        object oCaster = GetAreaOfEffectCreator();
        location lTarget = GetLocation(OBJECT_SELF);
        int nDam;
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nCasterLvl = PRCGetCasterLevel(oCaster);
        if(nCasterLvl > 20) nCasterLvl = 20;
        
        int nFire = GetLocalInt(OBJECT_SELF, "PRC_SPELL_FIRE_TRAP");
        
        int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE);
        
         effect eDam;
         effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
         effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
         //Check the faction of the entering object to make sure the entering object is not in the casters faction
         if(nFire == 0)
         {
                 if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                 {
                         SetLocalInt(OBJECT_SELF, "PRC_SPELL_FIRE_TRAP",TRUE);
                         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
                         //Cycle through the targets in the explosion area
                         oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
                         while(GetIsObjectValid(oTarget))
                         {
                                 if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                                 {
                                         //Fire cast spell at event for the specified target
                                         SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FIRE_TRAP));
                                         //Make SR check
                                         if(!PRCDoResistSpell(oCaster, oTarget,nCasterLvl + SPGetPenetr()))
                                         {
                                                 int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                                                 nDam = d4(1) + nCasterLvl;
                                                 if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                                                 {
                                                         nDam = 4 + nCasterLvl;
                                                 }
                                                 if ((nMetaMagic & METAMAGIC_EMPOWER)) nDam +=(nDam/2);
                                                 nDam += SpellDamagePerDice(oCaster, 1);

                                                 //nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                                                 //Change damage according to Reflex, Evasion and Improved Evasion
                                                 nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nDC, SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
                                                 //Set up the damage effect
                                                 eDam = PRCEffectDamage(oTarget, nDam, EleDmg);
                                                 if(nDam > 0)
                                                 {
                                                         //Apply VFX impact and damage effect
                                                         SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                                                         DelayCommand(0.01, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                                                         PRCBonusDamage(oTarget);
                                                 }
                                         }
                                 }
                                 //Get next target in the sequence
                                 oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
                         }
                         DestroyObject(OBJECT_SELF, 1.0);
                 }
         }
         PRCSetSchool();
}
