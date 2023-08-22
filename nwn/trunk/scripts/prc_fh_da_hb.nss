//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Foe Hunter Death Attack Heartbeat script
    Used the PnP Assassins death attack as reference
    to setup a more PnP style death attack for the
    Foe Hunter.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: July 12, 2004
//:://////////////////////////////////////////////

#include "prc_inc_combat"
void main()
{
    object oPC = OBJECT_SELF;

    // Currently from the PnP rules they dont have to wait except for the study time
    // So this fWaitTime is not being used at all
    // Are we still counting down before they can do another DA?
    float fWaitTime = GetLocalFloat(oPC, "PRC_FH_DEATHATTACK_WAITSEC");
    if (fWaitTime > 0.0)
    {
        // The wait is over they can do another DA
        DeleteLocalFloat(oPC, "PRC_FH_DEATHATTACK_WAITSEC");
        return;
    }

    // We must be counting down until we can apply the slay property
    // Assasain must not be seen
    if (!((GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED) ||
         (PRCGetHasEffect(EFFECT_TYPE_INVISIBILITY,oPC)) ||
         !(GetIsInCombat(oPC)) ||
         (PRCGetHasEffect(EFFECT_TYPE_SANCTUARY,oPC))))
    {
        FloatingTextStringOnCreature("Your target is aware of you, you can not perform a death attack", OBJECT_SELF);
        DeleteLocalFloat(oPC, "PRC_FH_DEATHATTACK_APPLY");
        return;
    }
    
    float fApplyDATime = GetLocalFloat(oPC, "PRC_FH_DEATHATTACK_APPLY");
    // We run every 6 seconds
    fApplyDATime -= 6.0;
    SetLocalFloat(oPC, "PRC_FH_DEATHATTACK_APPLY", fApplyDATime);

    // Times up, perform the death attack
    if (fApplyDATime <= 0.0)
    {
        object oTarget = PRCGetSpellTargetObject();
        object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        
        int bIsRangedAttack = GetWeaponRanged(oWeapR);
     
        int bIsDeniedDex = GetIsDeniedDexBonusToAC(oTarget, oPC);
        int iEnemyRace = MyPRCGetRacialType(oTarget);
     
        effect eDeath;
        string sSuccess = "";
        string sMiss = "";
        
        // If they are not within 10 ft, they can't do a melee attack.
        if(!bIsRangedAttack && !GetIsInMeleeRange(oTarget, oPC) )
        {
             SendMessageToPC(oPC,"You are not close enough to your target to attack!");
             return;
        }
     
        if(!bIsRangedAttack && GetLocalInt(oPC, "HatedFoe") == iEnemyRace )
        {
              sSuccess = "*Death Attack Hit*";
              sMiss = "*Death Attack Miss*";
             
              AssignCommand(oPC, ActionMoveToLocation(GetLocation(oTarget), TRUE) );
           
              int iSaveDC = 10 + GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC) + GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
              int iSave = FortitudeSave(oTarget, iSaveDC, SAVING_THROW_TYPE_NONE, oPC);
              if(iSave == 0)
              {
                   eDeath = EffectDeath();
              }
              else
              {
                   sSuccess = "*Death Attack Failed*";
              }
        }
        
        if(GetLocalInt(oPC, "HatedFoe") != iEnemyRace )
        {
            sSuccess = "*Not Hated Foe: Death Attack Not Possible*";
        }          
        
        PerformAttackRound(oTarget, oPC, eDeath, 0.0, 0, 0, 0, FALSE, sSuccess, sMiss);
    }
    else
    {
        SendMessageToPC(oPC,"Your are still studying your target.  Please wait "+IntToString(FloatToInt(fApplyDATime))+ " seconds and you will perform the death attack");
        // Run more heartbeats
        DelayCommand(6.0,ExecuteScript("prc_fh_da_hb",oPC));
    }
    return;
}