/*
1/2/21 by Stratovarius

Dragonfire Mask

Descriptors: Draconic, Fire
Classes: Totemist
Chakra: Brow, throat (totem)
Saving Throw: See text

Chakra Bind (Throat)

A seething ring of fire encircles your neck, and wisps of smoke occasionally burst from the dragon head.

You gain the ability to emit a fiery breath weapon as a standard action. The breath weapon is a 30-foot cone that deals 2d6 points of fire 
damage + an extra 1d6 points of fire damage for every point of essentia invested in your dragonfire mask. 
Targets are allowed a Reflex save for half damage. After using your breath weapon, you must wait 1d4 rounds before you can use it again.
*/

const string DRAGBREATHLOCK = "DragonBreathLock";

#include "moi_inc_moifunc"
#include "prc_inc_breath"

void main()
{
    // Check the dragon breath delay lock
    if(GetLocalInt(OBJECT_SELF, DRAGBREATHLOCK))
    {
        SendMessageToPC(OBJECT_SELF, "You cannot use your breath weapon again so soon");
        return;
    }
	
    int nDamageDice = 2 + GetEssentiaInvested(OBJECT_SELF, MELD_DRAGONFIRE_MASK);
    struct breath FireBreath;
    
    FireBreath = CreateBreath(OBJECT_SELF, FALSE, 30.0, DAMAGE_TYPE_FIRE, 6, nDamageDice, GetMeldshaperDC(OBJECT_SELF, CLASS_TYPE_TOTEMIST, MELD_DRAGONFIRE_MASK), 0);
    
    //Apply the breath
    PRCPlayDragonBattleCry();
    ApplyBreath(FireBreath, PRCGetSpellTargetLocation());
    
    //Apply the recharge lock
    SetLocalInt(OBJECT_SELF, DRAGBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(FireBreath.nRoundsUntilRecharge);
    SendMessageToPC(OBJECT_SELF, "Your breath weapon will be ready again in " + IntToString(FireBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, DRAGBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(OBJECT_SELF, "Your breath weapon is ready now"));
}


