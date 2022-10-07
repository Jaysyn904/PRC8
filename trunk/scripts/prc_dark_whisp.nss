//////////////////////////////////////////////////////////////
/*
Dark Whispers [Vile]
By whispering foul utterances in the Dark Speech, you can
drive your enemies insane.
Prerequisite: Dark Speech.
Benefit: In addition to the basic uses of the Dark Speech,
you can whisper words of incredible wickedness to form
grotesque visions in the minds of those who hear you. All
living creatures within a 30-foot radius that can hear your
words must make Will saves (DC 10 + 1/2 your character
level + your Cha modifier). On a failure, creatures with fewer
Hit Dice than you are staggered for 1d10 rounds; those with
as many or more Hit Dice are confused for 1 round. This is a
mind-affecting, supernatural effect.
Whenever you use Dark Speech in this manner, you take
1 point of Charisma damage.
Special: You gain a +2 circumstance bonus on saving
throws made when someone uses the Dark Speech against
you. This bonus stacks with the +4 circumstance bonus from
Dark Speech.
Special: If you cannot take ability damage, you cannot
select this feat.*/
//////////////////////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    location lLoc = GetLocation(oPC);
    int nDC = 10 + (GetHitDice(oPC) / 2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eStaggered = SupernaturalEffect(EffectSlow());
    int nMyHitDice = GetHitDice(oPC);    
    
    if(GetIsImmune(oPC, IMMUNITY_TYPE_ABILITY_DECREASE))
    {
        FloatingTextStringOnCreature("If you cannot take ability damage, you cannot use this feat", oPC, FALSE);
        return;
    }    
    
    ApplyAbilityDamage(oPC, ABILITY_CHARISMA, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), lLoc);
    
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
          
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oPC)
        {
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                if(GetHitDice(oTarget) < nMyHitDice) SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStaggered, oTarget, RoundsToSeconds(d10(1))); 
                else SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(PRCEffectConfused()), oTarget, RoundsToSeconds(1));
                
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_RED), oTarget);
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}