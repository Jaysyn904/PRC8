//::////////////////////////////////////////////////////////
//::
/*	
	Sandblast	(sp_sandblast.nss)
	Evocation
	Level: 				Druid 1,
	Components: 		V, S, DF,
	Casting Time: 		1 standard action
	Range: 				10 ft.
	Area: 				10-ft.-radius burst centered on you
	Duration: 			Instantaneous
	Saving Throw: 		Reflex half
	Spell Resistance: 	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	Whipping your hand in a wide arc, you spray sand from 
	your fingers in a powerful blast.

	Creatures in the area take 1d6 points of nonlethal 
	damage. Any creature that fails its Reflex save is also 
	stunned for 1 round. You are not harmed by the spell.
	
	PnP mechanics:  
	- 1d6 nonlethal damage to all creatures in the burst.  
	  NWN has no nonlethal damage -> bludgeoning.  
	- Failed Reflex save: also stunned 1 round.  
	- Caster is unharmed (excluded from shape). 	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 18:04:45
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_add_spell_dc"
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);  
  
    object oCaster = OBJECT_SELF;  
    int nCasterLvl = PRCGetCasterLevel(oCaster);  
    int nPenetr    = nCasterLvl + SPGetPenetr();  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nSpellID   = PRCGetSpellId();  
  
    // Flat 1d6 — no caster-level scaling per PnP  
    int nDam = PRCMaximizeOrEmpower(6, 1, nMetaMagic);  
    nDam    += SpellDamagePerDice(oCaster, 1);  
  
    effect eVis  = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);  
    effect eStun = EffectStunned();  

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oCaster));  
  
    // 10-ft radius burst centered on the caster  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0),  
                         GetLocation(oCaster), TRUE, OBJECT_TYPE_CREATURE);  
  
    while (GetIsObjectValid(oTarget))  
    {  
        // Caster is unharmed; normal hostile targeting  
        if (oTarget != oCaster &&  
            spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))  
        {  
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);  
  
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))  
            {  
                int nDC    = PRCGetSaveDC(oTarget, oCaster);  
                int bSaved = PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget,  
                                              nDC, SAVING_THROW_TYPE_SPELL,  
                                              oCaster);  
  
                // Reflex half damage  
                int nFinal = bSaved ? nDam / 2 : nDam;  
  
                if (nFinal > 0)  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                        PRCEffectDamage(oTarget, nFinal,  
                            DAMAGE_TYPE_BLUDGEONING),  
                        oTarget, 0.0f, FALSE, nSpellID, nCasterLvl, oCaster);  
  
                // Failed save: stunned for 1 round  
                if (!bSaved)  
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun,  
                        oTarget, RoundsToSeconds(1), FALSE,  
                        nSpellID, nCasterLvl, oCaster);  
            }  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0),  
                      GetLocation(oCaster), TRUE, OBJECT_TYPE_CREATURE);  
    }  
  
    PRCSetSchool();  
}