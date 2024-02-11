//::///////////////////////////////////////////////
//:: Name      Rain of Frogs or Fish
//:: FileName  sp_frogs_fish.nss
//:://////////////////////////////////////////////
/*  Spell that is cast on individual creatures to 
handle the damage and removal of Rain of Frogs or
Fish.

Author:    Tenjac
Created:   3/10/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void DamLoop(object oTarget, object oArea, int nCounter);

#include "prc_inc_spells"

void main()
{
        object oTarget = OBJECT_SELF;
        object oArea = GetLocalObject(oTarget, "PRC_RAIN_FROGS_FISH_AREA");
        int nCounter = 10 * (d6(3));
        
        DamLoop(oTarget, oArea, nCounter);      
}

void DamLoop(object oTarget, object oArea, int nCounter)
{
        if(GetArea(oTarget) == oArea && nCounter > 0)
        {
        		int nDam = d3(1);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING), oTarget);
                
                //Decrement counter
                nCounter--;
                
                //Do it again
                DelayCommand(6.0f, DamLoop(oTarget, oArea, nCounter));
        }
}