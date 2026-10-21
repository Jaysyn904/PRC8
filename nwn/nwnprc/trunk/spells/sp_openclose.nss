//::////////////////////////////////////////////////////////
//::
/*	
	Open/Close	(sp_openclose.nss)
	Transmutation
	Level: 				Brd 0, Sor/Wiz 0
	Components: 		V, S, F
	Casting time: 		1 action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Target: 			Portal or object that can be opened 
						or closed
	Duration: 			Instantaneous
	Saving Throw: 		Will negates (object)
	Spell Resistance: 	Yes (object)	
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	The character can open or close (caster's choice) a 
	door, chest, box, window, bag, pouch, bottle, or other 
	container. If anything resists this activity the spell 
	fails. In addition, the spell can only open and close 
	things that are of standard weight. 
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Fractal
//:: Date: 	One late uneventful night, Nov 2005
//::	
//:: Fixed by: Jaysyn
//:: Date: 2026-10-07 16:47:08
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    //:: Spellcast hook  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    //:: Declare major variables  
    object oTarget = PRCGetSpellTargetObject();  
    int nType      = GetObjectType(oTarget);

    //:: Item targets = craft-scroll hooking; let the hook  
    //:: handle it and exit without complaint.  
    if (nType == OBJECT_TYPE_ITEM)  
    {  
        PRCSetSchool();  
        return;  
    }	
  
    //:: Only doors and placeables are valid targets.  
    if (nType != OBJECT_TYPE_DOOR && nType != OBJECT_TYPE_PLACEABLE)  
    {  
        FloatingTextStringOnCreature(  
            "You can only target a door or container.", oCaster, FALSE);  
        PRCSetSchool();  
        return;  
    }  
  
    //:: Non-hostile signal event  
    PRCSignalSpellEvent(oTarget, FALSE, PRCGetSpellId(), oCaster);  
  
    //:: PnP: if anything resists, the spell fails  
    if (GetLocked(oTarget) || GetPlotFlag(oTarget))  
    {  
        FloatingTextStringOnCreature(  
            GetLocked(oTarget) ? "*Locked.*" : "*It does not budge.*",  
            oCaster, FALSE);  
        PRCSetSchool();  
        return;  
    }  
  
    //:: Doors  
    if (nType == OBJECT_TYPE_DOOR)  
    {  
        if (GetIsOpen(oTarget))  
            AssignCommand(oTarget, ActionCloseDoor(oTarget));  
        else  
            AssignCommand(oTarget, ActionOpenDoor(oTarget));  
    }  
    //:: Placeables (chests, boxes, bags, etc.)  
    else  
    {  
        if (GetIsOpen(oTarget))  
            AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));  
        else if (GetHasInventory(oTarget))  
            AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_OPEN));  
        else  
			//:: Non-container placeables (levers, windows, etc.)  
            AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));  
    }  
  
    PRCSetSchool();  
}