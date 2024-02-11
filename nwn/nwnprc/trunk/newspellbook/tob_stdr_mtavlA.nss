//////////////////////////////////////////////////
// Mountain Avalanche On Enter
// Stone Dragon (Strike)
// tob_stdr_mtavlA.nss
//////////////////////////////////////////////////
/** @file Mountain Avalanche
Stone Dragon (Strike)
Level: Crusader 5, swordsage 5, warblade 5
Prerequisite: Two Stone Dragon maneuvers
Initiation Action: 1 full-round action
Range: Personal
Target: You
Saving Throw: Reflex half; see text

You wade through your enemies like a stone giant rampaging through a mob of orcs.
You crush them underfoot and drive them before you, leaving a trail of the dead in
your wake.

As part of this maneuver, you can move up to double your speed and trample your 
opponents. You can enter the space of any creature of your size category or smaller.
If you enter and occupy the space occupied by such a creature, it takes 
damage equal to 2d6 + 1 1/2 times your Str bonus (if any).

You can deal trampling damage to a creature only once per round, no matter how many
times you move into or through its space. You must move into every square a creature
occupies to trample it. If you move over only part of the space a creature occupies, 
it can either attempt an attack of opportunity against you or it can attempt a Reflex 
save (DC 15 = your Str modifier) to avoid half of your trampling damage.


 <Stratovarius> Use the inc_draw stuff
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
        object oPC = OBJECT_SELF;
        object oTarget = GetEnteringObject();
        
        int nDam = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        nDam += (nDam/2);
        nDam += d6(2);
        
        int nSizePC = PRCGetCreatureSize(oPC);
        int nSizeTarget = PRCGetCreatureSize(oTarget);
        
        if(nSizePC >= nSizeTarget)
        {
                if(!GetLocalInt(oTarget, "PRC_TOB_TRAMPLED") && (oTarget != oPC))
                {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING), oTarget);
                        
                        //Screwed up rules
                        SetLocalInt(oTarget, "PRC_TOB_TRAMPLED", 1);
                        DelayCommand(6.0f, DeleteLocalInt(oTarget, "PRC_TOB_TRAMPLED"));
                }
        }       
}