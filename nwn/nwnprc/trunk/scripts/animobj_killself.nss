void main()
{
    effect eKill = EffectDamage(9999, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, OBJECT_SELF);
}
