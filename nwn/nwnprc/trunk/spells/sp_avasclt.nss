//::///////////////////////////////////////////////
//:: Name     Avasculate
//:: FileName   prc_avasclt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/** @file
    Necromancy [Death, Evil]
    Sorc/Wizard 7
    Range: Close
    Saving Throw: Fortitude partial
    Spell Resistance: yes

    You shoot a ray of necromantic energy from your outstretched hand,
    causing any living creature struck by the ray to violently purge
    blood or other vital fluids through its skin. You must succeed on
    a ranged touch attack to affect the subject. If successful, the
    subject is reduced to half of its current hit points (rounded down)
    and stunned for 1 round. On a successful Fortitude saving throw the
    subject is not stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 9/20/05
//::
//:: Modified By: Flaming_Sword
//:: Modified On: 9/21/05
//::
//:: Added hold ray functionality - HackyKid
//:://////////////////////////////////////////////


#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nHP = GetCurrentHitPoints(oTarget);
    
    PRCSignalSpellEvent(oTarget,TRUE, SPELL_AVASCULATE, oCaster);
    
    //SPEvilShift(oCaster);

    //Make touch attack
    int iAttackRoll = PRCDoRangedTouchAttack(oTarget);
    
    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oCaster, BODY_NODE_HAND, !iAttackRoll), oTarget, 1.0f); 

    if (iAttackRoll)
    {
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr) && PRCGetIsAliveCreature(oTarget))
        {
            //damage rounds up now
            int nDam = (nHP - (nHP / 2));
            effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
            effect eBeam = EffectBeam(VFX_BEAM_EVIL, oCaster, BODY_NODE_HAND);
            
            //Blood VFX.  Lots of em.
            effect eBlood = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
                   eBlood = EffectLinkEffects(eBlood, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED));
                   eBlood = EffectLinkEffects(eBlood, EffectVisualEffect(VFX_COM_BLOOD_REG_RED));
                   eBlood = EffectLinkEffects(eBlood, EffectVisualEffect(VFX_COM_BLOOD_SPARK_LARGE)); 
            
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oTarget);

            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_EVIL))
            {
                effect eStun = EffectStunned();
                effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStunVis, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0);
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
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
	if (oCaster != oTarget)	//cant target self with this spell, only when holding charge
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
