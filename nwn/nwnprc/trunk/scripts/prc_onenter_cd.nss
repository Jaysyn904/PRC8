#include "x2_inc_switches"
#include "prc_inc_switch"
#include "inc_sql"
#include "inc_debug"

int VerifyPlayernameAgainstCDKey(object oPlayer)
{
    int nBoot = FALSE;
    string sPName = GetStringLowerCase(GetPCPlayerName(oPlayer));
    string sKey = GetPCPublicCDKey(oPlayer);

DoDebug("Running CD-check... Player name = "+sPName+" key = "+sKey);

    if(GetPRCSwitch(PRC_USE_DATABASE))
    {
        DoDebug("Using MySQL or SQLite");
        
        string sPlayer = ReplaceSingleChars(sPName, "'","~");
        string sStoredKey, sAddingKey;
        string sSQL = "SELECT val, tag FROM pwdata WHERE name='PlayernameKey_" + sPlayer + "'";
        PRC_SQLExecDirect(sSQL);

        /* there's at least one key stored already */
        if (PRC_SQLFetch() == PRC_SQL_SUCCESS) {
            sStoredKey = PRC_SQLGetData(1);
            sAddingKey = PRC_SQLGetData(2);

            /* they indicated that they wanted to add a key this login */
            if (sAddingKey == "Adding") {
            DoDebug("Adding new key to database");

                /* their current key is not in the key string, add it unless at 7 keys already */
                if (FindSubString(sStoredKey, sKey) == -1) {
                    int nKeyLength = GetStringLength(sStoredKey);

                    /* allow 7 keys max key-key-key-key-key-key-key    6 spacers + 7x8 keys = 62 */
                    if (nKeyLength > 61) {
                        nBoot = TRUE;

                        /* must mark as no longer adding */
                        sSQL = "UPDATE pwdata SET tag='Set' WHERE name='PlayernameKey_" + sPlayer + "'";
                        PRC_SQLExecDirect(sSQL);

                        /* add the key to the string */
                    } else {
                        sSQL =
                            "UPDATE pwdata SET tag='Set',val='" + sStoredKey + "-" + sKey + "' WHERE name='PlayernameKey_" + sPlayer +
                            "'";
                        PRC_SQLExecDirect(sSQL);
                        DelayCommand(25.0, FloatingTextStringOnCreature("New CD Key Successfully Added!", oPlayer, FALSE));
                    }

                    /* let them know they already had this key in their string */
                } else {
                    DelayCommand(25.0,
                        FloatingTextStringOnCreature("CD Key Addition Failed! This key already listed for this account!", oPlayer,
                            FALSE));

                    /* must mark as no longer adding */
                    sSQL = "UPDATE pwdata SET tag='Set' WHERE name='PlayernameKey_" + sPlayer + "'";
                    PRC_SQLExecDirect(sSQL);
                }

                /* they are not adding, and the cd key doesnt match those listed - boot and log */
            } else if (FindSubString(sStoredKey, sKey) == -1) {
                string sReport = "INCORRECT CD KEY DETECTED! ID: " + sPName + "; Name: " +
                    GetName(oPlayer) + "; CD Key: " + sKey + "; IP: " + GetPCIPAddress(oPlayer) ;
    
                WriteTimestampedLogEntry(sReport);
                SendMessageToAllDMs(sReport);
    
                nBoot = TRUE;
            DoDebug("Error - key doesn't match - BOOT PLAYER");

            }
        /* new account, add the key */
        } else {
            sSQL = "INSERT INTO pwdata (val,name) VALUES" + "('" + sKey + "','PlayernameKey_" + sPlayer + "')";
            PRC_SQLExecDirect(sSQL);
        DoDebug("Player cd key added to database");


        }
    }
    else
    {
        DoDebug("Using Bioware database");

        string sNewKey, sAddingKey, sStoredKey = GetCampaignString("PlayernameKey", sPName);
    
        /* there's at least one key stored already */
    
        if (sStoredKey != "") {
            sAddingKey = GetStringLeft(sStoredKey, 3);
            sStoredKey = GetStringRight(sStoredKey, GetStringLength(sStoredKey) - 3);
    
            /* they indicated that they wanted to add a key this login */
    
            if (sAddingKey == "ADD") {
            DoDebug("Adding new key to database");
                /* their current key is not in the key string, add it unless at 7 keys already */
                if (FindSubString(sStoredKey, sKey) == -1) {
                    int nKeyLength = GetStringLength(sStoredKey);
    
                    /* allow 7 keys max SET-key-key-key-key-key-key-key   SET/ADD + 7 spacers + 7x8 keys = 66 */
                    if (nKeyLength > 65) {
                        nBoot = TRUE;
    
                        /* must mark as no longer adding */
                        SetCampaignString("PlayernameKey", sPName, "SET" + sStoredKey);
    
                        /* add the key to the string */
                    } else {
                        sNewKey = "SET" + sStoredKey  + "-" + sKey;
                        SetCampaignString("PlayernameKey", sPName, sNewKey);
                        DelayCommand(25.0, FloatingTextStringOnCreature("New CD Key Successfully Added!", oPlayer, FALSE));
                    }
    
                    /* let them know they already had this key in their string */
                } else {
                    DelayCommand(25.0,
                        FloatingTextStringOnCreature("CD Key Addition Failed! This key already listed for this account!", oPlayer,
                            FALSE));
    
                    /* must mark as no longer adding */
                    SetCampaignString("PlayernameKey", sPName, "SET" + sStoredKey);
                }

                /* they are not adding, and the cd key doesnt match those listed - boot and log */
            } else if (FindSubString(sStoredKey, sKey) == -1) {
                string sReport = "INCORRECT CD KEY DETECTED! ID: " + sPName + "; Name: " +
                    GetName(oPlayer) + "; CD Key: " + sKey + "; IP: " + GetPCIPAddress(oPlayer);
    
                WriteTimestampedLogEntry(sReport);
                SendMessageToAllDMs(sReport);
                nBoot = TRUE;
            DoDebug("Error - key doesn't match - BOOT PLAYER");

            }
        /* new account, add the key */
        } else {
            DoDebug("Player cd key added to database");
            SetCampaignString("PlayernameKey", sPName, "SET-" + sKey);
        }
    }
    return nBoot;
}

void main()
{
    object oPC=OBJECT_SELF;
    if(VerifyPlayernameAgainstCDKey(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        if (GetIsObjectValid(oPC))
            BootPC(oPC);
    }
}