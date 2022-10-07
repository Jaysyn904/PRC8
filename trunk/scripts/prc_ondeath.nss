//::///////////////////////////////////////////////
//:: OnPlayerDeath eventscript
//:: prc_ondeath
//:://////////////////////////////////////////////
/*
    This is also triggered by the NPC OnDeath event.
*/

#include "prc_inc_combat"
#include "psi_inc_psifunc"
#include "inc_ecl"
#include "prc_inc_assoc"

void PreyOnTheWeak(object oDead)
{
    float fRange = FeetToMeters(10.0);

    int i = 1;
    object oPrey = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oDead, i, CREATURE_TYPE_IS_ALIVE, TRUE);
    while(GetIsObjectValid(oPrey) && GetDistanceBetween(oPrey, oDead) < fRange)
    {
        if(GetHasSpellEffect(MOVE_TC_PREY_ON_THE_WEAK, oPrey))
        {
            if(!GetLocalInt(oPrey, "PRC_POTW_HAS_ATTACKED"))
            {
                //GetNearestEnemy
                object oAoOTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPrey, 1, CREATURE_TYPE_IS_ALIVE, TRUE);
                if(GetIsObjectValid(oAoOTarget) && GetDistanceBetween(oPrey, oAoOTarget) < fRange)
                {
                    effect eNone;
                    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPrey);
                    //SetLocalInt
                    SetLocalInt(oPrey, "PRC_POTW_HAS_ATTACKED", 1);

                    PerformAttack(oAoOTarget, oPrey, eNone, 0.0, 0, 0, GetWeaponDamageType(oWeap), "Prey on the Weak Hit", "Prey on the Weak Miss");

                    //Set up removal
                    DelayCommand(RoundsToSeconds(1), DeleteLocalInt(oPrey, "PRC_POTW_HAS_ATTACKED"));
                }
            }
        }
        i++;
        oPrey = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oDead, i, CREATURE_TYPE_IS_ALIVE, TRUE);
    }
}

void main()
{
    object oDead   = GetLastBeingDied();
    object oKiller = MyGetLastKiller();

    // We are not actually dead until -10
    // Unless it's a spell death

    //int nHP = GetCurrentHitPoints(oDead);
    //if ((nHP >= -9) || (GetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied"))
    //    return;


    // Unsummon familiar/animal companions
    DelayCommand(0.1f, UnsummonCompanions(oDead));

    // Clear a damage tracking variable. Oni's stuff uses this
    SetLocalInt(oDead, "PC_Damage", 0);

    // Do Lolth's Meat for the killer
    if(GetAbilityScore(oDead, ABILITY_INTELLIGENCE) > 4 && GetHasFeat(FEAT_LOLTHS_MEAT, oKiller))
    {
        effect eLink = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
               eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1, ATTACK_BONUS_MISC));
               eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oKiller, RoundsToSeconds(GetHitDice(oKiller)));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oKiller);
    }
	
	// Do Mind Cleave feat
	if(GetHasFeat(FEAT_MIND_CLEAVE, oKiller))
    {
    	SetLocalInt(oKiller, "MindCleave", TRUE);
		ExecuteScript("psi_sk_psychsrtk", oKiller);
		DelayCommand(0.25, DeleteLocalInt(oKiller, "MindCleave"));
	}
    
    // Do Merciless Purity from Shadowbane Inq
    if(GetLocalInt(oDead, "MercilessPurity") && GetIsObjectValid(GetLocalObject(oDead, "Shadowbane")))
    {
        object oShadow = GetLocalObject(oDead, "Shadowbane");
        effect eLink = EffectSavingThrowIncrease(SAVING_THROW_FORT, 1, SAVING_THROW_TYPE_ALL);
               eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 1, SAVING_THROW_TYPE_ALL));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oShadow, HoursToSeconds(24));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oShadow);
        if (DEBUG) FloatingTextStringOnCreature("Merciless Purity activated", oShadow, FALSE);
    }    

    if(GetPRCSwitch(PRC_XP_USE_PNP_XP))
    {
        if(GetObjectType(oKiller) == OBJECT_TYPE_TRIGGER)
            oKiller = GetTrapCreator(oKiller);
        if(oKiller != oDead
            && GetIsObjectValid(oKiller)
            && !GetIsFriend(oKiller, oDead)
            && (GetIsObjectValid(GetFirstFactionMember(oKiller, TRUE))
                || GetPRCSwitch(PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS)))
        {
            GiveXPRewardToParty(oKiller, oDead);

           /* Not needed as we now disabled the bioware system if this is enabled
            *
            //bypass bioware XP system
            //AssignCommand(oDead, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDead));
            SetLocalInt(oDead, "PRC_PNP_XP_DEATH", 1);
            //AssignCommand(oDead, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(10000, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oDead));
            AssignCommand(oDead, ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oDead));
            */
        }
    }

    // Prey on the Weak
    PreyOnTheWeak(oDead);

    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oDead))
        SetPersistantLocalInt(oDead, "persist_dead", TRUE);

    // Psionic creatures lose all PP on death
    if(GetIsPsionicCharacter(oDead))
        LoseAllPowerPoints(oDead, TRUE);

    DeleteLocalInt(oDead, "PRC_SPELL_CHARGE_COUNT");
    DeleteLocalInt(oDead, "PRC_SPELL_HOLD");

    // Trigger the death/bleed if the PRC Death system is enabled (ElgarL).
    if((GetPRCSwitch(PRC_PNP_DEATH_ENABLE)) && GetIsPC(oDead))
        AddEventScript(oDead, EVENT_ONHEARTBEAT, "prc_timer_dying", TRUE, FALSE);

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oDead, EVENT_ONPLAYERDEATH);
}

