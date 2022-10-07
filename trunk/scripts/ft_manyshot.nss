#include "prc_inc_combat"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    int iType = GetBaseItemType(oWeap);

    if ( !(iType == BASE_ITEM_LONGBOW || iType ==BASE_ITEM_SHORTBOW ))
    {
        SendMessageToPC(OBJECT_SELF, "You can only use Many Shot with a longbow or shortbow");
        return;
    }

    //cant fire more arrows than max no of attacks
    int iMaxAttacks = GetMainHandAttacks(OBJECT_SELF);
    //spellID determines how many arrows
    int nId = GetSpellId();
    int iAttacks;
    int nABPenalty;

    switch(nId)
    {
        case SPELL_MANYSHOT2: iAttacks = 2; break;
        case SPELL_MANYSHOT3: iAttacks = 3; break;
        case SPELL_MANYSHOT4: iAttacks = 4; break;
        case SPELL_MANYSHOT5: iAttacks = 5; break;
        case SPELL_MANYSHOT6: iAttacks = 6; break;
    }

    //cap attacks
    if (iAttacks>iMaxAttacks)
        iAttacks = iMaxAttacks;
    //calculate AB penalty
    nABPenalty = (iAttacks-1)*-2;

    //do the attacks in a loop
    effect eInvalid;
    int i;
    for(i=0;i<iAttacks;i++)
    {
        PerformAttack(oTarget, OBJECT_SELF, eInvalid, 0.0, nABPenalty, 0,0, "*Many Shot Hit*", "*Many Shot Miss*");
        effect eArrow = EffectVisualEffect(NORMAL_ARROW);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);
    }
}

