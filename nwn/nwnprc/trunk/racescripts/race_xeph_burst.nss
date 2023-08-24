/* Burst racial ability for Xephs
   Speed Increase for 3 rounds.*/

void main()
{
    int nSpdIncrease;

    switch(GetHitDice(OBJECT_SELF))
    {
        case 1:
        case 2:
        case 3:
        case 4: nSpdIncrease = 33; break;

        case 5:
        case 6:
        case 7:
        case 8: nSpdIncrease = 67; break;

        default: nSpdIncrease = 99; break;
    }
    effect eLink = EffectLinkEffects(EffectMovementSpeedIncrease(nSpdIncrease),
                                     EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(3));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), OBJECT_SELF);
}