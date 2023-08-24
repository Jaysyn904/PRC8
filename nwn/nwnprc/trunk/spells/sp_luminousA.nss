///////////////////////////////////////////////////
// Luminous Armor HB
// sp_luminousA.nss
////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oPC = GetAreaOfEffectCreator();
        location lLoc = GetLocation(oPC);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 6.096f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
                if(!GetIsReactionTypeFriendly(oTarget))
                {
                        if(GetAttackTarget(oTarget) == oPC)
                        {
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(4), oTarget, 6.0f);
                        }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, 6.096f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        }
}  