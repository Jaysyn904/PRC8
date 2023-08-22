#include "prc_inc_combat"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    int iBonusA;

    //check for non-ranged weapon
    if (!GetWeaponRanged(oWeap))
    {
        SendMessageToPC(OBJECT_SELF, "You can only use Pinpoint Accuracy with a ranged weapon");
        return;
    }

    //arrow vfx
    effect eArrow = EffectVisualEffect(NORMAL_ARROW);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);

    //spell ID determines level of effect
    int nSpellId = GetSpellId();
    switch (nSpellId)
    {
        case SPELL_PINPOINTACCURACY2: iBonusA = 2; break;
        case SPELL_PINPOINTACCURACY4: iBonusA = 4; break;
        case SPELL_PINPOINTACCURACY6: iBonusA = 6; break;
    }

    //Perfect shot adds extra damage
    int nDamage;
    int nLostAttacks = GetMainHandAttacks(OBJECT_SELF)-1;
    if(GetHasFeat(FEAT_PERFECTSHOT2))
        nDamage = d6(nLostAttacks);
    else if(GetHasFeat(FEAT_PERFECTSHOT))
        nDamage = d4(nLostAttacks);

    //killing shot increases critical range by 2
    //this is fudged into the main combat functions
    if(GetHasFeat(FEAT_KILLINGSHOT))
    {
        SetLocalInt(OBJECT_SELF, "KillingShotCritical", TRUE);
        DelayCommand(0.1, DeleteLocalInt(OBJECT_SELF, "KillingShotCritical"));
    }

    effect eInvalid;
    PerformAttack(oTarget, OBJECT_SELF, eInvalid, 0.0, iBonusA, nDamage, DAMAGE_TYPE_PIERCING, "*Pinpoint Accuracy Hit*", "*Pinpoint Accuracy Miss*");
}
