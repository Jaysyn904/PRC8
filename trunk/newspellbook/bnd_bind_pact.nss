/*
03/02/21 by Stratovarius

Pact Augmentation (Su): Beginning at 2nd level, you can draw additional power from the vestiges you bind. As long as you are bound to at least one vestige, you can choose
one ability from the following list. Each time you rebind a vestige, you also reselect your pact augmentation ability. 

As you attain higher levels, you can make additional selections from the list. You gain one additional ability at 5th, 10th, 16th, and 20th level (to a maximum of five selections
at 20th level). You can choose a single ability multiple times, and their effects stack. For instance, at 16th level you could choose bonus hit points twice and damage reduction twice,
gaining +10 hit points and damage reduction 2/—.

Pact Augmentation Abilities
+5 hit points
Energy resistance 5 (acid, cold, electricity, fire, or sonic)
+1 insight bonus on saving throws
Damage reduction 1/—
+1 insight bonus to Armor Class
+1 insight bonus on attack rolls
+1 insight bonus on damage rolls
*/

#include "prc_inc_natweap"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    // Temp HP
    if (GetLocalInt(oBinder, "PactAugment1")) eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(GetLocalInt(oBinder, "PactAugment1")*5)); 
    if (GetLocalInt(oBinder, "PactAugment2")) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, GetLocalInt(oBinder, "PactAugment2")*5)); 
    if (GetLocalInt(oBinder, "PactAugment3")) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, GetLocalInt(oBinder, "PactAugment3")*5)); 
    if (GetLocalInt(oBinder, "PactAugment4")) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, GetLocalInt(oBinder, "PactAugment4")*5)); 
    if (GetLocalInt(oBinder, "PactAugment5")) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, GetLocalInt(oBinder, "PactAugment5")*5)); 
    if (GetLocalInt(oBinder, "PactAugment6")) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC, GetLocalInt(oBinder, "PactAugment6")*5)); 
    if (GetLocalInt(oBinder, "PactAugment7")) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, GetLocalInt(oBinder, "PactAugment7"))); 
    if (GetLocalInt(oBinder, "PactAugment8")) 
    {
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, GetLocalInt(oBinder, "PactAugment8"))); 
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING, GetLocalInt(oBinder, "PactAugment8"))); 
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, GetLocalInt(oBinder, "PactAugment8"))); 
    }	
    if (GetLocalInt(oBinder, "PactAugment9")) eLink = EffectLinkEffects(eLink, EffectACIncrease(GetLocalInt(oBinder, "PactAugment9"))); 
    if (GetLocalInt(oBinder, "PactAugment10")) eLink = EffectLinkEffects(eLink, EffectAttackIncrease(GetLocalInt(oBinder, "PactAugment10"))); 
    if (GetLocalInt(oBinder, "PactAugment11")) eLink = EffectLinkEffects(eLink, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(GetLocalInt(oBinder, "PactAugment11"))));     
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));  
    
    // Clean up time
    int i;
    for(i = 0; i <= 11; i++)
    	DeleteLocalInt(oBinder, "PactAugment"+IntToString(i));
}