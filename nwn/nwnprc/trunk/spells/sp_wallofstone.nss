//::////////////////////////////////////////////////////////
//::
/*	
	Wall of Stone (sp_wallofstone.nss)
	Conjuration (Creation)
	Level: 				Clr 5, Drd 6, Earth 5, Sor/Wiz 5
	Components: 		V, S, M/DF
	Casting time: 		1 action
	Range: 				Medium (100 ft. + 10 ft./level)
	Effect: 			Stone wall whose area is up to one 
						5-ft. square/level (S)
	Duration: 			Instantaneous
	Saving Throw: 		See text
	Spell Resistance: 	No
	
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	This spell creates a wall of rock that merges into 
	adjoining rock surfaces. The wall of stone is 1 inch 
	thick per four caster levels and composed of up to one 
	5-foot square per level. The character can double the 
	wall's area by halving its thickness. The wall cannot be 
	conjured so that it occupies the same space as a creature 
	or another object.

	The character can create a wall of stone in almost any 
	shape the character desires. The wall created need not be 
	vertical, nor rest upon any firm foundation; however, it
	must merge with and be solidly supported by existing stone. 
	It can be used to bridge a chasm, for instance, or as a 
	ramp. For this use, if the span is more than 20 feet, the 
	wall must be arched and buttressed. This requirement 
	reduces the spell's area by half. The wall can be 
	crudely shaped to allow crenellations, battlements, and 
	so forth by likewise reducing the area.

	Each 5-foot square has 15 hit points per inch of 
	thickness. Creatures can hit the wall automatically, 
	but the wall is so hard that the first 8 points of 
	damage from each blow are ignored. A section of wall 
	whose hit points drop to 0 is breached. If a creature 
	tries to break through the wall with a single attack, 
	the DC for the Strength check is 20 + 2 per inch of 
	thickness.

	It is possible, but difficult, to trap mobile opponents 
	within or under a wall of stone, provided the wall is 
	shaped so it can hold the creatures. Creatures avoid 
	entrapment with successful Reflex saves. 
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Spartan Hoplite (Gatecrashers)
//:: Date: 	2009/09/26
//::	
//:: Fixed by: Jaysyn
//:: Date: 2026-10-07 16:06:12
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
#include "inc_nwnx_funcs"  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));  
  
    // Spellcast hook  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    // ---- Declare major variables ----  
    int nCasterLevel   = PRCGetCasterLevel(oCaster);  
    location lTarget   = PRCGetSpellTargetLocation();  
    location lCaster   = GetLocation(oCaster);  
    effect eVis        = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM);  
    object oArea       = GetArea(oCaster);  
  
    // PnP: 1 inch thick per 4 caster levels (min 1 inch)  
    int nInches = nCasterLevel / 4;  
    if (nInches < 1) nInches = 1;  
  
    // PnP: 15 HP per inch of thickness  
    int nWallHP = nInches * 15;  
  
    // PnP: Str check DC 20 + 2 per inch to burst through  
    int nStrDC = 20 + (2 * nInches);  
  
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
  
    // ---- Tileset-specific wall appearance ----  
    string wall = "spell_stonewall";  
    string ts = GetTilesetResRef(oArea);  
    if (ts == TILESET_RESREF_CASTLE_INTERIOR || ts == "tni01" || ts == "tni02" ||  
        ts == "ct1" || ts == "tzs01" || ts == "gi" || ts == "thv01" || ts == "vwz01")  
        wall += "4"; // White wall  
    else if (ts == TILESET_RESREF_CRYPT || ts == TILESET_RESREF_DESERT ||  
             ts == TILESET_RESREF_RUINS || ts == "tdg07" || ts == "ttz01")  
        wall += "3"; // Desert wall  
    else if (ts == TILESET_RESREF_SEWERS || ts == TILESET_RESREF_FOREST ||  
             ts == "tbw01" || ts == "tdd01" || ts == "dls10" || ts == "dls11" ||  
             ts == "ttm01" || ts == "gg" || ts == "tdt01" || ts == "ttf01" ||  
             ts == "ttf02" || ts == "tw003")  
        wall += "2"; // Swamp wall  
    else if (ts == "fir01")  
        wall += "5"; // Lava wall  
    else if (ts == "tsl02" || ts == "tsf02")  
        wall += "6"; // Shadow wall  
    else if (ts == "az2" || ts == "twc03")  
        wall += "7"; // Beigy wall  
    else if (ts == "tdcic" || ts == "tti01" || ts == "tts01" || ts == "tpms1")  
        wall += "8"; // Snowy wall  
    else  
        wall += "1"; // Standard wall  
  
    // ---- Create the wall (permanent per PnP) ----  
    object oWall = CreateObject(OBJECT_TYPE_PLACEABLE, wall, lTarget);  
    if (GetIsObjectValid(oWall))  
    {  
        // Shadow-plane variant gets the shadow VFX  
        if (wall == "spell_stonewall6")  
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,  
                EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), oWall);  
  
        // Lava walls are weaker and erode quickly on the Fire Plane  
        int nHP = nWallHP;  
        if (wall == "spell_stonewall5")  
        {  
            nHP = nInches * 8;  
            DestroyObject(oWall, 4.0 * nCasterLevel);  
        }  
  
        // Set the wall's current HP directly to the PnP value.  
        // Delayed so it lands after the placeable finishes spawning,  
        // same pattern as the image HP in sp_mirror.nss.  
        DelayCommand(0.1, PRC_Funcs_SetCurrentHitPoints(oWall, nHP));  
  
        // Store PnP stats on the wall for its OnDamaged /  
        // break-through scripts to reference  
        SetLocalInt(oWall, "PRC_STONEWALL_STRDC",    nStrDC);  
        SetLocalInt(oWall, "PRC_STONEWALL_HARDNESS", 8);  
        SetLocalInt(oWall, "PRC_STONEWALL_INCHES",   nInches);  
    }  
  
    // ---- Entrapment: Reflex save or be pinned by the rising wall ----  
    int nDC = PRCGetSaveDC(oCaster, oCaster);  
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,  
        RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    while (GetIsObjectValid(oTarget))  
    {  
        if (oTarget != oCaster &&  
            spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))  
        {  
            SignalEvent(oTarget, EventSpellCastAt(oCaster, PRCGetSpellId()));  
            if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))  
            {  
                effect eHold = EffectLinkEffects(  
                    EffectParalyze(),  
                    EffectVisualEffect(VFX_DUR_STONEHOLD));  
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                    ExtraordinaryEffect(EffectKnockdown()), oTarget, 3.0, FALSE);  
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                    ExtraordinaryEffect(eHold), oTarget, 3.0, FALSE);  
            }  
        }  
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,  
            RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    }  
  
    PRCSetSchool();  
}
