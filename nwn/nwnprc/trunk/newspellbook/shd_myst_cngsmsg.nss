/*
13/02/19 by Stratovarius

Congress of Shadows, Listener Script

Apprentice, Ebon Whispers 
Level/School: 2nd/Divination [Mind-Affecting] 
Range: 1 mile/level
Target: One living creature whose exact location is known to you, or one living creature you know well whose approximate location (within 100 ft.) is known to you 
Duration: Instantaneous 
Saving Throw: None 
Spell Resistance: None

You look toward your shadow and speak a few words knowing that some distance away, a subject hears them and might reply.

You speak, and your words appear in the mind of a distant creature. The message can consist of up to five words, plus one additional word per caster level. 
It cannot deliver command words for magic items, or in any other respect function as anything but normal speech. If the subject is where you believe it to be, 
the message is delivered. The subject recognizes the identity of the sender of the message if it knows you. The creature can then reply, using the same number 
of words that you used. The message cannot cross planar boundaries.
*/

#include "prc_inc_listener"

void main()
{
    object oShadow = GetLastSpeaker();
    string sMsg    = GetMatchedSubstring(1);
    
    object oPartyMem = GetFirstFactionMember(oShadow, TRUE);
    while (GetIsObjectValid(oPartyMem)) 
    {
        FloatingTextStringOnCreature(sMsg, oPartyMem, FALSE);
        FloatingTextStringOnCreature("You may speak and respond", oPartyMem, FALSE);
        if (!GetLocalInt(oPartyMem, "CongressShadows")) // If they haven't heard the message before
        {
            object oListener = SpawnListener("shd_myst_cngsmsg", GetLocation(oPartyMem), "**", oPartyMem, 15.0f, FALSE);
            SetLocalInt(oPartyMem, "CongressShadows", TRUE);
            DelayCommand(60.0, DeleteLocalInt(oPartyMem, "CongressShadows"));
        }    
        
        oPartyMem = GetNextFactionMember(oShadow, TRUE); 
    }    
}