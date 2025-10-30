//::///////////////////////////////////////////////
//:: Name      Prismatic Wall On Enter
//:: FileName  sp_prism_wallA.nss
//:://////////////////////////////////////////////
/**@file Prismatic Wall
Abjuration
Level: Sor/Wiz 8
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Effect: Wall 4 ft./level wide, 2 ft./level high
Duration: 10 min./level (D)
Saving Throw: See text
Spell Resistance: See text

Prismatic wall creates a vertical, opaque wall; a
shimmering, multicolored plane of light that
protects you from all forms of attack. The wall
flashes with seven colors, each of which has a
distinct power and purpose. The wall is immobile,
and you can pass through and remain near the wall
without harm. However, any other creature with
less than 8 HD that is within 20 feet of the wall
is blinded for 2d4 rounds by the colors if it
looks at the wall.

The wall�s maximum proportions are 4 feet wide per
caster level and 2 feet high per caster level. A
prismatic wall spell cast to materialize in a
space occupied by a creature is disrupted, and
the spell is wasted.

Each color in the wall has a special effect. The
accompanying table shows the seven colors of the
wall, the order in which they appear, their
effects on creatures trying to attack you or pass
through the wall, and the magic needed to negate
each color.

The wall can be destroyed, color by color, in
consecutive order, by various magical effects;
however, the first color must be brought down
before the second can be affected, and so on.
A rod of cancellation or a mage�s disjunction
spell destroys a prismatic wall, but an
antimagic field fails to penetrate it. Dispel
magic and greater dispel magic cannot dispel
the wall or anything beyond it. Spell resistance
is effective against a prismatic wall, but the
caster level check must be repeated for each
color present.

Color   Order   Effect of Color

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
                                // makes the target invisible
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oTarget, 6.0);
                                // allows pathfinding through the target
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oTarget, 6.0);
                                // paralyzes the target, ignores immunity
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oTarget, 6.0);
                                // save the target location for later visual effect
                                location lLoc = GetLocation(oTarget);

                                // separate player targets from NPCs
                                if(GetIsPC(oTarget))
                                {
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
                                        // allow respawn, but not wait for help since sent away
                                        // also if not letting respawn and cannot reload, the player cannot continue via GUI
                                        DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, TRUE , FALSE, nTalk));
                                        DelayCommand(2.75, ExecuteScript("prc_ondeath", oTarget));
                                }
                                else
                                {
                                        // Target is not a player
                                        // To simplify against NPCs and also reward xp, applies same death as Green color
                                        DeathlessFrenzyCheck(oTarget);
                                        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
                                }
                                // a visual effect for banishment
                                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), lLoc);
                        }
                }
        }
}
