/*
   ----------------
   Pearl of Black Doubt

   tob_dmnd_prlbdt
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Pearl of Black Doubt

    Diamond Mind (Stance)
    Level: Swordsage 3, Warmage 3
    Prerequisite: One Diamond Mind maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    With every miss, your opponents become more uncertain, their doubt growing
    like an irritating pearl in the mouth of a helpless oyster.
    
    Whenever a foe swings and misses you, you gain +2 AC.
*/
#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

int GetAPR(object oCreature)
{
	int nAPR = GetAttacksPerRound(oCreature, TRUE);

    if (PRCGetHasEffect(EFFECT_TYPE_HASTE, oCreature))
    {
        nAPR++;
    }

    return nAPR;
}

void main()
{
	//Declare main variables.
    int nEvent = GetRunningEvent();
	
	object oItem;
    object oInitiator;
	object oTarget       = PRCGetSpellTargetObject();
	
    switch(nEvent)
    {

		case EVENT_ONHEARTBEAT:         	oInitiator = OBJECT_SELF;               break;
		case EVENT_ONPLAYERREST_FINISHED:	oInitiator = GetLastBeingRested();		break;

        default:
            oInitiator = OBJECT_SELF;
			
    }
	
	if(nEvent == FALSE)
    {
		if (!PreManeuverCastCode())
		{
			// If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
			return;
		}
		// End of Spell Cast Hook

		struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

		if(move.bCanManeuver)
		{
			object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);

			itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);  
			ip = TagItemProperty(ip, "Tag_PRC_OnHitKeeper");
			IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
								  9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
						
			effect eDur = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
			eDur		= TagEffect(eDur, "PEARL_OF_BLACK_DOUBT");
			eDur 		= ExtraordinaryEffect(eDur);
			
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, 9999.0);

			if(DEBUG) DoDebug("PoBD stance activated");  	

			AddEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_dmnd_prlbdt", TRUE, FALSE);
			AddEventScript(oInitiator, EVENT_ONPLAYERREST_FINISHED, "tob_dmnd_prlbdt", TRUE, FALSE);			
		}
		
	}
	if(nEvent == EVENT_ONHEARTBEAT)
	{
		int nBonus = 0;
		location lLoc = GetLocation(oTarget);
		object oEnemy = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lLoc, TRUE, OBJECT_TYPE_CREATURE);

		while (GetIsObjectValid(oEnemy))
		{
			if (GetIsEnemy(oTarget, oEnemy) &&
				GetIsInCombat(oEnemy) &&
				GetDistanceBetween(oEnemy, oTarget) <= 5.0 &&
				GetCurrentAction(oEnemy) == ACTION_ATTACKOBJECT &&  // Must be attacking
				GetAttackTarget(oEnemy) == oTarget)  // Must be attacking this PC
			{
				int nAPR = GetAPR(oEnemy);
				nBonus += 2 * nAPR;

				string s = "Enemy: " + GetName(oEnemy) + " APR: " + IntToString(nAPR);
				if(DEBUG) DoDebug(s, oTarget);
			}

			oEnemy = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lLoc);
		}

		if (nBonus > 0)  
		{  
			if(GetLocalInt(oTarget, "PearlOfBlackDoubt_JustHit"))  
			{  
				DeleteLocalInt(oTarget, "PearlOfBlackDoubt_JustHit");  
				return;  
			}  
		  
			// Cap bonus at +20  
			if(nBonus > 20) nBonus = 20;  
		  
			if(DEBUG) DoDebug("Applying AC Bonus: " + IntToString(nBonus));  
			  
			effect eAC 	= EffectACIncrease(nBonus);  
			eAC 		= ExtraordinaryEffect(eAC);  
			eAC 		= TagEffect(eAC, "PEARL_OF_BLACK_DOUBT_BONUS");			  
			  
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, 5.9);  
			SetLocalInt(oTarget, "PearlOfBlackDoubtBonus", nBonus);  
		}
		else
		{
			if(DEBUG) DoDebug("PoBD: No enemies in melee");
			DeleteLocalInt(oTarget, "PearlOfBlackDoubtBonus");
	
			effect eEffect = GetFirstEffect(oInitiator);
			while(GetIsEffectValid(eEffect))
			{
				if(GetEffectTag(eEffect) == "PEARL_OF_BLACK_DOUBT_BONUS")
					RemoveEffect(oInitiator, eEffect);
				
				eEffect = GetNextEffect(oInitiator);
			}
		}			
	}
	if(nEvent == EVENT_ONPLAYERREST_FINISHED)
	{		
		effect eEffect = GetFirstEffect(oInitiator);
		while(GetIsEffectValid(eEffect))
		{
			if(GetEffectTag(eEffect) == "PEARL_OF_BLACK_DOUBT")
				RemoveEffect(oInitiator, eEffect);
			
			eEffect = GetNextEffect(oInitiator);
		}
		
		if(DEBUG) DoDebug("Removing Pearl of Black Doubt");
		
		RemoveEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_dmnd_prlbdt", TRUE, FALSE);
		RemoveEventScript(oInitiator, EVENT_ONPLAYERREST_FINISHED, "tob_dmnd_prlbdt", TRUE, FALSE);		
	}
}