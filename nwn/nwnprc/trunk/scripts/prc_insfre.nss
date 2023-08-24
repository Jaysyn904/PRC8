//::///////////////////////////////////////////////
//:: Frenzied Berserker - Inspire Frenzy
//:: NW_S1_insfre
//:: Copyright (c) 2004 
//:://////////////////////////////////////////////
/*
     Causes party members within range to make a 
     Will Save DC or enter a frenzy
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Feb 25, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    // Is only cast if you are frenzying
    if(GetHasFeatEffect(FEAT_FRENZY)) // 4300
    {	
        // Declare major variables
        int nLevel = GetLevelByClass(CLASS_TYPE_FRE_BERSERKER);   // 210
        int willSaveDC = 10 + nLevel + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF); 
        object oTarget;
        location oLoc = GetLocation(OBJECT_SELF);

        //Determine friends in the radius around the character
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(OBJECT_SELF));
        while (GetIsObjectValid(oTarget))
        {
             if(GetIsFriend(oTarget))
             {
                 int saveVal = WillSave(oTarget, willSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
                 if(saveVal == 0)
                 {
                      AssignCommand(oTarget, ActionCastSpellAtObject(SPELL_FRENZY, oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
                 }
              }
              
              oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(OBJECT_SELF));
        }
    }
}