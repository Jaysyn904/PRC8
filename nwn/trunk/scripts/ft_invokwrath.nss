#include "prc_alterations"
#include "prc_feat_const"
#include "prc_spell_const"

void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(40550);
        return;
   }

  int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nHospLevel = GetLevelByClass(CLASS_TYPE_HOSPITALER);
    int nSolLevel = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT);
    int nTNLevel = GetLevelByClass(CLASS_TYPE_TRUENECRO);
    int nTotalLevel =  GetHitDice(OBJECT_SELF);

    int nTurnLevel = nClericLevel;
    int nClassLevel = nClericLevel;

    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);

    // GZ: Since paladin levels stack when turning, blackguard levels should stack as well
    // GZ: but not with the paladin levels (thus else if).
    if(nTNLevel > 0)
    {
        nClassLevel += (nTNLevel);
        nTurnLevel  += (nTNLevel);
    }
    if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
    {
        nClassLevel += (nBlackguardlevel - 2);
        nTurnLevel  += (nBlackguardlevel - 2);
    }
    else if((nPaladinLevel - 2) > 0)
    {
        nClassLevel += (nPaladinLevel -2);
        nTurnLevel  += (nPaladinLevel - 2);
    }
    if((nHospLevel - 2) > 0)
    {
        nClassLevel += (nHospLevel -2);
        nTurnLevel  += (nHospLevel - 2);
    }
    if ( nAlign == ALIGNMENT_GOOD)
    {
      nClassLevel += nSolLevel;
      nTurnLevel  += nSolLevel;
    }

    object oTarget = PRCGetSpellTargetObject();
    int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA) + nTurnLevel/2;

    if (!FortitudeSave(oTarget,nDC))
    {
        effect eVis = EffectVisualEffect(VFX_IMP_HARM);
        effect eDmg = EffectDamage(d8(nClassLevel/2),DAMAGE_TYPE_DIVINE,DAMAGE_POWER_ENERGY);
        effect eLink =EffectLinkEffects(eVis,eDmg);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);

    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);


}

