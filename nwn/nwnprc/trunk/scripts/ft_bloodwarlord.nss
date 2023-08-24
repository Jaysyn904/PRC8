/*
    Blood of the Warlord: +2 to intimidate and persuade,
    +1 to attack rolls and will saving throws of allies.
*/
#include "prc_inc_spells"

void main()
{
    if (!GetHasSpellEffect(GetSpellId()))
    {
        effect eBonus = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR, "ft_bloodwarlord1", "", "ft_bloodwarlord2");
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_PERSUADE, 2), RACIAL_TYPE_HUMANOID_ORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_INTIMIDATE, 2), RACIAL_TYPE_HUMANOID_ORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_PERSUADE, 2), RACIAL_TYPE_HALFORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_INTIMIDATE, 2), RACIAL_TYPE_HALFORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_PERSUADE, 2), RACIAL_TYPE_GRAYORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_INTIMIDATE, 2), RACIAL_TYPE_GRAYORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_PERSUADE, 2), RACIAL_TYPE_ORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_INTIMIDATE, 2), RACIAL_TYPE_ORC));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_PERSUADE, 2), RACIAL_TYPE_OROG));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_INTIMIDATE, 2), RACIAL_TYPE_OROG));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_PERSUADE, 2), RACIAL_TYPE_TANARUKK));
        eBonus = EffectLinkEffects(eBonus, VersusRacialTypeEffect(EffectSkillIncrease(SKILL_INTIMIDATE, 2), RACIAL_TYPE_TANARUKK));
    
        eBonus = ExtraordinaryEffect(eBonus);

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, OBJECT_SELF);
        FloatingTextStringOnCreature("*Blood of the Warlord Activated*", OBJECT_SELF, FALSE);
    }
    else
    {
        object oCre = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE);
        
        while (GetIsObjectValid(oCre))
        {
            PRCRemoveSpellEffects(GetSpellId(), OBJECT_SELF, oCre);
            oCre = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE);
        }

        PRCRemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());
        
        FloatingTextStringOnCreature("*Blood of the Warlord Deactivated*", OBJECT_SELF, FALSE);
    }
}

