//::///////////////////////////////////////////////
//:: Power Attack Script
//:: prc_nui_pa_trggr
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
#include "inc_2dacache"

//
// ExecutePowerAttackChange
// Takes a Power Attack SpellID and checks to see what it's spell2da Master is.
// it then takes the Master's FeatID and the spell's spellId and does UseActionFeat
// to execute the power attack change.
//
// Arguments:
//   spellId:int the Power attack spell Id this is being executed for
//
void ExecutePowerAttackChange(int spellId);

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

    //sets the 5 values for Power attack ranging from 0,5,10,15,20 respectivly
    if (prevPowerAttack5 != powerAttack5Amount)
    {
        if (powerAttack5Amount == 0) // Power Attack 0
            ExecutePowerAttackChange(SPELL_POWER_ATTACK6);
        if (powerAttack5Amount == 1) // Power Attack 5
            ExecutePowerAttackChange(SPELL_POWER_ATTACK7);
        if (powerAttack5Amount == 2) // Power Attack 10
            ExecutePowerAttackChange(SPELL_POWER_ATTACK8);
        if (powerAttack5Amount == 3) // Power Attack 15
            ExecutePowerAttackChange(SPELL_POWER_ATTACK9);
        if (powerAttack5Amount == 4) // Power Attack 20
            ExecutePowerAttackChange(SPELL_POWER_ATTACK10);
        SetLocalInt(OBJECT_SELF, "prevPowerAttack5", powerAttack5Amount);
    }

    if (prevPowerAttack1 != powerAttack1Amount)
    {
        //sets the 1 values for Power attack ranging from 0,1,2,3,4 respectivly
        if (powerAttack1Amount == 0) // Power Attack 0
            ExecutePowerAttackChange(SPELL_POWER_ATTACK1);
        if (powerAttack1Amount == 1) // Power Attack 1
            ExecutePowerAttackChange(SPELL_POWER_ATTACK2);
        if (powerAttack1Amount == 2) // Power Attack 2
            ExecutePowerAttackChange(SPELL_POWER_ATTACK3);
        if (powerAttack1Amount == 3) // Power Attack 3
            ExecutePowerAttackChange(SPELL_POWER_ATTACK4);
        if (powerAttack1Amount == 4) // Power Attack 4
            ExecutePowerAttackChange(SPELL_POWER_ATTACK5);
        SetLocalInt(OBJECT_SELF, "prevPowerAttack1", powerAttack1Amount);
    }
}

void ExecutePowerAttackChange(int spellId)
{
    int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
    int featID;
    int subSpellId = 0;

    if (masterSpellId)
    {
        featID = StringToInt(Get2DACache("spells", "FeatID", masterSpellId));
        subSpellId = spellId;
    }
    else
        featID = StringToInt(Get2DACache("spells", "FeatID", spellId));

    ActionUseFeat(featID, OBJECT_SELF, subSpellId);
}
