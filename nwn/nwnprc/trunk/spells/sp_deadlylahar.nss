//::////////////////////////////////////////////////////////
//::
/*	
	Deadly Lahar (sp_deadlylahar.nss)
	Conjuration [Earth, Fire]
	Level: 				Druid 8, sorcerer/wizard 8
	Components: 		V, S
	Casting Time: 		1 standard action
	Range: 				60 ft.
	Area: 				Cone-shaped spread
	Duration: 			Instantaneous
	Saving Throw: 		Reflex partial
	Spell Resistance:	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	You create a liquid landslide of molten hot volcanic 
	material. All creatures in the area of the spell take 
	10d6 points of fire damage.Additionally, those creatures
	are coated in a thick layer of the viscous substance, 
	slowing them (as the slow spell) for the next 3 rounds 
	and dealing an additional 5d6 points of fire damage per 
	round. A successful Reflex save reduces the initial damage 
	by half and prevents the slow effect and the additional 
	damage.
	
	PnP mechanics:  
	- 10d6 fire damage to all creatures in the cone.  
	- Failed Reflex save: also coated — slowed (as slow)  
	  for 3 rounds and takes 5d6 fire per round for 3 rounds.  
	- Successful save: half damage, no slow, no coat.  
	- No SR. 60-ft cone = ~18.28m spread.  	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 16:51:33
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
#include "spinc_cone"  
  
void LaharTick(object oTarget, object oCaster, int nTicksLeft)  
{  
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget)  
        || !GetLocalInt(oTarget, "PRC_LAHAR_COATED"))  
        return;  
  
    // 5d6 fire per round, no further save per PnP  
    int nDamage = d6(5) + SpellDamagePerDice(oCaster, 5);  
    int nEleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
        PRCEffectDamage(oTarget, nDamage, nEleDmg), oTarget);  
  
    nTicksLeft--;  
    if (nTicksLeft > 0)  
        DelayCommand(6.0f, LaharTick(oTarget, oCaster, nTicksLeft));  
    else  
        DeleteLocalInt(oTarget, "PRC_LAHAR_COATED");  
}  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
  
    object oCaster    = OBJECT_SELF;  
    int nSpellID      = PRCGetSpellId();  
    int nMetaMagic    = PRCGetMetaMagicFeat();  
    location lTarget  = PRCGetSpellTargetLocation();  
    int nEleDmg       = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);  
    int nSaveType     = ChangedSaveType(nEleDmg);  
  
    effect eVis  = EffectVisualEffect(VFX_IMP_FLAME_M);  
    effect eSlow = EffectSlow();  
  
    // 60-ft cone-shaped spread  
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE,  
        FeetToMeters(60.0), lTarget, TRUE,  
        OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
  
    while (GetIsObjectValid(oTarget))  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)  
            && oTarget != oCaster  
            && !CheckMasteryOfShapes(oCaster, oTarget))  
        {  
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);  
  
            // Distance-based application delay  
            float fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);  
  
            int nSaveDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);  
            int bSaved  = PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, nSaveType);  
  
            // Fixed 10d6 initial damage — NOT caster-level dice  
            int nDamage = PRCGetMetaMagicDamage(nEleDmg, 10, 6)  
                        + SpellDamagePerDice(oCaster, 10);  
  
            // Reflex partial: save halves; evasion/improved evasion apply  
            if (bSaved)  
            {  
                nDamage /= 2;  
                if (GetHasFeat(FEAT_EVASION, oTarget)  
                    || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))  
                    nDamage = 0;  
            }  
            else if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))  
            {  
                nDamage /= 2;  
            }  
  
            if (nDamage > 0)  
            {  
                DelayCommand(fDelay, SPApplyEffectToObject(  
                    DURATION_TYPE_INSTANT,  
                    PRCEffectDamage(oTarget, nDamage, nEleDmg), oTarget));  
                DelayCommand(fDelay, SPApplyEffectToObject(  
                    DURATION_TYPE_INSTANT, eVis, oTarget));  
                PRCBonusDamage(oTarget);  
            }  
  
            // Failed save: coated — slowed 3 rounds, 5d6/round for 3 rounds  
            if (!bSaved && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)  
            {  
                DelayCommand(fDelay, SPApplyEffectToObject(  
                    DURATION_TYPE_TEMPORARY, eSlow, oTarget,  
                    RoundsToSeconds(3), TRUE, nSpellID));  
                SetLocalInt(oTarget, "PRC_LAHAR_COATED", TRUE);  
                DelayCommand(fDelay + 6.0f,  
                    LaharTick(oTarget, oCaster, 3));  
            }  
        }  
  
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE,  
            FeetToMeters(60.0), lTarget, TRUE,  
            OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
    }  
  
    PRCSetSchool();  
}