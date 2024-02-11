#include "prc_spell_const"
#include "prc_misc_const"

void main()
{
    object oAura = OBJECT_SELF;
    object oTarget = GetEnteringObject();
    object oMarshal = GetAreaOfEffectCreator();

    int nAuraID    = GetLocalInt(oAura, "SpellID");
    int nAuraBonus = GetLocalInt(oAura, "AuraBonus");

    effect eBonus = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

	if(GetIsFriend(oTarget, oMarshal))
    {
        switch(nAuraID)
        {
            case SPELL_MINAUR_DEMFORT:{ //Demand Fortitude
                eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_FORT, nAuraBonus, SAVING_THROW_TYPE_ALL));
                break;}
            case SPELL_MINAUR_FORCEWILL:{ //Force of Will
                eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_WILL, nAuraBonus, SAVING_THROW_TYPE_ALL));
                break;}
            case SPELL_MINAUR_WATCHEYE:{ //Watchful Eye
                eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nAuraBonus, SAVING_THROW_TYPE_ALL));
                break;}
            case SPELL_MINAUR_ARTOFWAR:{ //Art of War
                SetLocalInt(oTarget, "Marshal_ArtWar", nAuraBonus);
                break;}               
            case SPELL_MINAUR_BOOSTCHA:{ //Boost Charisma
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_BLUFF, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_INTIMIDATE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_PERFORM, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_PERSUADE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_IAIJUTSU_FOCUS, nAuraBonus));
                break;}
            case SPELL_MINAUR_BOOSTCON:{ //Boost Constitution
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CONCENTRATION, nAuraBonus));
                break;}
            case SPELL_MINAUR_BOOSTDEX:{ //Boost Dexterity
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_HIDE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_OPEN_LOCK, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_PARRY, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_PICK_POCKET, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_SET_TRAP, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_TUMBLE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_RIDE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_BALANCE, nAuraBonus));
                break;}
            case SPELL_MINAUR_BOOSTINT:{ //Boost Intelligence
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_SPELLCRAFT, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_SEARCH, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_LORE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_DISABLE_TRAP, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CRAFT_WEAPON, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CRAFT_TRAP, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CRAFT_ARMOR, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_APPRAISE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_TRUESPEAK, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_MARTIAL_LORE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_PSICRAFT, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CRAFT_GENERAL, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CRAFT_ALCHEMY, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CRAFT_POISON, nAuraBonus));
                break;}
            case SPELL_MINAUR_BOOSTSTR:{ //Boost Strength
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_DISCIPLINE, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_JUMP, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CLIMB, nAuraBonus));
                break;}
            case SPELL_MINAUR_BOOSTWIS:{ //Boost Wisdom
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_SPOT, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_LISTEN, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_HEAL, nAuraBonus));
                eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_SENSE_MOTIVE, nAuraBonus));
                break;}
            case SPELL_MINAUR_DETCAST:{ //Determined Caster
                SetLocalInt(oTarget, "Marshal_DetCast", nAuraBonus);
                break;}
        }
    }

    eBonus = ExtraordinaryEffect(eBonus);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}