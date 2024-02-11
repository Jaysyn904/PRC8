//::///////////////////////////////////////////////
//:: Name      Despoil
//:: FileName  sp_despoil.nss
//:://////////////////////////////////////////////
/**@file Despoil
Transmutation [Evil] 
Level: Clr 9 
Components: V, S, M 
Casting Time: 1 minute 
Range: Touch
Area: 100-ft./level radius 
Duration: Instantaneous 
Saving Throw: Fortitude partial (plants) or Fortitude negates (other living creatures) 
Spell Resistance: Yes

The caster blights and corrupts a vast area of land.
Plants with 1 HD or less shrivel and die, and the 
ground cannot support such plant life ever again. 
Plants with more than 1 HD must succeed at a 
Fortitude saving throw or die. Even those successful
on their saves take 5d6 points of damage. All living
creatures in the area other than plants (and the 
caster) must succeed at a Fortitude saving throw 
or take 1d4 points of Strength damage.

Unattended objects, including structural features 
such as walls and doors, grow brittle and lose 1 
point of hardness (to a minimum of 0), then take 
1d6 points of damage.

Only the effects of multiple wish or miracle spells 
can undo the lasting effects of this spell.

Material Component: Corpse of a freshly dead or 
preserved (still bloody) living creature.

Author:    Tenjac
Created:   6/12/06
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
    int nCasterLevel = PRCGetCasterLevel(oPC);
    location lLoc = PRCGetSpellTargetLocation();
    
    //VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HORRID_WILTING), lLoc); 
        
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, (10.0f * nCasterLevel), lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    
    while(GetIsObjectValid(oTarget))
    {
        //Spell resistance
        if(!PRCDoResistSpell(oPC, oTarget, nCasterLevel + SPGetPenetr()))
        {    
            int nType = GetObjectType(oTarget);
            int nRace = MyPRCGetRacialType(oTarget);
            int nDC = PRCGetSaveDC(oTarget, oPC);
            
            if(nType == OBJECT_TYPE_CREATURE)
            {
                /*if(nRace == RACIAL_TYPE_PLANT)
                {
                    //Check HD
                    if(GetHitDice(oTarget) == 1)
                    {
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    }
                    else
                    {
                        //Save
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        {
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        }
                        
                        else
                        {
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, d6(5), DAMAGE_TYPE_MAGICAL), oTarget);
                        }
                    }
                }*/
                
                //nonliving
                if(!PRCGetIsAliveCreature(oTarget))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, 1.0f);
                }
                
                //living
                else
                {
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                    {
                        ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d4(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
                    }
                }
            }
            if(nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE)
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, d6(1), DAMAGE_TYPE_MAGICAL), oTarget);
            }
        }
        
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, (10.0f * nCasterLevel), lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    
    //SPEvilShift(oPC);
    PRCSetSchool();
}