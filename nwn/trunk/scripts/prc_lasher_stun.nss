//::///////////////////////////////////////////////
//:: Lasher - Stunning Snap
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 27, 2005
//:: Modified: Sept 29, 2005
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetLocalInt(oPC, "LASHER_STUN_USED"))
    {   //setting a flag for one round
        SetLocalInt(oPC, "LASHER_STUN_USED", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oPC, "LASHER_STUN_USED"));

        object oTarget = PRCGetSpellTargetObject();
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        int nDC = 10 + (GetLevelByClass(CLASS_TYPE_LASHER)) + GetAbilityModifier(ABILITY_STRENGTH, oPC);
        int nSpellId = GetSpellId();
        float fRange = 4.5;
        float fDistance = GetDistanceToObject(oTarget);
        effect eBlank;
        if(fDistance < fRange)
        {
            SignalEvent(oTarget, EventSpellCastAt(oPC, nSpellId));

            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0);

            ActionDoCommand(PerformAttackRound(oTarget, oPC, eBlank));
        }
        else
        {
            SendMessageToPC(oPC, "The target is too far away");
            IncrementRemainingFeatUses(oPC, FEAT_LASHER_STUNNING_SNAP);
        }
    }
    else
    {
        SendMessageToPC(oPC, "You cannot use Stunning Snap more than once per round");
        IncrementRemainingFeatUses(oPC, FEAT_LASHER_STUNNING_SNAP);
    }
}
