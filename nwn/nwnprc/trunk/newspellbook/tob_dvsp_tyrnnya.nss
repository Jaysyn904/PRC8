/*
   ----------------
   Aura of Tyranny, Heartbeat

   tob_dvsp_tyrnnya.nss
   ----------------

    19/09/07 by Stratovarius
*/ /** @file

    Aura of Tyranny

    Devoted Spirit (Stance)
    Level: Crusader 6
    Prerequisite: Two Devoted Spirit maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    A sickly grey radiance surrounds you, sapping the strength of your allies and funneling it to you.
    
    Each round, you damage all allies within 10 feet 2 hit points, and you heal 1 hit point for each ally struck.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    if(DEBUG) DoDebug("tob_dvsp_tyrnnya: Name: " + GetName(GetAreaOfEffectCreator()));
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
    	// Enemies only
	if (GetIsFriend(oTarget, GetAreaOfEffectCreator()))
	{
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), GetAreaOfEffectCreator());
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), GetAreaOfEffectCreator());  
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(2), oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_RED), oTarget);  
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}