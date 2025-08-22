//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks domain powers and class to determine
    the proper turning abilities of the casting
    character.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 2, 2001
//:: Updated On: Jul 15, 2003 - Georg Zoeller
//:://////////////////////////////////////////////

/*
308  - turn undead
1726 - Turn_Scaleykind
1727 - Turn_Slime
1728 - Turn_Spider
1729 - Turn_Plant
1730 - Turn_Air
1731 - Turn_Earth
1732 - Turn_Fire
1733 - Turn_Water
1734 - Turn_Blightspawned
2259 - turn outsider
3497 - Turn cold
25992 - FEAT_PLANT_DEFIANCE
25993 - FEAT_PLANT_CONTROL

*/

#include "prc_inc_clsfunc"
#include "prc_inc_domain"
#include "prc_inc_turning"
#include "prc_inc_factotum"

void main()
{
    int nTurnType = GetSpellId();
    
    if(nTurnType == VESTIGE_TENEBROUS_TURN)
    {    
    	if(!BindAbilCooldown(OBJECT_SELF, GetSpellId(), VESTIGE_TENEBROUS)) return;
    	nTurnType = SPELL_TURN_UNDEAD;
    }	
    
    if(nTurnType == SPELL_OPPORTUNISTIC_PIETY_TURN)
    {
    	if (!ExpendInspiration(OBJECT_SELF, 1))
    	{
    		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_OPPORTUNISTIC_PIETY_TURN);
    		return;
    	}	
    	// We know we can cast it now	
    	nTurnType = SPELL_TURN_UNDEAD;	
    	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_OPPORTUNISTIC_PIETY_HEAL);
    }    

    // Because Turn Undead/Outsider isn't from a domain, skip this check
    if(nTurnType != SPELL_TURN_UNDEAD && nTurnType != SPELL_TURN_OUTSIDER && nTurnType != SPELL_PLANT_DEFIANCE && nTurnType != SPELL_PLANT_CONTROL)
    {
        // Used by the uses per day check code for bonus domains
        if(!DecrementDomainUses(GetTurningDomain(nTurnType), OBJECT_SELF))
            return;
    }

    int bUndeadMastery = GetHasFeat(FEAT_UNDEAD_MASTERY);

    //casters level for turning
    int nLevel = GetTurningClassLevel(OBJECT_SELF, nTurnType);
    int nCommandLevel = bUndeadMastery ? nLevel * 10 : nLevel;

    //check alignment - we will need that later
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);

    //casters charisma modifier
    int nChaMod = GetTurningCharismaMod(nTurnType);

    //key values for turning
    int nTurningTotalHD = d6(2) + nLevel + nChaMod;
    int nTurningCheck = d20() + nChaMod;
    
    if(nTurnType == SPELL_TURN_UNDEAD) // Hallow spell, +4 for turning, -4 for commanding undead
    {
    	if (nAlign == ALIGNMENT_EVIL && GetLocalInt(OBJECT_SELF, "HallowTurn")) nTurningCheck -= 4;
    	else if (GetLocalInt(OBJECT_SELF, "HallowTurn")) nTurningCheck += 4;
    }	
    
    int nTurningMaxHD = GetTurningCheckResult(nLevel, nTurningCheck);

    //these stack but dont multiply
    //so use a bonus amount and then add that on later

    //apply maximize turning
    //+100% if good
    if((GetHasFeat(FEAT_MAXIMIZE_TURNING) && nAlign == ALIGNMENT_GOOD)
    || GetLocalInt(OBJECT_SELF,"vMaximizeNextTurn"))
    {
        nTurningTotalHD += nTurningTotalHD;
        DeleteLocalInt(OBJECT_SELF,"vMaximizeNextTurn");
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_ML_MAXIMIZE_TURNING);
    }

    //apply empowered turning
    //+50%
    //only if maximize doesnt apply
    else if(GetHasFeat(FEAT_EMPOWER_TURNING))
        nTurningTotalHD += nTurningTotalHD/2;

    // Evil clerics rebuke, not turn, and have a different VFX
    effect eImpactVis = nAlign == ALIGNMENT_EVIL ? EffectVisualEffect(VFX_FNF_LOS_EVIL_30):
                                                   EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));

    //zone of animation effect
    //"You can use a rebuke or command undead attempt to animate
    //corpses within range of your rebuke or command attempt.
    //You animate a total number of HD of undead equal to the
    //number of undead that would be commanded by your result
    //(though you can’t animate more undead than there are available
    //corpses within range). You can’t animate more undead with
    //any single attempt than the maximum number you can command
    //(including any undead already under your command). These
    //undead are automatically under your command, though your
    //normal limit of commanded undead still applies. If the
    //corpses are relatively fresh, the animated undead are zombies.
    //Otherwise, they are skeletons."
    //currently implemented ignoring corpses & what the corpses are of.
    if(GetLocalInt(OBJECT_SELF, "UsingZoneOfAnimation"))
    {
        //Undead Mastery multiplies total HD by 10
        int bUndeadMastery = GetHasFeat(FEAT_UNDEAD_MASTERY);
        if(bUndeadMastery)
            nLevel *= 10;
        //keep creating stuff
        int nCommandedTotalHD = GetCommandedTotalHD(nTurnType, bUndeadMastery);
        while(nCommandedTotalHD < nTurningTotalHD)
        {
            //skeletal blackguard
            string sResRef = "x2_s_bguard_18"; 
            object oCreated = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(OBJECT_SELF));

            int nTargetHD = GetHitDiceForTurning(oCreated, nTurnType, RACIAL_TYPE_UNDEAD);

            if(nCommandedTotalHD + nTargetHD <= nLevel)
            {
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), GetLocation(oCreated));
                DoCommand(oCreated);
                CorpseCrafter(OBJECT_SELF, oCreated);
                nCommandedTotalHD += nTargetHD;
            }
            //cant be commanded, clean it up
            else
                DestroyObject(oCreated);
        }
        //send feedback
        FloatingTextStringOnCreature("Currently commanding "+IntToString(nCommandedTotalHD)+"HD out of "+IntToString(nLevel)+"HD.", OBJECT_SELF, FALSE);
        return;
    }

    FloatingTextStringOnCreature("You are turning "+IntToString(nTurningTotalHD)+"HD of creatures whose HD is equal or less than "+IntToString(nTurningMaxHD), OBJECT_SELF, FALSE);

    int bDisplayCommandMessage = -1;
    int nCommandedTotalHD = GetCommandedTotalHD(nTurnType, bUndeadMastery);
    int nHDCount, nTurnOrRebuke, nTargetHD, nTargetRace;
    int i = 1;
    
    object oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, i);
    if (GetEssentiaInvestedFeat(OBJECT_SELF, FEAT_AZURE_TURNING) && nTurnType == SPELL_TURN_UNDEAD)
    {
    	while(GetIsObjectValid(oTest) && GetDistanceToObject(oTest) < 20.0)
    	{
    		nTargetRace = MyPRCGetRacialType(oTest);
    	    if(nTargetRace == RACIAL_TYPE_UNDEAD && nTurningMaxHD >= GetHitDiceForTurning(oTest, nTurnType, nTargetRace))
    	    {
    	        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d8(GetEssentiaInvestedFeat(OBJECT_SELF, FEAT_AZURE_TURNING)), DAMAGE_TYPE_DIVINE), oTest);
    	    }
	
    	    //move to next test
    	    i++;
    	    oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, i);
    	}
    }	
    
    i = 1;
    oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, i);
    while(GetIsObjectValid(oTest) && nHDCount < nTurningTotalHD && GetDistanceToObject(oTest) < 20.0)//20 m = 60 ft
    {
        nTargetRace = MyPRCGetRacialType(oTest);
        nTurnOrRebuke = GetIsTurnOrRebuke(oTest, nTurnType, nTargetRace);
        if(nTurnOrRebuke)
        {
            int nTargetHD = GetHitDiceForTurning(oTest, nTurnType, nTargetRace);
            if(nTargetHD <= nTurningMaxHD && nHDCount+nTargetHD <= nTurningTotalHD)
            {
                nHDCount += nTargetHD;

                //signal the event
                SignalEvent(oTest, EventSpellCastAt(OBJECT_SELF, nTurnType));

                //sun domain
                //destroys instead of turn/rebuke/command
                //useable once per day only
                if(GetLocalInt(OBJECT_SELF, "UsingSunDomain"))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTest);
                    //Do not destroy until this script finishes, otherwise GetNearestCreature() will not work correctly
                    DelayCommand(0.0, DoDestroy(oTest));
                }
                else
                {
					if(nTurnOrRebuke == ACTION_TURN)
					{
						ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTest);

						// If target's HD < half level we would normally destroy.
						// For plants targeted by Plant Defiance/Control, never destroy — apply non-lethal outcome instead.
						if(nTargetHD < nLevel/2)
						{
							if(nTargetRace == RACIAL_TYPE_PLANT
							   && (nTurnType == SPELL_PLANT_DEFIANCE || nTurnType == SPELL_PLANT_CONTROL))
							{
								// For Turn-type (Plant Defiance) -> DoTurn (fear)
								// For Control-type (Plant Control) -> DoCommand (dominate)
								if(nTurnType == SPELL_PLANT_DEFIANCE)
									DelayCommand(0.0, DoTurn(oTest));
								else
									DelayCommand(0.0, DoCommand(oTest));
							}
							else
							{
								// Default: destroy
								DelayCommand(0.0, DoDestroy(oTest));
							}
						}
						else
						{
							DoTurn(oTest);
						}
					}

/*                     if(nTurnOrRebuke == ACTION_TURN)
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTest);
                        //if half of level, destroy
                        //otherwise turn
                        if(nTargetHD < nLevel/2)
                            DelayCommand(0.0, DoDestroy(oTest));
                        else
                            DoTurn(oTest);
                    } */
                    else
                    {
                        bDisplayCommandMessage = TRUE;
                        //if half of level, command
                        //otherwise rebuke
                        if(nTargetHD < nLevel/2)
                        {
                            //undead mastery only applies to undead
                            //so non-undead have thier HD multiplied by 10
                            if(nTargetRace != RACIAL_TYPE_UNDEAD && bUndeadMastery)
                                nTargetHD *= 10;
    
                            if(nCommandedTotalHD + nTargetHD <= nCommandLevel)
                            {
                                nCommandedTotalHD += nTargetHD;
                                DoCommand(oTest);
                            }
                            //not enough commanding power left
                            //rebuke instead
                            else
                                DoRebuke(oTest);
                        }
                        else
                            DoRebuke(oTest);
                    }
                }
    
                // Check for Exalted Turning
                // take 3d6 damage if they do
                // Only works on undead
                if(nAlign == ALIGNMENT_GOOD
                && nTargetRace == RACIAL_TYPE_UNDEAD
                && (GetHasFeat(FEAT_EXALTED_TURNING)) || GetPersistantLocalInt(OBJECT_SELF, "VoPFeat"+IntToString(FEAT_EXALTED_TURNING)))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(3), DAMAGE_TYPE_DIVINE), oTest);
                }
                
                //Check for Holy Fire
                if(GetHasSpellEffect(SPELL_HOLY_FIRE, oTest))
                {
                	int nFire = nTurningMaxHD / 2;
                	int nHoly = nTurningMaxHD - nFire;
                	effect eDam = EffectLinkEffects(EffectDamage(DAMAGE_TYPE_DIVINE, nHoly), EffectDamage(DAMAGE_TYPE_FIRE, nFire));
                	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTest);
                }
            }
        }

        //move to next test
        i++;
        oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, i);
    }  

    if(bDisplayCommandMessage)
        FloatingTextStringOnCreature("Currently commanding "+IntToString(nCommandedTotalHD)+"HD out of "+IntToString(nCommandLevel)+"HD.", OBJECT_SELF, FALSE);
}