/*
   ----------------
   Iron Guard's Glare, Exit

   tob_dvsp_igglrb.nss
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
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(MOVE_DS_IRON_GUARDS_GLARE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by MOVE_DS_IRON_GUARDS_GLARE
                    if(GetEffectSpellId(eAOE) == MOVE_DS_IRON_GUARDS_GLARE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

