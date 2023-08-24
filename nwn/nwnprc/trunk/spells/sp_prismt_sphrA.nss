//::///////////////////////////////////////////////
//:: Name      Prismatic Sphere on enter
//:: FileName  sp_prismt_sphrA.nss
//:://////////////////////////////////////////////
/**@file Prismatic Sphere
Abjuration
Level: Protection 9, Sor/Wiz 9, Sun 9
Components: V
Range: 10 ft.
Effect: 10-ft.-radius sphere centered on you

This spell functions like prismatic wall, except you
conjure up an immobile, opaque globe of shimmering,
multicolored light that surrounds you and protects
you from all forms of attack. The sphere flashes in
all colors of the visible spectrum.

The sphere’s blindness effect on creatures with less
than 8 HD lasts 2d4x10 minutes.

You can pass into and out of the prismatic sphere and
remain near it without harm. However, when you’re
inside it, the sphere blocks any attempt to project
something through the sphere (including spells). Other
creatures that attempt to attack you or pass through
suffer the effects of each color, one at a time.

Typically, only the upper hemisphere of the globe will
exist, since you are at the center of the sphere, so
the lower half is usually excluded by the floor surface
you are standing on.

The colors of the sphere have the same effects as the
colors of a prismatic wall.

Red     1st     Deals 20 points of fire damage (Reflex half).
Orange  2nd     Deals 40 points of acid damage (Reflex half).
Yellow  3rd     Deals 80 points of electricity damage (Reflex half).
Green   4th     Poison (Kills; Fortitude partial for 1d6 points of Con damage instead).
Blue    5th     Turned to stone (Fortitude negates).
Indigo  6th     Will save or become insane (as insanity spell).
Violet  7th     Creatures sent to another plane (Will negates).

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
        object oPC = GetAreaOfEffectCreator();
        object oTarget = GetEnteringObject();
        int nDC = PRCGetSaveDC(oTarget, oPC);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDam;
        int nPenetr =  nCasterLvl + SPGetPenetr();

        //Passing into the wall
        SetLocalInt(oTarget, "PRC_INSIDE_PRISMATIC_SPHERE", 1);

        if(!GetIsReactionTypeFriendly(oTarget, oPC) && (oTarget != oPC))
        {
                //Red
                if(!PRCDoResistSpell(oPC, oTarget,nPenetr))
                {
                        nDam = 20;

                        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
                        {
                                nDam = 10;
                        }

                        ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FIRE), oTarget);
                }

                //Orange
                if(!PRCDoResistSpell(oPC, oTarget, nPenetr))
                {
                        nDam = 40;

                        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ACID))
                        {
                                nDam = 20;
                        }

                        ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_ACID), oTarget);
                }

                //Yellow
                if(!PRCDoResistSpell(oPC, oTarget, nPenetr))
                {
                        nDam = 80;

                        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY))
                        {
                                nDam = 40;
                        }

                        ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_ELECTRICAL), oTarget);
                }

                //Green
                if (PRCGetIsAliveCreature(oTarget) && (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE))
                {
                    if(!PRCDoResistSpell(oPC, oTarget, nPenetr))
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                        {
                                DeathlessFrenzyCheck(oTarget);
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
                        }

                        else ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0);
                    }
                }

                //Blue
                if(!PRCDoResistSpell(oPC, oTarget, nPenetr)) PRCDoPetrification(nCasterLvl, oPC, oTarget, SPELL_PRISMATIC_RAY, nDC);

                //Indigo
                if(!PRCDoResistSpell(oPC, oTarget, nPenetr))
                {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        {
                                effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
                                effect eConfuse = PRCEffectConfused();
                                effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                                effect eLink = EffectLinkEffects(eMind, eConfuse);
                                eLink = EffectLinkEffects(eLink, eDur);
                                eLink = SupernaturalEffect(eLink);

                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0, TRUE, SPELL_PRISMATIC_SPHERE, nCasterLvl);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }
                }

                //Violet
                if(!PRCDoResistSpell(oPC, oTarget, nPenetr))
                {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        {
                                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oTarget);
                                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oTarget);
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget);

                                int nMessageRoll = d6(1);
                                int nTalk;

                                switch(nMessageRoll)
                                {
                                        case 1:
                                        {
                                                nTalk = 1729332;
                                                break;
                                        }

                                        case 2:
                                        {
                                                nTalk = 1729333;
                                                break;
                                        }

                                        case 3:
                                        {
                                                nTalk = 1729334;
                                                break;
                                        }

                                        case 4:
                                        {
                                                nTalk = 1729335;
                                                break;
                                        }

                                        case 5:
                                        {
                                                nTalk = 1729336;
                                                break;
                                        }

                                        case 6:
                                        {
                                                nTalk = 1729337;
                                                break;
                                        }
                                }
                                //Death Popup
                                DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, nTalk));
                                DelayCommand(2.75, ExecuteScript("prc_ondeath", oTarget));
                        }
                }
        }
}


















