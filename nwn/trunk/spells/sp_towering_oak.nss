//::///////////////////////////////////////////////
//:: Name      Towering Oak
//:: FileName  sp_towering_oak.nss
//:://////////////////////////////////////////////
/**@file Towering Oak
Illusion (Glamer)
Level: Ranger 1
Components: V, S
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round/level

You draw on the oak’s strength to
improve your ability to intimidate your
enemies. You gain a +10 competence
bonus on Intimidate checks and a +2
enhancement bonus to Strength.

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_ILLUSION);
        
        object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = RoundsToSeconds(nCasterLvl);
                
        effect eLink = EffectSkillIncrease(SKILL_INTIMIDATE, 10);
        effect eSTR = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
               eLink = EffectLinkEffects(eLink, eSTR);
               
        //Apply VFX - Green impact with <3 second wood texture - use nature summoning anims
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_NATURE), oPC);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN), oPC, 2.75f, TRUE, SPELL_TOWERING_OAK, nCasterLvl);
        
        //Apply bonuses
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        
        PRCSetSchool();
}