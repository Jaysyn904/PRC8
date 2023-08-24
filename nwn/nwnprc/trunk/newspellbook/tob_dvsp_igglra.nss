/*
   ----------------
   Iron Guard's Glare, Enter

   tob_dvsp_igglra.nss
   ----------------

    29/03/07 by Stratovarius
*/ /** @file

    Iron Guard's Glare

    Devoted Spirit (Stance)
    Level: Crusader 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    With a quick snarl and a glare that would stop a charging barbarian in his tracks,
    you spoil an opponent's attack. Rather than strike his original target, your enemy
    turns his attention to you.
    
    Any creature you threaten takes a -4 penalty on attacks against allies.
    (Mechnical implementation: AoE that grants allies +4 Dodge AC when they are in it).
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eAC = EffectACIncrease(4);
           eAC = ExtraordinaryEffect(eAC);
    // Targets it can apply to
    if (oTarget != GetAreaOfEffectCreator() && 
        GetIsFriend(oTarget, GetAreaOfEffectCreator()) &&
        GetIsPC(oTarget))
    {
    	// Lasts until they leave the AoE
    	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oTarget);
    }
}