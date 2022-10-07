//::///////////////////////////////////////////////
//:: [Power Word Blind]
//:: [SP_PWBlind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
Enchantment (Compulsion) [Mind-Affecting]
Level: Sor/Wiz 7, War 7
Components: V
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature with 200 hp or less
Duration: See text
Saving Throw: None
Spell Resistance: Yes

You utter a single word of power that causes one
creature of your choice to become blinded, whether
the creature can hear the word or not. The
duration of the spell depends on the target’s
current hit point total. Any creature that
currently has 201 or more hit points is unaffected
by power word blind.

Hit Points  Duration
50 or less  Permanent
51-100      1d4+1 minutes
101-200     1d4+1 rounds

*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    object oTarget = PRCGetSpellTargetObject();
    int nHP =  GetCurrentHitPoints(oTarget);
    effect eBlind = EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDur, eBlind);
    //effect eVis = EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_RED);
    effect eWord = EffectVisualEffect(VFX_IMP_PWBLIND);
    int nState; // 1 - affected, 2 - permanent effect
    float fDuration, fMeta;
    int nMetaMagic = PRCGetMetaMagicFeat();

    //Apply the VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWord, PRCGetSpellTargetLocation());

    //Determine the duration
    if (nHP >= 201)
    {
        nState = 0;//not affected
    }
    else if (nHP >= 101 && nHP <= 150)
    {
        fDuration = RoundsToSeconds(d4(1));
        fMeta = 30.0f;
    }
    else if (nHP >= 51  && nHP <= 100)
    {
        fDuration = TurnsToSeconds(d4(1));
        fMeta = 300.0f;
    }
    else
    {
        nState = 2;//permanent
    }

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        fDuration = fMeta;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        fDuration = fDuration + (fDuration/2); //Damage/Healing is +50%
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fDuration = fDuration * 2;  //Duration is +100%
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_BLIND));
        //Make an SR check
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget))
        {
            if(nState > 0)
            {
                //Apply linked effect and the VFX impact
                //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                if(nState == 2)
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, TRUE, -1, CasterLvl);
                else
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, CasterLvl);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

