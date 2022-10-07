//::///////////////////////////////////////////////
//:: Tasha's Hideous Laughter
//:: [x0_s0_laugh.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target is held, laughing for the duration
    of the spell (1d3 rounds)

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

// * returns true if oCreature does not have a mind
int PRCIsMindless(object oCreature)
{
    int nRacialType = MyPRCGetRacialType(oCreature);
    int nMindless;
    switch(nRacialType)
    {
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_OOZE:
        nMindless = TRUE;
    }
    if(GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) > 3)
        nMindless = FALSE;

    return nMindless;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
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


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nCasterLvl = CasterLvl;
    int nDamage = 0;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCnt;
    effect eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);


    int nDuration = d3(1);


    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }


    int nModifier = 0;
    nCasterLvl +=SPGetPenetr();

    // * creatures of different race find different things funny
    if (MyPRCGetRacialType(oTarget) != MyPRCGetRacialType(OBJECT_SELF))
    {
        nModifier = 4;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TASHAS_HIDEOUS_LAUGHTER));

        if (PRCIsMindless(oTarget) == FALSE)   {
            if ( !GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS,OBJECT_SELF ))   {

        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLvl)
            && !/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, ((PRCGetSaveDC(oTarget,OBJECT_SELF))-nModifier), SAVING_THROW_TYPE_MIND_SPELLS))
        {
            effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

            float fDur = RoundsToSeconds(nDuration);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDur,TRUE,-1,CasterLvl);

        /*    string szLaughMale = "as_pl_laughingm2";
            string szLaughFemale = "as_pl_laughingf3";

            if (GetGender(oTarget) == GENDER_FEMALE)
            {
                PlaySound(szLaughFemale);
            }
            else
            {
                PlaySound(szLaughMale);
            }      */
            AssignCommand(oTarget, ClearAllActions());
            AssignCommand(oTarget, PlayVoiceChat(VOICE_CHAT_LAUGH));
            AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
            effect eLaugh = EffectKnockdown();
            DelayCommand(0.3, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLaugh, oTarget, fDur,TRUE,-1,CasterLvl));
        } } }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}





