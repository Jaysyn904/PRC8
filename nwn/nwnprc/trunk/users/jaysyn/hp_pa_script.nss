//::///////////////////////////////////////////////
//:: Power Attack Script
//:: hp_pa_script
//:://////////////////////////////////////////////
/*
    A script that sets the power attack on a player based on the amount
    given.
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

#include "prc_spell_const"

void SetPowerAttack();

//
// Sets the power attack for a player, if the player has power attack and the
// amount is less than or equal to the players BAB it will apply the
// power attack and set the current power attack to the player at variable
// 'prcPaScriptPaVariable', otherwise it will tell the player it can't.
//
// Arguments:
//   amount int the amount of power attack you want
//   oPlayer object the player to apply the power attack to
//
void main()
{
    int amount = GetLocalInt(OBJECT_SELF, "PRC_PowerAttack_Level");
    int prevPowerAttack5 = GetLocalInt(OBJECT_SELF, "prevPowerAttack5");
    int prevPowerAttack1 = GetLocalInt(OBJECT_SELF, "prevPowerAttack1");
    int powerAttack5Amount = amount / 5;
    int powerAttack1Amount = amount % 5;

    // Current actions can cause this to not run right away, so clear the queue
    // and force this to happen.
    ClearAllActions();


    //sets the 5 values for Power attack ranging from 0,5,10,15,20 respectivly
    if (prevPowerAttack5 != powerAttack5Amount)
    {
        if (powerAttack5Amount == 0) // Power Attack 0
        {
            ActionDoCommand(ActionCastSpellAtObject(SPELL_POWER_ATTACK6, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        }
        if (powerAttack5Amount == 1) // Power Attack 5
        {
            ActionDoCommand(ActionCastSpellAtObject(SPELL_POWER_ATTACK7, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        }
        if (powerAttack5Amount == 2) // Power Attack 10
        {
            ActionCastSpellAtObject(SPELL_POWER_ATTACK8, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        if (powerAttack5Amount == 3) // Power Attack 15
        {
            ActionCastSpellAtObject(SPELL_POWER_ATTACK9, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        if (powerAttack5Amount == 4) // Power Attack 20
        {
            ActionCastSpellAtObject(SPELL_POWER_ATTACK10, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        SetLocalInt(OBJECT_SELF, "prevPowerAttack5", powerAttack5Amount);
    }

    if (prevPowerAttack1 != powerAttack1Amount)
    {
        //sets the 1 values for Power attack ranging from 0,1,2,3,4 respectivly
        if (powerAttack1Amount == 0) // Power Attack 0
        {
            ActionDoCommand(ActionCastSpellAtObject(SPELL_POWER_ATTACK1, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        }
        if (powerAttack1Amount == 1) // Power Attack 1
        {
            ActionDoCommand(ActionCastSpellAtObject(SPELL_POWER_ATTACK2, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        }
        if (powerAttack1Amount == 2) // Power Attack 2
        {
            ActionCastSpellAtObject(SPELL_POWER_ATTACK3, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        if (powerAttack1Amount == 3) // Power Attack 3
        {
            ActionCastSpellAtObject(SPELL_POWER_ATTACK4, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        if (powerAttack1Amount == 4) // Power Attack 4
        {
            ActionCastSpellAtObject(SPELL_POWER_ATTACK5, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        SetLocalInt(OBJECT_SELF, "prevPowerAttack1", powerAttack1Amount);
    }
}