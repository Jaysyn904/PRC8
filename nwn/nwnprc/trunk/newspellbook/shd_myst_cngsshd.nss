/*
13/02/19 by Stratovarius

Congress of Shadows

Apprentice, Ebon Whispers 
Level/School: 2nd/Divination [Mind-Affecting] 
Range: Infinite
Target: Your party
Duration: Instantaneous 
Saving Throw: None 
Spell Resistance: None

You look toward your shadow and speak a few words knowing that some distance away, a subject hears them and might reply.

You speak, and your words appear in the mind of your party. The members can then reply.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_listener"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        if (!GetLocalInt(oShadow, "CongressShadows")) // If they haven't heard the message before
        {
            object oListener = SpawnListener("shd_myst_cngsmsg", GetLocation(oShadow), "**", oShadow, 15.0f, FALSE);
            SetLocalInt(oShadow, "CongressShadows", TRUE);
            DelayCommand(60.0, DeleteLocalInt(oShadow, "CongressShadows"));
        } 
    }
}