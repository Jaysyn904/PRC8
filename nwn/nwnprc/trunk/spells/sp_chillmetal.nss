//::////////////////////////////////////////////////////////
//::
/*	Chill Metal (sp_chillmetal.nss)
	Transmutation [Cold]
	Level: 				Drd 2
	Components: 		V, S, DF
	Casting time: 		1 standard action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Target: 			Metal equipment of one creature per 
						two levels, no two of which can be 
						more than 30 ft. apart; or 25 lb. of 
						metal/level, none of which can be 
						more than 30 ft. away from any of the 
						rest
	Duration: 			7 rounds
	Saving Throw: 		Will negates (object)
	Spell Resistance: 	Yes (object)
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 
	Chill metal makes metal extremely cold. Unattended, 
	nonmagical metal gets no saving throw. Magical metal is 
	allowed a saving throw against the spell. An item in a 
	creature’s possession uses the creature’s saving throw 
	bonus unless its own is higher.

	A creature takes cold damage if its equipment is chilled. 
	It takes full damage if its armor is affected or if it 
	is holding, touching, wearing, or carrying metal weighing 
	one-fifth of its weight. The creature takes minimum damage 
	(1 point or 2 points; see the table) if it’s not wearing 
	metal armor and the metal that it’s carrying weighs less 
	than one-fifth of its weight.

	On the first round of the spell, the metal becomes 
	chilly and uncomfortable to touch but deals no damage.
	The same effect also occurs on the last round of the 
	spell’s duration. During the second (and also the next-
	to-last) round, icy coldness causes pain and damage. In 
	the third, fourth, and fifth rounds, the metal is 
	freezing cold, causing more damage, as shown on the 
	table below.
	
	Round 	Metal Temp.	Damage
	1 		Cold		None
	2 		Icy 		1d4 points
	3–5 	Freezing 	2d4 points
	6 		Icy 		1d4 points
	7 		Cold 		None

	Any heat intense enough to damage the creature negates 
	cold damage from the spell (and vice versa) on a 
	point-for-point basis. Underwater, chill metal deals no 
	damage, but ice immediately forms around the affected 
	metal, making it more buoyant.

	Chill metal counters and dispels heat metal. 
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Spartan Hoplite (Gatecrashers)
//:: Date: 	2009/09/26
//::	
//:: Fixed by: Jaysyn
//:: Date: 2026-10-07 15:12:18
//::
/*
	Lots of parts of this lifted from the Inferno spell 
	script: x0_s0_inferno
*/
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "x2_inc_spellhook"  
  
void RunImpact(object oTarget, object oCaster, int nMetaMagic, int nRound, int nMaxRounds, int bFullDamage, int nEleDmg);  
  
//:: Returns the base AC of the armor in the chest slot (0 if none)  
int GetBaseArmorAC(object oTarget)  
{  
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);  
    if (!GetIsObjectValid(oArmor)) return 0;  
  
    int nAC = GetItemACValue(oArmor);  
  
    //:: Subtract enhancement AC from ITEM_PROPERTY_AC_BONUS  
    itemproperty prop = GetFirstItemProperty(oArmor);  
    while (GetIsItemPropertyValid(prop))  
    {  
        if (GetItemPropertyType(prop) == ITEM_PROPERTY_AC_BONUS)  
            nAC -= GetItemPropertyCostTableValue(prop);  
        prop = GetNextItemProperty(oArmor);  
    }  
    return nAC;  
}  
  
void main()  
{  
    //--------------------------------------------------------------------------  
    // Spellcast Hook Code  
    //--------------------------------------------------------------------------  
    if (!X2PreSpellCastCode())  
        return;  
  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    object oCaster = OBJECT_SELF;  
    location lTarget = PRCGetSpellTargetLocation();  
    int nSpellID = PRCGetSpellId();  
  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nCasterLvl = PRCGetCasterLevel(oCaster);  
    int nPenetr = nCasterLvl + SPGetPenetr();  
    int nEleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_COLD);  
  
    int nDuration = 7;  
    if (nMetaMagic & METAMAGIC_EXTEND)  
        nDuration *= 2;  
  
    effect eDur = EffectVisualEffect(VFX_DUR_LIGHT_BLUE_10);  
    effect eFX  = EffectVisualEffect(VFX_IMP_PULSE_WIND);  
  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oCaster);  
  
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    while (GetIsObjectValid(oTarget))  
    {  
        //:: Chill Metal counters/dispels Heat Metal  
        if (GetHasSpellEffect(88888/* SPELL_HEAT_METAL */, oTarget))  
        {  
            PRCRemoveSpellEffects(88888/* SPELL_HEAT_METAL */, oCaster, oTarget);  
        }  
        else if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))  
        {  
            SignalEvent(oTarget, EventSpellCastAt(oCaster, 99999/* SPELL_CHILL_METAL */));  
  
            float fDelay = PRCGetRandomDelay();  
  
            //:: SR check  
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))  
            {  
                //:: Not already affected by Chill Metal  
                if (!GetHasSpellEffect(99999/* SPELL_CHILL_METAL */, oTarget))  
                {  
                    //:: Will save (object) - creature's armor must be metal (base AC >= 4)  
                    int bFullDamage = (GetBaseArmorAC(oTarget) >= 4);  
  
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_COLD, oCaster, fDelay))  
                    {  
						SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));  
						DelayCommand(fDelay, RunImpact(oTarget, oCaster, nMetaMagic, 1, nDuration, bFullDamage, nEleDmg));  
                    }  
                }  
            }  
        }  
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    }  
}  
  
void RunImpact(object oTarget, object oCaster, int nMetaMagic, int nRound, int nMaxRounds, int bFullDamage, int nEleDmg)  
{  
    //--------------------------------------------------------------------------  
    // Check if the spell has expired (check also removes effects)  
    //--------------------------------------------------------------------------  
    if (PRCGetDelayedSpellEffectsExpired(99999/* SPELL_CHILL_METAL */, oTarget, oCaster))  
        return;  
  
    if (!GetIsDead(oTarget))  
    {  
        //----------------------------------------------------------------------  
        // PnP damage table mirrored around the midpoint, per DoAgitateMetal:  
        //   Round 1 & last round        - Cold,     no damage  
        //   Round 2 & next-to-last      - Icy,      1d4  
        //   All rounds in between       - Freezing, 2d4  
        //----------------------------------------------------------------------  
        int nDice;  
        if (nRound == 1 || nRound == nMaxRounds)  
            nDice = 0;                                    // Cold  
        else if (nRound == 2 || nRound == nMaxRounds - 1)  
            nDice = 1;                                    // Icy  
        else  
            nDice = 2;                                    // Freezing  
  
        if (nDice > 0)  
        {  
            int nDamage;  
            if (bFullDamage)  
                nDamage = PRCMaximizeOrEmpower(4, nDice, nMetaMagic);  
            else  
                nDamage = nDice;                          // Minimum damage (1 or 2 pts)  
  
            nDamage += SpellDamagePerDice(oCaster, nDice);  
  
            effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);  
            effect eDam = PRCEffectDamage(oTarget, nDamage, nEleDmg);  
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(eVis, eDam), oTarget);  
        }  
  
        if (nRound < nMaxRounds)  
            DelayCommand(6.0f, RunImpact(oTarget, oCaster, nMetaMagic, nRound + 1, nMaxRounds, bFullDamage, nEleDmg));  
    }  
}