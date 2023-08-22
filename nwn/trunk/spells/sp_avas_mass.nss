//::///////////////////////////////////////////////
//:: Name     Avascular Mass
//:: FileName   sp_avas_mass.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*Avascular Mass
  Necromancy [Death, Evil]
  Sorc/Wizard 8
  Range: Close
  Saving Throw: Fortitude partial and Reflex negates
  Spell Resistance: yes

  You shoot a ray of necromantic energy from your outstretched 
  hand, causing any living creature struck by the ray to violently 
  purge blood vessels through its skin. You must succeed 
  on a ranged touch attack to affect the subject. If successful, the 
  subject is reduced to half of its current hit points (rounded down) 
  and stunned for 1 round. On a successful Fortitude saving throw the 
  subject is not stunned.
  
  Also, the purged blood vessels are magically animated, creating a many
  layered mass of magically strong, adhesive tissue that traps those caught
  in it... Creatures caught within a 20 foot radius become entangled unless 
  the succeed on a Reflex save. The original target of the spell is automatically 
  entangled.

  The entangled creature takes a -2 penalty on attack rolls, -4 to effective Dex, 
  and can't move. An entangled character that attempts to cast a spell must succeed 
  in a concentration check. Because the avascular mass is magically animate, and 
  gradually tightens on those it holds, the Concentration check DC is 30...Once loose,
  a creature may progress through the writhing blood vessels very slowly.  

  Spell is modeled after Entanglement, using three seperate scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 10/05/05
//:://////////////////////////////////////////////
//::Added hold ray functionality - HackyKid


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
	effect eHold = EffectEntangle();
	effect eSlow = EffectSlow();
	
	PRCSignalSpellEvent(oTarget, TRUE, SPELL_AVASCULAR_MASS, oCaster);
	
	//temporary VFX
	
	effect eLink = EffectVisualEffect(VFX_DUR_ENTANGLE);
	
	//damage rounds up
	int nDam = (nHP - (nHP / 2));
	effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
	
	
	//Blood gush
	effect eBlood = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
	
	//Make touch attack
	int iAttackRoll= PRCDoRangedTouchAttack(oTarget);
	
	// Do attack beam VFX. Ornedan is my hero. 
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oCaster, BODY_NODE_HAND, !iAttackRoll), oTarget, 1.0f); 
	
	if (iAttackRoll)
	{	
		//Spell Resistance & Living Check
		if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr) && PRCGetIsAliveCreature(oTarget))
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oTarget);
			
			
			//Apply AoE writing blood vessel VFX centered on oTarget
			//ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eMass, lLocation, fDuration);
			
			//Orignial target automatically entangled
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2),FALSE);
			
			//Fortitude Save for Stun
			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_EVIL))
			{
				effect eStun = EffectStunned();
				effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStunVis, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1));
			}
			
			//Declare major variables for Mass including Area of Effect Object
			effect eAOE = EffectAreaOfEffect(VFX_PER_AVASMASS);
			location lTarget = PRCGetSpellTargetLocation();
			
			int nDuration = 3 + nCasterLevel / 2;
			
			//Make sure duration does not equal 0
			if(nDuration < 1)
			{
				nDuration = 1;
			}
			//Check Extend metamagic feat
			if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
			{
				nDuration = nDuration * 2;    //Duration is +100%
			}
			
			
			//Create an instance of the AOE Object using the Apply Effect function
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
			
			object oAoE = GetAreaOfEffectObject(lTarget, GetAreaOfEffectTag(VFX_PER_AVASMASS));
			SetAllAoEInts(SPELL_AVASCULAR_MASS, oAoE, PRCGetSpellSaveDC(SPELL_AVASCULAR_MASS, SPELL_SCHOOL_CONJURATION), 0, nCasterLevel);
			
			
			
			DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
			// Getting rid of the local integer storing the spellschool name
		}
	}
	//SPEvilShift(oCaster);

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

