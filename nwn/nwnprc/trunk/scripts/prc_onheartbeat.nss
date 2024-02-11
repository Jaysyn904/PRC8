//::///////////////////////////////////////////////
//:: OnHeartbeat eventscript
//:: prc_onheartbeat
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_leadersh"

void main()
{
    // Item creation code
    ExecuteScript("hd_o0_heartbeat", OBJECT_SELF);

    int bBiowareDBCache = GetPRCSwitch(PRC_USE_BIOWARE_DATABASE);

    if(bBiowareDBCache)
    {
        //decide if to cache bioware 2da yet
        object oModule = GetModule();
        if(GetLocalInt(oModule, "Bioware2dacacheCount") >= bBiowareDBCache)
            DeleteLocalInt(oModule, "Bioware2dacacheCount");
        else
        {
            SetLocalInt(oModule, "Bioware2dacacheCount", GetLocalInt(oModule, "Bioware2dacacheCount") + 1);
            bBiowareDBCache = FALSE;
        }
        if(bBiowareDBCache)
        {
            //due to biowares piss-poor database coding, you have to destroy the old database before storing
            //the object
            //If you dont, the dataabse will bloat infinitely because when overriting an existing
            //database entry really marks the old entry as "deleted" ( but doesnt actually remove it)
            //and creates a new entry instead.

            if(DEBUG) DoDebug                 ("Storing Bioware2DACache");
            else      WriteTimestampedLogEntry("Storing Bioware2DACache");
            string sDBName = GetBiowareDBName();
            DestroyCampaignDatabase(sDBName);
            object o2daCache = GetObjectByTag("Bioware2DACache");
            // Rebuild the DB
            StoreCampaignObject(sDBName, "CacheChest", o2daCache);
            SetCampaignString(sDBName, "version", PRC_VERSION);
            SetCampaignString(sDBName, "PRC_2DA_Cache_Fingerprint", GetLocalString(oModule, "PRC_2DA_Cache_Fingerprint"));
            if(DEBUG) DoDebug                 ("Finished storing Bioware2DACache");
            else      WriteTimestampedLogEntry("Finished storing Bioware2DACache");

            // Updated last access fingerprint
            SetLocalString(oModule, "PRC_2DA_Cache_Fingerprint_LastAccessed", GetLocalString(oModule, "PRC_2DA_Cache_Fingerprint"));
        }
    }

    // Player HB code moved to prc_onhb_indiv
    // Removes a LOT of load from teh Module HB
    // and should prevent TMI problems.
}
