//::////////////////////////////////////////////////////////
//::
/*
	Frost Breath
	Evocation [Cold]
	Level: 				Cleric 2, Druid 2, Sorcerer 2, Wizard 2,
	Components: 		V, S, M,
	Casting Time: 		1 standard action
	Range: 				30 feet
	Effect: 			Cone-shaped burst
	Duration:			Instantaneous
	Saving Throw: 		Reflex half
	Spell Resistance: 	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	Giving a forceful exhale across your cupped hand, your 
	breath shoots forth tinged with frost and crystals of ice.

	You breathe a cone of intense cold at your foes. The 
	spell deals 1d4 points of cold damage per two caster 
	levels (maximum 5d4). In addition, all creatures damaged 
	by the frost breath that fail their Reflex save are dazed 
	for 1 round by the sudden shock of cold.

	Material Component: Three drops of water or fragments of 
	ice (which are held in a cupped palm and blown toward the 
	target).

	PnP notes:  
	- 1d4 cold damage per 2 caster levels (max 5d4).  
	- Creatures damaged that FAIL the Reflex save are also  
	  dazed 1 round by the shock of cold.	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 18:19:11
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);  
  
    object oCaster   = OBJECT_SELF;  
    int    nSpellID  = PRCGetSpellId();  
    int    nCasterLvl = PRCGetCasterLevel(oCaster);  
    int    nPenetr   = nCasterLvl + SPGetPenetr();  
    int    nMetaMagic = PRCGetMetaMagicFeat();  
    int    nSaveDC;  
    float  fDelay;  
    object oTarget;  
    location lTarget = PRCGetSpellTargetLocation();  
  
    // 1d4 per 2 CL, max 5d4 -> dice = CL/2 capped at 5  
    int nDice = PRCMin(5, nCasterLvl / 2);  
  
    int nDmgType  = ChangedElementalDamage(oCaster, DAMAGE_TYPE_COLD);  
    int nSaveType = ChangedSaveType(nDmgType);  
  
    effect eDaze = EffectDazed();  
    effect eDazeVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);  
    effect eDazeLink = EffectLinkEffects(eDaze, eDazeVis);  
  
    // 30-ft cone ~ 10.0m spread  
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, FALSE,  
        OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
  
    while (GetIsObjectValid(oTarget))  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)  
            && oTarget != oCaster)  
        {  
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID);  
            fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);  
  
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))  
            {  
                nSaveDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);  
  
                int nDamage = PRCGetMetaMagicDamage(nDmgType, nDice, 4, 0);  
                nDamage += SpellDamagePerDice(oCaster, nDice);  
  
                // One roll decides both damage and the daze.  
                int bSaved = PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget,  
                    nSaveDC, nSaveType, oCaster, fDelay);  
  
                if (bSaved)  
                {  
                    // Evasion handling  
                    if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))  
                        nDamage /= 4;  
                    else if (GetHasFeat(FEAT_EVASION, oTarget))  
                        nDamage = 0;  
                    else  
                        nDamage /= 2;  
                }  
  
                if (nDamage > 0)  
                {  
                    effect eDam = PRCEffectDamage(oTarget, nDamage, nDmgType);  
                    DelayCommand(fDelay, SPApplyEffectToObject(  
                        DURATION_TYPE_INSTANT, eDam, oTarget));  
                    DelayCommand(fDelay, SPApplyEffectToObject(  
                        DURATION_TYPE_INSTANT,  
                        EffectVisualEffect(VFX_IMP_FROST_S), oTarget));  
                    PRCBonusDamage(oTarget);  
  
                    // Creatures that failed the save are dazed  
                    if (!bSaved)  
                    {  
                        DelayCommand(fDelay, SPApplyEffectToObject(  
                            DURATION_TYPE_TEMPORARY, eDazeLink, oTarget,  
                            RoundsToSeconds(1), TRUE, nSpellID, nCasterLvl));  
                    }  
                }  
            }  
        }  
  
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, FALSE,  
            OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
    }  
  
    PRCSetSchool();  
}