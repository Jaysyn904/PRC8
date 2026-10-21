//::////////////////////////////////////////////////////////
//::
/*	
	Wall of Force (sp_wallofforce.nss)
	Evocation [Force]
	Level: 				Sor/Wiz 5
	Components: 		V, S, M
	Casting time: 		1 action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Effect: 			Wall whose area is up to one 10-ft. 
						square/level or a sphere or hemisphere 
						with a radius of up to 1 ft./level
	Duration: 			1 minute/level (D)
	Saving Throw: 		None
	Spell Resistance: 	No
	
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	A wall of force spell creates an invisible wall of force.
	The wall of force cannot move, it is immune to damage of 
	all kinds, and it is totally unaffected by most spells, 
	including dispel magic. However, disintegrate immediately 
	destroys it, as does a rod of cancellation, a sphere of 
	annihilation, and disjunction. Spells and breath weapons 
	cannot pass through the wall in either direction, 
	although transportation spells and effects can bypass 
	the barrier. It blocks ethereal creatures as well as 
	material creatures (though ethereal creatures can 
	usually get around the wall by floating under or over 
	it through material floors and ceilings). Gaze attacks 
	can operate through the wall of force.

	The caster can form the wall into a flat, vertical plane 
	whose area is up to one 10-foot square per level, or 
	into a sphere or hemisphere with a radius of up to 1 
	foot per level.

	The wall of force must be continuous and unbroken when 
	formed. If its surface is broken by any object or 
	creature, the spell fails. 
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Spartan Hoplite (Gatecrashers)
//:: Date: 	2009/09/26
//::	
//:: Fixed by: Jaysyn
//:: Date: 2026-10-07 16:47:08
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);  
  
    // Spellcast hook  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    // ---- Declare major variables ----  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    int nMetaMagic   = PRCGetMetaMagicFeat();  
    location lTarget = PRCGetSpellTargetLocation();  
    location lCaster = GetLocation(oCaster);  
    object oArea     = GetArea(oCaster);  
    effect eVis      = EffectVisualEffect(VFX_IMP_DISPEL);  
    effect eGlow     = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE);  
  
    // PnP: 1 minute/level, dismissable; Extend doubles it.  
    float fDur = nCasterLevel * 60.0;  
    if (nMetaMagic & METAMAGIC_EXTEND)  
        fDur += fDur;  
  
    // ---- PnP: wall must be continuous and unbroken when  
    //      formed. If a creature or object occupies the  
    //      target point, the spell fails. ----  
    object oObstacle = GetFirstObjectInShape(SHAPE_SPHERE,  
        RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    if (GetIsObjectValid(oObstacle))  
    {  
        FloatingTextStringOnCreature(  
            "Wall of Force fails: the area is occupied.", oCaster, FALSE);  
        PRCSetSchool();  
        return;  
    }  
  
    // ---- Offset VFX locations (unchanged geometry) ----  
    float sep   = 1.0;  
    float lenCT = GetDistanceBetweenLocations(lCaster, lTarget);  
    float lenTX = sep;  
    float lenCX = sqrt(pow(lenCT, 2.0) + pow(lenTX, 2.0));  
    float angC  = asin(lenTX / lenCX);  
  
    vector c = GetPositionFromLocation(lCaster);  
    vector t = GetPositionFromLocation(lTarget);  
    float height = t.z;  
    float tx = t.x, ty = t.y;  
    float cx = c.x, cy = c.y;  
    float dx = ty - cy;  
    float dy = tx - cx;  
  
    float angle0 = asin(dx / lenCT);  
    float angle4 = 90.0 - angle0;  
    float addX = -sin(angle0) * lenTX;  
    float addY =  sin(angle4) * lenTX;  
    if (dy < 0.0) addX = -addX;  
  
    location lOff1 = Location(oArea, Vector(tx+addX,   ty+addY,   height), 0.0);  
    location lOff2 = Location(oArea, Vector(tx-addX,   ty-addY,   height), 0.0);  
    location lOff3 = Location(oArea, Vector(tx+addX*2, ty+addY*2, height), 0.0);  
    location lOff4 = Location(oArea, Vector(tx-addX*2, ty-addY*2, height), 0.0);  
    location lOff5 = Location(oArea, Vector(tx+addX*3, ty+addY*3, height), 0.0);  
    location lOff6 = Location(oArea, Vector(tx-addX*3, ty-addY*3, height), 0.0);  
  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);  
    DelayCommand(0.166, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff1));  
    DelayCommand(0.166, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff2));  
    DelayCommand(0.33,  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff3));  
    DelayCommand(0.33,  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff4));  
    DelayCommand(0.5,   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff5));  
    DelayCommand(0.5,   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOff6));  
  
    // ---- Create the wall ----  
    object oWall = CreateObject(OBJECT_TYPE_PLACEABLE, "spell_forcewall", lTarget);  
    if (GetIsObjectValid(oWall))  
    {  
        // Invisible per PnP; keep the faint glow so players  
        // can see where it is (comment out for true invisibility)  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlow, oWall, fDur);  
  
        // PnP: immune to damage of all kinds  
        SetPlotFlag(oWall, TRUE);  
  
        // Flag for disintegrate/disjunction-type scripts:  
        // they should DestroyObject() this despite the plot flag  
        SetLocalInt(oWall, "PRC_WALL_OF_FORCE", TRUE);  
        SetLocalObject(oWall, "PRC_WALL_CASTER", oCaster);  
  
        // PnP duration: 1 min/level  
        DestroyObject(oWall, fDur);  
    }  
  
    PRCSetSchool();  
}