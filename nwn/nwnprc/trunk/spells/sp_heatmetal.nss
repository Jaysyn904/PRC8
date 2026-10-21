//::////////////////////////////////////////////////////////
//::
//:: Heat Metal (sp_heatmetal.nss)
//:: Transmutation [Fire]
//:: Level: 			Drd 2, Sun 2
//:: Components: 		V, S, DF
//:: Casting time: 		1 standard action
//:: Range: 			Close (25 ft. + 5 ft./2 levels)
//:: Target: 			Metal equipment of one creature per 
//::					two levels, no two of which can be 
//::					more than 30 ft. apart; or 25 lb. of 
//::					metal/level, all of which must be 
//::					within a 30-ft. circle
//:: Duration: 			7 rounds
//:: Saving Throw: 		Will negates (object)
//:: Spell Resistance: 	Yes (object)
//::
//::////////////////////////////////////////////////////////
//::
/*	Heat metal makes metal extremely warm. Unattended, 
	nonmagical metal gets no saving throw. Magical metal is 
	allowed a saving throw against the spell. An item in a 
	creature’s possession uses the creature’s saving throw 
	bonus unless its own is higher.

	A creature takes fire damage if its equipment is heated. 
	It takes full damage if its armor is affected or if it is 
	holding, touching, wearing, or carrying metal weighing 
	one-fifth of its weight. The creature takes minimum 
	damage (1 point or 2 points; see the table) if it’s not 
	wearing metal armor and the metal that it’s carrying 
	weighs less than one-fifth of its weight.

	On the first round of the spell, the metal becomes warm 
	and uncomfortable to touch but deals no damage. The same 
	effect also occurs on the last round of the spell’s 
	duration. During the second (and also the next-to-last) 
	round, intense heat causes pain and damage. In the third, 
	fourth, and fifth rounds, the metal is searing hot, 
	causing more damage, as shown on the table below.
	
	Round 		Metal Temperature 	Damage
	1 			Warm 				None
	2 			Hot 				1d4 points
	3–5 		Searing 			2d4 points
	6 			Hot 				1d4 points
	7 			Warm 				None

	Any cold intense enough to damage the creature negates 
	fire damage from the spell (and vice versa) on a 
	point-for-point basis. If cast underwater, heat metal 
	deals half damage and boils the surrounding water.

	Heat metal counters and dispels chill metal. 
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Spartan Hoplite (Gatecrashers)
//:: Date: 	2009/09/26
//::	
//:: Fixed by: Jaysyn
//:: Date: 2026-10-06 07:57:35
//::
/*
	Lots of parts of this lifted from the Inferno spell 
	script: x0_s0_inferno
*/
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
  
void RunImpact(object oTarget, object oCaster, int nSpellID, int nMetaMagic,  
               int nRound, int nDuration, int bMinDamage, int nEleDmg, int nCasterLvl);  
  
// Base AC of armor, excluding enhancement bonuses  
int GetArmorBaseAC(object oArmor)  
{  
    if (!GetIsObjectValid(oArmor))  
        return 0;  
    int nAC = GetItemACValue(oArmor);  
    itemproperty ip = GetFirstItemProperty(oArmor);  
    while (GetIsItemPropertyValid(ip))  
    {  
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS)  
            nAC -= GetItemPropertyCostTableValue(ip);  
        ip = GetNextItemProperty(oArmor);  
    }  
    return nAC;  
}  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    object oCaster   = OBJECT_SELF;  
    int nSpellID     = PRCGetSpellId();  
    int nMetaMagic   = PRCGetMetaMagicFeat();  
    int nCasterLvl   = PRCGetCasterLevel(oCaster);  
    int nPenetr      = nCasterLvl + SPGetPenetr();  
    int nEleDmg      = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);  
    int nDuration    = 7;  
    location lTarget = PRCGetSpellTargetLocation();  
  
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))  
        nDuration = 14;  
  
    effect eFX  = EffectVisualEffect(VFX_IMP_PULSE_WIND);  
    effect eDur = EffectVisualEffect(VFX_DUR_LIGHT_RED_10);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFX, lTarget);  
  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget,  
                                          TRUE, OBJECT_TYPE_CREATURE);  
    while (GetIsObjectValid(oTarget))  
    {  
        // Heat metal counters and dispels chill metal  
        if (GetHasSpellEffect(99999/* SPELL_CHILL_METAL */, oTarget))  
        {  
            PRCRemoveEffectsFromSpell(oTarget, 99999/* SPELL_CHILL_METAL */);  
        }  
        else if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)  
                 && PRCGetIsAliveCreature(oTarget))  
        {  
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);  
  
            if (!GetHasSpellEffect(nSpellID, oTarget)  
                && !PRCDoResistSpell(oCaster, oTarget, nPenetr))  
            {  
                int nDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);  
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC,  
                                      SAVING_THROW_TYPE_FIRE, oCaster))  
                {  
                    // Full damage only with metal armor (base AC >= 4,  
                    // chain shirt or heavier); otherwise minimum damage  
                    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);  
                    int bMinDamage = (GetArmorBaseAC(oArmor) < 4);  
  
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget,  
                                          RoundsToSeconds(nDuration), TRUE,  
                                          nSpellID, nCasterLvl);  
  
                    // Round 1 is "warm" (no damage); first tick is round 2  
                    DelayCommand(6.0f, RunImpact(oTarget, oCaster, nSpellID,  
                                                 nMetaMagic, 2, nDuration,  
                                                 bMinDamage, nEleDmg, nCasterLvl));  
                }  
            }  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget,  
                                      TRUE, OBJECT_TYPE_CREATURE);  
    }  
  
    PRCSetSchool();  
}  
  
void RunImpact(object oTarget, object oCaster, int nSpellID, int nMetaMagic,  
               int nRound, int nDuration, int bMinDamage, int nEleDmg, int nCasterLvl)  
{  
    // Check if the spell has expired (also strips tracking effects)  
    if (PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster))  
        return;  
  
    if (!PRCGetIsAliveCreature(oTarget))  
        return;  
  
    // Damage table: last round warm (none), round 2 & penultimate hot (1d4),  
    // middle rounds searing (2d4)  
    int nDice;  
    if (nRound == nDuration)  
        nDice = 0;  
    else if (nRound == 2 || nRound == nDuration - 1)  
        nDice = 1;  
    else  
        nDice = 2;  
  
    if (nDice > 0)  
    {  
        int nDamage;  
        if (bMinDamage)  
            nDamage = nDice;    // minimum: 1 or 2 points  
        else  
        {  
            nDamage = PRCGetMetaMagicDamage(nEleDmg, nDice, 4, 0, 0, nMetaMagic);  
            nDamage += SpellDamagePerDice(oCaster, nDice);  
        }  
  
        if (nDamage > 0)  
        {  
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                EffectVisualEffect(VFX_IMP_FLAME_S), oTarget);  
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                PRCEffectDamage(oTarget, nDamage, nEleDmg), oTarget);  
            PRCBonusDamage(oTarget);  
        }  
    }  
  
    if (nRound < nDuration)  
        DelayCommand(6.0f, RunImpact(oTarget, oCaster, nSpellID, nMetaMagic,  
                                     nRound + 1, nDuration, bMinDamage,  
                                     nEleDmg, nCasterLvl));  
}