//::///////////////////////////////////////////////
//:: Cone: Cold
//:: NW_S1_ConeCold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of damage eminated from the monster.  Does
    a set amount of damage based upon the creatures HD
    and can be halved with a Reflex Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11, 2001
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "NW_I0_SPELLS"

void main()
{
//:: Declare major variables
	object oNPC		= OBJECT_SELF;
	object oTarget;
	
    int nHD 		= GetHitDice(oNPC);
	int nCHAMod		= GetAbilityModifier(ABILITY_CHARISMA, oNPC);
    int nDC			= 10 +nCHAMod+ (nHD/2);	
    int nDamage;
	int nLoop 		= nHD / 3;
	
    float fDelay;

    if(nLoop == 0)
    {
        nLoop = 1;
    }
    
	//Calculate the damage
    for (nLoop; nLoop > 0; nLoop--)
    {
        nDamage = nDamage + d6(2);
    }
    location lTargetLocation = PRCGetSpellTargetLocation();
    effect eCone;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    //Get first target in spell area
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != oNPC)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oNPC, SPELLABILITY_CONE_COLD));
            //Determine effect delay
            fDelay = GetDistanceBetween(oNPC, oTarget)/20;
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_COLD);
            //Set damage effect
            eCone = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_COLD);

            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            if(nDamage > 0)
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oTarget));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
    }
}


