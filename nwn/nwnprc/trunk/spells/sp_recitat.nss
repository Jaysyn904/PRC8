/*  
    Recitation Impact Script  
      
    Spell Compendium version:  
    - Conjuration (Creation)  
    - Level: Cleric 4, Purification 3  
    - Target: All allies within 60-ft. radius burst  
    - Duration: 1 round/level  
    - Allies gain +2 luck bonus to AC, attack rolls, saving throws  
    - +3 luck bonus if they worship same deity as caster  
*/  
#include "prc_inc_spells" 
#include "prc_sp_func"  
#include "prc_inc_combat"  
  
//Implements the spell impact
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)  
{  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    float fDuration = RoundsToSeconds(nCasterLevel);  
      
    // Apply metamagic  
    if(nMetaMagic & METAMAGIC_EXTEND)  
        fDuration *= 2.0;  
      
    // Get caster's deity for comparison  
    string sCasterDeity = GetDeity(oCaster);  
      
    // Check if target is an ally  
    if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))  
    {  
        // Determine bonus amount based on deity  
        int nBonus = 2;  
        if(GetDeity(oTarget) == sCasterDeity && sCasterDeity != "")  
            nBonus = 3;  
          
        // Create luck bonus effects 
        effect eAC = EffectACIncrease(nBonus, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);  
        eAC = EffectLinkEffects(eAC, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));  
          
        effect eAttack = EffectAttackIncrease(nBonus);  
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);  
          
        // Link all effects together  
        effect eLink = EffectLinkEffects(eAC, eAttack);  
        eLink = EffectLinkEffects(eLink, eSave);  
          
        // Apply the effects  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE);  
          
        // Apply visual effect  
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_HOLY), oTarget);  
    }  
      
    return TRUE; // Return TRUE for area spells  
}  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    int nSpellID = PRCGetSpellId();  
      
    PRCSetSchool(GetSpellSchool(nSpellID));  
    if (!X2PreSpellCastCode()) return;  
      
    // Get spell target location for area effect  
    location lTarget = GetSpellTargetLocation();  
      
    // Apply area of effect - 60ft radius (RADIUS_SIZE_COLOSSAL)  
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);  
      
    // Get all creatures in 60ft radius  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
      
    while(GetIsObjectValid(oTarget))  
    {  
        DoSpell(oCaster, oTarget, nCasterLevel, 0);  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    }  
      
    PRCSetSchool();  
}


/* void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = PRCGetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
	object oCaster = OBJECT_SELF;

	// Apply the area vfx.
//	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(), lTarget);
	
	// Build the bonus/penalty effect chains.
	effect ePositive = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	ePositive = EffectLinkEffects (ePositive, EffectAttackIncrease(2));
	ePositive = EffectLinkEffects (ePositive, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));
	ePositive = EffectLinkEffects (ePositive, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
	effect eNegative = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	eNegative = EffectLinkEffects (eNegative, EffectAttackDecrease(2));
	eNegative = EffectLinkEffects (eNegative, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
	eNegative = EffectLinkEffects (eNegative, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
	
	// Calculate the spell duration.
	float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));
	
	int nPenetr = nCasterLvl + SPGetPenetr();
	
	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	float fDelay;
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
	// make sure it doesn't stack
		if(GetHasSpellEffect(3140, oTarget) == FALSE)
		{
			// Apply a bonus/penalty effect to the target depending on it's reaction to the caster.
			// If the object is neutral it gets neither a bonus nor a penalty.
			int nFriendly = 0;
			if(GetIsFriend(oTarget, oCaster)) 
			{
				nFriendly = 1;
			}
			int nHostile = GetIsEnemy(oTarget, oCaster);
	
			if (nFriendly || nHostile)
			{
				// Determine which effect chain to use.
				effect eTarget = nFriendly ? ePositive : eNegative;
			
				// Fire cast spell at event for the specified target
				PRCSignalSpellEvent(oTarget, nHostile);
			
				// Check for SR vs. hostile targets before applying effects.
				fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);
				if (nFriendly || !PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
					DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTarget, oTarget, fDuration,TRUE,-1,nCasterLvl));
			}
		
			oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);
		}
	}
	
	PRCSetSchool();
}
 */