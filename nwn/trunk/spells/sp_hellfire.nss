//::///////////////////////////////////////////////
//:: Name      Hellfire
//:: FileName  sp_hellfire.nss
//:://////////////////////////////////////////////
/**@file Hellfire
Evocation [Evil] 
Level: Diabolic 4
Components: V, S 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 5-ft.-radius spread 
Duration: Instantaneous
Saving Throw: None 
Spell Resistance: Yes

The caster creates a small explosion of brimstone 
and fire that deals 3d6 points of special diabolic
fire damage. The diabolic flames are not subject
to being reduced by protection from elements 
(fire), fire shield (chill shield), or similar 
magic.

Author:    Tenjac
Created:   05/03/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"


void main()
{
        object oPC = OBJECT_SELF;
        location lLoc = PRCGetSpellTargetLocation();
        effect eVis = EffectVisualEffect(806);
        effect eExplode = EffectVisualEffect(VFX_FNF_HELLFIRE); 
        effect eDam;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDamage;
        int nMetaMagic = PRCGetMetaMagicFeat();
        float fDelay;
        
        //Spellhook
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
                
        //Apply the fireball explosion at the location captured above.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lLoc);
        
        //get initial oTarget
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        
        //damage loop
        while(GetIsObjectValid(oTarget))
        {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                        {
                                //Roll damage for each target
                                nDamage = d6(3);
                                
                                //Resolve metamagic
                                if (nMetaMagic & METAMAGIC_MAXIMIZE)
                                {
                                        nDamage = 18;
                                }
                                if (nMetaMagic & METAMAGIC_EMPOWER)
                                {
                                        nDamage = nDamage + nDamage / 2;
                                }
                                nDamage += SpellDamagePerDice(oPC, 3);
                                //Set the damage effect
                                eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_DIVINE);
                                
                                // Apply effects to the currently selected target.
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
        
        //SPEvilShift(oPC);
        PRCSetSchool();
}