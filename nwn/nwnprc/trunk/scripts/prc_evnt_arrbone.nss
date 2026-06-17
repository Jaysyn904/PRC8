//::///////////////////////////////////////////////
//:: Name      Arrow of Bone event script
//:: FileName  prc_evnt_arrbone.nss
//:://////////////////////////////////////////////
/**@file Arrow of Bone
Necromancy [Death]
Level: Sorcerer/wizard 7
Components: V, S, M
Range: Touch
Target: One projectile or thrown weapon touched
Duration: 1 hour/level or until discharged
Saving Throw: Fortitude partial
Spell Resistance: Yes

You complete the ritual needed to
cast the spell, scribing arcane runes into
the item. It changes before your eyes into
an identical item made of bone. The runes
glow with dark magic and the weapon feels
cold to the touch.
When thrown or fired at a creature as a
normal ranged attack, the weapon gains
a +4 enhancement bonus on attack
rolls and damage rolls. In addition, any
living creature struck by an arrow of
bone must succeed on a Fortitude save
or be instantly slain. A creature that
makes its save instead takes 3d6 points
of damage +1 point per caster level
(maximum +20). Regardless of whether
the attack hits, the magic of the arrow
of bone is discharged by the attack, and
the missile is destroyed.

Material Component: A tiny sliver
of bone and an oil of magic weapon

Author:    Tenjac
Created:   6/28/07

Fixed by:	Jaysyn
Date:   	2026-06-12 07:51:09
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        object oSpellOrigin = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
        int nSaveDC = PRCGetSaveDC(oTarget,oSpellOrigin);
        object oItem = PRCGetSpellCastItem(oSpellOrigin);
        int nCasterLvl = PRCGetCasterLevel(oSpellOrigin);
        
        //SR check
        if(!PRCDoResistSpell(oSpellOrigin, oTarget, (nCasterLvl + SPGetPenetr())) && PRCGetIsAliveCreature(oTarget))
        {
                //Save
				if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_DEATH))  
				{  
					int nDam = d6(3) + PRCMin(20, nCasterLvl);  
					effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);  
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);  
				}				
/*                 if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_DEATH))
                {
                        int nDam = d6(3) + PRCMin(20, nCasterLvl);
                } */
                
                else
                {
                        //Kill it
                        effect eDeath = EffectDeath();
                        eDeath = SupernaturalEffect(eDeath);
                        
                        DeathlessFrenzyCheck(oTarget);
                        
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                }
        }
}