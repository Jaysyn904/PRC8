//::///////////////////////////////////////////////
//:: Name      Heart Ripper
//:: FileName  sp_heart_ripr
//:://////////////////////////////////////////////
/**@file Heart Ripper
Necromancy [Death]
Level: Assassin 4
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

Invisible bolts of force instantly slay
the target you designate by driving its
heart from its body unless it succeeds
on a Fortitude save. If the target has
HD higher than your caster level, it
does not die on a failed saving throw,
but instead is stunned for 1d4 rounds.
Creatures that don’t depend on their
hearts for survival, creatures with no
anatomy, and creatures immune to
extra damage from critical hits are
unaffected by the spell.

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
                
        int nType = MyPRCGetRacialType(oTarget);
        
        if(nType == RACIAL_TYPE_UNDEAD ||
        nType == RACIAL_TYPE_ELEMENTAL ||
        nType == RACIAL_TYPE_CONSTRUCT ||
        GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
        
        {
                SendMessageToPC(oPC, "Target creature is immune to the effects of this spell.");
                PRCSetSchool();
                return;
        }
        
        //SR check
        if(!PRCDoResistSpell(oPC, oTarget, (nCasterLvl + SPGetPenetr())))
        {		
                //Save                                       
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oPC), SAVING_THROW_TYPE_DEATH))
                {
                        //Check HD
                        int nHD = GetHitDice(oTarget);
                        
                        if(nHD > nCasterLvl)
                        {
                                int nStun = d4(1);
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(nStun), TRUE, SPELL_HEART_RIPPER, nCasterLvl);
                        }
                        
                        else
                        {
                                //Kill it.  Chunkaliciously.
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM), oTarget);
                                
                                effect eDeath = EffectDeath();
                                SupernaturalEffect(eDeath);
                                
                                DeathlessFrenzyCheck(oTarget);
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                        }
                }
        }
        PRCSetSchool();
}