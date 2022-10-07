//::///////////////////////////////////////////////
//:: Name      Close Wounds
//:: FileName  sp_close_wounds.nss
//:://////////////////////////////////////////////
/** @file Close Wounds
Conjuration (Healing)
Level: Clr 3, Hlr 3
Components: V
Casting Time: 1 swift action
Range: Close
Target: One creature
Duration: Instantaneous
Saving Throw: Will half (harmless)
Spell Resistance: Yes (harmless)

This spell cures 2d4 points of damage. You can cast
this spell with an instant utterance.

Used against an undead creature, close wounds deals
damage instea of curing the creature (which takes half
damage if it makes a Will saving throw).
**/
//////////////////////////////////////////////////
// Author: Tenjac
// Date:   5.10.06
///////////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nHeal = d4(2);
    int nCasterLvl = PRCGetCasterLevel(oPC);

    if(nMetaMagic & METAMAGIC_MAXIMIZE)
        nHeal = 8;

    if(nMetaMagic & METAMAGIC_EMPOWER)
        nHeal += (nHeal/2);

    //Damage if undead
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
    || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
    {
        //SR
        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
        {
            //save for 1/2 dam
            nHeal += SpellDamagePerDice(oPC, 2);
            if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oPC), SAVING_THROW_TYPE_POSITIVE))
                nHeal = nHeal/2;

            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nHeal, DAMAGE_TYPE_POSITIVE), oTarget);
        }
    }
    else
    {
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal, oTarget), oTarget);
    }
    PRCSetSchool();
}