//::///////////////////////////////////////////////
//:: Name      Tree Shape
//:: FileName  sp_treeshape.nss
//:://////////////////////////////////////////////
/** @file Tree Shape
Transmutation
Level: Drd 2, Rgr 3, Justice of Weald and Woe 2
Components: V, S
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level (D)

By means of this spell, you are able to assume the form of a Large living tree or
shrub or a Large dead tree trunk with a small number of limbs. The closest inspection
cannot reveal that the tree in question is actually a magically concealed
creature. To all normal tests you are, in fact, a tree or shrub, although a detect magic
spell reveals a faint transmutation on the tree. While in tree form, you can observe
all that transpires around you just as if you were in your normal form, and your hit
points and save bonuses remain unaffected. You gain a +10 natural armor
bonus to AC but have an effective Dexterity score of 0 and a speed of 0 feet. You are
immune to critical hits while in tree form. All clothing and gear carried or worn
changes with you. You can dismiss tree shape as a free action.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

        object oPC = OBJECT_SELF;
        int nRandom = d4();
        string sTree;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = HoursToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if (nMetaMagic & METAMAGIC_EXTEND)
        {
            fDur = (fDur * 2);
        }

        string sNewTag = "Tree" + GetName(oPC);
        effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

        switch(nRandom)
        {
                case 1: sTree = "x0_smallpine";
                break;

                case 2: sTree = "plc_treeautumn";
                break;

                case 3: sTree = "plc_tree";
                break;

                case 4: sTree = "x0_deadtree";
                break;
        }

        //Make invis, ghost, and immobile
        effect eLink = EffectLinkEffects(EffectCutsceneGhost(), EffectCutsceneParalyze());
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
        if(!GetIsInCombat(oPC)) eLink = EffectLinkEffects(eLink, EffectEthereal());
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);

        object oTree = CreateObject(OBJECT_TYPE_PLACEABLE, sTree, GetLocation(oPC), FALSE, sNewTag);
        DestroyObject(oTree, fDur);
        DelayCommand(fDur, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));

        PRCSetSchool();
}