//::///////////////////////////////////////////////
//:: Magic of Incarnum events
//:: moi_events
//::///////////////////////////////////////////////
/** @file
    Does all MoI content that require event scripting.

    @author Stratovarius
    @date   Created - 2019.12.31
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "prc_inc_combmove"
#include "pnp_shft_main" // Silly horse system
#include "x0_i0_modes"
#include "inc_addragebonus"

//////////////////////////////////////////////////
/*             Content Functions                */
//////////////////////////////////////////////////

void BloodwarGauntlets(object oMeldshaper, object oItem, int nEvent)  
{  
    // Check if bound to Hands chakra (regular or double)  
    int nBoundToHands = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HANDS)) == MELD_BLOODWAR_GAUNTLETS ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HANDS)) == MELD_BLOODWAR_GAUNTLETS)  
        nBoundToHands = TRUE;  
  
    if (!nBoundToHands) return;  
  
    if(nEvent == EVENT_ONPLAYEREQUIPITEM)  
    {  
        itemproperty ip = ItemPropertyKeen();  
        ip = TagItemProperty(ip, "moi_BloodwarGauntletsKeen");  
        IPSafeAddItemProperty(oItem, ip, 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)  
    {  
        // Remove only the tagged keen property  
        itemproperty ipCheck = GetFirstItemProperty(oItem);  
        while (GetIsItemPropertyValid(ipCheck))  
        {  
            if (GetItemPropertyTag(ipCheck) == "moi_BloodwarGauntletsKeen")  
                RemoveItemProperty(oItem, ipCheck);  
            ipCheck = GetNextItemProperty(oItem);  
        }  
    }  
}

/* void BloodwarGauntlets(object oMeldshaper, object oItem, int nEvent)
{
	if (GetIsMeldBound(oMeldshaper, MELD_BLOODWAR_GAUNTLETS) != CHAKRA_HANDS) return;
	
	if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
		IPSafeAddItemProperty(oItem, ItemPropertyKeen(), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);	       
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
    	RemoveSpecificProperty(oItem, ITEM_PROPERTY_KEEN, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);  
    }	
} */

void Bloodtalons(object oMeldshaper, object oItem, object oTarget)
{
	if (GetIsMeldBound(oMeldshaper, MELD_BLOODTALONS) != CHAKRA_TOTEM) return;
    
    if(oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper) || oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper)) 
    {
    	// Living creatures only
    	if (PRCGetIsAliveCreature(oTarget))
    	{	
        	effect eDam = EffectDamage(GetEssentiaInvested(oMeldshaper, MELD_BLOODTALONS), DAMAGE_TYPE_BASE_WEAPON);
        	DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }	
    }// end if - Item is a melee weapon 	
}

void DreadCarapace(object oMeldshaper)
{
	object oLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper);
	object oRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper);
	object oBite  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oMeldshaper);
	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DREAD_CARAPACE);
	
    if (GetIsObjectValid(oLeft)) 
    {
    	IPSafeAddItemProperty(oLeft, ItemPropertyAttackPenalty(nEssentia+1), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    	IPSafeAddItemProperty(oLeft, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, IPDamageConstant(nEssentia+1)), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    }	
    if (GetIsObjectValid(oRight)) 
    {
    	IPSafeAddItemProperty(oRight, ItemPropertyAttackPenalty(nEssentia+1), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    	IPSafeAddItemProperty(oRight, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, IPDamageConstant(nEssentia+1)), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    }
    if (GetIsObjectValid(oBite)) 
    {
    	IPSafeAddItemProperty(oBite, ItemPropertyAttackPenalty(nEssentia+1), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    	IPSafeAddItemProperty(oBite, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, IPDamageConstant((nEssentia+1)*2)), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    }
	
    if (GetIsMeldBound(oMeldshaper, MELD_DREAD_CARAPACE) == CHAKRA_ARMS || GetIsMeldBound(oMeldshaper, MELD_DREAD_CARAPACE) == CHAKRA_DOUBLE_ARMS)
    {
    	if (GetIsObjectValid(oLeft)) IPSafeAddItemProperty(oLeft, ItemPropertyKeen(), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (GetIsObjectValid(oRight)) IPSafeAddItemProperty(oRight, ItemPropertyKeen(), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (GetIsObjectValid(oBite)) IPSafeAddItemProperty(oBite, ItemPropertyKeen(), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
}

void FearsomeMask(object oMeldshaper)
{
	location lTarget = GetLocation(oMeldshaper);
	int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_SOULBORN, MELD_FEARSOME_MASK);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetIsEnemy(oMeldshaper, oTarget))
        {
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, 60.0);
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }	
}

void GirallonArms(object oMeldshaper)
{
	object oLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper);
	object oRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper);
	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_GIRALLON_ARMS);
	
    if (GetIsObjectValid(oLeft)) 
    	IPSafeAddItemProperty(oLeft, ItemPropertyEnhancementBonus(nEssentia), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);	
    if (GetIsObjectValid(oRight)) 
    	IPSafeAddItemProperty(oRight, ItemPropertyEnhancementBonus(nEssentia), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
}

void HeartOfFire(object oMeldshaper)
{
	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_HEART_OF_FIRE);
	//FloatingTextStringOnCreature("Heart of Fire heartbeat", oMeldshaper);
    if (GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_TOTEM)
    {
    	
		object oLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper);
		object oRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper);
		object oBite  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oMeldshaper);   
		
		int nDamage = EssentiaToD4(nEssentia);
		//FloatingTextStringOnCreature("Heart of Fire heartbeat Damage is "+IntToString(nDamage), oMeldshaper);
    
    	if (GetIsObjectValid(oLeft)) 
    	{
    		//FloatingTextStringOnCreature("Heart of Fire oLeft is "+GetName(oLeft), oMeldshaper);
    		IPSafeAddItemProperty(oLeft, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    		AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage), oLeft, 6.0);
    		//if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper))) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nEssentia), DAMAGE_TYPE_FIRE), oTarget);
    	}	
    	if (GetIsObjectValid(oRight)) 
    	{
    		//FloatingTextStringOnCreature("Heart of Fire oRight is "+GetName(oRight), oMeldshaper);
			IPSafeAddItemProperty(oRight, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
			AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage), oRight, 6.0);
		}	
    	if (GetIsObjectValid(oBite)) 
    	{
    		//FloatingTextStringOnCreature("Heart of Fire oBite is "+GetName(oBite), oMeldshaper);
			IPSafeAddItemProperty(oBite, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage), 6.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
			AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage), oBite, 6.0);
		}	
	}
}

void HeartOfFireOnHit(object oMeldshaper, object oTarget)
{
	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_HEART_OF_FIRE);
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    if (!GetIsObjectValid(oRight)) // If they don't have a weapon in their right hand and hit us, it was a natural attack
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nEssentia), DAMAGE_TYPE_FIRE), oTarget);
}

void _DoPush(object oTarget, object oMeldshaper)
{
        // Calculate how far the creature gets pushed
        float fDistance = FeetToMeters(50.0f);
        // Determine if they hit a wall on the way
        location lTrueSpeaker  = GetLocation(oMeldshaper);
        location lTargetOrigin = GetLocation(oTarget);
        vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lTrueSpeaker, lTargetOrigin));
        vector vTargetOrigin   = GetPosition(oTarget);
        vector vTarget         = vTargetOrigin + (vAngle * fDistance);
        
        if(!LineOfSightVector(vTargetOrigin, vTarget))
        {
                // Hit a wall, binary search for the wall
                float fEpsilon    = 1.0f;          // Search precision
                float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
                float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
                fDistance         = fDistance / 2; // The search position, set to middle of the range
                
                do
                {
                        // Create test vector for this iteration
                        vTarget = vTargetOrigin + (vAngle * fDistance);
                        
                        // Determine which bound to move.
                        if(LineOfSightVector(vTargetOrigin, vTarget))
                        fLowerBound = fDistance;
                        else
                        fUpperBound = fDistance;
                        
                        // Get the new middle point
                        fDistance = (fUpperBound + fLowerBound) / 2;
                }
                while(fabs(fUpperBound - fLowerBound) > fEpsilon);
        }
        
        // Create the final target vector
        vTarget = vTargetOrigin + (vAngle * fDistance);
        
        // Move the target
        location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget, JumpToLocation(lTargetDestination));
}

void LammasuRepulsion(object oMeldshaper)
{
    location lTarget = GetLocation(oMeldshaper);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    {
        if(GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED)
        {
	        _DoPush(oTarget, oMeldshaper);
        }
        //Get next target.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

void LammasuAllies(object oMeldshaper)
{
    location lTarget   = GetLocation(oMeldshaper);
	int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_LAMMASU_MANTLE);
    effect eLink       = EffectACIncrease(2, AC_DEFLECTION_BONUS);
    
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia));
    
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    {
        if(GetIsFriend(oMeldshaper, oTarget))
        {
	        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(VersusAlignmentEffect(eLink, ALIGNMENT_ALL, ALIGNMENT_EVIL)), oTarget, 6.0);
        }
        //Get next target.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

void MantleOfFlameOnHit(object oMeldshaper, object oTarget)
{
	if (GetDistanceBetween(oMeldshaper, oTarget) <= FeetToMeters(10.0f))
	{
		int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_MANTLE_OF_FLAME);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nEssentia+1), DAMAGE_TYPE_FIRE), oTarget);
	}	
}

void PhaseCloak(object oMeldshaper)  
{  
    // Check if bound to Shoulders chakra (regular or double)  
    int nBoundToShoulders = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_SHOULDERS)) == MELD_PHASE_CLOAK ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_SHOULDERS)) == MELD_PHASE_CLOAK)  
        nBoundToShoulders = TRUE;  
  
    if (!nBoundToShoulders) return;  
  
    // Check to see if the WP is valid  
    string sWPTag = "PhaseCloakWP_" + GetName(oMeldshaper);  
    object oTestWP = GetWaypointByTag(sWPTag);  
    if (!GetIsObjectValid(oTestWP))  
    {  
        // Create waypoint for the movement  
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oMeldshaper), FALSE, sWPTag);  
    }  
    else // We have a test waypoint, now to check the distance  
    {  
        // Distance moved in the last round  
        float fDist = GetDistanceBetween(oMeldshaper, oTestWP);  
        // Distance needed to move  
        float fCheck = FeetToMeters(5.0);  
  
        // Now clean up the WP and create a new one for next round's check  
        DestroyObject(oTestWP);  
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oMeldshaper), FALSE, sWPTag);  
  
        // Moved the distance  
        if (fDist >= fCheck)  
        {  
            SetIncorporeal(oMeldshaper, 3.0, 1);  
        }  
    }  
}

/* void PhaseCloak(object oMeldshaper)
{
    // Check to see if the WP is valid
    string sWPTag = "PhaseCloakWP_" + GetName(oMeldshaper);
    object oTestWP = GetWaypointByTag(sWPTag);
    if (!GetIsObjectValid(oTestWP))
    {
        // Create waypoint for the movement
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oMeldshaper), FALSE, sWPTag);
    }
    else // We have a test waypoint, now to check the distance
    {
        // Distance moved in the last round
        float fDist = GetDistanceBetween(oMeldshaper, oTestWP);
        // Distance needed to move
        float fCheck = FeetToMeters(5.0);

        // Now clean up the WP and create a new one for next round's check
        DestroyObject(oTestWP);
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oMeldshaper), FALSE, sWPTag);

        // Moved the distance
        if (fDist >= fCheck)
        {
			SetIncorporeal(oMeldshaper, 3.0, 1);
        }
    }
} */

void PlanarWard(object oMeldshaper, object oTarget)
{
	if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_OUTSIDER || GetLocalInt(oTarget, "PlanarWardImmune")) return; // Outsiders only past this point
	
	int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_PLANAR_WARD) + GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_PLANAR_WARD) - GetHitDice(oTarget);
	
	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
		ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath(TRUE)), oTarget);
	else
		SetLocalInt(oTarget, "PlanarWardImmune", TRUE);
}

void RageClaws(object oMeldshaper)
{
	effect eLink = EffectLinkEffects(EffectAttackIncrease(2), EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BASE_WEAPON));
		   eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, 2));
		   
	if (GetHitDice(oMeldshaper) >= GetCurrentHitPoints(oMeldshaper))
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 6.0);
}

void RidingBracers(object oMeldshaper)
{
    if (PRCHorseGetIsMounted(oMeldshaper))
    {	
		if(GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_ARMS || GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_DOUBLE_ARMS)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectLinkEffects(EffectACIncrease(2, AC_DODGE_BONUS), EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BASE_WEAPON))), oMeldshaper, 6.0);
		
		if(GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_TOTEM || GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_DOUBLE_TOTEM)
			IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_EVASION), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}	
}

void TotemAvatar(object oMeldshaper)
{
	int nDamageBonus;
	if (GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_SHOULDERS)
		nDamageBonus += 2;
	
	if (GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_TOTEM) 
		nDamageBonus += GetEssentiaInvested(oMeldshaper, MELD_TOTEM_AVATAR);


	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
    if (!GetIsObjectValid(oRight)) // If they don't have a weapon in their right hand, it was a natural attack
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nDamageBonus), DAMAGE_TYPE_BASE_WEAPON), oMeldshaper, 6.0);
}

void WorgPeltHB(object oMeldshaper)
{
	object oLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper);
	object oBite  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oMeldshaper);
	
	if (GetIsObjectValid(oLeft))
    {       
        // Add eventhook to the armor
        IPSafeAddItemProperty(oLeft, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        AddEventScript(oLeft, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);
    }  	
	if (GetIsObjectValid(oBite))
    {       
        // Add eventhook to the armor
        IPSafeAddItemProperty(oBite, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        AddEventScript(oBite, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);
    } 	
}

void JaebrinHB(object oMeldshaper)
{
	object oBite  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oMeldshaper);
	
	if (GetIsObjectValid(oBite))
    {       
        // Add eventhook to the bite
        IPSafeAddItemProperty(oBite, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        AddEventScript(oBite, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);
    } 	
}

void WorgPeltOnHit(object oMeldshaper, object oItem, object oTarget)
{
	if (GetIsMeldBound(oMeldshaper, MELD_WORG_PELT) != CHAKRA_HANDS) return;
    
    if(oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper) || oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oMeldshaper)) 
    {
		DoTrip(oMeldshaper, oTarget, 0, FALSE, FALSE, TRUE);
    }// end if - Item is a melee weapon 	
}

void JaebrinOnHit(object oMeldshaper, object oItem, object oTarget)
{
	if (GetRacialType(oMeldshaper) != RACIAL_TYPE_JAEBRIN) return;
    
    if(oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oMeldshaper)) 
    {
		int nDC = 10 + GetHitDice(oMeldshaper)/2 + GetAbilityModifier(ABILITY_CONSTITUTION);
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
		{
			 effect eEssence = EffectSavingThrowDecrease(SAVING_THROW_WILL, 4);
			 eEssence = EffectLinkEffects(eEssence, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
			 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(10));
		}		
    }// end if - Item is a melee weapon 	
}

void CobaltExpertise(object oMeldshaper)
{
    // Only applies when using expertise
    if(GetModeActive(ACTION_MODE_EXPERTISE) || GetActionMode(oMeldshaper, ACTION_MODE_EXPERTISE) || GetLastAttackMode(oMeldshaper) == COMBAT_MODE_EXPERTISE ||
       GetModeActive(ACTION_MODE_IMPROVED_EXPERTISE) || GetActionMode(oMeldshaper, ACTION_MODE_IMPROVED_EXPERTISE) || GetLastAttackMode(oMeldshaper) == COMBAT_MODE_IMPROVED_EXPERTISE)
    {
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(GetEssentiaInvestedFeat(oMeldshaper, FEAT_COBALT_EXPERTISE)), oMeldshaper, 6.0);
    }
}

void CobaltPower(object oMeldshaper)
{
    // Only applies when using expertise
    if(GetModeActive(ACTION_MODE_POWER_ATTACK) || GetActionMode(oMeldshaper, ACTION_MODE_POWER_ATTACK) || GetLastAttackMode(oMeldshaper) == COMBAT_MODE_POWER_ATTACK ||
       GetModeActive(ACTION_MODE_IMPROVED_POWER_ATTACK) || GetActionMode(oMeldshaper, ACTION_MODE_IMPROVED_POWER_ATTACK) || GetLastAttackMode(oMeldshaper) == COMBAT_MODE_IMPROVED_POWER_ATTACK)
    {
    	int nDamageType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
       	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(GetEssentiaInvestedFeat(oMeldshaper, FEAT_COBALT_POWER)), nDamageType), oMeldshaper, 6.0);
    }
}

void MidnightDodge(object oMeldshaper)
{
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(GetEssentiaInvestedFeat(oMeldshaper, FEAT_MIDNIGHT_DODGE)), oMeldshaper, 6.0);
}

void IncandescentAura(object oMeldshaper)
{
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_INCANDESCENT_AURA);

    if (nEssentia) 
    {
    	location lTarget = GetLocation(oMeldshaper);
    	// Use the function to get the closest creature as a target
    	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oAreaTarget))
    	{
    	    if(oAreaTarget != oMeldshaper && // Not you
    	       GetIsInMeleeRange(oMeldshaper, oAreaTarget) && // They must be in melee range
    	       GetIsEnemy(oAreaTarget, oMeldshaper)) // Only enemies
    	    {
    	    	int nDamage = d6(nEssentia);
    	    	int nDC = 10 + nEssentia + GetAbilityModifier(ABILITY_CHARISMA, oMeldshaper);
    	    	if(PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_NONE))
    	    		nDamage /= 2;
    	        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE)), oAreaTarget);
    	    }
    	//Select the next target within the spell shape.
    	oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}	
    }  
}   

void NecroVestmentsAura(object oMeldshaper)  
{  
    // Validate bind state (regular or double Waist)  
    if (GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_VESTMENTS) != CHAKRA_WAIST &&  
        GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_VESTMENTS) != CHAKRA_DOUBLE_WAIST)  
        return;  
  
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_NECROCARNUM_VESTMENTS);  
    int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_NECROCARNUM_VESTMENTS);   
    location lTarget = GetLocation(oMeldshaper);  
    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    while(GetIsObjectValid(oAreaTarget))  
    {  
        if(oAreaTarget != oMeldshaper && // Not you  
           GetIsInMeleeRange(oMeldshaper, oAreaTarget) && // They must be in melee range  
           GetIsEnemy(oAreaTarget, oMeldshaper)) // Only enemies  
        {  
            int nDamage = d6();  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oAreaTarget, nDC, SAVING_THROW_TYPE_COLD))  
                ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(nDamage, DAMAGE_TYPE_COLD)), oAreaTarget);  
        }  
        //Select the next target within the spell shape.  
        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    }	  
}

/* void NecroVestmentsAura(object oMeldshaper)
{
   	int nClass = GetMeldShapedClass(oMeldshaper, MELD_NECROCARNUM_VESTMENTS);
	int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_NECROCARNUM_VESTMENTS); 
    	location lTarget = GetLocation(oMeldshaper);
    	// Use the function to get the closest creature as a target
    	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oAreaTarget))
    	{
    	    if(oAreaTarget != oMeldshaper && // Not you
    	       GetIsInMeleeRange(oMeldshaper, oAreaTarget) && // They must be in melee range
    	       GetIsEnemy(oAreaTarget, oMeldshaper)) // Only enemies
    	    {
    	    	int nDamage = d6();
    	    	if(!PRCMySavingThrow(SAVING_THROW_FORT, oAreaTarget, nDC, SAVING_THROW_TYPE_COLD))
    	    		ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(nDamage, DAMAGE_TYPE_COLD)), oAreaTarget);
    	    }
    	//Select the next target within the spell shape.
    	oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}	
}  */

void NecrocarnumWeaponHands(object oMeldshaper, object oTarget, object oItem)
{
	if (PRCGetIsAliveCreature(oTarget) && (d20() >= GetWeaponCriticalRange(oMeldshaper, oItem) || GetLocalInt(oTarget, "PRCCombat_CriticalHit")))
	{
		int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_WEAPON);
    	SetTemporaryEssentia(oMeldshaper, nEssentia);
    	DelayCommand(60.0, SetTemporaryEssentia(oMeldshaper, nEssentia*-1)); 
    }	
}

//////////////////////////////////////////////////
/*       Void Main and Event Triggers           */
//////////////////////////////////////////////////

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_events running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oMeldshaper = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oMeldshaper = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oMeldshaper = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oMeldshaper = OBJECT_SELF;               break;
        case EVENT_ONPLAYERREST_FINISHED:   oMeldshaper = GetLastBeingRested();      break;

        default:
            oMeldshaper = OBJECT_SELF;
    }

    object oItem;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("moi_events: Adding eventhooks");
        AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,     "moi_events", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONPLAYERUNEQUIPITEM,   "moi_events", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONHEARTBEAT,           "moi_events", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_events", TRUE, FALSE); 
        object oSkin = GetPCSkin(oMeldshaper);
        
        // Benefits from the Open Chakra feats
        if(GetHasFeat(FEAT_OPEN_LEAST_CHAKRA_CROWN     , oMeldshaper)) SetCompositeBonus(oSkin, "OpenChakraCrown", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        if(GetHasFeat(FEAT_OPEN_LEAST_CHAKRA_FEET      , oMeldshaper)) 
        {
        	SetCompositeBonus(oSkin, "OpenChakraFeet_B", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);
        	SetCompositeBonus(oSkin, "OpenChakraFeet_M", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
        }
        if(GetHasFeat(FEAT_OPEN_LEAST_CHAKRA_HANDS     , oMeldshaper)) 
        {
        	SetCompositeBonus(oSkin, "OpenChakraHands_C", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
        	SetCompositeBonus(oSkin, "OpenChakraHands_J", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
        }        
        if(GetHasFeat(FEAT_OPEN_LESSER_CHAKRA_BROW     , oMeldshaper)) 
        {
        	SetCompositeBonus(oSkin, "OpenChakraBrow_E", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        	SetCompositeBonus(oSkin, "OpenChakraBrow_P", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        }
        if(GetHasFeat(FEAT_OPEN_LESSER_CHAKRA_SHOULDERS, oMeldshaper)) SetCompositeBonus(oSkin, "OpenChakraShoulders", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        if(GetHasFeat(FEAT_OPEN_GREATER_CHAKRA_THROAT  , oMeldshaper)) 
        {
        	SetCompositeBonus(oSkin, "OpenChakraThroat_B", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        	SetCompositeBonus(oSkin, "OpenChakraThroat_P", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        }        
        if(GetHasFeat(FEAT_OPEN_GREATER_CHAKRA_WAIST   , oMeldshaper)) SetCompositeBonus(oSkin, "OpenChakraWaist", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("moi_events: OnHit:\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
        // Blood
        Bloodtalons(oMeldshaper, oItem, oTarget); 
        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            if (GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_WAIST || GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_DOUBLE_WAIST)    
                HeartOfFireOnHit(oMeldshaper, oTarget); 
            if (GetHasSpellEffect(MELD_MANTLE_OF_FLAME, oMeldshaper))
				MantleOfFlameOnHit(oMeldshaper, oTarget);
            if (GetIsMeldBound(oMeldshaper, MELD_PLANAR_WARD) == CHAKRA_THROAT || GetIsMeldBound(oMeldshaper, MELD_PLANAR_WARD) == CHAKRA_DOUBLE_THROAT)    
                PlanarWard(oMeldshaper, oTarget); 
        }
        // Melee weapon checks
        if(IPGetIsMeleeWeapon(oItem))
        {         
        	if (GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_WEAPON) == CHAKRA_HANDS ||
				GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_WEAPON) == CHAKRA_DOUBLE_HANDS) 
					NecrocarnumWeaponHands(oMeldshaper, oTarget, oItem);
		}   
		WorgPeltOnHit(oMeldshaper, oItem, oTarget);
		JaebrinOnHit(oMeldshaper, oItem, oTarget);
    }// end if - Running OnHit event
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oMeldshaper		= GetItemLastEquippedBy();
        oItem 			= GetItemLastEquipped();
		
		if (!GetHasSpellEffect(MELD_HEART_OF_FIRE, oMeldshaper) &&  
			!GetHasSpellEffect(MELD_MANTLE_OF_FLAME, oMeldshaper) &&  
			!GetHasSpellEffect(MELD_PLANAR_WARD, oMeldshaper) &&  
			!GetHasSpellEffect(MELD_BLOODWAR_GAUNTLETS, oMeldshaper) &&  
			!GetHasSpellEffect(MELD_INCARNATE_AVATAR, oMeldshaper) &&  
			!GetHasSpellEffect(MELD_NECROCARNUM_WEAPON, oMeldshaper) &&  
			!GetHasSpellEffect(MELD_MAULING_GAUNTLETS, oMeldshaper) &&  
			!GetHasSpellEffect(MELD_SIGHTING_GLOVES, oMeldshaper) &&  
			!GetIsMeldBound(oMeldshaper, MELD_LANDSHARK_BOOTS))  
			return; 		
		
        if(DEBUG) DoDebug("moi_events - OnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );                  
        // Armor checks
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            if (GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_WAIST || GetIsMeldBound(oMeldshaper, MELD_HEART_OF_FIRE) == CHAKRA_DOUBLE_WAIST ||
                GetHasSpellEffect(MELD_MANTLE_OF_FLAME, oMeldshaper) ||
                GetIsMeldBound(oMeldshaper, MELD_PLANAR_WARD) == CHAKRA_THROAT || GetIsMeldBound(oMeldshaper, MELD_PLANAR_WARD) == CHAKRA_DOUBLE_THROAT)
            {       
                // Add eventhook to the armor
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);
            }           
        } 
        // Melee weapon checks
        if(IPGetIsMeleeWeapon(oItem))
        {        
        	int nBonus = IPGetWeaponEnhancementBonus(oItem);
			
			if (GetHasSpellEffect(MELD_BLOODWAR_GAUNTLETS, oMeldshaper))
			{
				BloodwarGauntlets(oMeldshaper, oItem, nEvent);
			}

            if (GetHasSpellEffect(MELD_INCARNATE_AVATAR, oMeldshaper))
        	{
        		int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_INCARNATE_AVATAR);
        		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL)
        			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
        		if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)
        			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(DamageTypeToIPConst(GetWeaponDamageType(oItem)), IPDamageConstant((nEssentia*2) + nBonus)), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        				
        	}
        	if (GetHasSpellEffect(MELD_NECROCARNUM_WEAPON, oMeldshaper))
        	{
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(3), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(3), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       			if (GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_WEAPON) == CHAKRA_HANDS || GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_WEAPON) == CHAKRA_DOUBLE_HANDS)
       			{
                	// Add eventhook to the armor
                	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                	AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);       			
       			}
       		}	
    		if (GetIsMeldBound(oMeldshaper, MELD_MAULING_GAUNTLETS) == CHAKRA_ARMS || GetIsMeldBound(oMeldshaper, MELD_MAULING_GAUNTLETS) == CHAKRA_DOUBLE_ARMS)
				IPSafeAddItemProperty(oItem, ItemPropertyKeen(), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);        	
        }
        // Ranged weapon checks
        if(GetWeaponRanged(oItem))
        {        
        	if (GetHasSpellEffect(MELD_INCARNATE_AVATAR, oMeldshaper))
        	{
        		int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_INCARNATE_AVATAR);
        		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC)
        			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);      				
        	}
        	if (GetHasSpellEffect(MELD_SIGHTING_GLOVES, oMeldshaper))
        	{
        		int nDamageType = IP_CONST_DAMAGETYPE_PIERCING;
        		int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_SIGHTING_GLOVES);
        		
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(nDamageType, IPDamageConstant(nEssentia+1)), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);     	
        	}        	
        }
        // Shields only
        if(GetIsShield(oItem))
        {
        	if (GetIsMeldBound(oMeldshaper, MELD_LANDSHARK_BOOTS) == CHAKRA_TOTEM || GetIsMeldBound(oMeldshaper, MELD_LANDSHARK_BOOTS) == CHAKRA_DOUBLE_TOTEM)
        		ForceUnequip(oMeldshaper, oItem, INVENTORY_SLOT_LEFTHAND);
        }
        // Ammo checks
        if (GetBaseItemType(oItem) == BASE_ITEM_ARROW ||
            GetBaseItemType(oItem) == BASE_ITEM_BOLT ||
            GetBaseItemType(oItem) == BASE_ITEM_BULLET) 
        {
        	if (GetHasSpellEffect(MELD_SIGHTING_GLOVES, oMeldshaper))
        	{
        		int nDamageType = IP_CONST_DAMAGETYPE_PIERCING;
        		int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_SIGHTING_GLOVES);
        		if (GetBaseItemType(oItem) == BASE_ITEM_BULLET) nDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
        		
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(nDamageType, IPDamageConstant(nEssentia+1)), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);     	
        	}
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oMeldshaper   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("moi_events - OnUnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
				
        if (GetTag(oItem) == "moi_incarnatewpn")  
        	ForceEquip(oMeldshaper, oItem, INVENTORY_SLOT_RIGHTHAND); // No unequipping this weapon
        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            // Remove the temporary OnHitCastSpell: Unique
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);       
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        } 
        // Melee weapon
        if(IPGetIsMeleeWeapon(oItem))
        {
            BloodwarGauntlets(oMeldshaper, oItem, nEvent);
			
			// Remove the attack bonus
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_KEEN, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            // Remove the temporary OnHitCastSpell: Unique
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "moi_events", TRUE, FALSE);       
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);            
        }  
        // Melee weapon
        if(GetWeaponRanged(oItem))
        {
            // Remove the attack bonus
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
        } 
        // Ammo checks
        if (GetBaseItemType(oItem) == BASE_ITEM_ARROW ||
            GetBaseItemType(oItem) == BASE_ITEM_BOLT ||
            GetBaseItemType(oItem) == BASE_ITEM_BULLET) 
        {
			RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }        
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
		if (GetIsMeldShaped(oMeldshaper, MELD_DREAD_CARAPACE, CLASS_TYPE_TOTEMIST)) DreadCarapace(oMeldshaper);

		//if (GetIsMeldBound(oMeldshaper, MELD_FEARSOME_MASK) == CHAKRA_BROW) FearsomeMask(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_FEARSOME_MASK) == CHAKRA_BROW ||  
			GetIsMeldBound(oMeldshaper, MELD_FEARSOME_MASK) == CHAKRA_DOUBLE_BROW) 
		{
			FearsomeMask(oMeldshaper);
		}
		
		//if (GetIsMeldBound(oMeldshaper, MELD_GIRALLON_ARMS) == CHAKRA_TOTEM) GirallonArms(oMeldshaper);
		
		if (GetHasSpellEffect(MELD_HEART_OF_FIRE, oMeldshaper)) HeartOfFire(oMeldshaper);
        /*if (GetHasSpellEffect(MELD_INCARNATE_AVATAR, oMeldshaper))
        {
        	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_INCARNATE_AVATAR);
        	if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(nEssentia), oMeldshaper, 6.0);     				
        }*/		
        
		// If you have the meld bound to the correct Chakra and there's nothing in your weapon hand
        //if (GetIsMeldBound(oMeldshaper, MELD_KRUTHIK_CLAWS) == CHAKRA_HANDS && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper))) 
        	//IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FINESSE), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		if (GetIsMeldBound(oMeldshaper, MELD_KRUTHIK_CLAWS) == CHAKRA_HANDS ||  
			GetIsMeldBound(oMeldshaper, MELD_KRUTHIK_CLAWS) == CHAKRA_DOUBLE_HANDS &&
			!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper))) 
		{
			IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FINESSE), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}		
		
        //if (GetIsMeldBound(oMeldshaper, MELD_LAMMASU_MANTLE) == CHAKRA_SHOULDERS) LammasuRepulsion(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_LAMMASU_MANTLE) == CHAKRA_SHOULDERS ||  
			GetIsMeldBound(oMeldshaper, MELD_LAMMASU_MANTLE) == CHAKRA_DOUBLE_SHOULDERS) 
		{
			LammasuRepulsion(oMeldshaper);
		}		
        
		//if (GetIsMeldBound(oMeldshaper, MELD_LAMMASU_MANTLE) == CHAKRA_ARMS) LammasuAllies(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_LAMMASU_MANTLE) == CHAKRA_ARMS ||  
			GetIsMeldBound(oMeldshaper, MELD_LAMMASU_MANTLE) == CHAKRA_DOUBLE_ARMS) 
		{
			LammasuAllies(oMeldshaper);
		}        

		//if (GetIsMeldBound(oMeldshaper, MELD_MAULING_GAUNTLETS) == CHAKRA_HANDS && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper)))
        	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(GetEssentiaInvested(oMeldshaper, MELD_MAULING_GAUNTLETS)*2), DAMAGE_TYPE_BASE_WEAPON), oMeldshaper, 6.0);

		// If you have the meld bound to the correct Chakra and there's nothing in your weapon hand
		if (GetIsMeldBound(oMeldshaper, MELD_MAULING_GAUNTLETS) == CHAKRA_HANDS ||  
			GetIsMeldBound(oMeldshaper, MELD_MAULING_GAUNTLETS) == CHAKRA_DOUBLE_HANDS && 
			!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper))) 
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(GetEssentiaInvested(oMeldshaper, MELD_MAULING_GAUNTLETS)*2), DAMAGE_TYPE_BASE_WEAPON), oMeldshaper, 6.0);
		} 
        
		//if (GetIsMeldBound(oMeldshaper, MELD_PHASE_CLOAK) == CHAKRA_SHOULDERS) PhaseCloak(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_PHASE_CLOAK) == CHAKRA_SHOULDERS ||  
			GetIsMeldBound(oMeldshaper, MELD_PHASE_CLOAK) == CHAKRA_DOUBLE_SHOULDERS) 
		{
			PhaseCloak(oMeldshaper);
		}
		
        //if (GetIsMeldBound(oMeldshaper, MELD_RAGECLAWS) == CHAKRA_HANDS) RageClaws(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_RAGECLAWS) == CHAKRA_HANDS ||  
			GetIsMeldBound(oMeldshaper, MELD_RAGECLAWS) == CHAKRA_DOUBLE_HANDS) 
		{
			RageClaws(oMeldshaper);
		}
		
        //if (GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_ARMS || GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_TOTEM) RidingBracers(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_ARMS ||  
			GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_DOUBLE_ARMS ||
			GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_TOTEM ||  
			GetIsMeldBound(oMeldshaper, MELD_RIDING_BRACERS) == CHAKRA_DOUBLE_TOTEM) 
		{
			RidingBracers(oMeldshaper);
		}
		
        //if (GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_SHOULDERS || GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_TOTEM) TotemAvatar(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_SHOULDERS ||  
			GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_DOUBLE_SHOULDERS ||
			GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_TOTEM ||  
			GetIsMeldBound(oMeldshaper, MELD_TOTEM_AVATAR) == CHAKRA_DOUBLE_TOTEM) 
		{
			TotemAvatar(oMeldshaper);
		}		
        
		//if (GetIsMeldBound(oMeldshaper, MELD_WORG_PELT) == CHAKRA_HANDS) WorgPeltHB(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_WORG_PELT) == CHAKRA_HANDS ||  
			GetIsMeldBound(oMeldshaper, MELD_WORG_PELT) == CHAKRA_DOUBLE_HANDS) 
		{
			WorgPeltHB(oMeldshaper);
		}
			
        if (GetRacialType(oMeldshaper) == RACIAL_TYPE_JAEBRIN) JaebrinHB(oMeldshaper);
        if (GetEssentiaInvestedFeat(oMeldshaper, FEAT_COBALT_EXPERTISE)) CobaltExpertise(oMeldshaper);
        //if (GetEssentiaInvestedFeat(oMeldshaper, FEAT_COBALT_POWER)) CobaltPower(oMeldshaper); Commented out so it doesn't work with Bioware PA any more.
        if (GetEssentiaInvestedFeat(oMeldshaper, FEAT_MIDNIGHT_DODGE)) MidnightDodge(oMeldshaper);
    	if (GetEssentiaInvested(oMeldshaper, MELD_INCANDESCENT_AURA)) IncandescentAura(oMeldshaper);
    	
		//if (GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_VESTMENTS) == CHAKRA_WAIST) NecroVestmentsAura(oMeldshaper);
		if (GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_VESTMENTS) == CHAKRA_WAIST ||  
			GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_VESTMENTS) == CHAKRA_DOUBLE_WAIST) 
			{
				NecroVestmentsAura(oMeldshaper);
			}
    	
		if (GetHasSpellEffect(MELD_NECROCARNUM_CIRCLET, oMeldshaper)) ActionCastSpellOnSelf(SPELL_DETECT_UNDEAD);
    	if (GetLevelByClass(CLASS_TYPE_NECROCARNATE, oMeldshaper)) // This tells the PRC whether to check for a necrocarnate on NPC death or not. Only allows 1 necrocarnate at a time
    	{
    		SetLocalObject(GetModule(), "Necrocarnate", oMeldshaper);
    		//DelayCommand(5.99, DeleteLocalObject(GetModule(), "Necrocarnate"));
    		/*int nEssentia = GetLocalInt(oMeldshaper, "EssentiaTrap");
    		if (nEssentia)
    		{
				SetTemporaryEssentia(oMeldshaper, nEssentia);
    			DelayCommand(6.0, SetTemporaryEssentia(oMeldshaper, nEssentia * -1));
    			FloatingTextStringOnCreature("Essentia trapped "+IntToString(nEssentia)+" temporary essentia for one round", oMeldshaper, FALSE);
    		}	*/
    		DeleteLocalInt(oMeldshaper, "EssentiaTrap");
    	}
    }   
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED)    
    {
    	if (GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oMeldshaper) || GetHasFeat(FEAT_INVEST_ESSENTIA_CONV, oMeldshaper)) ClearMeldShapes(oMeldshaper);
    	if (GetHasFeat(FEAT_HEART_INCARNUM, oMeldshaper)) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(GetTotalEssentia(oMeldshaper)), oMeldshaper, 9999.0);
    	if (GetHasFeat(FEAT_INCARNUM_FORTIFIED_BODY, oMeldshaper)) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(GetIncarnumFeats(oMeldshaper)*2), oMeldshaper, 9999.0);
    	while (GetHasFeat(FEAT_NECROCARNATE_HARVEST, oMeldshaper)) DecrementRemainingFeatUses(oMeldshaper, FEAT_NECROCARNATE_HARVEST);
    	if(GetHasFeat(FEAT_OPEN_HEART_CHAKRA, oMeldshaper)) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(GetHitDice(oMeldshaper)/2), oMeldshaper, 9999.0);
    	if(GetHasFeat(FEAT_OPEN_SOUL_CHAKRA, oMeldshaper)) ActionCastSpellOnSelf(MELD_OPEN_SOUL_CHAKRA);
    }     
}