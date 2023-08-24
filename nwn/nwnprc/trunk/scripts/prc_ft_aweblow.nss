/*
Awesome Blow

As a standard action, the creature may choose to subtract 4 from its melee attack roll and deliver an awesome blow.
If the creature hits a corporeal opponent smaller than itself with an awesome blow, its opponent must succeed on a 
Reflex save (DC = damage dealt) or be knocked flying 10 feet in a direction of the attacking creature’s choice and fall prone. 
*/
#include "prc_inc_combmove"
#include "moi_inc_moifunc"

void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nHP        = GetCurrentHitPoints(oTarget);
    int nSizeBonus;
    // This section is for a strike, change for a boost or counter
    effect eNone;
    PerformAttack(oTarget, oPC, eNone, 0.0, -4);
    if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
    	int nDC = nHP - GetCurrentHitPoints(oTarget); // This should be the amount caused by the attack
		if (GetIsMeldBound(oPC, MELD_WORMTAIL_BELT) == CHAKRA_WAIST) 
		{	
			nSizeBonus++;
			nDC = GetMeldshaperDC(oPC, CLASS_TYPE_TOTEMIST, MELD_WORMTAIL_BELT);
		}	
        if ((PRCGetCreatureSize(oPC)+nSizeBonus) > PRCGetCreatureSize(oTarget))
        {
        	if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        	{
        		_DoBullRushKnockBack(oTarget, oPC, 10.0);
        		DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0));
        	}
        }
    }   
}