/*
    nw_s0_poison

    Must make a touch attack. If successful the target
    is struck down with wyvern poison.

    By: Preston Watamaniuk
    Created: May 22, 2001
    Modified: Jun 15, 2006

    Moved touch attack roll to after hostility
        check
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void DoPoison(object oTarget, object oCaster, int nDC, int CasterLvl, int nMetaMagic){
   //Declare major variables
   int nDam = PRCGetMetaMagicDamage(-1, 1, 10, 0, 0, nMetaMagic);
   //effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
   //effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_IMP_POISON_L), eDamage);

   // First check for poison immunity, if not, make a fort save versus spells.
   if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) &&
      !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster))
   {
       //Apply the poison effect and VFX impact
       //SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,TRUE,-1,CasterLvl);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_L), oTarget);
       ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_PERMANENT, TRUE, 0.0f, TRUE, oCaster);
   }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int CasterLvl = nCasterLevel;
    int nDC = PRCGetSaveDC(oTarget,oCaster);
    //not sure why it was doing this instead Primogenitor
        //10 + (CasterLvl / 2) + GetAbilityModifier(ABILITY_WISDOM);
    int nMetaMagic = PRCGetMetaMagicFeat();

    int iAttackRoll = 0;    //placeholder

    int nTouch = PRCDoMeleeTouchAttack(oTarget);;// Was a constant 1. No idea why - Ornedan

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
       //Fire cast spell at event for the specified target
       SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_POISON));
       //Make touch attack
       if (iAttackRoll > 0)
       {
           //Make SR Check
           if (!PRCDoResistSpell(oCaster, oTarget))
           {
               // Primary damage
               DoPoison(oTarget, oCaster, nDC, CasterLvl, nMetaMagic);

               // Secondary damage
               DelayCommand(MinutesToSeconds(1), DoPoison(oTarget, oCaster, nDC, CasterLvl, nMetaMagic));
           }
       }
    }
    return iAttackRoll;    //return TRUE if spell charges should be decremented
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