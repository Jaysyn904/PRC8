//::///////////////////////////////////////////////
//:: Name Drow Judicator Warstrike
//:: FileName prc_dj_warstrike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This is the spell effect of the Warstrike ability
of the Drow Judicator prestige class.
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-24-04
//:: Updated by Oni5115 9/23/2004 to use new combat engine
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{

//Setup Variables
object oPC      = OBJECT_SELF;
object oTarget  = PRCGetSpellTargetObject();

if(oPC == oTarget)
{
     SendMessageToPC(oPC,"You cannot attack yourself...");
     return;
}
        
object oWeapR   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

int bIsRangedAttack = GetWeaponRanged(oWeapR);
int    nClass   = GetLevelByClass(CLASS_TYPE_JUDICATOR);
int    nChaMod  = GetAbilityModifier(ABILITY_CHARISMA);
int    nFortDC  = 10+nClass+nChaMod;
int    nCon     = d6(2);

//Roll Fortitude Saving Throw
if(FortitudeSave(oTarget, nFortDC, SAVING_THROW_FORT, oPC))
{
    nCon = nCon/2;
			if (GetHasMettle(oTarget, SAVING_THROW_FORT))
			// This script does nothing if it has Mettle, bail
				return;      
    //Debug
    //SpeakString("Debug Save Succeeded.  Damage Dealt ="+IntToString(nCon));
}

effect eVis = EffectVisualEffect(VFX_IMP_POISON_L);
effect eCon  = EffectAbilityDecrease(ABILITY_CONSTITUTION,nCon);
effect eLink = EffectLinkEffects(eVis, eCon);

//ApplyEffectToObject(DURATION_TYPE_PERMANENT, MagicalEffect(eLink), oTarget);
//Debug
//SpeakString("Damage Dealt ="+IntToString(nCon));


     // script now uses combat system to hit and apply effect if appropriate
     string sSuccess = "";
     string sMiss = "";
     float fDistance = GetDistanceBetween(oPC, oTarget);
        
     // If they are not within 10 ft, they can't do a melee attack.
     if(!bIsRangedAttack &&  !GetIsInMeleeRange(oTarget, oPC) )
     {
          SendMessageToPC(oPC,"You are not close enough to your target to attack!");
          return;
     }
     
     if(!bIsRangedAttack)
     {
           AssignCommand(oPC, ActionMoveToLocation(GetLocation(oTarget), TRUE) );
           sSuccess = "*War Strike Hit*";
           sMiss    = "*War Strike Miss*";
           
     }        
     
     PerformAttackRound(oTarget, oPC, eLink, 0.0, 0, 0, 0, FALSE, sSuccess, sMiss);
}
