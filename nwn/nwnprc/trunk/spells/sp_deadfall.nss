//::////////////////////////////////////////////////////////
//::
/*
	Deadfall	(sp_deadfall.nss)
	Conjuration (Creation)
	Level: 				Druid 8,
	Components: 		V, S,
	Casting Time: 		1 standard action
	Range: Long 		(400 ft. + 40 ft./level)
	Effect: 			Mass of dead wood forming in a 
						cylinder (20-ft. radius, 40 ft. 
						high); see text
	Duration: 			Instantaneous; see text
	Saving Throw: 		Reflex partial; see text
	Spell Resistance:	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	With the final word of the spell you call into being a 
	huge tower of logs and branches. It collapses to the 
	ground with a roar, crushing creatures beneath its weight.

	Pick a point on the ground as the center of the radius 
	and bottom of the cylinder. Deadfall creates a tangled 
	mass of huge branches, logs, and fallen trees on the 
	ground. The deadfall immediately collapses in on itself 
	with terrific force and noise. Creatures and objects 
	in the area take 1d6 points of damage per caster level 
	(maximum 20d6). In addition, creatures in the area must 
	succed on a Reflex save or be knocked prone.

	Once you cast the spell, a considerable volume of dead 
	wood remains behind. This pile of brush is 5 feet high, 
	with a 20 foot radius, and it counts as dense rubble 
	(DMG 90) 

	PnP notes:  
	- 1d6 bludgeoning/CL (max 20d6) to all in the cylinder.  
	- Reflex save or knocked prone (partial; dmg is NOT halved).  
	- Leaves a 5-ft-high, 20-ft-radius pile of dense rubble.  
	  DMG 90 dense rubble = difficult terrain; approximated  
	  with a persistent AoE or left as visual debris.  
	- VFX: ring of dead-tree placeables scaled ~40 ft tall,  
	  then shrunk/lowered to a brush pile.  
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-09 23:05:28
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
  
const float DEADFALL_RADIUS   = 6.10f;   // ~20 ft  
const float DEADFALL_HEIGHT   = 12.2f;   // ~40 ft  
const int   DEADFALL_TREES    = 8;  
  
void CollapseTower(location lCenter)  
{  
    object oTree = GetFirstObjectInShape(SHAPE_SPHERE, DEADFALL_RADIUS + 2.0f,  
                                         lCenter, FALSE, OBJECT_TYPE_PLACEABLE);  
    while (GetIsObjectValid(oTree))  
    {  
        if (GetLocalInt(oTree, "PRC_DEADFULL_TREE"))  
        {  
            // Sink + squash to sell the collapse  
            SetObjectVisualTransform(oTree, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, -2.0f);  
            SetObjectVisualTransform(oTree, OBJECT_VISUAL_TRANSFORM_SCALE, 0.4f);  
            DestroyObject(oTree, 2.5f);  
        }  
        oTree = GetNextObjectInShape(SHAPE_SPHERE, DEADFALL_RADIUS + 2.0f,  
                                     lCenter, FALSE, OBJECT_TYPE_PLACEABLE);  
    }  
}  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
  
    object   oCaster     = OBJECT_SELF;  
    location lTarget     = PRCGetSpellTargetLocation();  
    int      nCasterLvl  = PRCGetCasterLevel(oCaster);  
    int      nMetaMagic  = PRCGetMetaMagicFeat();  
    int      nSpellID    = PRCGetSpellId();  
    int      nDice       = PRCMin(20, nCasterLvl);  
  
    //:: Tower of trees 
    float fStep   = 360.0f / IntToFloat(DEADFALL_TREES);  
    float fAngle  = 0.0f;  
    int   i;  
    for (i = 0; i < DEADFALL_TREES; i++)  
    {  
        vector vPos = GetPositionFromLocation(lTarget);  
        vPos.x += DEADFALL_RADIUS * 0.6f * cos(fAngle);  
        vPos.y += DEADFALL_RADIUS * 0.6f * sin(fAngle);  
        location lTree = Location(GetAreaFromLocation(lTarget), vPos, fAngle + 90.0f);  
  
        object oTree = CreateObject(OBJECT_TYPE_PLACEABLE, "x0_deadtree", lTree, FALSE);  
        if (GetIsObjectValid(oTree))  
        {  
            SetLocalInt(oTree, "PRC_DEADFALL_TREE", TRUE);  
            SetPlotFlag(oTree, TRUE);  
            // Stretch each tree to ~40 ft  
            SetObjectVisualTransform(oTree, OBJECT_VISUAL_TRANSFORM_SCALE, 3.0f);  
        }  
        fAngle += fStep;  
    }  
  
    //:: Impact shake + dust at the center  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_FNF_SCREEN_SHAKE2), lTarget);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), lTarget);  
  
    //:: Collapse the tower after it registers visually  
    DelayCommand(1.5f, CollapseTower(lTarget));  
  
    //:: Damage + prone
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, DEADFALL_RADIUS, lTarget,  
                                          TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
    while (GetIsObjectValid(oTarget))  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)  
            || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)  
        {  
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));  
  
            int nDamage = PRCMaximizeOrEmpower(6, nDice, nMetaMagic);  
            nDamage += SpellDamagePerDice(oCaster, nDice);  
  
            // NO save vs damage — full damage to everything in the cylinder  
            if (nDamage > 0)  
            {  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                    PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING), oTarget);  
                PRCBonusDamage(oTarget);  
            }  
  
            // Reflex save only negates the knockdown  
            if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget,  
                                  PRCGetSaveDC(oTarget, oCaster)))  
            {  
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                    EffectKnockdown(), oTarget, 6.0f);  
            }  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, DEADFALL_RADIUS, lTarget,  
                                      TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
    }  
  
    PRCSetSchool();  
}