//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Str and Con of the Barbarian increases,
    Will Save are +2, AC -2.
    Greater Rage starts at level 15.

    Updated: 2004-01-18 mr_bumpkin: Added bonuses for exceeding +12 stat cap
    Updated: 2004-2-24 by Oni5115: Added Intimidating Rage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "inc_addragebonus"
#include "inc_npc"
#include "psi_inc_psifunc"
#include "prc_inc_factotum"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetHasSpellEffect(SPELL_SPELL_RAGE))
    {
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_BARBARIAN_RAGE);
        FloatingTextStringOnCreature("You can't use Barbarian Rage and Spell Rage at the same time.", OBJECT_SELF, FALSE);
        return;
    }

    if(!GetHasFeatEffect(FEAT_BARBARIAN_RAGE) && !GetHasSpellEffect(GetSpellId()))
    {
        int nBBC = GetLevelByClass(CLASS_TYPE_BLACK_BLOOD_CULTIST);
        //Declare major variables
        int nLevel = GetLevelByClass(CLASS_TYPE_BARBARIAN)
                   + GetLevelByClass(CLASS_TYPE_RUNESCARRED)
                   + GetLevelByClass(CLASS_TYPE_BATTLERAGER)
                   + GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH)
                   + nBBC
                   + GetLevelByClass(CLASS_TYPE_RAGE_MAGE);
        int iStr, iCon, iAC;
        int nSave, nBonusEss;
        int nTotem = GetLevelByClass(CLASS_TYPE_TOTEM_RAGER, oPC);
        
        // Factotum Cunning Brilliance
        if (GetIsAbilitySaved(oPC, FEAT_BARBARIAN_RAGE))
        	nLevel = GetLevelByClass(CLASS_TYPE_FACTOTUM);

        iAC = 2;

        //Lock: Added compatibility for PRC Mighty Rage ability
        if(nLevel > 14)
        {
            if(GetHasFeat(FEAT_PRC_EPIC_MIGHT_RAGE))
            {
                iStr = 8;
                iCon = 8;
                nSave = 4;
            }
            else
            {
                iStr = 6;
                iCon = 6;
                nSave = 3;
            }
        }
        else
        {
            iStr = 4;
            iCon = 4;
            nSave = 2;
        }

        // Eye of Gruumsh ability. Additional  +4 Str and -2 AC.
        if(GetHasFeat(FEAT_SWING_BLINDLY))
        {
            iStr += 4;
            iAC += 2;
        }

        // +2 Str/Con -2 AC
        if(GetHasFeat(FEAT_RECKLESS_RAGE))
        {
            iStr += 2;
            iCon += 2;
            iAC += 2;
        }
        // +2 Con
        if(GetHasFeat(FEAT_ETTERCAP_BERSERKER))
            iCon += 2;

        //(Patch 1.70 - if not silenced) play a random voice chat instead of just VOICE_CHAT_BATTLECRY1
        if(!PRCGetHasEffect(EFFECT_TYPE_SILENCE))
        {
            int iVoice = d3(1);
            switch(iVoice)
            {
                 case 1: iVoice = VOICE_CHAT_BATTLECRY1; break;
                 case 2: iVoice = VOICE_CHAT_BATTLECRY2; break;
                 case 3: iVoice = VOICE_CHAT_BATTLECRY3; break;
            }
            PlayVoiceChat(iVoice);
        }

        //Determine the duration by getting the con modifier after being modified
        //Patch 1.70 - duration calculation was bugged
        int nCon = 3 + ((GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION) - 10 + iCon)/2);
        effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, iCon));
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, iStr));
               eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave));
               eLink = EffectLinkEffects(eLink, EffectACDecrease(iAC, AC_DODGE_BONUS));

        // Blazing Berserker
        if(GetHasFeat(FEAT_BLAZING_BERSERKER))
        {
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));
               eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 50));
               eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100));
        }
        // Frozen Berserker
        if(GetHasFeat(FEAT_FROZEN_BERSERKER))
        {
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));
               eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50));
               eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100));
        }
        // Ice Troll Berserker
        if(GetHasFeat(FEAT_ICE_TROLL_BERSERKER))
        {
            int nBonus = 2;
            if(nLevel > 14) nBonus = 4;
            eLink = EffectLinkEffects(eLink, EffectACIncrease(nBonus, AC_NATURAL_BONUS));
        }     
        // Cobalt Rage
		int nEssentia = GetEssentiaInvestedFeat(oPC, FEAT_COBALT_RAGE);
		// Totem Rage from Totem Rager
		if (nTotem) 
		{
			int nTotemRage = GetMaxEssentiaCapacityFeat(oPC) - nEssentia;
			int nExtraEss = max(nTotem/2, 1);
			int nBoost;
			if (nExtraEss >= nTotemRage) 
			{
				nBonusEss = nExtraEss - nTotemRage;
				nEssentia += nTotemRage; 	
			}	
			else
				nEssentia += nExtraEss; 				
		}
        if (nEssentia)
        {
        	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nEssentia));
        	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia), DAMAGE_TYPE_BASE_WEAPON));
        }
        
        //Make effect extraordinary
        eLink = ExtraordinaryEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX

        SignalEvent(oPC, EventSpellCastAt(oPC, SPELLABILITY_BARBARIAN_RAGE, FALSE));

        if(nCon > 0)
        {
            // 2004-01-18 mr_bumpkin: determine the ability scores before adding bonuses, so the values
            // can be read in by the GiveExtraRageBonuses() function below.
            int StrBeforeBonuses = GetAbilityScore(oPC, ABILITY_STRENGTH);
            int ConBeforeBonuses = GetAbilityScore(oPC, ABILITY_CONSTITUTION);

            float fDuration = RoundsToSeconds(nCon);
            fDuration += GetHasFeat(FEAT_EXTENDED_RAGE, oPC) ? 30.0 : 0.0;
            if (nEssentia > 5 && nTotem >= 5) fDuration += 6.0 * (nEssentia - 5); 

            // Terrifying Rage
            if(GetHasFeat(FEAT_EPIC_TERRIFYING_RAGE))
            {
                effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR, "x2_s2_terrage_A");
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eAOE), oPC, fDuration);
            }
            
            // Frostrager
            int nFrost = GetLevelByClass(CLASS_TYPE_FROSTRAGER, oPC);
            object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
            string sWeapType = "PRC_UNARMED_B";            
            if(nFrost>0 && GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_INVALID &&
               GetIsObjectValid(oWeapL) && GetTag(oWeapL) == sWeapType) //Only applies when unarmed and you actually have a creature weapon
            {
                // Record that we're Frostraging
                SetLocalInt(oPC, "Frostrage", TRUE);
                DelayCommand(fDuration, DeleteLocalInt(oPC, "Frostrage")); 
                int nFrostAC = 4;
                int nFrostDamage = IP_CONST_DAMAGEBONUS_1d4;
            
                if(nFrost>3) //Improved Frost Rage
                {
                    nFrostAC = 6;
                    nFrostDamage = IP_CONST_DAMAGEBONUS_1d6; 
                }
                    
                eLink = EffectLinkEffects(eLink, EffectACIncrease(nFrostAC, AC_NATURAL_BONUS));
                AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,nFrostDamage),oWeapL,fDuration);
            }
            else if (nFrost>0)
                FloatingTextStringOnCreature("Frostrage failed, invalid weapon", oPC, FALSE);

            //Apply the VFX impact and the actual rage effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            
            // Totem Rage bonus Essentia
            if (nBonusEss)
            {
				SetTemporaryEssentia(oPC, nBonusEss);
				DelayCommand(fDuration, SetTemporaryEssentia(oPC, nBonusEss * -1)); 
				FloatingTextStringOnCreature("Totem Rage has granted you "+IntToString(nBonusEss)+" temporary essentia", oPC, FALSE);
            }

            // Shared Fury
            if(GetHasFeat(FEAT_SHARED_FURY, oPC))
            {
                object oComp = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oComp))
                {
                    if(GetMasterNPC(oComp) == oPC && GetAssociateTypeNPC(oComp) == ASSOCIATE_TYPE_ANIMALCOMPANION)
                    {
                        PRCRemoveEffectsFromSpell(oComp, SPELLABILITY_BARBARIAN_RAGE);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oComp, fDuration);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oComp);
                    }
                    oComp = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
                }
            }

            // 2004-2-24 Oni5115: Intimidating Rage
            if(GetHasFeat(FEAT_INTIMIDATING_RAGE, oPC))
            {
                //Finds nearest visible enemy within 30 ft.
                object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
                if(GetDistanceBetween(oPC, oTarget) < FeetToMeters(30.0))
                {
                    // Will save DC 10 + 1/2 Char level + Cha mod
                    int saveDC = 10 + (GetHitDice(oPC)/2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
                    int nResult = WillSave(oTarget, saveDC, SAVING_THROW_TYPE_NONE);
                    if(!nResult)
                    {
                        // Same effect as Doom Spell
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, fDuration);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), oTarget);
                    }
                }
            }

            // Thundering Rage
            if(GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, oPC))
            {
                object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
                if(GetIsObjectValid(oWeapon))
                {
                    IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
                    IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
                    IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS,IP_CONST_ONHIT_SAVEDC_20,IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
                }

                oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
                if(GetIsObjectValid(oWeapon))
                {
                    IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
                    IPSafeAddItemProperty(oWeapon,ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
                }
            }
            
            // Black Blood Cultist, don't trigger at 10th level because it becomes permanent then
            if (10 > nBBC && nBBC > 0)
            {  
                int nClawDamage = IP_CONST_MONSTERDAMAGE_1d6;
                int nBiteDamage = IP_CONST_MONSTERDAMAGE_1d4;
                string sResRef = "prc_claw_1d6m_"; 
                if (nBBC >= 7)
                {
                    nClawDamage = IP_CONST_MONSTERDAMAGE_1d8;
                    nBiteDamage = IP_CONST_MONSTERDAMAGE_1d6;  
                    sResRef = "prc_claw_1d8m_"; 
                }
                
                // Create the creature weapon & add the base damage
                object oLClaw = GetPsionicCreatureWeapon(oPC, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_L, fDuration);
                object oRClaw = GetPsionicCreatureWeapon(oPC, "PRC_UNARMED_SP", INVENTORY_SLOT_CWEAPON_R, fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nClawDamage), oLClaw, fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nClawDamage), oRClaw, fDuration);
                if (nBBC >= 3)
                {
                    object oBite = GetPsionicCreatureWeapon(oPC, "prc_bw0_bite_t", INVENTORY_SLOT_CWEAPON_B, fDuration);
                    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBiteDamage), oBite, fDuration);             
                }    
                if (nBBC >= 6) // Rend, see inc_rend and prc_onhitcast
                {
                    IPSafeAddItemProperty(oLClaw, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    IPSafeAddItemProperty(oRClaw, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                }    

                sResRef += GetAffixForSize(PRCGetCreatureSize(oPC));
                AddNaturalPrimaryWeapon(oPC, sResRef, 2, TRUE);
                DelayCommand(6.0f, NaturalPrimaryWeaponTempCheck(oPC, oPC, GetSpellId(), FloatToInt(fDuration) / 6, sResRef));  
                AddNaturalSecondaryWeapon(oPC, "prc_bw0_bite_t", 1);
                DelayCommand(6.0f, NaturalSecondaryWeaponTempCheck(oPC, oPC, GetSpellId(), FloatToInt(fDuration) / 6, "prc_bw0_bite_t"));  
            }
            
            // 2004-01-18 mr_bumpkin: Adds special bonuses to those barbarians who are restricted by the
            // +12 attribute bonus cap, to make up for them. :)
            // The delay is because you have to delay the command if you want the function to be able
            // to determine what the ability scores become after adding the bonuses to them.
            DelayCommand(0.1, GiveExtraRageBonuses(nCon, StrBeforeBonuses, ConBeforeBonuses, iStr, iCon, nSave, DAMAGE_TYPE_BASE_WEAPON, oPC));
			
			if(GetLevelByClass(CLASS_TYPE_FORSAKER, oPC) >= 3) //Run feat script if Forsaker lvl3 to increase AC based on CON, then decrease again after it ends
			{
				ExecuteScript("prc_forsaker", oPC);
				DelayCommand(fDuration + 0.1, ExecuteScript("prc_forsaker", oPC));
			}

        }
    }
}
