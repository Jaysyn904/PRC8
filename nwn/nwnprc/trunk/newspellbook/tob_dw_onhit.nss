/*
   ----------------
   Desert Wind On Hit

   tob_dw_onhit.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    OnHit for Burning Blade and other DW booster spells.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"

void main()
{
	// fill the variables
	object oPC = OBJECT_SELF;
    object oItem = GetSpellCastItem();
    object oTarget = GetSpellTargetObject(); // Might still be SELF in some cases

    if (oTarget == OBJECT_INVALID || oTarget == oPC) 
	{
        if (GetIsObjectValid(GetAttackTarget(oPC))) 
		{
            oTarget = GetAttackTarget(oPC);
        }
    }
	
	if (DEBUG && oTarget == oPC)
	{
		DoDebug("Warning: DW OnHit is attempting to apply damage to self. Skipped.");
	}	
	
	int nLevel     = GetInitiatorLevel(oPC, CLASS_TYPE_SWORDSAGE);
	int nSpellId   = GetLocalInt(oPC, "DesertWindBoost");
	if(DEBUG) DoDebug("tob_dw_onhit: nSpellId " + IntToString(nSpellId));
	effect eDam;
	switch(nSpellId)
	{
		case MOVE_DW_BURNING_BLADE:
		{
			eDam = EffectDamage(d6() + nLevel, DAMAGE_TYPE_FIRE);
			if(DEBUG) DoDebug("tob_dw_onhit: MOVE_DW_BURNING_BLADE");
			break;
		}
		case MOVE_DW_SEARING_BLADE:
		{
			eDam = EffectDamage(d6(2) + nLevel, DAMAGE_TYPE_FIRE);
			if(DEBUG) DoDebug("tob_dw_onhit: MOVE_DW_SEARING_BLADE");
			break;
		}
		case MOVE_DW_INFERNO_BLADE:
		{
			eDam = EffectDamage(d6(3) + nLevel, DAMAGE_TYPE_FIRE);
			if(DEBUG) DoDebug("tob_dw_onhit: MOVE_DW_INFERNO_BLADE");
			break;
		}		
	}
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
}