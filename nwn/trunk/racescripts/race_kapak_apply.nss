/* Kapak Saliva ability
   Male: 1d6/1d6 dex damage, DC 18
   Female: 2d6 heal, every 4 hours for each creature, can't use on self*/

#include "prc_inc_fork"
#include "prc_x2_itemprop"

void main()
{
    object oPC = OBJECT_SELF;
    int nGender = GetGender(oPC);

    if(nGender == GENDER_MALE)
    {
        object oItem = PRCGetSpellTargetObject();
        //weapons only
        if(!GetIsWeapon(oItem))
            return;
        itemproperty ipPoison = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_KAPAK_POISON, GetHitDice(oPC));
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ACID);

        //poison lasts for 3 rounds
        IPSafeAddItemProperty(oItem, ipPoison, RoundsToSeconds(3), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    }
    else if(nGender == GENDER_FEMALE)
    {
        object oCreature = PRCGetSpellTargetObject();
        //if HD is 0 or below, not a creature
        if(GetHitDice(oCreature) < 1)
            return;
        effect eHeal = EffectHeal(d6(2));
        //Make sure it's the first time or been over 4 hours
        int nHealed = GetLocalInt(oCreature, "KapakHealLock");
        if(nHealed == TRUE) return;
        //apply the heal
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
        effect eLink = EffectLinkEffects(eVis, eHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oCreature);
        //set the haling lock
        SetLocalInt(oCreature, "KapakHealLock", TRUE);
        DelayCommand(HoursToSeconds(4), DeleteLocalInt(oCreature, "KapakHealLock"));
    }
}