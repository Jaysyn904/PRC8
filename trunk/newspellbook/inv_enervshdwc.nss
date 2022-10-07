//::///////////////////////////////////////////////
//:: AoE: On Exit
//:://////////////////////////////////////////////
/*
   
*/

#include "prc_alterations"
#include "inv_inc_invfunc"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oArea = GetArea(oCaster);
    
    if(GetIsObjectValid(oArea)
          && GetIsDay()
          && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
          && !GetIsAreaInterior(oArea)
         )
         PRCRemoveSpellEffects(INVOKE_ENERVATING_SHADOW, oCaster, oCaster);
        
}

