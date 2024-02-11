//::///////////////////////////////////////////////
//:: Name      Shriveling
//:: FileName  sp_shriveling.nss
//:://////////////////////////////////////////////
/**@file Shriveling
Necromancy [Evil]
Level: Clr 3, Sor/Wiz 2
Components: V, S, Disease
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

The caster channels dark energy that blasts and
blackens the subject's flesh. The subject takes
1d4 points of damage per caster level (maximum 10d4).

Disease Component: Soul rot.

Author:    Tenjac
Created:   05/04/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

int GetHasSoulRot(object oPC);

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDC = PRCGetSaveDC(oTarget, oPC);

    //spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    PRCSignalSpellEvent(oTarget,TRUE, SPELL_SHRIVELING, oPC);

    //Check for Soul rot
    if(!GetHasSoulRot(oPC))
    {
            SendMessageToPC(oPC, "This spell requires the caster to have the Soul Rot disease.");
            PRCSetSchool();
            return;
    }

    //SR
    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()) && PRCGetIsAliveCreature(oTarget))
    {
            int nDam = d4(min(nCasterLvl, 10));

            //eval metamagic
            if(nMetaMagic & METAMAGIC_MAXIMIZE)
            {
                    nDam = 4 * (min(nCasterLvl, 10));
            }

            if(nMetaMagic & METAMAGIC_EMPOWER)
            {
                    nDam += (nDam/2);
            }

            //Check for save
            if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                    nDam = nDam/2;
            }
			nDam += SpellDamagePerDice(oPC, min(nCasterLvl, 10));
            effect eVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);

            //Apply damage & visual
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    //SPEvilShift(oPC);
    PRCSetSchool();
}


int GetHasSoulRot(object oPC)
{
    int bHasDisease = FALSE;
    effect eTest = GetFirstEffect(oPC);
    effect eDisease = EffectDisease(DISEASE_SOUL_ROT);

    if (PRCGetHasEffect(EFFECT_TYPE_DISEASE, oPC))
    {
        while (GetIsEffectValid(eTest))
        {
            if(eTest == eDisease)
            {
                bHasDisease = TRUE;

            }
            eTest = GetNextEffect(oPC);
        }
    }
    return bHasDisease;
}