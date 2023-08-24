//::///////////////////////////////////////////////
//:: Name Selvetarm's Wrath
//:: FileName prc_dj_selwrath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
The Selvetarm's Wrath feat for the Drow Judicator
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-31-04
//:: Updated by Oni5115 9/23/2004 to use new combat engine
//:://////////////////////////////////////////////

#include "prc_inc_combat"
//#include "prc_inc_util"

void main()
{
     object oPC   = OBJECT_SELF;
     object oTarget  = PRCGetSpellTargetObject();

     if(oPC == oTarget)
     {
          SendMessageToPC(oPC,"You cannot attack yourself...");
          return;
     }
        

     object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
     object oWeapR   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

     int bIsRangedAttack = GetWeaponRanged(oWeapR);
     int iDamageBonus = GetLevelByClass(CLASS_TYPE_JUDICATOR);

     // script now uses combat system to hit and apply effect if appropriate
     string sSuccess = "";
     string sMiss = "";
     float fDistance = GetDistanceBetween(oPC, oTarget);
     
     if(oPC == oTarget)
     {
          SendMessageToPC(oPC,"You cannot attack yourself...");
          return;
     }
        
     // If they are not within 5 ft, they can't do a melee attack.
     if(!bIsRangedAttack && !GetIsInMeleeRange(oTarget, oPC) )
     {
          SendMessageToPC(oPC,"You are not close enough to your target to attack!");
          return;
     }
     
     if(!bIsRangedAttack)
     {
           AssignCommand(oPC, ActionMoveToLocation(GetLocation(oTarget), TRUE) );
           sSuccess = "*Selvetarm's Wrath Hit*";
           sMiss    = "*Selvetarm's Wrath Miss*";
     }        
     
     effect eVis1 = EffectVisualEffect(VFX_IMP_EVIL_HELP);
     effect eVis2 = EffectVisualEffect(VFX_IMP_HARM);
     effect eLink = EffectLinkEffects(eVis1, eVis2);
     
     PerformAttackRound(oTarget, oPC, eLink, 0.0, 0, iDamageBonus, DAMAGE_TYPE_DIVINE, FALSE, sSuccess, sMiss);
}