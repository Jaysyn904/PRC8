//::///////////////////////////////////////////////
//:: Prismatic Spray
//:: [NW_S0_PrisSpray.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 19, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Last Updated By: Aidan Scanlan On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: June 11, 2001
//::///////////////////////////////////////////////
/*
Evocation
Level:  Sor/Wiz 7
Components: V, S
Casting Time:   1 standard action
Range:  60 ft.
Area:   Cone-shaped burst
Duration:   Instantaneous
Saving Throw:   See text
Spell Resistance:   Yes
This spell causes seven shimmering, intertwined, multicolored beams of light to spray from your hand. Each beam has a different power. Creatures in the area of the spell with 8 HD or less are automatically blinded for 2d4 rounds. Every creature in the area is randomly struck by one or more beams, which have additional effects:

1d8    Color of Beam       Effect

1      Red                 20 points fire damage(Reflex half)
2      Orange              40 points acid damage(Reflex half)
3      Yellow              80 points electricity damage (Reflex half)
4      Green               Poison (Kills; Fortitude partial, take 1d6 Con damage instead)
5      Blue                Turned to stone(Fortitude negates)
6      Indigo              Insane, as insanity spell (Will negates)
7      Violet              Sent to another plane(Will negates)
8      Two effects; roll twice more, ignoring any '8' results

Updated by AshLancer 1/22/2020 to be PnP accurate
*/
//:://////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget,int nDC,int CasterLvl);

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"
//:: left its elemental damage alone, since it's already determined randomly.




void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);



    int nMetaMagic = PRCGetMetaMagicFeat();
    int nRandom;
    int nHD;
    int nVisual;
    effect eVisual;
    int bTwoEffects;
    int nPenetr = CasterLvl + SPGetPenetr();

    //Set the delay to apply to effects based on the distance to the target
    float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
    //Get first target in the spell area
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 18.28f, PRCGetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));
            //Make an SR check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
            {
                 int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                //Blind the target if they are less than 9 HD
                nHD = GetHitDice(oTarget);
                if (nHD <= 8)
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(d4(2)),TRUE,-1,CasterLvl);
                }
                //Determine if 1 or 2 effects are going to be applied
                nRandom = d8();
                if(nRandom == 8)
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget,nDC,CasterLvl);
                    nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget,nDC,CasterLvl);
                }
                else
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(nRandom, oTarget,nDC,CasterLvl);
                }
                //Set the visual effect
                if(nVisual != 0)
                {
                    eVisual = EffectVisualEffect(nVisual);
                    //Apply the visual effect
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
            }
        }
        //Get next target in the spell area
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 18.28f, PRCGetSpellTargetLocation());
    }



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school

}

///////////////////////////////////////////////////////////////////////////////
//  ApplyPrismaticEffect
///////////////////////////////////////////////////////////////////////////////
/*  Given a reference integer and a target, this function will apply the effect
    of corresponding prismatic cone to the target.  To have any effect the
    reference integer (nEffect) must be from 1 to 7.*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan On: April 11, 2001
///////////////////////////////////////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget,int nDC,int CasterLvl)
{
    int nDamage;
    effect ePrism;
    effect eVis;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink;
    int nVis;
    float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
    PRCBonusDamage(oTarget);
    //Based on the random number passed in, apply the appropriate effect and set the visual to
    //the correct constant
    switch(nEffect)
    {
        case 1://fire
            nDamage = 20;
            //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
            nVis = VFX_IMP_FLAME_S;
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC,SAVING_THROW_TYPE_FIRE);
            ePrism = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 2: //Acid
            nDamage = 40;
            //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
            nVis = VFX_IMP_ACID_L;
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (nDC),SAVING_THROW_TYPE_ACID);
            ePrism = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_ACID);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 3: //Electricity
            nDamage = 80;
            //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
            nVis = VFX_IMP_LIGHTNING_S;
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (nDC),SAVING_THROW_TYPE_ELECTRICITY);
            ePrism = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_ELECTRICAL);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 4: //Poison
            {
                if (PRCGetIsAliveCreature(oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                {
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                    {
                        DeathlessFrenzyCheck(oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
                    }

                    else ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0);
                }
            }
        break;
        case 5: //Petrification
            {
                PRCDoPetrification(CasterLvl, OBJECT_SELF, oTarget, SPELL_PRISMATIC_SPRAY, nDC);
            }
        break;
        case 6: //Insanity
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

                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0, TRUE, -1, CasterLvl);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        break;
        case 7: //Banish
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
        break;
    }
    return nVis;
}

