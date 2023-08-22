//::///////////////////////////////////////////////
//:: Nobility Domain Power
//:: prc_domain_noble.nss
//::///////////////////////////////////////////////
/*
    Grants +2 Attack, Saving Throws, Skills and Damage to all allies.
    Does not affect the caster
    Lasts Charisma modifier rounds.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_domain"

void main()
{
    object oPC = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if(!DecrementDomainUses(PRC_DOMAIN_NOBILITY, oPC)) return;

    if(PRCGetHasEffect(EFFECT_TYPE_SILENCE, oPC))
    {
        FloatingTextStrRefOnCreature(85764, oPC); // not useable when silenced
        return;
    }

    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
           eLink = EffectLinkEffects(eLink, eSave);
           eLink = EffectLinkEffects(eLink, eSkill);
           eLink = SupernaturalEffect(eLink);

    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE, FALSE);

    location lTarget = GetLocation(oPC);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
         // Does not gain benefit if silenced or deaf
         if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE, oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))
         {
              if(GetIsFriend(oTarget) && oTarget != oPC)
              {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(GetAbilityModifier(ABILITY_CHARISMA, oPC)));
              }
         }
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}