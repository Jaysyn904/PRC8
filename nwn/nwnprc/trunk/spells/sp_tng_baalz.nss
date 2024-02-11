//::///////////////////////////////////////////////
//:: Name      Tongue of Baalzebul
//:: FileName  sp_tng_baalz.nss
//:://////////////////////////////////////////////
/**@file Tongue of Baalzebul 
Transmutation [Evil] 
Level: Clr 1 
Components: V, S, M, Drug 
Casting Time: 1 full round
Range: Personal 
Target: Caster 
Duration: 1 hour/level

The caster gains the ability to lie, seduce and 
beguile with devil's skill. He gains a +2 competence
bonus on Bluff, Diplomacy, and Gather information 
checks.

Material Component: A tongue from any creature 
capable of speech.

Drug Component: Mushroom powder. 

Author:    Tenjac
Created:   5/8/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //spellhook
    if(!X2PreSpellCastCode()) return;

    //if(is using mushroom powder)
    if(!GetHasSpellEffect(SPELL_MUSHROOM_POWDER))
    {
        FloatingTextStringOnCreature("You need to be under effect of mushroom powder to cast this spell", OBJECT_SELF, FALSE);
        return;
    }

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //var
    int nCasterLvl = PRCGetCasterLevel();
    float fDur = HoursToSeconds(nCasterLvl);

    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        fDur *= 2;

    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_BLUFF, 2), EffectSkillIncrease(SKILL_PERSUADE, 2));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDur, TRUE, SPELL_BARKSKIN, nCasterLvl);

    //SPEvilShift(OBJECT_SELF);

    PRCSetSchool();
}