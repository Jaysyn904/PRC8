//::///////////////////////////////////////////////
//:: Holy Word
//:: [sp_holyword.nss]
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
//:: Primogenitor: Split into the 4 alingment versions

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"

#include "prc_alterations"
#include "prc_add_spell_dc"

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

    effect eDeaf = EffectDeaf();
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
    int n35ed = GetPRCSwitch(PRC_35ED_WORD_OF_FAITH);

    int nPenetr = CasterLvl + SPGetPenetr();

    //Apply the FNF VFX impact to the target location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSmite, PRCGetSpellTargetLocation());
    //Get the first target in the spell area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, PRCGetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        //Make a faction check
        //and an alignment one
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
            && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
        {
            fDelay = PRCGetRandomDelay(0.5, 2.0);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLY_WORD));
            //Make SR check
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSonic, oTarget);

                ///----------------------------------------------------------
                // And this is the part where the divine power smashes the
                // unholy summoned creature and makes it return to its homeplane
                //----------------------------------------------------------
                if (GetIsObjectValid(GetMaster(oTarget)))
                {
                    if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED)
                    {
                        DeathlessFrenzyCheck(oTarget);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummon, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eDeath), oTarget));
                     }
                }
                else if(!PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))
                {
                    //Check the HD of the creature
                    nHD = GetHitDice(oTarget);
                    //Apply the appropriate effects based on HD
                        // deafness 1d4 rounds
                    eLink = EffectLinkEffects(eDur, eDeaf);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d4()),TRUE,-1,CasterLvl));
                    if ((nHD < 12 && !n35ed)
                    || (n35ed && nHD < CasterLvl))
                    {
                        //stunned 1 round
                        eLink = EffectLinkEffects(eMind, eStun);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1),TRUE,-1,CasterLvl));
                    }
                    if ((nHD < 8 && n35ed)
                    || (n35ed && nHD < CasterLvl-5))
                    {
                        //confusion 1d10 minutes
                        eLink = EffectLinkEffects(eSonic, eConfuse);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(d10()),TRUE,-1,CasterLvl));
                    }
                    if((nHD < 4 && n35ed)
                    || (n35ed && nHD < CasterLvl-10))
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
