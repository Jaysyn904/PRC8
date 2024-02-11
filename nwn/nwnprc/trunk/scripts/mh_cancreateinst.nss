#include "prc_feat_const"

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_INSTRUMENT,GetPCSpeaker());
    return iResult;
}
