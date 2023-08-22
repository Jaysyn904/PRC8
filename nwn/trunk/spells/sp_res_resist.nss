//::///////////////////////////////////////////////
//:: Name      Resonating Resistance
//:: FileName  sp_res_resist.nss
//:://////////////////////////////////////////////
/**@file Resonating Resistance 
Transmutation
Level: Clr 5, Mortal Hunter 4, Sor/Wiz 5
Components: V, Fiend 
Casting Time: 1 action 
Range: Personal 
Target: Caster
Duration: 1 minute/level

The caster improves his spell resistance. Each time
a foe attempts to bypass the caster's spell 
resistance, it must make a spell resistance check 
twice. If either check fails, the foe fails to bypass
the spell resistance.

The caster must have spell resistance as an 
extraordinary ability for resonating resistance to 
function. Spell resistance granted by a magic item or
the spell resistance spell does not improve.

Author:    Tenjac
Created:   7/5/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
  if(!X2PreSpellCastCode()) return;

  PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

  object oPC = OBJECT_SELF;
  int nCasterLvl = PRCGetCasterLevel(oPC);
  float fDur = (60.0f * nCasterLvl);
  int nMetaMagic = PRCGetMetaMagicFeat();
  effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

  if(nMetaMagic & METAMAGIC_EXTEND)
  {
    fDur += fDur;
  }

  //if is a fiend
  if((GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) && (MyPRCGetRacialType(oPC) == RACIAL_TYPE_OUTSIDER))
  {
    //has spell SR on hide
    object oSkin = GetPCSkin(oPC);
    itemproperty iTest = GetFirstItemProperty(oSkin);
    int bValid = FALSE;

    while(GetIsItemPropertyValid(iTest))
    {
      if(GetItemPropertyType(iTest) == ITEM_PROPERTY_SPELL_RESISTANCE)
      {
        bValid = TRUE;
        break;
      }
      iTest = GetNextItemProperty(oSkin);
    }

    //has SR feat
    if(GetHasFeat(FEAT_SPELL27, oPC) ||
       GetHasFeat(FEAT_SPELL25, oPC) ||
       GetHasFeat(FEAT_SPELL23, oPC) ||
       GetHasFeat(FEAT_SPELL22, oPC) ||
       GetHasFeat(FEAT_SPELL21, oPC) ||
       GetHasFeat(FEAT_SPELL20, oPC) ||
       GetHasFeat(FEAT_SPELL19, oPC) ||
       GetHasFeat(FEAT_SPELL18, oPC) ||
       GetHasFeat(FEAT_SPELL17, oPC) ||
       GetHasFeat(FEAT_SPELL16, oPC) ||
       GetHasFeat(FEAT_SPELL15, oPC) ||
       GetHasFeat(FEAT_SPELL14, oPC) ||
       GetHasFeat(FEAT_SPELL13, oPC) ||
       GetHasFeat(FEAT_SPELL11, oPC) ||
       GetHasFeat(FEAT_SPELL10, oPC) ||
       GetHasFeat(FEAT_SPELL8, oPC) ||
       GetHasFeat(FEAT_SPELL5, oPC))
    {
      bValid = TRUE;
    }

    if(bValid == TRUE)
    {
      SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, fDur);
    }
  }

  PRCSetSchool();
}

