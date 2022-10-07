//:://////////////////////////////////////////////
//:: Name     Revenance
//:: FileName   sp_revenance.nss
//:://////////////////////////////////////////////
/** @file Conjuration (Healing)
Level: Blackguard 4, Cleric 4, Paladin 4, Bard 6
Components: V, S, DF,
Casting Time: 1 standard action
Range: Touch
Target: Dead ally touched
Duration: 1 minute/level
Saving Throw: None; see text
Spell Resistance: Yes (harmless)

You rush to your fallen companion amid the chaos of the
battle and cry out the words that will bring her back for
one last fight.

This spell brings a dead ally temporarily back to life. 
The subject can have been dead for up to 1 round per level.
Your target functions as if a raise dead spell (PH 268) 
had been cast upon her, except that she does not lose a level
and has half of her full normal hit points. She is alive 
(not undead) for the duration of the spell and can be healed
normally, but dies as soon as the spell ends.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/20/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = (nCasterLvl * 60);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        object oTarget = GetSpellTargetObject();
        
        if(!GetIsDead(oTarget) || GetIsReactionTypeHostile(oTarget))
        {
        	SendMessageToPC(oPC, "Must target a dead ally.");
        	break;
        }
        
        //resurrect
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oTarget);
        //Heal by half
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(GetMaxHitPoints(oTarget) / 2, oTarget), oTarget);
        //Schedule doom
        DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);        
        
        PRCSetSchool();
}