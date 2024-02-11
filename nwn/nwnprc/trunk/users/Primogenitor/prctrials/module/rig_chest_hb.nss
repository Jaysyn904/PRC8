#include "rig_inc"

void DoStuff()
{
    int nBaseItemType = GetLocalInt(OBJECT_SELF, "BaseItem");
    int nMax = RIG_GetCacheSize(nBaseItemType);    
    int i;
    int nLevel = 1;
    int nCount = nMax; //lowest number of items of nLevel level
    for(i=1;i<=40;i++)
    {
        int nItemCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(i));
        if(nItemCount < nCount)   
        {
            nLevel = i;
            nCount = nItemCount;
        }
        //shortcut if totally out of something cant get lower
        if(nCount == 0)
            break;    
    }
    
    if(nCount < nMax)
    {
        DoDebug(GetTag(OBJECT_SELF)+" creating level "+IntToString(nLevel)+". Cache at "+IntToString(nCount));
        int nAC = GetLocalInt(OBJECT_SELF, "AC");
        float fDelay = 0.01; 
        DelayCommand(fDelay, CreateRandomizeItemByType(nBaseItemType, nLevel, nAC));
        return;
    }
    //at this point, cache must be full
    if(GetLocalInt(GetModule(), "RIG_Doing_Setup"))
        SetLocalInt(GetModule(), "RIG_Doing_Setup", GetLocalInt(GetModule(), "RIG_Doing_Setup")-1);    
}

void main()
{
    //since there are ~70 of these, only 10% will fire on average each hb
    //in the first minute of a module, do a lot of these to setup the cache quickly
    //since we want to cache at least 70x40 = 2100 items
    if(Random(10) 
        && !GetLocalInt(GetModule(), "RIG_Doing_Setup"))
        return;
    //in the rapid-setup period, do this once a second
    if(GetLocalInt(GetModule(), "RIG_Doing_Setup"))
    {
        float fDelay;
        for(fDelay = 0.0; fDelay < 6.0; fDelay += 1.0)
        {
            DelayCommand(fDelay, DoStuff());
        }    
        return;
    }    
    //delay the firing to some time in the next 6 seconds
    float fDelay = IntToFloat(Random(60))/10.0;
    DelayCommand(fDelay, DoStuff());
}
