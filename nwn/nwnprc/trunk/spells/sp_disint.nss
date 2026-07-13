//::///////////////////////////////////////////////
//:: Name       Disintegrate
//:: FileName   sp_disint.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/** @file Disintegrate
    School: Transmutation
    Level: Destruction 7, Sor/Wiz 6
    Components: V, S, M/DF
    Casting Time: 1 action
    Range: Medium (100 ft. + 10 ft/level)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: Fortitude partial
    Spell Resistance: Yes

    A thin, green ray springs from your pointing finger.
    You must make a successful ranged touch attack to hit.
    Any creature struck by the ray takes 2d6 points of
    damage per caster level (to a maximum of 40d6). Any
    creature reduced to 0 or fewer hit points by this
    spell is entirely disintegrated, leaving behind only
    a trace of fine dust. A disintegrated creature’s
    equipment is unaffected.

    When used against an object, the ray simply
    disintegrates as much as one 10- foot cube of
    nonliving matter. Thus, the spell disintegrates only
    part of any very large object or structure targeted.
    The ray affects even objects constructed entirely of
    force, such as forceful hand or a wall of force, but
    not magical effects such as a globe of invulnerability
    or an antimagic field.

    A creature or object that makes a successful Fortitude
    save is partially affected, taking only 5d6 points of
    damage. If this damage reduces the creature or object
    to 0 or fewer hit points, it is entirely disintegrated.

    Only the first creature or object struck can be
    affected; that is, the ray affects only one target per
    casting.

    Material Components: A lodestone and a pinch of dust.
*/
//:://////////////////////////////////////////////
//:: Created By: ????
//:: Created On: ????
//::
//:: Modified By: Tenjac 1/11/06
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

    int iAttackRoll;

    // Target allowed check
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        // Fire cast spell at event for the specified target
        PRCSignalSpellEvent(oTarget);

        // Make the touch attack.
        iAttackRoll = PRCDoRangedTouchAttack(oTarget);

        // Shoot the beam. Hit / miss animation
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                              EffectBeam(VFX_BEAM_DISINTEGRATE, oCaster, BODY_NODE_HAND, !iAttackRoll),
                              oTarget, 1.0, FALSE);

        // If the beam hit, affect the target
        if (iAttackRoll > 0)
        {
			if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))  
			{  
				// Check for placeables immunity - if immune, force save to succeed (reduced damage only)  
				int bImmune = GetLocalInt(oTarget, "IMMUNITY_SPELL_DISINTEGRATE");  
				  
                // Fort save or die time, but we implement death by doing massive damage
                // since disintegrate works on constructs, undead, etc.  At some point EffectDie()
                // should be tested to see if it works on non-living targets, and if it does it should
                // be used instead.
                // Test done. Result: It does kill them. 
				int bKills = FALSE;  
				int bSaveSuccess = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL);  
				  
				// Force save to succeed if immune  
				if (bImmune) bSaveSuccess = TRUE;  
				  
				if (bSaveSuccess)  
				{  
					if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
						return 0;  
					  
					int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_UNTYPED, 1 == iAttackRoll ? 5 : 20, 6);  
					nDamage += SpellDamagePerDice(oCaster, 5);  
			  
					if(nDamage >= GetCurrentHitPoints(oTarget))  
						bKills = TRUE;  
			  
					ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_UNTYPED);  
				}  
				else  
				{  
					DeathlessFrenzyCheck(oTarget);  
					bKills = TRUE;  
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);  
				}  
			  
				if(bKills)  
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), oTarget);  
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget);  
			}			
/*             // Make SR check
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
				// Check for immunity - if immune, force save to succeed (reduced damage only)  
				int bImmune = GetLocalInt(oTarget, IMMUNITY_SPELL_DISINTEGRATE);  
	
                // Fort save or die time, but we implement death by doing massive damage
                // since disintegrate works on constructs, undead, etc.  At some point EffectDie()
                // should be tested to see if it works on non-living targets, and if it does it should
                // be used instead.
                // Test done. Result: It does kill them.
                int bKills = FALSE;
                if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
                {
			if (GetHasMettle(oTarget, SAVING_THROW_FORT))
			// This script does nothing if it has Mettle, bail
				return 0;                
                    int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_UNTYPED, 1 == iAttackRoll ? 5 : 20, 6);
                    nDamage += SpellDamagePerDice(oCaster, 5);

                    // Determine if we should show the special kill VFX
                    if(nDamage >= GetCurrentHitPoints (oTarget))
                        bKills = TRUE;

                    // Run the touch attack damage applicator
                    ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_UNTYPED);
                }
                else
                {
                    // If FB passes saving throw it survives, else it dies
                    DeathlessFrenzyCheck(oTarget);

                    // Always show the special kill VFX
                    bKills = TRUE;

                    // Schedule dying to happen in 1.. 2.. 3..
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
                }

                // Apply damage effect and VFX impact, and if the target is dead then apply
                // the fancy rune circle too.
                if(bKills)
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget);
            } */
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

