//::///////////////////////////////////////////////////
//:: X0_S1_PETRGAZE
//:: Petrification gaze monster ability.
//:: Fortitude save (DC 15) or be turned to stone permanently.
//:: This will be changed to a temporary effect.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////
//:: Used by Basilisk

#include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nHitDice = GetHitDice(OBJECT_SELF);
	effect eImmune = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);


    location lTargetLocation = PRCGetSpellTargetLocation();

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
        int nSpellID = GetSpellId();
        object oSelf = OBJECT_SELF;
	//:: Check for Immunity to Petrification 
		int bImmune = GetHasFeat(FEAT_IMMUNE_PETRIFICATION, oTarget);

		if (bImmune)
		{ 
			SendMessageToPC(OBJECT_SELF, "This creatrure is immune to petrification"); 
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eImmune, oTarget);
			return;
		}	
		
		else
		{
			DelayCommand(fDelay,  PRCDoPetrification(nHitDice, oSelf, oTarget, nSpellID, 13));
		}

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }



}

