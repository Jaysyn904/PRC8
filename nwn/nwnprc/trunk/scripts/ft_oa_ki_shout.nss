//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//;;
//:: ft_oa_ki_shout.nss
//;:
//:://////////////////////////////////////////////////////////////////
//:
/*
	Ki Shout
	(Oriental Adventures, p. 64)

	[General]

	You can bellow forth a ki-empowered shout that strikes terror into
	your enemies.
	
	Prerequisite
	Base attack bonus +1, CHA 13
	
	Required for
	Empty Hand Mastery (OA) , Great Ki Shout (OA) , Mighty Works 
	Mastery II (OA)
	
	Benefit
	Making a ki shout is a standard action. Opponents who can hear 
	your shout and who are within 30 feet of you may become shaken for 
	1d6 rounds. The ki shout affects only opponents with fewer Hit 
	Dice or levels than you have. An affected opponent can resist the 
	effects with a successful Will save against a DC of 10 + 1/2 your 
	character level + your Charisma modifier. You can use Ki Shout 
	once per day.

	Shaken characters suffer a -2 morale penalty on attack rolls, 
	saves, and checks.


	Great Ki Shout
	(Oriental Adventures, p. 63)

	[General]

	Your ki shout can panic your opponents.
	
	Prerequisite
	Ki Shout (OA) , CHA 13, Base attack bonus +9
	
	Benefit	

	When you make a ki shout, your opponents are panicked for 2d6 
	rounds unless they succeed at their Will saves (DC 10 + 1/2 your 
	character level + your Charisma modifier). Panicked characters 
	suffer a —2 morale penalty on attack rolls, saves, and checks, 
	they have a 50% chance to drop what they are holding, and they 
	run away from you as quickly as they can. The effects of being 
	panicked supersede the effects of being shaken.
	
*/
//:
//:://////////////////////////////////////////////////////////////////
//:: 
//:: Created by: Jaysyn
//:: Created on: 2026-02-13 18:31:43
//::
//:://////////////////////////////////////////////////////////////////  
#include "prc_inc_spells"   
 
// Copy non-plot item from a slot to the ground, confirm, then destroy original; notify victim
void ForceDropSlot(object oTarget, int nSlot)  
{  
    object oItem = GetItemInSlot(nSlot, oTarget);  
    if (!GetIsObjectValid(oItem) || GetPlotFlag(oItem)) return;  
  
    // Ensure droppable and not stolen  
    SetDroppableFlag(oItem, TRUE);  
    SetStolenFlag(oItem, FALSE);  
  
    // Copy to the ground at target's location  
    location lLoc = GetLocation(oTarget);  
    object oCopy = CopyObject(oItem, lLoc, OBJECT_INVALID);  
  
    if (GetIsObjectValid(oCopy))  
    {  
        DestroyObject(oItem);  
        SendMessageToPC(oTarget, "You dropped " + GetName(oItem) + ".");  
    }  
}

void main()  
{  
    object oPC = OBJECT_SELF;  
    int bGreat = GetHasFeat(FEAT_GREAT_KI_SHOUT, oPC);  
    if (!bGreat && !GetHasFeat(FEAT_KI_SHOUT, oPC, TRUE)) return;

    // Effects  
    effect eShaken = ExtraordinaryEffect(EffectShaken());  
    effect ePanicked = ExtraordinaryEffect(EffectLinkEffects(eShaken, EffectFrightened()));  
    ePanicked = EffectLinkEffects(ePanicked, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));  
  
    // Radius and duration  
    float fRadius = FeetToMeters(30.0f);  
    float fDuration = RoundsToSeconds(bGreat ? d6(2) : d6());  
  
    // DC  
    int nDC = 10 + (GetHitDice(oPC) / 2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);  
    int nPCHD = GetHitDice(oPC);  
    string sPCID = ObjectToString(oPC);  
    int bDoVFX = FALSE;  
  
    // Loop targets  
    location lLoc = GetLocation(oPC);  
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE);  
    while (GetIsObjectValid(oTarget))  
    {  
         if(DEBUG) DoDebug("Evaluating: " + GetName(oTarget) + " HD=" + IntToString(GetHitDice(oTarget))  
        + " ImmFear=" + IntToString(GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR))  
        + " Saved=" + IntToString(GetLocalInt(oTarget, "KiShout_SavedVs" + sPCID)));
		
		if (oTarget != oPC &&  
            !GetLocalInt(oTarget, "KiShout_SavedVs" + sPCID) &&  
            spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) &&  
            nPCHD > GetHitDice(oTarget))  
        {  
            bDoVFX = TRUE;  
            SignalEvent(oTarget, EventSpellCastAt(oPC, -1, TRUE));  
  
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oPC) &&  
                !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oPC))  
            { 
				if (bGreat)  
				{  
					object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
					object oItemR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
					
					if (d100() < 50)  
					{
						if (GetIsObjectValid(oItemL))  
						{ 
							//SendMessageToPC(oPC, GetName(oTarget)+" is dropping "+GetName(oItemL)+".");
							AssignCommand(oTarget, ForceDropSlot(oTarget, INVENTORY_SLOT_LEFTHAND));  
	 
						}
					}
					if (d100() < 50)  
					{
						if (GetIsObjectValid(oItemR))  
						{ 
							//SendMessageToPC(oPC, GetName(oTarget)+" is dropping "+GetName(oItemR)+".");
							AssignCommand(oTarget, ForceDropSlot(oTarget, INVENTORY_SLOT_RIGHTHAND));  
						}
					}
					
					// Apply panicked effect after drops  
					DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePanicked, oTarget, fDuration));  
				}
				else  
				{  
					// Apply shaken  
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, fDuration);  
				}  
			}  
			else  
			{  
				// 24h immunity  
				SetLocalInt(oTarget, "KiShout_SavedVs" + sPCID, TRUE);  
				AssignCommand(oTarget, DelayCommand(HoursToSeconds(24),  
				DeleteLocalInt(oTarget, "KiShout_SavedVs" + sPCID)));  
			}  
		}  
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE);  
    }  
  
    // VFX  
    if (bDoVFX)  
        ApplyEffectToObject(DURATION_TYPE_INSTANT,  
            EffectVisualEffect(GetGender(oPC) == GENDER_FEMALE ? VFX_FNF_HOWL_WAR_CRY_FEMALE : VFX_FNF_HOWL_WAR_CRY),  
            oPC);  
}