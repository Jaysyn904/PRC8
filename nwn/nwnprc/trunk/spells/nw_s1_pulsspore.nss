//::///////////////////////////////////////////////
//:: Vrock Spores
//:: NW_S1_PulsSpore
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A wave of disease spreads out from the creature
    and infects all those within 10ft
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    //Declare major variables
	object oNPC = oNPC;
	object oTarget;
	
    float fDelay;
    effect eDisease;
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oNPC);
    
	//Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(oNPC));
    while(GetIsObjectValid(oTarget))
    {
    	if(oTarget != oNPC)
    	{
        	if(!GetIsReactionTypeFriendly(oTarget))
        	{
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oNPC, SPELLABILITY_PULSE_DISEASE));
                //Determine effect delay
                fDelay = GetDistanceBetween(oNPC, oTarget)/20;
                eDisease = EffectDisease(DISEASE_SOLDIER_SHAKES);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDisease, oTarget));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oNPC));
    }
}
