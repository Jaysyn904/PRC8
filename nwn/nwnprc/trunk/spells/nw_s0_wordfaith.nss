//::///////////////////////////////////////////////
//:: Word of Faith
//:: [NW_S0_WordFaith.nss]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A 30ft blast of divine energy rushs out from the
    Cleric blasting all enemies with varying effects
    depending on their HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 5, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Sep 2002: fixed the 'level 8' instantkill problem
//:: description is slightly inaccurate but I won't change it
//:: Georg: It's nerf time! oh yes. The spell now matches it's description.


//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"  

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

    //DeleteLocalInt(OBJECT_SELF, "specific_spellschool_number");
    //SetLocalInt(OBJECT_SELF, "specific_spellschool_number",


    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


        //Declare major variables
        object oTarget;
        int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
 

        effect eBlind = EffectBlindness();
        effect eStun = EffectStunned();
        effect eConfuse = PRCEffectConfused();
        effect eDeath = EffectDeath();
        effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
        effect eSmite = EffectVisualEffect(VFX_FNF_WORD);
        effect eSonic = EffectVisualEffect(VFX_IMP_SONIC);
        effect eUnsummon =  EffectVisualEffect(VFX_IMP_UNSUMMON);
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eKill;
        effect eLink;
        int nHD;
        float fDelay;
        int nDuration = CasterLvl / 2;
        
        int nPenetr = CasterLvl + SPGetPenetr();
        
        //Apply the FNF VFX impact to the target location
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSmite, PRCGetSpellTargetLocation());
        //Get the first target in the spell area
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, PRCGetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            //Make a faction check
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                fDelay = PRCGetRandomDelay(0.5, 2.0);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WORD_OF_FAITH));
                //Make SR check
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
                {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSonic, oTarget);
                    //----------------------------------------------------------
                    //Check if the target is an outsider
                    //GZ: And do nothing anymore. This was not supposed to happen
                    //----------------------------------------------------------
                    /*if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL)
                    {
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummon, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }*/

                    ///----------------------------------------------------------
                    // And this is the part where the divine power smashes the
                    // unholy summoned creature and makes it return to its homeplane
                    //----------------------------------------------------------
                    if (GetIsObjectValid(GetMaster(oTarget)))
                    {
                        if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED)
                        {
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummon, oTarget));
                            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                            {
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                            }
                            else
                            {
                                eKill  = PRCEffectDamage(oTarget, GetCurrentHitPoints(oTarget)+10);
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            }
                         }
                    }
                    else
                    {
                        //Check the HD of the creature
                        nHD = GetHitDice(oTarget);
                        //Apply the appropriate effects based on HD
                        if (nHD >= 12)
                        {
                            eLink = EffectLinkEffects(eStun, eDur);
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
                        }
                        else if (nHD >= 8 && nHD < 12)
                        {
                            eLink = EffectLinkEffects(eStun, eMind);
                            eLink = EffectLinkEffects(eLink, eDur);
                            eLink = EffectLinkEffects(eLink, eBlind);

                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
                        }
                        else if (nHD > 4 && nHD < 8)
                        {
                            eLink = EffectLinkEffects(eStun, eMind);
                            eLink = EffectLinkEffects(eLink, eDur);
                            eLink = EffectLinkEffects(eLink, eConfuse);
                            eLink = EffectLinkEffects(eLink, eBlind);

                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
                        }
                        else
                        {
                           DeathlessFrenzyCheck(oTarget);
                           
                           if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                           {
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                           }
                           DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        }
                    }
                }
            }
            //Get the next target in the spell area
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, PRCGetSpellTargetLocation());
        }
        


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
