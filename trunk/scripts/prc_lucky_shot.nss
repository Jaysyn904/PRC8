////////////////////////////////////////////////////////
// Lucky Shot
// prc_lucky_shot
////////////////////////////////////////////////////////

/* Lucky Shot (Su): Once per day as a free action, you can gain
a +10 insight bonus to one attack roll with your longbow. You
must declare the use of this ability before rolling the die.
*/

void main()
{
    object oPC = OBJECT_SELF;
    effect eLink = EffectLinkEffects(SupernaturalEffect(EffectAttackIncrease(10)), EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 3.0);
}