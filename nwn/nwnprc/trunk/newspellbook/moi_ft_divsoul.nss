//::///////////////////////////////////////////////
//:: Name      Divine Soultouch
//:: FileName  moi_ft_divsoul.nss
//:://////////////////////////////////////////////
/** You can spend a turn or rebuke undead attempt 
as a free action to add 1 point of essentia to 
your essentia pool for 1 round. For the duration 
of this effect, your essentia capacity in all 
soulmelds, incarnum feats, and other essentia-
powered abilities is increased by 1. You can 
use this ability once per round. 

Author:    Stratovarius
Created:   20.1.2020
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oMeldshaper))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oMeldshaper, FALSE);
        return;
    }
    else 
    {
        //use up one
        DecrementRemainingFeatUses(oMeldshaper, FEAT_TURN_UNDEAD);
        SetTemporaryEssentia(oMeldshaper, 1);
        SetLocalInt(oMeldshaper, "DivineSoultouch", TRUE);
        DelayCommand(6.0, SetTemporaryEssentia(oMeldshaper, -1));
        DelayCommand(6.0, DeleteLocalInt(oMeldshaper, "DivineSoultouch"));
    }    
        
}

