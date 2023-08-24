//::///////////////////////////////////////////////
//:: Name      Command
//:: FileName  sp_command.nss
//:://////////////////////////////////////////////
/**@file Command
Enchantment (Compulsion) [Mind-Affecting]
Level: Cleric 1
Components: V
Casting Time: 1 action
Range: Close (25 ft. + 5 ft/2 levels)
Targets: 1 living creature
Duration: 1 Round
Saving Throw: Will Negates
Spell Resistance: Yes
 
You give the subject a single command, which it obeys to the best of its ability.

Approach - The target runs directly towards you for one round.
Drop - The target drops what it is holding (This will not work on creatures that cannot be disarmed). 
Fall - The target falls to the ground for one round.
Flee - The target runs away from the caster for one round.
Halt - The target stands in place and takes no action for one round.

Author:    Stratovarius
Created:   29/4/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//Define vars
    	object oCaster = OBJECT_SELF;
    	object oTarget = PRCGetSpellTargetObject();
    	int nSpellId = PRCGetSpellId();
    	int nMetaMagic = PRCGetMetaMagicFeat();
    	int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
    	int nCaster = PRCGetCasterLevel(OBJECT_SELF);
    	int nDuration = 1;
    	//Enter Metamagic conditions
	if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
	{
	        nDuration = nDuration * 2; //Duration is +100%
	}
	
    	effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    	effect eLink = EffectLinkEffects(eMind, eDur);
    
    	//Fire cast spell at event for the specified target
    	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCaster+SPGetPenetr()) && PRCGetIsAliveCreature(oTarget))
        {
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), TRUE,-1,nCaster);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                DoCommandSpell(oCaster, oTarget, nSpellId, nDuration, nCaster);
            }
        }	
	
	PRCSetSchool();
}
				
				