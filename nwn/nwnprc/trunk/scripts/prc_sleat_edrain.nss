//::///////////////////////////////////////////////
//:: Soul Eater: Energy Drain
//:: prc_sleat_edrain
//:://////////////////////////////////////////////
/** @file
    Implements all of the Soul Eater's Energy Drain
    -related abilities.

    Energy Drain (Su): A soul eater gains the ability to drain energy, bestowing
     negative levels upon it's victims. Beginning at 1st level, the touch of a
     soul eater bestows one negative level on it's target. At 7th level, the
     soul eater bestows two negative levels with a touch.

    Soul Strength (Su): When a 2nd-level soul eater uses it's energy drain
     ability, it gains a +4 bonus to Strenth for 24 hours.

    Soul Enhancement (Su): When a 4th-level soul eater uses it's energy drain
     ability, it gains a +2 enhancement bonus on all saving throws and skill
     checks for 24 hours.

    Soul Endurance (Su): When a 5nd-level soul eater uses it's energy drain
     ability, it gains a +4 bonus to Constitution for 24 hours.

    Soul Radiance (Su): If a 6th-level soul eater completely drains a creature
     of energy, it may adopt the creature's soul radiance, taking the victim's
     form, appearance, and abilities for 24 hours.

    Soul Agility (Su): When a 8th-level soul eater uses it's energy drain
     ability, it gains a +4 bonus to Dexterity for 24 hours.

    Soul Slave (Su): If a 9th-level soul eater completely drains a creature of
     energy, the victim becomes a wight under the command of the soul eater.

    Soul Power (Su): After a 10th-level soul eater has drained energy, all
     spell-like and supernatural abilities gain a +2 profane bonus to their
     saving throw DC for 24 hours. Further, it may use it's Soul Blast ability
     up to two times instead of one during that 24-hour period.

    @date   Modified - 04.12.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_inc_shifting"
#include "prc_spell_const"

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

void DoEnergyDrain(object oEater, object oTarget, int nDamage);
void DoDeathDependent(object oEater, object oTarget, string sResRef, string sName);
void LevelUpWight(int nTargetLevel, object oCreature);
void IncrementMarker(object oEater);
void DecrementMarker(object oEater);


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void main()
{
    object oEater  = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItem   = PRCGetSpellCastItem();
    effect eImpact = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    int nDrain     = GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater) < 7 ? 1 : 2;

	// Sanity check - can't affect self or dead stuff. Also, check PvP limits  
	if(oTarget == oEater  ||  
	   GetIsDead(oTarget) ||  
	   !spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oEater) ||  
	   GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)  // NEW: Only affect creatures  
		return;

    // Let the target's AI know about hostile action
    SignalEvent(oTarget, EventSpellCastAt(oEater, PRCGetSpellId(), TRUE));

    int bHit = FALSE;
    if (GetIsObjectValid(oItem))
    {
        //If happening due to an On Hit Cast Spell: skip the touch attack (we've already touched when we hit)
        //Have to use local variable on the item because GetSpellCastItem() can return valid object from
        //previously cast spells that are not this spell at all.
        //TODO: Is there a better way to do this?
        bHit = GetLocalInt(oItem, "PRC_SOULEATER_ONHIT_ENERGYDRAIN");
    }
    else
    {
        // Melee touch attack to actually do anything       
        bHit = PRCDoMeleeTouchAttack(oTarget, TRUE, oEater);
    }
    
    if(bHit)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        DoEnergyDrain(oEater, oTarget, nDrain);
    }
}

void DoEnergyDrain(object oEater, object oTarget, int nDamage)  
{  
    // Immunity prevents anything from actually happening  
    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))  
    {  
        // Apply the actual drain  
        effect eDrain = SupernaturalEffect(EffectNegativeLevel(nDamage));  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);  
  
        // Update marker  
        IncrementMarker(oEater);  
        DelayCommand(HoursToSeconds(24), DecrementMarker(oEater));  
  
        //:: Soul X side effects  
        // Remove existing tagged effects before applying new ones  
        effect eOld = GetFirstEffect(oEater);  
        while(GetIsEffectValid(eOld))  
        {  
            string sTag = GetEffectTag(eOld);  
            if(sTag == "SOULEATER_SOUL_STRENGTH" ||  
               sTag == "SOULEATER_SOUL_ENHANCEMENT" ||  
               sTag == "SOULEATER_SOUL_ENDURANCE" ||  
               sTag == "SOULEATER_SOUL_AGILITY")  
            {  
                RemoveEffect(oEater, eOld);  
            }  
            eOld = GetNextEffect(oEater);  
        }  
  
        // Generate new effects with tags  
        int nClassLevel    = GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater);  
  
        // Soul Strength  
        if(nClassLevel >= 2)  
        {  
            effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);  
            eStr = SupernaturalEffect(eStr);  
            eStr = TagEffect(eStr, "SOULEATER_SOUL_STRENGTH");  
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oEater, HoursToSeconds(24));  
        }  
  
        // Soul Enchancement  
        if(nClassLevel >= 4)  
        {  
            effect eSave = EffectSavingThrowIncrease(SAVING_THROW_TYPE_ALL, 2);  
            eSave = SupernaturalEffect(eSave);  
            eSave = TagEffect(eSave, "SOULEATER_SOUL_ENHANCEMENT");  
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oEater, HoursToSeconds(24));  
              
            effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);  
            eSkill = SupernaturalEffect(eSkill);  
            eSkill = TagEffect(eSkill, "SOULEATER_SOUL_ENHANCEMENT");  
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oEater, HoursToSeconds(24));  
        }  
  
        // Soul Endurance  
        if(nClassLevel >= 5)  
        {  
            effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);  
            eCon = SupernaturalEffect(eCon);  
            eCon = TagEffect(eCon, "SOULEATER_SOUL_ENDURANCE");  
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCon, oEater, HoursToSeconds(24));  
        }  
  
        // Soul Agility  
        if(nClassLevel >= 8)  
        {  
            effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);  
            eDex = SupernaturalEffect(eDex);  
            eDex = TagEffect(eDex, "SOULEATER_SOUL_AGILITY");  
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oEater, HoursToSeconds(24));  
        }  
        // Soul Power
        // Rebalanced to give +2 to all DCs and just double Soul Blast uses, due to it not being sanely
        // possible to find out all use-limited abilities one may have
        if(nClassLevel >= 10)
        {
            // +2 DCs
            // Handled based on "PRC_SoulEater_HasDrained" and class level in the relevant places

            // 2x special abilities uses
            //IncrementRemainingFeatUses(oEater, FEAT_SLEAT_SBLAST); // Handled via 2da instead
        }



        // Soul Radiance and Soul Slave work only if the target was killed.
        // And death by level loss only gets calculated once the script has terminated.
        // Therefore, delay by 0.0
        DelayCommand(0.0f, DoDeathDependent(oEater, oTarget, GetResRef(oTarget), GetName(oTarget)));
    }
    else
        FloatingTextStrRefOnCreature(16832115, oEater, FALSE); // "Target is immune to negative levels"
}

void DoDeathDependent(object oEater, object oTarget, string sResRef, string sName)
{
    // For anything to happen here, the target needs to be dead. And if it is, due to having only been delayed by 0
    // we know that the only reason for it's death can have been level drain
    if(GetIsDead(oTarget))
    {
        // Soul Radiance
        if(GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater) >= 6)
        {
            // If the user has toggled Soul Radiance active, use the shifting code to turn into the target
            if(GetLocalInt(oEater, "PRC_SoulEater_SoulRadianceActive"))
            {
                StoreCurrentAppearanceAsTrueAppearance(oEater, TRUE);
                ShiftIntoCreature(oEater, SHIFTER_TYPE_SOULEATER, oTarget, TRUE); // Gain special abilities
                    //TODO: only if there are uses left
            }
        }


        // Soul Slave
        if(GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater) >= 9)
        {
            int nMaxHenchmen = GetMaxHenchmen();
            int nNumSlaves   = 0;
            int nMaxSlaves   = GetPRCSwitch(PRC_SOUL_EATER_MAX_SLAVES);
            effect eSummon   = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

            // Special switch values handling
            if(nMaxSlaves == 0 ) nMaxSlaves = 4;
            if(nMaxSlaves == -1) nMaxSlaves = 0;

            // Determine current number of slaves
            int i = 1;
            object oHench;
            do {
                oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oEater, i++);
                if(GetResRef(oHench) == "soul_wight_test")
                    nNumSlaves++;
            } while(GetIsObjectValid(oHench));
			// Check if target is a valid creature type for wight creation  
			int nRacialType = MyPRCGetRacialType(oTarget);  
			if(nRacialType == RACIAL_TYPE_VERMIN ||  
			   nRacialType == RACIAL_TYPE_OOZE ||  
			   nRacialType == RACIAL_TYPE_CONSTRUCT ||  
			   nRacialType == RACIAL_TYPE_UNDEAD)  
			{  
				// Cannot create wights from these creature types  
				return;  
			}  			

            // If we can add more wights, do so. Spawn the wight with some VFX at the corpse's location
            if(nNumSlaves < nMaxSlaves)
            {
                location lSpawn = GetLocation(oTarget);

                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, lSpawn);

			object oSlave = CreateObject(OBJECT_TYPE_CREATURE, "soul_wight_test", lSpawn);  
			if(GetIsObjectValid(oSlave))  
			{  
				// Copy feats using EffectBonusFeat
				effect eFeatLink;  
				int bHasEffect = FALSE;  
				int nFeat;  
				  
				// Iterate through feat range  
				for(nFeat = 1; nFeat < 3000; nFeat++)  
				{  
					if(GetHasFeat(nFeat, oTarget))  
					{  
						// Skip certain combat feats that may not work on NPCs  
						if(nFeat == FEAT_POWER_ATTACK || nFeat == FEAT_IMPROVED_POWER_ATTACK ||  
						   nFeat == FEAT_EXPERTISE || nFeat == FEAT_IMPROVED_EXPERTISE)  
							continue;  
							  
						// Create bonus feat effect and link it  
						if(!bHasEffect)  
						{  
							eFeatLink = EffectBonusFeat(nFeat);  
							bHasEffect = TRUE;  
						}  
						else  
						{  
							eFeatLink = EffectLinkEffects(eFeatLink, EffectBonusFeat(nFeat));  
						}  
					}  
				}  
				  
				// Apply the linked feat effects if any were found  
				if(bHasEffect)  
				{  
					eFeatLink = TagEffect(eFeatLink, "SOUL_SLAVE_COPIED_FEATS");  
					eFeatLink = UnyieldingEffect(eFeatLink);  
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFeatLink, oSlave);  
				}  
				
				// Copy appearance and portrait (existing code)  
				SetCreatureAppearanceType(oSlave, GetAppearanceType(oTarget));  
				SetPhenoType(GetPhenoType(oTarget), oSlave);  
				  
				// Copy portrait (existing code)  
				int nPortraitID = GetPortraitId(oTarget);  
				if(nPortraitID != PORTRAIT_INVALID)  
				{  
					string sPortraitResRef = Get2DACache("portraits", "BaseResRef", nPortraitID);  
					sPortraitResRef = GetStringLeft(sPortraitResRef, GetStringLength(sPortraitResRef)-1);  
					SetPortraitResRef(oSlave, sPortraitResRef);  
					SetPortraitId(oSlave, nPortraitID);  
				}  				
				  
				// Rest of existing code...  
				SetMaxHenchmen(PRCMax(nMaxHenchmen, i));  
				AddHenchman(oEater, oSlave);  
				SetMaxHenchmen(nMaxHenchmen);  
				//DelayCommand(3.0f, LevelUpWight(GetHitDice(oEater) - 3, oSlave));
				DelayCommand(0.0f, LevelUpWight(PRCMax(GetHitDice(oTarget), GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater) - 1), oSlave));				
			}
			else if(DEBUG)
				DoDebug("prc_sleat_edrain: ERROR: Failed to create wight at location " + DebugLocation2Str(lSpawn));
            }
        }
    }
}

void LevelUpWight(int nTargetLevel, object oCreature)
{
    int n;
    for(n = 1; n < nTargetLevel; n++)
        LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
}

void IncrementMarker(object oEater)
{
    SetLocalInt(oEater, "PRC_SoulEater_HasDrained", GetLocalInt(oEater, "PRC_SoulEater_HasDrained") + 1);
}

void DecrementMarker(object oEater)
{
    SetLocalInt(oEater, "PRC_SoulEater_HasDrained", GetLocalInt(oEater, "PRC_SoulEater_HasDrained") - 1);
}
