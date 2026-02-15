//::///////////////////////////////////////////////
//:: OnDeath NPC eventscript
//:: prc_npc_death
//:://////////////////////////////////////////////
#include "moi_inc_moifunc"
#include "prc_inc_combmove"

void main()
{
	object oDead = OBJECT_SELF;
    ExecuteScript("prc_ondeath", oDead);

	// Clear Circle Magic state on death  
	DeleteLocalInt(OBJECT_SELF, "CircleMagicActive");  
	DeleteLocalInt(OBJECT_SELF, "CircleMagicTotal");  
	DeleteLocalString(OBJECT_SELF, "CircleMagicClass");  
	DeleteLocalInt(OBJECT_SELF, "CircleMagicMaxParticipants");  
	DeleteLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_ADJUSTMENT);
	DeleteLocalInt(OBJECT_SELF, "CircleMagicAnimating"); 	
    
    if (GetIsObjectValid(GetLocalObject(GetModule(), "Necrocarnate")))
    {
    	int nType = MyPRCGetRacialType(oDead);
		
		// Skip non-living creature types
		if(nType != RACIAL_TYPE_UNDEAD && nType != RACIAL_TYPE_CONSTRUCT)
		{
			object oNecro = GetLocalObject(GetModule(), "Necrocarnate");
			if (GetDistanceBetween(oDead, oNecro) < FeetToMeters(100.0))
			{
				if (!GetLocalInt(oNecro, "NecroHarvestSoul1"))
				{
					SetLocalInt(oNecro, "NecroHarvestSoul1", GetHitDice(oDead));
					IncrementRemainingFeatUses(oNecro, FEAT_NECROCARNATE_HARVEST);	
					FloatingTextStringOnCreature("Harvested a soul for necrocarnum essentia", oNecro, FALSE);
					if (DEBUG) DoDebug("NecroHarvestSoul1 set for "+GetName(oNecro)+" with "+IntToString(GetHitDice(oDead))+" by "+GetName(oDead));
				}
				else if (!GetLocalInt(oNecro, "NecroHarvestSoul2"))
				{
					SetLocalInt(oNecro, "NecroHarvestSoul2", GetHitDice(oDead));
					IncrementRemainingFeatUses(oNecro, FEAT_NECROCARNATE_HARVEST);		
					FloatingTextStringOnCreature("Harvested a soul for necrocarnum essentia", oNecro, FALSE);
					if (DEBUG) DoDebug("NecroHarvestSoul1 set for "+GetName(oNecro)+" with "+IntToString(GetHitDice(oDead))+" by "+GetName(oDead));
				}	
				else if (!GetLocalInt(oNecro, "NecroHarvestSoul3"))
				{
					SetLocalInt(oNecro, "NecroHarvestSoul3", GetHitDice(oDead));
					IncrementRemainingFeatUses(oNecro, FEAT_NECROCARNATE_HARVEST);
					FloatingTextStringOnCreature("Harvested a soul for necrocarnum essentia", oNecro, FALSE);
					if (DEBUG) DoDebug("NecroHarvestSoul1 set for "+GetName(oNecro)+" with "+IntToString(GetHitDice(oDead))+" by "+GetName(oDead));
				}
				else if (!GetLocalInt(oNecro, "NecroHarvestSoul4"))
				{
					SetLocalInt(oNecro, "NecroHarvestSoul4", GetHitDice(oDead));
					IncrementRemainingFeatUses(oNecro, FEAT_NECROCARNATE_HARVEST);	
					FloatingTextStringOnCreature("Harvested a soul for necrocarnum essentia", oNecro, FALSE);
					if (DEBUG) DoDebug("NecroHarvestSoul1 set for "+GetName(oNecro)+" with "+IntToString(GetHitDice(oDead))+" by "+GetName(oDead));
				}				
				else if (!GetLocalInt(oNecro, "NecroHarvestSoul5"))
				{
					SetLocalInt(oNecro, "NecroHarvestSoul5", GetHitDice(oDead));
					IncrementRemainingFeatUses(oNecro, FEAT_NECROCARNATE_HARVEST);	
					FloatingTextStringOnCreature("Harvested a soul for necrocarnum essentia", oNecro, FALSE);
					if (DEBUG) DoDebug("NecroHarvestSoul1 set for "+GetName(oNecro)+" with "+IntToString(GetHitDice(oDead))+" by "+GetName(oDead));
				}
				
				if (GetLevelByClass(CLASS_TYPE_NECROCARNATE, oNecro) >= 5 && !GetLocalInt(oNecro, "EssentiaTrap"))
				{
					if (TakeSwiftAction(oNecro))
					{
						// This is deliberate, as the Necrocarnate can immediately invest as part of the swift action.
						DeleteLocalInt(oNecro, PRC_SWIFT_ACTION_MARKER);
    					int nEssentia = GetHitDice(oDead)/2;
    					SetTemporaryEssentia(oNecro, nEssentia);
    					//SendMessageToPC(GetFirstPC(),"Necro1 is "+GetName(oNecro));
    					SetLocalInt(oNecro, "EssentiaTrapClean", nEssentia);
    					ExecuteScript("moi_ncr_clean", oNecro);
    					SetLocalInt(oNecro, "EssentiaTrap", TRUE);
    					//DelayCommand(6.0, DeleteLocalInt(oNecro, "EssentiaTrap"));
    					FloatingTextStringOnCreature("Essentia trapped "+IntToString(nEssentia)+" temporary essentia for one round", oNecro, FALSE);
					}
				}	
			}
		}
    }

    if (GetLocalInt(oDead, "DestructionRetribution"))
    {
        if(DEBUG) DoDebug("Destruction Retribution firing. Dead creature = " + DebugObject2Str(oDead));

        int nDamage;
        int nDice = PRCMax(1, GetHitDice(oDead) / 2); // (hd / 2)d6, min 1d6
        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_10); //Replace with Negative Pulse
        effect eVis     = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
        effect eDam, eHeal;
        effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eDur2    = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        
        if(DEBUG) DoDebug("Destruction Retribution firing. nDice = " + IntToString(nDice));

        location lTarget = GetLocation(oDead);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
        while (GetIsObjectValid(oTarget))
        {
            nDamage = d6(nDice);
            if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_NEGATIVE))
            {
                nDamage /= 2;
            }
            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
            || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
            || GetLocalInt(oTarget, "AcererakHealing"))
            {
                SignalEvent(oTarget, EventSpellCastAt(oDead, SPELL_NEGATIVE_ENERGY_BURST));
                eHeal = EffectHeal(nDamage);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
            }
            else if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD
            && !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
            {
                SignalEvent(oTarget, EventSpellCastAt(oDead, SPELL_NEGATIVE_ENERGY_BURST));
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }

            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
        }
    }
    
    if (GetResRef(oDead) == "bnd_agares_small" ||
        GetResRef(oDead) == "bnd_agares_med" ||
        GetResRef(oDead) == "bnd_agares_large" ||
        GetResRef(oDead) == "bnd_agares_huge")
    {
    	object oBinder = GetMaster(oDead);
    	FloatingTextStringOnCreature("You must wait one hour to resummon your elemental companion!", oBinder, FALSE);
    	SetLocalInt(oBinder, "AgaresDelay", TRUE);
    	ExecuteScript("bnd_vest_agadel", oBinder);
    	DelayCommand(HoursToSeconds(1), DeleteLocalInt(oBinder, "AgaresDelay"));
    	DelayCommand(HoursToSeconds(1), FloatingTextStringOnCreature("You can now resummon your elemental companion!", oBinder, FALSE));
    }
	
    // Trigger the death/bleed if the PRC Death system is enabled (ElgarL).
    if(GetPRCSwitch(PRC_PNP_DEATH_ENABLE))
        AddEventScript(oDead, EVENT_ONHEARTBEAT, "prc_timer_dying", TRUE, FALSE);

    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(oDead, EVENT_NPC_ONDEATH);
}