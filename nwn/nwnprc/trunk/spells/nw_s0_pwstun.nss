//::///////////////////////////////////////////////
//:: [Power Word Stun]
//:: [NW_S0_PWStun.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature is stunned for a certain number of
    rounds depending on its HP.  No save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 4, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.28
- =151HP stunned for 4d4 rounds
- >151HP sometimes stunned for indefinit duration
*/

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"





void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
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
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    object oTarget = PRCGetSpellTargetObject();
    int nHP =  GetCurrentHitPoints(oTarget);
    effect eStun = EffectStunned();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eLink = EffectLinkEffects(eMind, eStun);
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eWord = EffectVisualEffect(VFX_FNF_PWSTUN);
    int nDuration;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nMeta;
    //Apply the VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWord, PRCGetSpellTargetLocation());
    //Determine the number rounds the creature will be stunned
    if (nHP >= 151)
    {
        nDuration = 0;
        nMeta = 0;
    }
    else if (nHP >= 101 && nHP <= 150)
    {
        nDuration = d4(1);
        nMeta = 4;
    }
    else if (nHP >= 51  && nHP <= 100)
    {
        nDuration = d4(2);
        nMeta = 8;
    }
    else
    {
        nDuration = d4(4);
        nMeta = 16;
    }

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nDuration = nMeta;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_STUN));
        //Make an SR check
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget))
        {
            if (nDuration>0)
            {
                //Apply linked effect and the VFX impact
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

