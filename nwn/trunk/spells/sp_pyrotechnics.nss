//::///////////////////////////////////////////////
//:: Name      Pyrotechnics
//:: FileName  sp_pyrotechnics.nss
//:://////////////////////////////////////////////
/**@file Pyrotechnics
Transmutation
Level: Brd 2, Sor/Wiz 2 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Target: One fire source, up to a 20-ft. cube 
Duration: 1d4+1 rounds, or 1d4+1 rounds after 
creatures leave the smoke cloud; see text 
Saving Throw: Will negates or Fortitude negates; see text 
Spell Resistance: Yes or No; see text

Pyrotechnics turns a fire into either a burst of 
blinding fireworks or a thick cloud of choking smoke,
depending on the version you choose.

Fireworks: The fireworks are a flashing, fiery, 
momentary burst of glowing, colored aerial lights. 
This effect causes creatures within 120 feet of the 
fire source to become blinded for 1d4+1 rounds 
(Will negates). These creatures must have line of 
sight to the fire to be affected. Spell resistance 
can prevent blindness.

Smoke Cloud: A writhing stream of smoke billows out 
from the source, forming a choking cloud. The cloud
spreads 20 feet in all directions and lasts for 1 
round per caster level. All sight, even darkvision,
is ineffective in or through the cloud. All within 
the cloud take -4 penalties to Strength and Dexterity
(Fortitude negates). These effects last for 1d4+1 rounds 
after the cloud dissipates or after the creature leaves 
the area of the cloud. Spell resistance does not apply.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget;
        location lLoc = PRCGetSpellTargetLocation();
        float fDur = RoundsToSeconds(d4(1) + 1);
        int nSpell = GetSpellId();
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = PRCGetSaveDC(oTarget, oPC);
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        //Fireworks
        if(nSpell == SPELL_PYROTECHNICS_FIREWORKS)
        {
                effect eVis = EffectVisualEffect(VFX_FNF_PYRO_FIREWORKS_REDORANGE);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
                
                oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(120.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
                
                while(GetIsObjectValid(oTarget))
                {
                        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                        {
                                //Will save
                                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                                {
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, fDur, TRUE, SPELL_PYROTECHNICS_FIREWORKS, nCasterLvl);
                                }
                        }
                        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(120.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
                }                
        }        
        //Smoke
        if(nSpell == SPELL_PYROTECHNICS_SMOKE)
        {
                fDur = RoundsToSeconds(nCasterLvl);
                if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;

                effect eAoE = EffectAreaOfEffect(AOE_PER_PYROTECHNICS_SMOKE);
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lLoc, fDur);
        }        
        PRCSetSchool();
}