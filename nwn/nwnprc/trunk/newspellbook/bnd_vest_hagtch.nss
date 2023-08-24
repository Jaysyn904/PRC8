/*
1/03/21 by Stratovarius

Haagenti, Mother of Minotaurs
  
Haagenti tricked the god of frost giants and paid a terrible price for that deed. She girds her summoners for battle and gives them the power to confuse foes.

Granted Abilities: 
Haagenti grants you some of Thrym’s skill with arms and armor, plus her own aversion to transformation and the ability to inflict a state of confusion upon others.

Confusing Touch: You can confuse by touch. The target of your touch attack must succeed on a Will save or become confused for 1 round per three effective binder 
levels you possess. When you attain an effective binder level of 19th, this ability functions as a maze spell. Once you have used this ability, 
you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_sp_tch"
#include "spinc_maze"

void main()
{
	object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
	int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_HAAGENTI);
	int nDC = GetBinderDC(oBinder, VESTIGE_HAAGENTI);
	if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_HAAGENTI)) return;
    int nAttack = PRCDoMeleeTouchAttack(oTarget);;

    // PvP check.
    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oBinder))
    {    
    	if (nAttack > 0)
    	{
			if(nBinderLevel >= 19)
			{
      			// Get the maze area
        		object oMazeArea = GetObjectByTag("prc_maze_01");
		
        		if(DEBUG && !GetIsObjectValid(oMazeArea))
        		    DoDebug("Maze: ERROR: Cannot find maze area!", oBinder);
	
        		// Determine which entry to use
        		int nMaxEntry = GetLocalInt(oMazeArea, "PRC_Maze_Entries_Count");
        		int nEntry = Random(nMaxEntry) + 1;
        		object oEntryWP = GetWaypointByTag("PRC_MAZE_ENTRY_WP_" + IntToString(nEntry));
        		location lTarget = GetLocation(oEntryWP);
	
        		// Validity check
        		if(DEBUG && !GetIsObjectValid(oEntryWP))
        		    DoDebug("Maze: ERROR: Selected waypoint does not exist!");
		
        		// Make sure the target can be teleported
        		if(GetCanTeleport(oTarget, lTarget, TRUE))
        		{
        		    // Store the target's current location for return
        		    SetLocalLocation(oTarget, "PRC_Maze_Return_Location", GetLocation(oTarget));
		
        		    // Jump the target to the maze - the maze's scripts will handle the rest
        		    DelayCommand(1.5f, AssignCommand(oTarget, JumpToLocation(lTarget)));

        		    // Clear the action queue, so there's less chance of getting to abuse the ghost effect
        		    AssignCommand(oTarget, ClearAllActions());

        		    // Make the character ghost for the duration of the maze. Apply here so the effect gets a spellID association
        		    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oTarget, 600.0f);

        		    // Apply some VFX
        		    DoMazeVFX(GetLocation(oTarget));
        		}
        		else
        		    SendMessageToPCByStrRef(oBinder, 16825702); // "The spell fails - the target cannot be teleported."			
			}
			else
           	{
				if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
				{           	
           			float fDur = RoundsToSeconds(nBinderLevel / 3);
	        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(PRCEffectConfused()), oTarget, fDur);
	        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE)), oTarget, fDur);
	        	}	
           	}	
        }
    }
}