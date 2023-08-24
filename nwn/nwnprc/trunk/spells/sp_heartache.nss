//::///////////////////////////////////////////////
//:: Name      Heartache
//:: FileName  sp_heartache.nss
//:://////////////////////////////////////////////
/**@file Heartache
Enchantment [Evil, Mind-Affecting]
Level: Clr 1, Mortal Hunter 1
Components: V, S, DF
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: 1 round
Saving Throw: Will negates
Spell Resistance: Yes

The caster fills the subject with heart wrenching
sorrow that renders it incapacitated for 1 round.
The subject cannot move or take actions and is
helpless for that round.

Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    //Spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    float fDur = 6.0f;
    int nMetaMagic = PRCGetMetaMagicFeat();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_HEARTACHE, oPC);

    //Spell Resistance
    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        //Save
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
        {
            //eval metamagic
            if (nMetaMagic & METAMAGIC_EXTEND)
            {
                fDur = (fDur * 2);
            }

            effect ePar = EffectCutsceneParalyze();
            effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE), ePar);

            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
        }
    }

    //SPEvilShift(oPC);
    PRCSetSchool();
}

