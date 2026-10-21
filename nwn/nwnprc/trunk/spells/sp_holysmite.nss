//::////////////////////////////////////////////////////////
//::
/*	
	Holy Smite (sp_holysmite.nss)
	Evocation [Good]
	Level: 				Knight of the Chalice 4, Good 4, Glory 4
	Components: 		V, S,
	Casting Time: 		1 standard action
	Range: 				Medium (100 ft. + 10 ft./level)
	Area: 				20-ft.-radius burst
	Duration: 			Instantaneous (1 round); see text
	Saving Throw: 		Will partial; see text
	Spell Resistance: 	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	You draw down holy power to smite your enemies.
	Only evil and neutral creatures are harmed by the spell; 
	good creatures are unaffected.
	The spell deals 1d8 points of damage per two caster levels 
	(maximum 5d8) to each evil creature in the area (or 1d6 
	points of damage per caster level, maximum 10d6, to an 
	evil outsider) and causes it to become blinded for 1 
	round.

	A successful Will saving throw reduces damage to half and 
	negates the blinded effect.
	The spell deals only half damage to creatures who are 
	neither good nor evil, and they are not blinded.
	Such a creature can reduce that damage by half (down to 
	one-quarter of the roll) with a successful Will save 
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Spartan Hoplite
//:: Date: 	???
//:: I completely yanked the damage code out of this and 
//:: redid it all to exactly replicate Holy Smite ala PNP.  
//:: Why it wasn't done this way to begin with I
//:: really don't know.
//::	
//:: PRC'd by: Jaysyn
//:: Date: 2026-10-07 22:34:28
//::
//::////////////////////////////////////////////////////////

#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
  
void main()  
{  
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    object oCaster    = OBJECT_SELF;  
    location lTarget  = PRCGetSpellTargetLocation();  
    int nCasterLvl    = PRCMin(PRCGetCasterLevel(oCaster), 10);   
    int nDice         = nCasterLvl / 2;                            
    int nMetaMagic    = PRCGetMetaMagicFeat();  
    int nPenetr       = nCasterLvl + SPGetPenetr();  
    float fDur        = RoundsToSeconds(1);                       
    effect eVis       = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);  
  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_FNF_WORD), lTarget);  
  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE,  
        RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    while (GetIsObjectValid(oTarget))  
    {  
        int nAlign = GetAlignmentGoodEvil(oTarget);  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)  
            && nAlign != ALIGNMENT_GOOD)  
        {  
            PRCSignalSpellEvent(oTarget, TRUE);  
            float fDelay = PRCGetRandomDelay(0.75, 1.0);  
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))  
            {  
                // Outsider dice use full CL; others use CL/2  
                int bOutsider = MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER  
                                && nAlign == ALIGNMENT_EVIL;  
                int nDam = bOutsider ? d6(nCasterLvl) : d8(nDice);  
  
                if (nMetaMagic & METAMAGIC_MAXIMIZE)  
                    nDam = bOutsider ? 6 * nCasterLvl : 8 * nDice;  
                else if (nMetaMagic & METAMAGIC_EMPOWER)  
                    nDam += nDam / 2;  
                nDam += SpellDamagePerDice(oCaster, bOutsider ? nCasterLvl : nDice);  
  
                // Neutral creatures take half before the save  
                if (nAlign == ALIGNMENT_NEUTRAL)  
                    nDam /= 2;  
  
                // Will partial: half damage, negate blind  
                if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget,  
                        PRCGetSaveDC(oTarget, oCaster),  
                        SAVING_THROW_TYPE_DIVINE, oCaster, fDelay))  
                {  
                    nDam /= 2;  
                }  
                else if (nAlign == ALIGNMENT_EVIL)  
                {  
                    DelayCommand(fDelay, SPApplyEffectToObject(  
                        DURATION_TYPE_TEMPORARY, EffectBlindness(),  
                        oTarget, fDur));  
                }  
  
                if (nDam > 0)  
                {  
                    DelayCommand(fDelay, SPApplyEffectToObject(  
                        DURATION_TYPE_INSTANT,  
                        PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE),  
                        oTarget));  
                }  
                DelayCommand(fDelay, SPApplyEffectToObject(  
                    DURATION_TYPE_INSTANT, eVis, oTarget));  
            }  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE,  
            RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    }  
    PRCSetSchool();  
}
