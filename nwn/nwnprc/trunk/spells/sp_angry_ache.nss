//::///////////////////////////////////////////////
//:: Name      Angry Ache
//:: FileName  sp_angry_ache.nss
//:://////////////////////////////////////////////
/**@file Angry Ache
Necromancy
Level: Asn 1, Clr 1, Pain 1
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: 1 minute/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster temporarily strains the subject's muscles
in a very specific way. The subject feels a sharp
pain whenever she makes an attack. All her attack
rolls have a -2 circumstance penalty for every four
caster levels (maximum penalty -10).

Author:    Tenjac
Created:   02/05/06
Modified:  X
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nPenetr = nCasterLvl + SPGetPenetr();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_ANGRY_ACHE, oPC);

    //Check Spell Resistance
    if(!PRCDoResistSpell(oPC, oTarget, nPenetr) && PRCGetIsAliveCreature(oTarget))
    {
        //Calculate DC
        int nDC = PRCGetSaveDC(oTarget, oPC);

        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
            int nMetaMagic = PRCGetMetaMagicFeat();
            float fDuration = TurnsToSeconds(nCasterLvl);
            if(nMetaMagic & METAMAGIC_EXTEND)
                fDuration *= 2;

            int nPenalty = nCasterLvl / 2;
            nPenalty = nPenalty > 10 ? 10 : nPenalty;

            //Construct effect
            effect ePenalty = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
            effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            effect eLink    = EffectLinkEffects(ePenalty, eDur);

            effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);

            //Apply Effect
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_ANGRY_ACHE, nCasterLvl);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }

    PRCSetSchool();
}