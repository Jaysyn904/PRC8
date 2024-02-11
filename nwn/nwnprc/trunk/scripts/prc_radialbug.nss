//::///////////////////////////////////////////////
//:: Spellscript: Inform user of having triggered a BioBug
//:: prc_radialbug
//::///////////////////////////////////////////////
/**
    Sends a message to the user of whatever triggered
    this script being executed. It is assigned
    as the ImpactScript of subradial feat master
    entries. There is a bug where the game attempts
    to use the master entry instead of selected subradial.
    This script is meant to inform the user of the fact
    and of the workaround.

    @author Ornedan
    @date   Created - 2006.05.14
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
    SendMessageToPCByStrRef(OBJECT_SELF, 16825845);
    //You just stumbled across a BioBug. Attempting to use this feat/power/spell when you open the radial on your character does not work.
    //Workarounds: Either place it on your quickbar or just open the radial on whatever you intend to target. Note that the latter option will obviously not work if you need to target yourself.
}