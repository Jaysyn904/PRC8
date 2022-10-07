//:://////////////////////////////////////////////
//:: FileName: "activate_seeds"
/*   Purpose: This is the script that gets called by the OnItemActivated event
        when the item is one of the Epic Spell Seed books.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    if(DEBUG) DoDebug("activate_seeds executing");

    object oPC = OBJECT_SELF;
    object oBook = GetItemActivated();
    int nSeed = GetSeedFromAbrev(GetTag(oBook));
    //int nFE = GetFeatForSeed(nSeed);
    //int nIP = GetIPForSeed(nSeed);

    // Give the seed if the player is able to comprehend it, doesn't already
    // have it, and is allowed to learn it.
    if(GetCanLearnSeed(oPC, nSeed))
    {
        if(!GetHasEpicSeedKnown(nSeed, oPC))
        {
            int nDC = GetDCForSeed(nSeed);
            if (GetSpellcraftSkill(oPC) >= nDC)
            {
                if (PLAY_SPELLSEED_CUT == TRUE)
                    ExecuteScript(SPELLSEEDS_CUT, oPC);
                SetEpicSeedKnown(nSeed, oPC, TRUE);
                SendMessageToPC(oPC, MES_LEARN_SEED);
                DoBookDecay(oBook, oPC);
            }
            else
            {
                SendMessageToPC(oPC, GetName(oPC) + " " + MES_NOT_ENOUGH_SKILL);
                SendMessageToPC(oPC, "You need a spellcraft skill of " +
                    IntToString(nDC) + " or greater.");
            }
        }
        else
        {
            SendMessageToPC(oPC, MES_KNOW_SEED);
        }
    }
    else
    {
        SendMessageToPC(oPC, MES_CLASS_NOT_ALLOWED);
    }
}
