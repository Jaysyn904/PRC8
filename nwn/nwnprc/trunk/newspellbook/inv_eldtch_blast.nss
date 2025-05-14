//::///////////////////////////////////////////////
//:: Name      Eldritch Blast - Normal
//:: FileName  inv_eldtch_blast.nss
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_inc_sp_tch"
#include "inv_inc_invfunc"
#include "inv_invokehook"
#include "inv_inc_blast"
#include "psi_inc_core"


//:: Increases Blast DC if the PC has taken Ability Focus 
//:: for the current active essences & shapes.
//int InvokerAbilityFocus(oPC, nEssenceData, nEssenceData2);


//internal function for delayed damage
void DoDelayedBlast(object oTarget, int nDamageType = DAMAGE_TYPE_FIRE, int nVFX = VFX_IMP_FLAME_M)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), nDamageType), oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), oTarget);
}

void main()
{
    // Ugly hack to tell PreInvocationCastCode() that we are casting as warlock
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, PRC_INVOKING_CLASS, CLASS_TYPE_WARLOCK + 1);
    DelayCommand(0.0f, DeleteLocalInt(oPC, PRC_INVOKING_CLASS));

    if(!PreInvocationCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();
    int nEssence = GetLocalInt(oPC, "BlastEssence");
    int nEssence2 = GetLocalInt(oPC, "BlastEssence2");
    int nEssenceData = GetLocalInt(oPC, "EssenceData");
    int nEssenceData2 = GetLocalInt(oPC, "EssenceData2");
    effect eEssence;

    //remove Corrupting Blast essence - it's a one-shot power
    if(nEssence == INVOKE_CORRUPTING_BLAST)
        DeleteLocalInt(oPC, "BlastEssence");
    else if(nEssence2 == INVOKE_CORRUPTING_BLAST)
        DeleteLocalInt(oPC, "BlastEssence2");

    //calculate DC for essence effects
    int nInvLevel = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK);
    int nBlastLvl = PRCMin((nInvLevel + 1) / 2, 9);
    nBlastLvl = PRCMax(PRCMax(nEssenceData & 0xF, nEssenceData2 & 0xF), nBlastLvl);
    int nDC = 10 + nBlastLvl + GetAbilityModifier(ABILITY_CHARISMA);
    if(GetHasFeat(FEAT_LORD_OF_ALL_ESSENCES)) nDC += 2;
	
	nDC += InvokerAbilityFocus(oPC, nEssence, nEssence2);

    int nDamageType = nEssence ? (nEssenceData >>> 4) & 0xFFF : DAMAGE_TYPE_MAGICAL;
    int nDamageType2 = nEssence2 ? (nEssenceData2 >>> 4) & 0xFFF : DAMAGE_TYPE_MAGICAL;

    //Set correct blast damage type
    if(nDamageType != nDamageType2)
    {
        if(nDamageType != DAMAGE_TYPE_MAGICAL)
        {
            if(nDamageType2 == DAMAGE_TYPE_MAGICAL)
                nDamageType2 = nDamageType;
        }
        else if(nDamageType2 != DAMAGE_TYPE_MAGICAL)
        {
            nDamageType = nDamageType2;
        }
    }

    //get beam and impact vfx
    int nBeamVFX, nVis;
    switch(nDamageType)
    {
        case DAMAGE_TYPE_FIRE:     nBeamVFX = VFX_BEAM_FIRE;         nVis = VFX_IMP_FLAME_M;         break;
        case DAMAGE_TYPE_COLD:     nBeamVFX = VFX_BEAM_COLD;         nVis = VFX_IMP_FROST_S;         break;
        case DAMAGE_TYPE_ACID:     nBeamVFX = VFX_BEAM_DISINTEGRATE; nVis = VFX_IMP_ACID_S;          break;
        case DAMAGE_TYPE_NEGATIVE: nBeamVFX = VFX_BEAM_BLACK;        nVis = VFX_IMP_NEGATIVE_ENERGY; break;
        default:                   nBeamVFX = VFX_BEAM_DISINTEGRATE; nVis = VFX_IMP_LIGHTNING_S;     break;
    }

    effect eVis = EffectVisualEffect(nVis);

    //add second vfx if needed
    if(nDamageType != nDamageType2)
    {
        switch(nDamageType2)
        {
            case DAMAGE_TYPE_FIRE:     nVis = VFX_IMP_FLAME_M;         break;
            case DAMAGE_TYPE_COLD:     nVis = VFX_IMP_FROST_S;         break;
            case DAMAGE_TYPE_ACID:     nVis = VFX_IMP_ACID_S;          break;
            case DAMAGE_TYPE_NEGATIVE: nVis = VFX_IMP_NEGATIVE_ENERGY; break;
        }
        eVis = EffectLinkEffects(eVis, EffectVisualEffect(nVis));
    }

    int nDam = d6(GetBlastDamageDices(oPC, nInvLevel));
    if(GetHasSpellEffect(INVOKE_WILD_FRENZY, oPC))
        nDam += 2;

//:: RAW, Eldritch Blast is considered a ranged attack & should work with the Psionic Shot chain  -Jaysyn.
	
	if(GetIsPsionicallyFocused())
	{
		if (GetHasFeat(FEAT_PSIONIC_SHOT))
		{
			nDam += d6(2);
		}
		if (GetHasFeat(FEAT_GREATER_PSIONIC_SHOT))
		{		
			nDam += d6(2);
		}
		
		LosePsionicFocus();
	}

/* 	if(GetIsPsionicallyFocused() && GetHasFeat(FEAT_GREATER_PSIONIC_SHOT))
	{	
		nDam += d6(4);
		LosePsionicFocus();
	}
	if(GetIsPsionicallyFocused() && GetHasFeat(FEAT_PSIONIC_SHOT))
	{	
		nDam += d6(2);
		LosePsionicFocus();
	} */	
	
    int nAtkBns = GetAttackBonus(oTarget, oPC, OBJECT_INVALID, FALSE, TOUCH_ATTACK_RANGED_SPELL);
    if(GetHasFeat(FEAT_ELDRITCH_SCULPTOR))
        nAtkBns += 2;

    //Penetrating Blast
    int nPenetr = nInvLevel + SPGetPenetr();
    if(nEssence == INVOKE_PENETRATING_BLAST || nEssence2 == INVOKE_PENETRATING_BLAST)
        nPenetr += 4;

    //Bane Blast
    int nRace = MyPRCGetRacialType(oTarget);
    if(nRace == ((nEssenceData >>> 16) & 0xFF) - 1
    || nRace == ((nEssenceData2 >>> 16) & 0xFF) - 1)
        nDam += d6(2);

    int nHellFire = 0;
    if(GetIsHellFireBlast(oPC))
    {
        if(HellFireConDamage(oPC))
        {
            nHellFire = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oPC) * 2;
            nBeamVFX = VFX_BEAM_FIRE;
        }
    }

    //Hammer Blast
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && nEssence != INVOKE_HAMMER_BLAST && nEssence2 != INVOKE_HAMMER_BLAST)
    {
        nDam /= 2;
        if(nDam < 1) nDam = 1;
        nHellFire /= 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oPC, INVOKE_ELDRITCH_BLAST));

        int iAttackRoll = PRCDoRangedTouchAttack(oTarget, TRUE, oPC, nAtkBns);
        if(iAttackRoll)
        {
            //Make SR Check
            int iSR = PRCDoResistSpell(oPC, oTarget, nPenetr);
            if(!iSR)
            {
                 //Apply secondary effects from essence invocations
                 if(nEssence == INVOKE_PENETRATING_BLAST || nEssence2 == INVOKE_PENETRATING_BLAST)
                 {
                     eEssence = EffectSpellResistanceDecrease(5);
                     if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
                 }
                 if((nEssence == INVOKE_HINDERING_BLAST || nEssence2 == INVOKE_HINDERING_BLAST) && PRCGetIsAliveCreature(oTarget))
                 {
                     eEssence = EffectSlow();
                     if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                 }
                 if(nEssence == INVOKE_BINDING_BLAST || nEssence2 == INVOKE_BINDING_BLAST)
                 {
                     eEssence = EffectStunned();
                     if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                 }
                 if(nEssence == INVOKE_BEWITCHING_BLAST || nEssence2 == INVOKE_BEWITCHING_BLAST)
                 {
                     eEssence = PRCEffectConfused();
                     if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                 }
                 if((nEssence == INVOKE_BESHADOWED_BLAST || nEssence2 == INVOKE_BESHADOWED_BLAST) && PRCGetIsAliveCreature(oTarget))
                 {
                     eEssence = EffectBlindness();
                     if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                 }
                 if((nEssence == INVOKE_HELLRIME_BLAST || nEssence2 == INVOKE_HELLRIME_BLAST))
                 {
                     eEssence = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
                     if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(10));
                 }
                 if(nEssence == INVOKE_UTTERDARK_BLAST || nEssence2 == INVOKE_UTTERDARK_BLAST)
                 {
                     eEssence = EffectNegativeLevel(2);
                     if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, HoursToSeconds(1));
                 }
                 if(nEssence == INVOKE_FRIGHTFUL_BLAST || nEssence2 == INVOKE_FRIGHTFUL_BLAST)
                 {
                     effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                     effect eFear = EffectFrightened();
                     effect eAttackD = EffectAttackDecrease(2);
                     effect eDmgD = EffectDamageDecrease(2,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
                     effect SaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
                     effect Skill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);

                     eEssence = EffectLinkEffects(eDmgD, eDur2);
                     eEssence = EffectLinkEffects(eEssence, eAttackD);
                     eEssence = EffectLinkEffects(eEssence, SaveD);
                     eEssence = EffectLinkEffects(eEssence, eFear);
                     eEssence = EffectLinkEffects(eEssence, Skill);

                     if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
                 }
                 if(nEssence == INVOKE_NOXIOUS_BLAST || nEssence2 == INVOKE_NOXIOUS_BLAST)
                 {
                     eEssence = EffectDazed();
                     if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
                 }
                 if(nEssence == INVOKE_CORRUPTING_BLAST || nEssence2 == INVOKE_CORRUPTING_BLAST)
                 {
                     if(CheckTurnUndeadUses(oPC, 1))
                     {
                         int nRed = GetLevelByClass(CLASS_TYPE_ELDRITCH_DISCIPLE, oPC) / 2;
                         if(nRed < 1) nRed = 1;
                         eEssence = EffectSavingThrowDecrease(SAVING_THROW_WILL, nRed);
                         eEssence = EffectLinkEffects(eEssence, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                     }
                     else
                         SpeakStringByStrRef(40550);//"This ability is tied to your turn undead ability, which has no more uses for today."
                 }
                 if((nEssence == INVOKE_SICKENING_BLAST || nEssence2 == INVOKE_SICKENING_BLAST) && PRCGetIsAliveCreature(oTarget))
                 {
                    eEssence = EffectSickened();
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, 60.0);
                 }
                 if((nEssence == INVOKE_BRIMSTONE_BLAST || nEssence2 == INVOKE_BRIMSTONE_BLAST) && !GetLocalInt(oTarget, "BrimstoneFire"))
                 {
                     if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
                     {
                         SetLocalInt(oTarget, "BrimstoneFire", TRUE);
                         int nDuration = nInvLevel / 5;
                         DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oTarget, "BrimstoneFire"));

                         int i;
                         float fRound = RoundsToSeconds(1);
                         for(i = 1; i <= nDuration; i++)
                         {
                             DelayCommand(fRound * i, DoDelayedBlast(oTarget));
                         }
                     }
                 }
                 //Apply the VFX impact
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             }
             //Vitriolic ignores SR
             if(nEssence == INVOKE_VITRIOLIC_BLAST || nEssence2 == INVOKE_VITRIOLIC_BLAST)
             {
                 //Apply the VFX impact
                 if(iSR) ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                 //Apply secondary effect from essence invocations
                 int nDuration = nInvLevel / 5;

                 int i;
                 float fRound = RoundsToSeconds(1);
                 for(i = 1; i <= nDuration; i++)
                 {
                     DelayCommand(fRound * i, DoDelayedBlast(oTarget, DAMAGE_TYPE_ACID, VFX_IMP_ACID_S));
                 }
             }
             //Apply damage effect
             ApplyBlastDamage(oPC, oTarget, iAttackRoll, iSR, nDam, nDamageType, nDamageType2, nHellFire);
        }
        //Beam VFX.
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(nBeamVFX, oPC, BODY_NODE_HAND, !iAttackRoll), oTarget, 1.0f);

        //Apply Spellblast or Greatreach Blast effect
        DoSpellBlast(oPC, iAttackRoll);

        if(GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC))
        {
            if(!GetLocalInt(oPC, "UsingSecondBlast"))
            {
                SetLocalInt(oPC, "UsingSecondBlast", TRUE);
                UseInvocation(INVOKE_ELDRITCH_SPEAR, CLASS_TYPE_WARLOCK, 0, TRUE);
            }
            else
                DeleteLocalInt(oPC, "UsingSecondBlast");
        }
    }
}