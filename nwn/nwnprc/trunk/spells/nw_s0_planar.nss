//::///////////////////////////////////////////////
//:: Planar Binding
//:: NW_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    effect eSummon;
    effect eGate;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eLink = EffectLinkEffects(eDur, EffectParalyze());
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eDur3);

    int nRacial = MyPRCGetRacialType(oTarget);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nDuration == 0)
    {
        nDuration == 1;
    }
    //Check for metamagic extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Check to make sure a target was selected
    if (GetIsObjectValid(oTarget))
    {
        //Check the racial type of the target
        if(nRacial == RACIAL_TYPE_OUTSIDER)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PLANAR_BINDING));
                //Make a Will save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, ((PRCGetSaveDC(oTarget,OBJECT_SELF))+2)))
                {
                    //Apply the linked effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration/2),TRUE,-1,CasterLvl);
                }
            }
        }
    }
    else
    {
        //Set the summon effect based on the alignment of the caster
        float fDelay = 3.0;
        switch (nAlign)
        {
            case ALIGNMENT_EVIL:
                eSummon = EffectSummonCreature("NW_S_SUCCUBUS",VFX_FNF_SUMMON_GATE, fDelay);
                //eGate = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
            break;
            case ALIGNMENT_GOOD:
                eSummon = EffectSummonCreature("NW_S_CHOUND", VFX_FNF_SUMMON_CELESTIAL, fDelay);
                //eGate = EffectVisualEffect(219);
            break;
            case ALIGNMENT_NEUTRAL:
                eSummon = EffectSummonCreature("NW_S_SLAADGRN",VFX_FNF_SUMMON_MONSTER_3, 1.0);
                //eGate = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
                //fDelay = 1.0;
            break;
        }
        //Apply the summon effect and VFX impact
        //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, PRCGetSpellTargetLocation());
        MultisummonPreSummon();
        float fDuration = HoursToSeconds(nDuration);
        if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
            fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

