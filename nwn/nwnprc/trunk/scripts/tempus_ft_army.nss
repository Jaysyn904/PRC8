#include "prc_alterations"
void main()
{


   //Declare major variables
   object oCaster = OBJECT_SELF;

   int Duration = GetAbilityModifier(ABILITY_CHARISMA)>0 ? GetAbilityModifier(ABILITY_CHARISMA):1;
   //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    effect eSave   = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
    effect eAtk    = EffectAttackIncrease(2);
    effect eSkill  = EffectSkillIncrease(SKILL_ALL_SKILLS,2);
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_SLASHING);
    effect eLink   = EffectLinkEffects(eSave,eAtk);
           eLink   = EffectLinkEffects(eLink,eSkill);
           eLink   = EffectLinkEffects(eLink,eDamage);

    effect eVFX    = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
           eLink   = EffectLinkEffects(eLink,eVFX);


       //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && GetObjectHeard(oTarget,oCaster))
    {

        if ( GetIsFriend(oTarget)|| GetFactionEqual(oTarget))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(Duration));
        }

        //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }

}
