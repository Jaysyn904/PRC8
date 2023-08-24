void main()
{
object oPC = OBJECT_SELF;



//Bonuses:
effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
effect eCst = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
effect eWillSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);

//Penalties:
effect eAC = EffectACDecrease(2);

//Visual Effects:
effect eVFX2 = EffectVisualEffect(VFX_DUR_BLUR);
effect eVFX3  = EffectVisualEffect(VFX_DUR_AURA_FIRE);

effect eLink;

eLink = EffectLinkEffects(eStr, eCst);
eLink = EffectLinkEffects(eLink, eWillSave);
eLink = EffectLinkEffects(eLink, eAC);
eLink = EffectLinkEffects(eLink, eVFX2);
eLink = EffectLinkEffects(eLink, eVFX3);

eLink = ExtraordinaryEffect(eLink);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(1));

FloatingTextStringOnCreature("Drunken Rage Activated", oPC);
}
