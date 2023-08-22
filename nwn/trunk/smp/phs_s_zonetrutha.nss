/*:://////////////////////////////////////////////
//:: Spell Name Zone of Truth: On Enter
//:: Spell FileName PHS_S_ZoneTruthA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Invisible Zone of Truth;

    - DM run for NPC's.
    - DM's know all results of all saving throws. Displayed to DM's privatly.

    PC's must DIY, although the saves are made privatly and not against the
    enemy player at all.

    Instead, I have added a (placeable) object into the SMP area, tagged
    as "PHS_ZONE_OF_TRUTH" and thus use that to pass into the parameters, as
    well as the Resisting spell part (ok, not too good because SR might always
    suceed, but oh well).

    The main thing is the caster DOES NOT KNOW if the person has passed or failed
    in the saves or resistance checks. For personal spells, it is fine, for this,
    it is not.

    On Enter:
    - Do only 1 save for this AOE. The creatures ID is stored, thus its result
     (1 = pass, 2 = fail, 0 = not done a save) is already there.
    - Remember to use the object, not the caster, for the save object!
    - PvP Doesn't apply here.
    - NO VISUALS.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check creator
    if(PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    string sID = "PHS_ZOT_ID" + ObjectToString(oTarget);
    object oSelf = OBJECT_SELF;

    // Check if we have a result already!
    int nResult = GetLocalInt(oSelf, sID);

    // Hasn't been tested. First time entered.
    if(nResult == 0)
    {
        // Things we need.
        int nCasterLevel = PHS_GetAOECasterLevel();
        int nSpellSaveDC = PHS_GetAOESpellSaveDC();

        // Get the zone of truth object.
        object oTruth = GetObjectByTag("PHS_ZONE_OF_TRUTH");

        // We check spell resistance first
        if(!ResistSpell(oTruth, oTarget))
        {
            // Check will saving throw. Immunity included here!
            if(!WillSave(oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oTruth))
            {
                // Failed!
                nResult = 3;
            }
            else
            {
                // Saved!
                nResult = 2;
            }
        }
        else
        {
            // "Resisted"
            nResult = 1;
        }
    }

    // Check result and report.
    if(nResult == 1)
    {
        // Spell Resisted somehow.

        // Tell the player, and DM's, about the sucess or failure, and why.
        FloatingTextStringOnCreature("You feel as if you were about to be forced to tell the truth, but the Spell Was Resisted, and you can act normally.", oTarget, FALSE);
        // Make them speak a string to the DM channel so DM's can see it.
        SpeakString("Zone of Truth: Spell Resisted. Can lie as normal.", TALKVOLUME_SILENT_SHOUT);
    }
    else if(nResult == 2)
    {
        // Spell was saved against

        // Tell the player, and DM's, about the sucess or failure, and why.
        FloatingTextStringOnCreature("You feel as if you were about to be forced to tell the truth, but you resist the spell, and can act normally.", oTarget, FALSE);
        // Make them speak a string to the DM channel so DM's can see it.
        SpeakString("Zone of Truth: Spell Saved Against. Can lie as normal.", TALKVOLUME_SILENT_SHOUT);
    }
    else
    {
        // Spell failed. Must tell the truth.

        // Tell the player, and DM's, about the sucess or failure, and why.
        FloatingTextStringOnCreature("You are aware of a Zone of Truth, you are forced to tell the truth if you decide to answer questions.", oTarget, FALSE);
        // Make them speak a string to the DM channel so DM's can see it.
        SpeakString("Zone of Truth: Failed: Cannot lie (If they speak).", TALKVOLUME_SILENT_SHOUT);
    }

    // Save result.
    SetLocalInt(oSelf, sID, nResult);
}
