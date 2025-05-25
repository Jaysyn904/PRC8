/////////////////////////////////////////////////////////
/*
Chosen of Evil [Vile]
Your naked devotion to wickedness causes dark powers to
take an interest in your well-being.
Prerequisites: Con 13, any other vile feat.
Benefit: As an immediate action, you can take 1 point
of Constitution damage to gain an insight bonus equal
to the number of vile feats you have, including this one.
Until the end of your next turn, you can apply this bonus
to attack rolls, saving throws, or skill checks.*/
/////////////////////////////////////////////////////////
#include "prc_inc_spells"

int GetVileFeats(object oPC);

void main()
{
    object oPC = OBJECT_SELF;
    if(GetIsImmune(oPC, IMMUNITY_TYPE_ABILITY_DECREASE))
    {
        FloatingTextStringOnCreature("If you cannot take ability damage you cannot use this feat", oPC, FALSE);
        return;
    }

    int nBonus = GetVileFeats(oPC);
    int nSpell = GetSpellId();
    float fDuration = TurnsToSeconds(1);

    ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);

    //VFX
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);

    //Different effects
    if(nSpell == SPELL_CHOSEN_EVIL_ATTACK)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(nBonus), oPC, fDuration);
    else if(nSpell == SPELL_CHOSEN_EVIL_SAVE)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL), oPC, fDuration);
    else if(nSpell == SPELL_CHOSEN_EVIL_SKILL)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus), oPC, fDuration);

    //epic fail
    else if(DEBUG) DoDebug("Invalid SpellID: " + IntToString(nSpell));
}

int GetVileFeats(object oPC)
{
    int nCount = GetHasFeat(FEAT_DARK_SPEECH, oPC)
               + GetHasFeat(FEAT_DEFORM_EYES, oPC)
               + GetHasFeat(FEAT_DEFORM_FACE, oPC)
               + GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC)
               + GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC)
               + GetHasFeat(FEAT_EB_HAND, oPC)
               + GetHasFeat(FEAT_EB_HEAD, oPC)
               + GetHasFeat(FEAT_EB_CHEST, oPC)
               + GetHasFeat(FEAT_EB_ARM, oPC)
               + GetHasFeat(FEAT_EB_NECK, oPC)
               + GetHasFeat(FEAT_LICHLOVED, oPC)
               + GetHasFeat(FEAT_THRALL_TO_DEMON, oPC)
               + GetHasFeat(FEAT_DISCIPLE_OF_DARKNESS, oPC)
               + GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_CLUB, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_DAGGER, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_MACE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_MORNINGSTAR, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_QUARTERSTAFF, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SPEAR, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SHORTSWORD, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_RAPIER, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SCIMITAR, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_LONGSWORD, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_GREATSWORD, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_HANDAXE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_BATTLEAXE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_GREATAXE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_HALBERD, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_LIGHTHAMMER, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_LIGHTFLAIL, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_WARHAMMER, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_HEAVYFLAIL, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SCYTHE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_KATANA, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_BASTARDSWORD, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_DIREMACE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_DOUBLEAXE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_TWOBLADED, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_KAMA, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_KUKRI, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_HEAVYCROSSBOW, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_LIGHTCROSSBOW, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SLING, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_LONGBOW, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SHORTBOW, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SHURIKEN, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_DART, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_SICKLE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_DWAXE, oPC)
               + GetHasFeat(FEAT_VILE_MARTIAL_MINDBLADE, oPC)			   
               + GetHasFeat(FEAT_VILE_MARTIAL_EAGLE_CLAW)
               + GetHasFeat(FEAT_VILE_MARTIAL_LIGHT_LANCE)
               + GetHasFeat(FEAT_VILE_MARTIAL_HEAVY_PICK)
               + GetHasFeat(FEAT_VILE_MARTIAL_LIGHT_PICK)
               + GetHasFeat(FEAT_VILE_MARTIAL_SAI)
               + GetHasFeat(FEAT_VILE_MARTIAL_NUNCHAKU)
               + GetHasFeat(FEAT_VILE_MARTIAL_FALCHION)
               + GetHasFeat(FEAT_VILE_MARTIAL_SAP)
               + GetHasFeat(FEAT_VILE_MARTIAL_KATAR)
               + GetHasFeat(FEAT_VILE_MARTIAL_HEAVY_MACE)
               + GetHasFeat(FEAT_VILE_MARTIAL_MAUL)
               + GetHasFeat(FEAT_VILE_MARTIAL_DBL_SCIMITAR)
               + GetHasFeat(FEAT_VILE_MARTIAL_GOAD)
               + GetHasFeat(FEAT_VILE_MARTIAL_ELVEN_LIGHTBLADE)
               + GetHasFeat(FEAT_VILE_MARTIAL_ELVEN_THINBLADE)
               + GetHasFeat(FEAT_VILE_MARTIAL_ELVEN_COURTBLADE)			   
               + GetHasFeat(FEAT_APOSTATE, oPC)
               + GetHasFeat(FEAT_DARK_WHISPERS, oPC)
               + GetHasFeat(FEAT_MASTERS_WILL, oPC)
               + GetHasFeat(FEAT_DEFORM_MADNESS, oPC)
               + GetHasFeat(FEAT_REFLEXIVE_PSYCHOSIS, oPC)
               + GetHasFeat(FEAT_FAVORED_ZULKIRS, oPC)
               + GetHasFeat(FEAT_CHOSEN_OF_EVIL, oPC);
             //+ GetHasFeat(, oPC);

    return nCount;
}