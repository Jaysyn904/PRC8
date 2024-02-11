#include "tetris_inc"
void main()
{
    object oPC = GetLastPCToCancelCutscene();
    object oArea = GetArea(oPC);
    if(GetIsObjectValid(oArea))
    {
        if(GetLocalObject(oArea, "Tetris_Player") == oPC)
        {
            //end cutscene
            AssignCommand(oArea, Tetris_EndGame(oPC, oArea, FALSE));
        }
    }

}
