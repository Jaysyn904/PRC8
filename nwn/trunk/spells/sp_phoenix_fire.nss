//::///////////////////////////////////////////////
//:: Name      Phoenix Fire
//:: FileName  sp_phoenix_fire.nss
//:://////////////////////////////////////////////
/** @file
Phoenix Fire
Necromancy [Fire, Good]
Level: Sanctified 7
Components: V,S,F,Sacrifice
Range: 15 feet
Area: 15 foot radius spread, centered on you
Duration: Instantaneous (see text)
Saving Throw: Reflex half (see text)
Spell Resistance: Yes (see text)

You immolate yourself, consuming your flesh in a
cloud of flame 20 feet high and 30 feet in diameter.
You die (no saving throw, and spell resistance does
not apply). Every evil creature within the cloud takes
2d6 points of damage per caster level (maximum 40d6).
Neutral characters take half damage (and a successful
Reflex save reduces that further in half), while good
characters take no damage at all. Half of the damage
dealt by the spell against any creature is fire; the
rest results directly from divine power and is 
therefore not subject to being reduced by resistance
to fire-based attacks, such as that granted by 
protection  from energy(fire), fire shield(chill 
shield), and similar magic.

After 10 minutes, you rise from the ashes as if restored
to life by a resurrection spell.

Sacrifice: Your death and the level you lose when you
return to life are the sacrifice cost for this spell.

*/
//  Author:   Tenjac
//  Created:  1/6/2006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


void Counter(object oPC, int nCounter);

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        //Define vars
        object oPC = OBJECT_SELF;
        location lLoc = GetLocation(oPC);   
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nDam;
        float fDur = TurnsToSeconds(10);
        
        //Immolate VFX on caster - VFX_IMP_HOLY_AID for casting VFX
        effect eFire = EffectVisualEffect(VFX_FNF_FIREBALL);
        effect eDivine = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
        
        DelayCommand(0.3f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oPC));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDivine, oPC);
        
        //VFX
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2), lLoc, fDur);             
        
        //"Kill" player
        effect eLink = EffectLinkEffects(EffectCutsceneParalyze(), EffectCutsceneGhost());
        eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), eLink);
        eLink = EffectLinkEffects(eLink, EffectEthereal());
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        Counter(oPC, 10);
        
        SetPlotFlag(oPC, TRUE);
        DelayCommand(fDur, SetPlotFlag(oPC, FALSE));
        DelayCommand(fDur, ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(GetMaxHitPoints(oPC), oPC), oPC));    
        
        //Get first object in shape
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        
        //While object valid
        while(GetIsObjectValid(oTarget))
        {
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
                {
                        int nDC = PRCGetSaveDC(oTarget, oPC);
                        
                        //If alignment evil
                        if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
                        {
                                //Damage = 2d6/level
                                nDam = d6(min(40, (2 * nCasterLvl)));
                                
                                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                                {                       
                                        nDam = 6 * (min(40, (2 * nCasterLvl)));
                                }
                                
                                if(nMetaMagic & METAMAGIC_EMPOWER)
                                {
                                        nDam += (nDam/2);
                                }
                                nDam += SpellDamagePerDice(oPC, min(40, (2 * nCasterLvl)));
                                //Reflex save for 1/2 damage
                                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_GOOD))
                                {
                                        nDam = nDam/2;
                                }
                                
                                //Half divine, half fire
                                int nDiv = nDam/2;
                                nDam = nDam - nDiv;
                                
                                //Apply damage
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDiv, DAMAGE_TYPE_DIVINE), oTarget);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FIRE), oTarget);            
                        }
                        
                        //If alignment neutral
                        else if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
                        {
                                //Half damage for neutrality, Damage = 1d6
                                nDam = d6(min(20,nCasterLvl));
                                
                                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                                {                       
                                        nDam = 6 * (min(20,nCasterLvl));
                                }
                                
                                if(nMetaMagic & METAMAGIC_EMPOWER)
                                {
                                        nDam += (nDam/2);
                                }
                                nDam += SpellDamagePerDice(oPC, min(20, nCasterLvl));
                                //Reflex for further 1/2
                                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_GOOD))
                                {
                                        nDam = nDam/2;
                                }
                                
                                //Half divine, half fire
                                int nDiv = nDam/2;
                                nDam = nDam - nDiv;
                                
                                //Apply damage
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDiv, DAMAGE_TYPE_DIVINE), oTarget);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FIRE), oTarget);            
                        }
                }
                //Get next object in shape
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, TRUE, OBJECT_TYPE_CREATURE);                
        }
        
        //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
        AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);
        
        PRCSetSchool();
        //SPGoodShift(oPC);
}

void Counter(object oPC, int nCounter)
{
        FloatingTextStringOnCreature("Phoenix Fire: "  + IntToString(nCounter) + " turns remaining until resurrection.", oPC);
        nCounter--;
        if(nCounter > 0) DelayCommand(TurnsToSeconds(1), Counter(oPC, nCounter));
}        