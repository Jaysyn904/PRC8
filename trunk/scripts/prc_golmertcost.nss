#include "prc_alterations"
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nCost;
    int nGolemType = GetLocalInt(oPC, "GolemType");
    int nGolemHD   = GetLocalInt(oPC, "GolemHD");
    switch(nGolemType)
    {
        case 0://flesh
            switch(nGolemHD)
            {
                case 10: nCost =  20000; break;
                case 15: nCost =  45000; break;
                case 20: nCost = 120000; break;
                case 25: nCost = 145000; break;
                default: nCost =    -1; break;
            }
            break;
        case 1://clay
            switch(nGolemHD)
            {
                case 12: nCost =  40000; break;
                case 17: nCost =  65000; break;
                case 22: nCost = 140000; break;
                case 27: nCost = 165000; break;
                case 32: nCost = 190000; break;
                default: nCost =    -1; break;
            }
            break;
        case 2://stone
            switch(nGolemHD)
            {
                case 15: nCost =  90000; break;
                case 20: nCost = 115000; break;
                case 25: nCost = 190000; break;
                case 30: nCost = 215000; break;
                case 35: nCost = 240000; break;
                case 40: nCost = 265000; break;
                default: nCost =    -1; break;
            }
            break;
        case 3://iron
            switch(nGolemHD)
            {
                case 19: nCost = 150000; break;
                case 24: nCost = 175000; break;
                case 29: nCost = 250000; break;
                case 34: nCost = 275000; break;
                case 39: nCost = 300000; break;
                case 44: nCost = 325000; break;
                case 49: nCost = 350000; break;
                case 54: nCost = 375000; break;
                default: nCost =    -1; break;
            }
            break;
        case 4://mithril
            switch(nGolemHD)
            {
                case 37: nCost = 250000; break;
                case 42: nCost = 275000; break;
                case 47: nCost = 300000; break;
                case 52: nCost = 325000; break;
                case 57: nCost = 400000; break;
                case 62: nCost = 425000; break;
                case 67: nCost = 450000; break;
                case 72: nCost = 475000; break;
                default: nCost =    -1; break;
            }
            break;
        case 5://adamantium
            switch(nGolemHD)
            {
                case 55: nCost = 500000; break;
                case 60: nCost = 525000; break;
                case 65: nCost = 550000; break;
                case 70: nCost = 575000; break;
                case 75: nCost = 600000; break;
                case 80: nCost = 625000; break;
                default: nCost =    -1; break;
            }
            break;
    }
    if(!GetHasGPToSpend(oPC, nCost)
        || nCost == -1)
        return TRUE;//show the cant afford it message
    return FALSE;//allow the player to buy it
}
