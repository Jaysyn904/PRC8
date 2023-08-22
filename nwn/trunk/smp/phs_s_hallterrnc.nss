/*:://////////////////////////////////////////////
//:: Spell Name Hallucinatory Terrain: On Heartbeat (AOE)
//:: Spell FileName PHS_S_HallTerrnC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It has a special (hidden!) Will Save for this spell, when they enter in the
    area and stay in for a cirtain number of rounds.

    Choose the terrain from a preset list. Bioware's "tilemagic" is what is used,
    IE the visual effect is a terrain piece.

    The AOE is placed via. the use of a placeable, which also has the correct
    visual applied to it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    object oSelf = OBJECT_SELF;
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    string sName = "PHS_HALL";
    int nTurnsIn, nWill, nRoll;

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // Won't bother checking for people who know its an illusion
        if(!GetFactionEqual(oTarget, oCaster))
        {
            // We store a local variable on us until they are in the AOE for a
            // while.
            nTurnsIn = PHS_IncreaseStoredInteger(oSelf, sName + ObjectToString(oTarget));

            // Need to have been in for an amount of rounds which is
            // 5 - nWill/5. Once we are, great!
            nWill = GetWillSavingThrow(oTarget);
            if(5 - (nWill/5) >= nTurnsIn)
            {
                nRoll = d20();
                // We will do a will save
                if((nRoll + nWill >= nSpellSaveDC || nRoll == 20) &&
                   (nRoll != 1))
                {
                    // Fire cast spell at event for the affected target
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HALLUCINATORY_TERRAIN);

                    // We tell them
                    FloatingTextStringOnCreature("*You see the terrain around you is an illusion*", oTarget, FALSE);
                }
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
