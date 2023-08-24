/*
    sp_soulscour

    This spell deal 2d6 points of charisma damage
    and 1d6 points of wisdom damage. It then deals
    an additional 1d6 charisma damage 1 minute later.

    By: ???
    Created: ???
    Modified: Jul 3, 2006
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"

//
// Does the secondary charisma drain that happens 1 minute after initial effect.
//
void DoSecondaryDrain(object oTarget, int nChaDrain)
{
     // Build the drain effect.
     /*effect eDebuff = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDrain);
     eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));*/
     effect eVFX = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

     // Apply the damage and the damage visible effect to the target.
     SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
     ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, nChaDrain, DURATION_TYPE_PERMANENT, TRUE);
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
     int nCasterLvl = nCasterLevel;
     int nDice = nCasterLvl;
     if (nDice > 5) nDice = 5;
     int nPenetr = nCasterLvl + SPGetPenetr();

    int nTouchAttack;
     if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
     {
          // Fire cast spell at event for the specified target
          PRCSignalSpellEvent(oTarget);

          // Make touch attack, saving result for possible critical
          nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
          if (nTouchAttack > 0)
          {
               if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
               {
                    // 2da cha drain, 1d6 wis drain.
                    int nChaDrain = PRCGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL,
                         1 == nTouchAttack ? 2 : 4, 6);
                    int nWisDrain = PRCGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL,
                         1 == nTouchAttack ? 1 : 2, 6);

                    // Build the drain effect.
                    /*effect eDebuff = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDrain);
                    eDebuff = EffectLinkEffects(eDebuff,
                         EffectAbilityDecrease(ABILITY_WISDOM, nWisDrain));
                    eDebuff = EffectLinkEffects(eDebuff,
                         EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));*/
                    effect eVFX = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

                    // Apply the damage and the damage visible effect to the target.
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
                    ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, nChaDrain, DURATION_TYPE_PERMANENT, TRUE);
                    ApplyAbilityDamage(oTarget, ABILITY_WISDOM,   nWisDrain, DURATION_TYPE_PERMANENT, TRUE);

                    // Target takes secondary 1d6 cha drain 1 minute later.
                    nChaDrain = PRCGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL,
                         1 == nTouchAttack ? 1 : 2, 6);
                    DelayCommand(MinutesToSeconds(1), DoSecondaryDrain(oTarget, nChaDrain));

                    // apply sneak damage if appropriate
                    ApplyTouchAttackDamage(OBJECT_SELF, oTarget, nTouchAttack, 0, DAMAGE_TYPE_NEGATIVE);
               }
          }
     }

    return nTouchAttack;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}