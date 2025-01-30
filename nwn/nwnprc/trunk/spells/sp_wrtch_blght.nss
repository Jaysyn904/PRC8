//::///////////////////////////////////////////////
//:: Name      Wretched Blight
//:: FileName  sp_wrtch_blght.nss
//:://////////////////////////////////////////////
/**@file Wretched Blight 
Evocation [Evil]
Level: Clr 7
Components: V, S 
Casting Time: 1 action 
Range: Medium (100 ft. + 10 ft./level)
Area: 20-ft.-radius spread
Duration: Instantaneous
Saving Throw: Fortitude partial (see text)
Spell Resistance: Yes 

The caster calls up unholy power to smite his enemies.
The power takes the form of a soul chilling mass of 
clawing darkness. Only good and neutral (not evil)
creatures are harmed by the spell.

The spell deals 1d8 pts of damage per caster level 
(maximum 15d8) to good creatures and renders them 
stunned for 1d4 rounds. A successful Fortitude save
reduces damage to half and negates the stunning effect.

The spell deals only half damage to creatures that
are neither evil nor good, and they are not stunned.
Such creatures can reduce the damage in half again 
(down to one­quarter of the roll) with a successful
Reflex save.

Author:    Tenjac
Created:   5/9/06
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
    location lLoc = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDice = PRCMin(nCasterLvl, 15);
    int nAlign;
    int nDam;
    int nDC;
    nCasterLvl += SPGetPenetr();
    effect eVis = EffectVisualEffect(VFX_DUR_DARKNESS);
    effect eDam;

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);

    //apply VFX
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lLoc, 3.0f);

    while(GetIsObjectValid(oTarget)){
        nAlign = GetAlignmentGoodEvil(oTarget);
        if(nAlign != ALIGNMENT_EVIL){
            //SR
            if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl)){
                nDam = d8(nDice);

                //Metmagic: Maximize
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDam = 8 * nDice;

                //Metmagic: Empower
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDam += (nDam/2);

                // 1/2 damage for neutral targets
                if(nAlign == ALIGNMENT_NEUTRAL)
                    nDam = nDam/2;
				nDam += SpellDamagePerDice(oPC, nDice);
                nDC = PRCGetSaveDC(oTarget, oPC);

                //Save for 1/2 dam
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL)){
                    //This script does nothing if it has Mettle, bail
                    if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                        continue;
                    nDam = nDam/2;
                }
                else if(nAlign == ALIGNMENT_GOOD){
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(d4(1)));
                }

                //Apply Damage
                eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
    //SPEvilShift(oPC);

    PRCSetSchool();
}