//::///////////////////////////////////////////////
//:: Name      Diamond Spray
//:: FileName  sp_dmnd_spray
//:://////////////////////////////////////////////
/**@file Diamond Spray 
Evocation [Good] 
Level: Sanctified 4 
Components: V, S, M 
Casting Time: 1 standard action 
Range: 60 ft.
Area: Cone-shaped burst 
Duration: Instantaneous 
Saving Throw: Reflex half 
Spell Resistance: Yes

A blast of diamond-like shards springs from your 
hand and extends outward in a glittering cone. The
cone dazzles evil creatures in the area for 2d6 
rounds. The spell also deals 1d6 points of damage
per caster level (maximum 10d6). The damage 
affects only evil creatures. A successful Reflex 
save reduces the damage by half but does not 
negate the dazzling effect.

Material Component: Diamond dust worth at least 100 gp.

Author:    Tenjac
Created:   6/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC;
        int nMetaMagic = PRCGetMetaMagicFeat();
        location lLoc = PRCGetSpellTargetLocation();       
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        float fDur = RoundsToSeconds(d6(2));
                
        //make sure it's not the PC
        if(oTarget == oPC)
        {
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        }
        
        while(GetIsObjectValid(oTarget))
        {               
                if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                {
                        int nDam = d6(PRCMin(nCasterLvl,10));
                        
                        if(nMetaMagic & METAMAGIC_MAXIMIZE)
                        {
                                nDam = 6 * (PRCMin(nCasterLvl, 10));
                        }
                        if(nMetaMagic & METAMAGIC_EMPOWER)
                        {
                                nDam += (nDam/2);
                        }
                        if(nMetaMagic & METAMAGIC_EXTEND)
                        {
                                fDur += fDur;
                        }
                        nDam += SpellDamagePerDice(oPC, PRCMin(nCasterLvl, 10));
                        if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
                        {
                                nDC = PRCGetSaveDC(oTarget, oPC); 
                                
                                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
                                {
                                        nDam = nDam/2;
                                }
                                
                                //Apply appropriate damage
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
                                
                                //Dazzled = -1 to Attack, Spot, and search
                                effect eDazzle = EffectLinkEffects(EffectDazzle(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
                                
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, fDur);
                        }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        }
        
        //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
        AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);
        
        //SPGoodShift(oPC);
        PRCSetSchool();
}