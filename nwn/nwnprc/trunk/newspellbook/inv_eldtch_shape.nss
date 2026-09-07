//::///////////////////////////////////////////////
//:: Name      Eldritch Blast - Normal
//:: FileName  inv_eldtch_blast.nss
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "inv_inc_invfunc"
#include "inv_invokehook"
#include "inv_inc_blast"
#include "prc_inc_combmove"

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
    
    object oBeamTarget = PRCGetSpellTargetObject();
    location lTargetArea = PRCGetSpellTargetLocation();
    int nEssence = GetLocalInt(oPC, "BlastEssence");
    int nEssence2 = GetLocalInt(oPC, "BlastEssence2");
    int nEssenceData = GetLocalInt(oPC, "EssenceData");
    int nEssenceData2 = GetLocalInt(oPC, "EssenceData2");
    effect eEssence;

    //If no beam target object, make one
    if (!GetIsObjectValid(oBeamTarget))
    {
        oBeamTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lTargetArea);
    }

    //remove Corrupting Blast essence - it's a one-shot power
    if(nEssence == INVOKE_CORRUPTING_BLAST)
        DeleteLocalInt(oPC, "BlastEssence");
    else if(nEssence2 == INVOKE_CORRUPTING_BLAST)
        DeleteLocalInt(oPC, "BlastEssence2");

    int nBlast = GetSpellId();
    int bSculptor = GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC);
    int nShape, nShapeLevel, bDoom;
    float fRange;

    if(nBlast == INVOKE_ELDRITCH_CONE)
    {
        nShape = SHAPE_SPELLCONE;
        fRange = bSculptor ? FeetToMeters(60.0) : FeetToMeters(30.0);
        nShapeLevel = 5;
    }
    else if(nBlast == INVOKE_ELDRITCH_LINE)
    {
        nShape = SHAPE_SPELLCYLINDER;
        fRange = bSculptor ? FeetToMeters(120.0) : FeetToMeters(60.0);
        nShapeLevel = 5;
    }
    else if(nBlast == INVOKE_ELDRITCH_DOOM)
    {
        bDoom = TRUE;
        nShape = SHAPE_SPHERE;
        fRange = bSculptor ? FeetToMeters(40.0) : FeetToMeters(20.0);
        nShapeLevel = 8;
    }

    //calculate DC for essence effects
    int nInvLevel = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK);
    int nBlastLvl = PRCMin((nInvLevel + 1) / 2, 9);
    nBlastLvl = PRCMax(nShapeLevel, PRCMax(PRCMax(nEssenceData & 0xF, nEssenceData2 & 0xF), nBlastLvl));
    int nDC = 10 + nBlastLvl + GetAbilityModifier(ABILITY_CHARISMA);
    if(GetHasFeat(FEAT_LORD_OF_ALL_ESSENCES)) nDC += 2;
	
	nDC += InvokerAbilityFocus(oPC, nEssence, nEssence2);
	
    int nDmgDice = GetBlastDamageDices(oPC, nInvLevel);
	
	int nDamageType = nEssence ? 1 << ((nEssenceData >>> 4) & 0x1F) : DAMAGE_TYPE_UNTYPED;
    int nDamageType2 = nEssence2 ? 1 << ((nEssenceData2 >>> 4) & 0x1F) : DAMAGE_TYPE_UNTYPED;

/*     int nDamageType = nEssence ? (nEssenceData >>> 4) & 0xFFF : DAMAGE_TYPE_UNTYPED;
    int nDamageType2 = nEssence2 ? (nEssenceData2 >>> 4) & 0xFFF : DAMAGE_TYPE_UNTYPED; */

    //Set correct blast damage type
    if(nDamageType != nDamageType2)
    {
        if(nDamageType != DAMAGE_TYPE_UNTYPED)
        {
            if(nDamageType2 == DAMAGE_TYPE_UNTYPED)
                nDamageType2 = nDamageType;
        }
        else if(nDamageType2 != DAMAGE_TYPE_UNTYPED)
        {
            nDamageType = nDamageType2;
        }
    }

    //get beam and impact vfx
    int nBeamVFX, nVis, nReflexSaveType;
    switch(nDamageType)
    {
        case DAMAGE_TYPE_FIRE:
              nBeamVFX        = bDoom ? VFX_IMP_PULSE_FIRE : VFX_BEAM_FIRE;
              nVis            = VFX_IMP_FLAME_M;
              nReflexSaveType = SAVING_THROW_TYPE_FIRE;
              break;
        case DAMAGE_TYPE_COLD:
              nBeamVFX        = bDoom ? VFX_IMP_PULSE_COLD : VFX_BEAM_COLD;
              nVis            = VFX_IMP_FROST_S;
              nReflexSaveType = SAVING_THROW_TYPE_COLD;
              break;
        case DAMAGE_TYPE_ACID:
              nBeamVFX        = bDoom ? VFX_IMP_PULSE_WATER : VFX_BEAM_DISINTEGRATE;
              nVis            = VFX_IMP_ACID_S;
              nReflexSaveType = SAVING_THROW_TYPE_ACID;
              break;
        case DAMAGE_TYPE_NEGATIVE:
              nBeamVFX        = bDoom ? VFX_IMP_PULSE_NEGATIVE : VFX_BEAM_BLACK;
              nVis            = VFX_IMP_NEGATIVE_ENERGY;
              nReflexSaveType = SAVING_THROW_TYPE_NEGATIVE;
              break;
        default:
              nBeamVFX        = bDoom ? VFX_IMP_PULSE_NEGATIVE : VFX_BEAM_DISINTEGRATE;
              nVis            = VFX_IMP_LIGHTNING_S;
              nReflexSaveType = SAVING_THROW_TYPE_SPELL;
              break;
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

    int nHellFire = 0;
    if(GetIsHellFireBlast(oPC))
    {
        if(HellFireConDamage(oPC))
        {
            nHellFire = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oPC) * 2;
            nBeamVFX = bDoom ? VFX_IMP_PULSE_FIRE : VFX_BEAM_FIRE;
        }
    }

    //Penetrating Blast
    int nPenetr = nInvLevel + SPGetPenetr();
    if(nEssence == INVOKE_PENETRATING_BLAST || nEssence2 == INVOKE_PENETRATING_BLAST)
        nPenetr += 4;

//Get first target in spell area
object oTarget = MyFirstObjectInShape(nShape, fRange, lTargetArea, TRUE,
    OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));

while(GetIsObjectValid(oTarget))
{
    int nDamage = d6(nDmgDice);
    if(GetHasSpellEffect(INVOKE_WILD_FRENZY, oPC))
        nDamage += 2;

    //Bane Blast
    int nRace = MyPRCGetRacialType(oTarget);
    if(nRace == ((nEssenceData >>> 16) & 0xFF) - 1
    || nRace == ((nEssenceData2 >>> 16) & 0xFF) - 1)
        nDamage += d6(2);

    //Hammer Blast
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE
    && nEssence != INVOKE_HAMMER_BLAST
    && nEssence2 != INVOKE_HAMMER_BLAST)
    {
        nDamage /= 2;
        if(nDamage < 1) nDamage = 1;
        nHellFire /= 2;
    }

    int nRep = bDoom ? SPELL_TARGET_SELECTIVEHOSTILE : SPELL_TARGET_STANDARDHOSTILE;

    // Heal friendly undead when affected by Doom + negative energy
    if (nDamageType == DAMAGE_TYPE_NEGATIVE && bDoom && GetIsFriend(oTarget, oPC)
        && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamage), oTarget);
    }
    // Skip all other allies when bDoom is active
    else if (bDoom && GetIsFriend(oTarget, oPC))
    {
        oTarget = MyNextObjectInShape(nShape, fRange, lTargetArea, TRUE,
            OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
        continue;
    }
    else if (spellsIsTarget(oTarget, nRep, oPC) && oTarget != oPC)
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oPC, INVOKE_ELDRITCH_BLAST));
        float fDelay = GetDistanceBetween(oPC, oTarget)/20;

        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nReflexSaveType);
        if(nDamage > 0)
        {
            int iSR = PRCDoResistSpell(oPC, oTarget, nPenetr);
            if(!iSR)
            {
                // secondary essence effects...
				if((nEssence == INVOKE_REPELLING_BLAST || nEssence2 == INVOKE_REPELLING_BLAST)  
					&& PRCGetIsAliveCreature(oTarget)  
					&& PRCGetCreatureSize(oTarget) <= CREATURE_SIZE_MEDIUM)  
				{  
					if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL))  
					{  
						int nDist = d6(); // 1d6 x 5 ft  
						_DoBullRushKnockBack(oTarget, oPC, IntToFloat(nDist) * 5.0);  
						DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0));  
					}  
				}				
                if(nEssence == INVOKE_PENETRATING_BLAST || nEssence2 == INVOKE_PENETRATING_BLAST)
                {
                    eEssence = EffectSpellResistanceDecrease(5);
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
                }
                if((nEssence == INVOKE_HINDERING_BLAST || nEssence2 == INVOKE_HINDERING_BLAST)
                    && PRCGetIsAliveCreature(oTarget))
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
                if((nEssence == INVOKE_BESHADOWED_BLAST || nEssence2 == INVOKE_BESHADOWED_BLAST)
                    && PRCGetIsAliveCreature(oTarget))
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
                    effect eDmgD = EffectDamageDecrease(2, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
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
                        SpeakStringByStrRef(40550);
                }
                if((nEssence == INVOKE_SICKENING_BLAST || nEssence2 == INVOKE_SICKENING_BLAST)
                    && PRCGetIsAliveCreature(oTarget))
                {
                    eEssence = EffectSickened();
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, 60.0);
                }
                if((nEssence == INVOKE_BRIMSTONE_BLAST || nEssence2 == INVOKE_BRIMSTONE_BLAST)
                    && !GetLocalInt(oTarget, "BrimstoneFire"))
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

                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }

            // Vitriolic ignores SR
            if(nEssence == INVOKE_VITRIOLIC_BLAST || nEssence2 == INVOKE_VITRIOLIC_BLAST)
            {
                if(iSR) ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                int nDuration = nInvLevel / 5;
                int i;
                float fRound = RoundsToSeconds(1);
                for(i = 1; i <= nDuration; i++)
                {
                    DelayCommand(fRound * i, DoDelayedBlast(oTarget, DAMAGE_TYPE_ACID, VFX_IMP_ACID_S));
                }
            }

            ApplyBlastDamage(oPC, oTarget, 1, iSR, nDamage, nDamageType, nDamageType2, nHellFire, FALSE);
        }
    }

    oTarget = MyNextObjectInShape(nShape, fRange, lTargetArea, TRUE,
        OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));

    if(DEBUG) DoDebug("inv_eldtch_shape: Next target is: " + DebugObject2Str(oTarget));
}

/*     //Get first target in spell area
    object oTarget = MyFirstObjectInShape(nShape, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
    while(GetIsObjectValid(oTarget))
    {
        int nDamage = d6(nDmgDice);
        if(GetHasSpellEffect(INVOKE_WILD_FRENZY, oPC))
            nDamage += 2;

        //Bane Blast
        int nRace = MyPRCGetRacialType(oTarget);
        if(nRace == ((nEssenceData >>> 16) & 0xFF) - 1
        || nRace == ((nEssenceData2 >>> 16) & 0xFF) - 1)
            nDamage += d6(2);

        //Hammer Blast
        if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && nEssence != INVOKE_HAMMER_BLAST && nEssence2 != INVOKE_HAMMER_BLAST)
        {
            nDamage /= 2;
            if(nDamage < 1) nDamage = 1;
            nHellFire /= 2;
        }

        int nRep = bDoom ? SPELL_TARGET_SELECTIVEHOSTILE : SPELL_TARGET_STANDARDHOSTILE;
        // This heals friendly undead targets with negative energy damage
        if (nDamageType == DAMAGE_TYPE_NEGATIVE && bDoom && GetIsFriend(oTarget, oPC) && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamage), oTarget);
        else if(spellsIsTarget(oTarget, nRep, oPC) && oTarget != oPC)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, INVOKE_ELDRITCH_BLAST));
            float fDelay = GetDistanceBetween(oPC, oTarget)/20;

            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nReflexSaveType);
            if(nDamage > 0)
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
                 ApplyBlastDamage(oPC, oTarget, 1, iSR, nDamage, nDamageType, nDamageType2, nHellFire, FALSE);
            }
        }

        //Get next target in spell area
        oTarget = MyNextObjectInShape(nShape, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
        if(DEBUG) DoDebug("inv_eldtch_shape: Next target is: " + DebugObject2Str(oTarget));
    }
 */
    if(nBlast == INVOKE_ELDRITCH_LINE)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(nBeamVFX, oPC, BODY_NODE_HAND, FALSE), oBeamTarget, 1.0f);
    else if(nBlast == INVOKE_ELDRITCH_DOOM)
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nBeamVFX), lTargetArea, 1.0f);

    //Remove the created beam target object if it exists
    if (GetResRef(oBeamTarget) == "prc_invisobj") DestroyObject(oBeamTarget, 3.0);

    if(bSculptor)
    {
        if(!GetLocalInt(oPC, "UsingSecondBlast"))
        {
            SetLocalInt(oPC, "UsingSecondBlast", TRUE);
            UseInvocation(nBlast, CLASS_TYPE_WARLOCK, 0, TRUE);
        }
        else
            DeleteLocalInt(oPC, "UsingSecondBlast");
    }
}
