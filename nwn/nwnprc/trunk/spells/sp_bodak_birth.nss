//::///////////////////////////////////////////////
//:: Name     Bodak Birth
//:: FileName sp_bodak_birth.nss
//:://////////////////////////////////////////////
/**@file Bodak Birth
Transmutation [Evil]
Level: Clr 8
Components: V S, F, Drug
Casting Time: 1 minute
Range: Touch
Target: Caster or one creature touched
Duration: Instantaneous
Saving Throw: None (see text)
Spell Resistance: No

The caster transforms one willing subject (which can
be the caster) into a bodak. Ignore all of the subject's
old characteristics, using the bodak description in
the Monster Manual instead.

Before casting the spell, the caster must make a miniature
figurine that represents the subject, then bathe it in the
blood of at least three Small or larger animals. Once the
spell is cast, anyone that holds the figurine can attempt
to mentally communicate and control the bodak, but the
creature resists such control with a successful Will saving
throw. If the bodak fails, it must obey the holder of the
figurine, but it gains a new saving throw every day to break
the control. If the figurine is destroyed, the bodak
disintegrates.

Focus: Figurine of subject, bathed in animal blood.

Drug Component: Agony

Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    //define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nType = MyPRCGetRacialType(oTarget);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    location lLoc = GetLocation(oTarget);
    effect eDeath = EffectDeath();

    PRCSignalSpellEvent(oTarget, FALSE, SPELL_BODAK_BIRTH, oPC);

    //Agony check
    if(GetPersistantLocalInt(oPC, "USING_AGONY"))
    {
        //"Willing" check
        if(PRCGetHasEffect(EFFECT_TYPE_DAZED, oTarget)
            || PRCGetHasEffect(EFFECT_TYPE_DOMINATED, oTarget)
            || PRCGetHasEffect(EFFECT_TYPE_PARALYZE, oTarget)
            || PRCGetHasEffect(EFFECT_TYPE_STUNNED, oTarget)
            || PRCGetHasEffect(EFFECT_TYPE_CHARMED, oTarget)
            || GetIsFriend(oTarget, oPC))

        {
            //Kill target
            DeathlessFrenzyCheck(oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);

            //Create Bodak
            object oBodak = CreateObject(OBJECT_TYPE_CREATURE, "nw_bodak", lLoc, FALSE);

            //Will save to avoid control
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oBodak, (PRCGetSaveDC(oBodak,oPC)), SAVING_THROW_TYPE_MIND_SPELLS, oPC, 1.0))
            {
                effect eDom = SupernaturalEffect(EffectCutsceneDominated());
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDom, oBodak);
            }
        }

    }
    //SPEvilShift(oPC);

    PRCSetSchool();
}