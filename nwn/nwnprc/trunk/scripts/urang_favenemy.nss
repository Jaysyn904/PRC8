
#include "prc_inc_combat"

void FavEn(int iFeat,int iBonus ,int nLevel, int iDmgType, int iFEAC, int iFERE, int nRacial, int iBiowareFeat)
{
  object oPC = PRCGetSpellTargetObject();
  if (!GetHasFeat(iFeat, oPC)) return ;

  if (GetHasFeat(iBiowareFeat)) return;  // make sure to punish people who take favored enemy twice with
                                         // bioware feats and UR feats.

  int iBaneDmgType;
  if (iDmgType = DAMAGE_TYPE_PIERCING)
  {
      iBaneDmgType = DAMAGE_TYPE_SLASHING;
  }
  else
  {
      iBaneDmgType = DAMAGE_TYPE_PIERCING;
  }

  effect eLink;

  eLink = VersusRacialTypeEffect(EffectDamageIncrease(iBonus,iDmgType) ,nRacial);
  eLink = EffectLinkEffects(eLink,VersusRacialTypeEffect(EffectSkillIncrease(nLevel,SKILL_BLUFF),nRacial));
  eLink = EffectLinkEffects(eLink,VersusRacialTypeEffect(EffectSkillIncrease(nLevel,SKILL_LISTEN),nRacial));
  eLink = EffectLinkEffects(eLink,VersusRacialTypeEffect(EffectSkillIncrease(nLevel,SKILL_SPOT),nRacial));
  if (iFEAC) eLink = EffectLinkEffects(eLink,VersusRacialTypeEffect( EffectACIncrease(nLevel) ,nRacial));
  if (iFERE) eLink = EffectLinkEffects(eLink,VersusRacialTypeEffect( EffectSavingThrowIncrease(SAVING_THROW_ALL,nLevel,SAVING_THROW_TYPE_SPELL) ,nRacial));
  if (GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES, oPC)) {
    eLink = EffectLinkEffects(eLink,VersusRacialTypeEffect( EffectAttackIncrease(2) ,nRacial));
    eLink = EffectLinkEffects(eLink,VersusRacialTypeEffect( EffectDamageIncrease(DAMAGE_BONUS_2d6,iBaneDmgType) ,nRacial));
  }
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eLink),oPC);

}

void main()
{
    object oPC = PRCGetSpellTargetObject();
    PRCRemoveEffectsFromSpell(oPC,GetSpellId());
    int nLevel = (GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC)+3)/5;
    int iIFE= GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY, oPC) ? 3: 0;

    int iDmgType = GetWeaponDamageType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC));
    if ( iDmgType == -1) iDmgType = DAMAGE_TYPE_BLUDGEONING;

    int iFEAC = GetHasFeat(FEAT_UR_DODGE_FE,oPC);
    int iFERE = GetHasFeat(FEAT_UR_RESIST_FE,oPC);

    int iSpell;
    if (GetHasFeat(FEAT_FAVORED_POWER_ATTACK,oPC))
    {
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK1,oPC)  ? 1 : 0;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK2,oPC)  ? 2 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK3,oPC)  ? 3 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK4,oPC)  ? 4 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK5,oPC)  ? 5 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK6,oPC)  ? 6 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK7,oPC)  ? 7 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK8,oPC)  ? 8 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK9,oPC)  ? 9 : iSpell;
        iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK10,oPC) ? 10: iSpell;
    //  iSpell =  GetHasSpellEffect(SPELL_SUPREME_POWER_ATTACK,oPC) ? 20: iSpell;
    }

    int iBonus = IPGetDamageBonusConstantFromNumber(nLevel+iIFE+iSpell);

    FavEn(FEAT_UR_FE_DWARF,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_DWARF, FEAT_FAVORED_ENEMY_DWARF);
    FavEn(FEAT_UR_FE_ELF,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_ELF, FEAT_FAVORED_ENEMY_ELF);
    FavEn(FEAT_UR_FE_GNOME,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_GNOME, FEAT_FAVORED_ENEMY_GNOME);
    FavEn(FEAT_UR_FE_HALFING,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HALFLING, FEAT_FAVORED_ENEMY_HALFLING);
    FavEn(FEAT_UR_FE_HALFELF,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HALFELF, FEAT_FAVORED_ENEMY_HALFELF);
    FavEn(FEAT_UR_FE_HALFORC,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HALFORC, FEAT_FAVORED_ENEMY_HALFORC);
    FavEn(FEAT_UR_FE_HUMAN,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HUMAN, FEAT_FAVORED_ENEMY_HUMAN);
    FavEn(FEAT_UR_FE_ABERRATION,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_ABERRATION, FEAT_FAVORED_ENEMY_ABERRATION);
    FavEn(FEAT_UR_FE_ANIMAL,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_ANIMAL, FEAT_FAVORED_ENEMY_ANIMAL);
    FavEn(FEAT_UR_FE_BEAST,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_BEAST, FEAT_FAVORED_ENEMY_BEAST);
    FavEn(FEAT_UR_FE_CONSTRUCT,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_CONSTRUCT, FEAT_FAVORED_ENEMY_CONSTRUCT);
    FavEn(FEAT_UR_FE_DRAGON,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_DRAGON, FEAT_FAVORED_ENEMY_DRAGON);
    FavEn(FEAT_UR_FE_GOBLINOID,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HUMANOID_GOBLINOID, FEAT_FAVORED_ENEMY_GOBLINOID);
    FavEn(FEAT_UR_FE_MONSTROUS,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HUMANOID_MONSTROUS, FEAT_FAVORED_ENEMY_MONSTROUS);
    FavEn(FEAT_UR_FE_ORC,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HUMANOID_ORC, FEAT_FAVORED_ENEMY_ORC);
    FavEn(FEAT_UR_FE_REPTILIAN,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_HUMANOID_REPTILIAN, FEAT_FAVORED_ENEMY_REPTILIAN);
    FavEn(FEAT_UR_FE_ELEMENTAL,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_ELEMENTAL, FEAT_FAVORED_ENEMY_ELEMENTAL);
    FavEn(FEAT_UR_FE_FEY,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_FEY, FEAT_FAVORED_ENEMY_FEY);
    FavEn(FEAT_UR_FE_GIANT,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_GIANT, FEAT_FAVORED_ENEMY_GIANT);
    FavEn(FEAT_UR_FE_MAGICAL_BEAST,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_MAGICAL_BEAST, FEAT_FAVORED_ENEMY_MAGICAL_BEAST);
    FavEn(FEAT_UR_FE_OUTSIDER,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_OUTSIDER, FEAT_FAVORED_ENEMY_OUTSIDER);
    FavEn(FEAT_UR_FE_SHAPECHANGER,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_SHAPECHANGER, FEAT_FAVORED_ENEMY_SHAPECHANGER);
    FavEn(FEAT_UR_FE_UNDEAD,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_UNDEAD, FEAT_FAVORED_ENEMY_UNDEAD);
    FavEn(FEAT_UR_FE_VERMIN,iBonus,nLevel,iDmgType,iFEAC,iFERE,RACIAL_TYPE_VERMIN, FEAT_FAVORED_ENEMY_VERMIN);



}
