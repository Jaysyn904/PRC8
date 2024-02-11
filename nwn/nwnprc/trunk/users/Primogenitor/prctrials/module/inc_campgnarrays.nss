/*
    My own array functions, for storing integers and strings inside the campaign
    database. Taken straight from nw_o0_itemmaker, and changed to make it set
    campaign variables instead of Campaign ones.
*/

// * Array Functions

void SetCampaignArrayString(string sCampaignName, string sVarName, int nVarNum, string nValue);
string GetCampaignArrayString(string sCampaignName, string sVarName, int nVarNum);
void SetCampaignArrayInt(string sCampaignName, string sVarName, int nVarNum, int nValue);
int GetCampaignArrayInt(string sCampaignName, string sVarName, int nVarNum);

//Function bodies. See nw_o0_itemmaker for more info.

    string GetCampaignArrayString(string sCampaignName, string sVarName, int nVarNum)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        return GetCampaignString(sCampaignName, sFullVarName);
    }

    void SetCampaignArrayString(string sCampaignName, string sVarName, int nVarNum, string nValue)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        SetCampaignString(sCampaignName, sFullVarName, nValue);
    }

    int GetCampaignArrayInt(string sCampaignName, string sVarName, int nVarNum)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        return GetCampaignInt(sCampaignName, sFullVarName);
    }

    void SetCampaignArrayInt(string sCampaignName, string sVarName, int nVarNum, int nValue)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        SetCampaignInt(sCampaignName, sFullVarName, nValue);
    }
