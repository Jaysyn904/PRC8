//::///////////////////////////////////////////////
//:: Name      Ray of Hope
//:: FileName  sp_ray_hope.nss
//:://////////////////////////////////////////////
/**@file Ray of Hope
Enchantment (Compulsion) [Good, Mind-Affecting]
Level: Brd 1, Clr 1
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: 1 round/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

Powerful hope wells up in the subject, who gains a
+2 morale bonus on saving throws, attack rolls,
ability checks, and skill checks.

Author:    Tenjac
Created:   7/2/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    float fDur = RoundsToSeconds(nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    if(nTouch && PRCGetIsAliveCreature(oTarget))
    {
        effect eLink = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
               eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }

    //SPGoodShift(oPC);
    PRCSetSchool();
}








