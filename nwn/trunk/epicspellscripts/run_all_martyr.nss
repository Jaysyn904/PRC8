//:://////////////////////////////////////////////
//:: FileName: "run_all_martyr"
/*   Purpose: For "Allied Martyr" spell - This is the actual functional body of
        the spell, but needs to be called seperately due to the need of a
        player's permission.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dispel"

void RunMyMartyrdom(object oAlly, int nDuration, object oMartyr = OBJECT_SELF);

void main()
{
    // Who is my ally that I am helping?
    object oAlly = GetLocalObject(OBJECT_SELF, "oAllyForMyMartyrdom");
    // How long do I have to do this for?
    int nDuration = GetLocalInt(OBJECT_SELF,
                "nTimeForMartyrdomFor");
    // Begin the martyrdom.
    RunMyMartyrdom(oAlly, nDuration, OBJECT_SELF);
}

void RunMyMartyrdom(object oAlly, int nDuration, object oMartyr = OBJECT_SELF)
{
    int nAllyCurrentHP = GetCurrentHitPoints(oAlly);
    int nAllyMaxHP = GetMaxHitPoints(oAlly);
    int nMyHP = GetCurrentHitPoints(OBJECT_SELF);
    int nTransfer = nAllyMaxHP - nAllyCurrentHP;
    effect eVisDown = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisUp = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eHPLoss = EffectDamage(nTransfer);
    effect eHPGain = EffectHeal(nTransfer);
    effect eLink1 = EffectLinkEffects(eVisDown, eHPLoss);
    effect eLink2 = EffectLinkEffects(eVisUp, eHPGain);
    // If the spell's duration has not expired yet.
    if (!GetIsDead(OBJECT_SELF) &&
        !GetIsDead(oAlly) &&
        GetIsObjectValid(oAlly) &&
        nTransfer > 0 )
    {
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, OBJECT_SELF);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oAlly);
    }
    if (nDuration > 0)
    {
        nDuration -= 1;
        DelayCommand(3.0, RunMyMartyrdom(oAlly, nDuration, OBJECT_SELF));
    }
}
