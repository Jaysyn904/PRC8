//::///////////////////////////////////////////////
//:: Frenzied Berserker - Armor/Skin
//:://////////////////////////////////////////////
/*
    Script for Auto Frenzy on hit
    Moved to separate script to fix GetTotalDamageDealt() issues
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////


#include "prc_spell_const"

void main()
{
     // 10 + damage dealt in that hit
     int willSaveDC = 10 + GetTotalDamageDealt();
     int save = WillSave(OBJECT_SELF, willSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
     if(save == 0)
     {
          ClearAllActions();
          ActionCastSpellAtObject(SPELL_FRENZY, OBJECT_SELF, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
     }
}