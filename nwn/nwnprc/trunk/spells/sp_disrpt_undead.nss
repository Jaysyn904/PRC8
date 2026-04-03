//::///////////////////////////////////////////////
//:: Name      Disrupt Undead/Greater Disrupt Undead
//:: FileName  sp_disrpt_undead.nss
//:://////////////////////////////////////////////
/**@file Disrupt Undead
Necromancy
Level:  Sor/Wiz 0
Components:     V, S
Casting Time:   1 standard action
Range:  Close (25 ft. + 5 ft./2 levels)
Effect:         Ray
Duration:       Instantaneous
Saving Throw:   None
Spell Resistance:       Yes

You direct a ray of positive energy. You must make a 
ranged touch attack to hit, and if the ray hits an 
undead creature, it deals 1d6 points of damage to it.

Greater Disrupt Undead
Necromancy
Level: Sorcerer/wizard 3
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Effect: Ray
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

You must succeed on a ranged touch attack with the ray
to strike a target. This spell functions like disrupt
undead (PH 223), except that this ray deals 1d8 points
of damage per caster level to any undead, to a maximum
of 10d8. If the damage is sufficient to destroy the 
first target, then you can redirect the ray to another
undead target within 15 feet of the first target. If 
you make a successful ranged touch attack on the second
target, that target takes half of the damage rolled for
the first target.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"  
#include "prc_sp_func"  
  
int DoSpell(object oCaster, object oTarget, int nCasterLevel)  
{  
    int nSpell = GetSpellId();  
    int nBeam;  
    int nDam;  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nTouch = PRCDoRangedTouchAttack(oTarget);  
    int nType = MyPRCGetRacialType(oTarget);  
  
    if(nSpell == SPELL_DISRUPT_UNDEAD)  
    {  
        nBeam = VFX_BEAM_HOLY;  
        nDam = d6(1);  
        nDam += SpellDamagePerDice(oCaster, 1);  
        if(nMetaMagic & METAMAGIC_MAXIMIZE) nDam = 6;  
    }  
      
    if(nSpell == SPELL_GREATER_DISRUPT_UNDEAD)  
    {  
        nBeam = VFX_BEAM_BLACK;  
        nDam = d6(3);  
        nDam += SpellDamagePerDice(oCaster, 3);  
        if(nMetaMagic & METAMAGIC_MAXIMIZE) nDam = 18;  
    }  
      
    if(nMetaMagic & METAMAGIC_EMPOWER) nDam += (nDam/2);  
      
    //Beam that acts accordingly  
    effect eVis = EffectBeam(nBeam, oCaster, BODY_NODE_HAND, !nTouch);  
      
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
      
    if(nTouch)  
    {  
        if(nType == RACIAL_TYPE_UNDEAD  
        || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))  
        {  
            if(!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))  
            {  
                if(nSpell == SPELL_GREATER_DISRUPT_UNDEAD)  
                {  
                    //Get hp before damage  
                    int nHP = GetCurrentHitPoints(oTarget);  
                      
                    //Apply Damage  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_POSITIVE), oTarget);  
                      
                    //if enough to kill target, bounce  
                    if(nDam >= nHP)  
                    {  
                        location lLoc = GetLocation(oTarget);  
                        object oTarget2 = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE);  
                          
                        while(GetIsObjectValid(oTarget2))  
                        {  
                            //Undead, enemy, and not the original target  
                            if((GetRacialType(oTarget2) == RACIAL_TYPE_UNDEAD || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget2) && GetAlignmentGoodEvil(oTarget2) != ALIGNMENT_GOOD)  
                            && GetIsEnemy(oTarget2, oCaster) && (oTarget != oTarget2)))  
                            {  
                                //Black beam, origin chest of previous target  
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectBeam(VFX_BEAM_BLACK, oTarget, BODY_NODE_CHEST), oTarget2);  
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam/2, DAMAGE_TYPE_POSITIVE), oTarget2);  
                                break;  
                            }  
                              
                            oTarget2 = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE);  
                        }  
                    }  
                }  
                else SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_POSITIVE), oTarget);  
            }  
        }  
    }  
      
    return nTouch; // return TRUE if spell charges should be decremented  
}  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);  
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags  
    if(!nEvent) //normal cast  
    {  
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)  
        {   //holding the charge, casting spell on self  
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges  
            return;  
        }  
        DoSpell(oCaster, oTarget, nCasterLevel);  
    }  
    else  
    {  
        if(nEvent & PRC_SPELL_EVENT_ATTACK)  
        {  
            if(DoSpell(oCaster, oTarget, nCasterLevel))  
                DecrementSpellCharges(oCaster);  
        }  
    }  
    PRCSetSchool();  
}

/* #include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpell = PRCGetSpellId();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nBeam;
    int nDam;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    int nType = MyPRCGetRacialType(oTarget);

    if(nSpell == SPELL_DISRUPT_UNDEAD)
    {
        nBeam = VFX_BEAM_HOLY;
        nDam = d6(1);
        nDam += SpellDamagePerDice(oPC, 1);
        if(nMetaMagic & METAMAGIC_MAXIMIZE) nDam = 6;
    }
    
    if(nSpell == SPELL_GREATER_DISRUPT_UNDEAD)
    {
        nBeam = VFX_BEAM_BLACK;
        nDam = d6(3);
        nDam += SpellDamagePerDice(oPC, 3);
        if(nMetaMagic & METAMAGIC_MAXIMIZE) nDam = 18;
    }
    
    if(nMetaMagic & METAMAGIC_EMPOWER) nDam += (nDam/2);
    
    //Beam that acts accordingly
    effect eVis = EffectBeam(nBeam, oPC, BODY_NODE_HAND, !nTouch);
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    
    if(nTouch)
    {
        if(nType == RACIAL_TYPE_UNDEAD
        || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
        {
            if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
            {
                if(nSpell == SPELL_GREATER_DISRUPT_UNDEAD)
                {
                    //Get hp before damage
                    int nHP = GetCurrentHitPoints(oTarget);
                    
                    //Apply Damage
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_POSITIVE), oTarget);
                    
                    //if enough to kill target, bounce
                    if(nDam >= nHP)
                    {
                        location lLoc = GetLocation(oTarget);
                        object oTarget2 = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE);
                        
                        while(GetIsObjectValid(oTarget2))
                        {
                            //Undead, enemy, and not the original target
                            if((GetRacialType(oTarget2) == RACIAL_TYPE_UNDEAD || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget2) && GetAlignmentGoodEvil(oTarget2) != ALIGNMENT_GOOD)
                            && GetIsEnemy(oTarget2, oPC) && (oTarget != oTarget2)))
                            {
                                //Black beam, origin chest of previous target
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectBeam(VFX_BEAM_BLACK, oTarget, BODY_NODE_CHEST), oTarget2);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam/2, DAMAGE_TYPE_POSITIVE), oTarget2);
                                break;
                            }
                            
                            oTarget2 = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE);
                        }
                    }
                }
                else SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_POSITIVE), oTarget);
            }
        }
    }
    PRCSetSchool();
} */