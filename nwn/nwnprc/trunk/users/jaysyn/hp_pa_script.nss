//::///////////////////////////////////////////////
//:: Power Attack Script
//:: prc_powatk_chs
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

//
// SetPowerAttack
// Sets the power attack for a player, if the amount is less than or equal to
// the players BAB it will apply the power attack, otherwise it will tell
// the player it can't.
//
// Arguments:
// amount int the amount of power attack you want
// oPlayer object the player to apply the power attack to
//
//
void SetPowerAttack(int amount, object oPlayer);

void SetPowerAttack(int amount, object oPlayer)
{
    //You need the power attack feat to use this
    if (GetHasFeat(FEAT_POWER_ATTACK, oPlayer))
    {
        // It won't work if your BAB is lower than your PA Value
        if(GetBaseAttackBonus(oPlayer) <= amount)
        {
            int powerAttack5Amount = amount / 5;
            int powerAttack1Amount = amount % 5;

            switch (powerAttack1Amount)
            {
                //sets the 1 values for Power attack ranging from 0,1,2,3,4 respectivly
                case 0: // Power Attack 0
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK1, oPlayer, TRUE);
                case 1: // Power Attack 1
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK2, oPlayer, TRUE);
                case 2: // Power Attack 2
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK3, oPlayer, TRUE);
                case 3: // Power Attack 3
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK4, oPlayer, TRUE);
                case 4: // Power Attack 4
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK5, oPlayer, TRUE);
            }
            switch (powerAttack5Amount)
            {
                case 0: // Power Attack 0
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK6, oPlayer, TRUE);
                case 1: // Power Attack 5
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK7, oPlayer, TRUE);
                case 2: // Power Attack 10
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK8, oPlayer, TRUE);
                case 3: // Power Attack 15
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK9, oPlayer, TRUE);
                case 4: // Power Attack 20
                    ActionCastSpellAtObject(SPELL_POWER_ATTACK10, oPlayer, TRUE);
            }
        } else {
            FloatingTextStringOnCreature("Power Attack Higher Than BAB", oPlayer);
        }
    } else {
        FloatingTextStringOnCreature("Need Power Attack To Use", oPlayer);
    }
}

//:: void main (){}