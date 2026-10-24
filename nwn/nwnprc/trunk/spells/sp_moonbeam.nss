#include "sp_moon_inc"

const string MOONBEAM_CONTROLLER_PREFIX = "MBC_";
const string MOONBEAM_IMMUNITY_PREFIX   = "MBI_";
const string MOONBEAM_WATCH_PREFIX      = "PRC_MBW_";
const string MOONBEAM_ACTIVE_CONTROLLER = "PRC_MOONBEAM_CONTROLLER";
const string MOONBEAM_FACING_LOCAL      = "PRC_MOONBEAM_FACING";
const string MOONBEAM_REDIRECT_ACTIVE   = "PRC_MOONBEAM_REDIRECT_ACTIVE";
const string MOONBEAM_REDIRECT_SERIAL   = "PRC_MOONBEAM_REDIRECT_SERIAL";
const string MOONBEAM_LOGOUT_CLEANUP    = "PRC_MOONBEAM_LOGOUT_CLEANUP";

const int MOONBEAM_REDIRECT_FEAT  = 25146;
const int MOONBEAM_REDIRECT_SPELL = 19410;

// Keep these values aligned with the spellbook NUI development source.
const string MOONBEAM_NUI_WINDOW_ID    = "prcSpellbookNui";
const string MOONBEAM_NUI_ENABLED_BIND = "sbMrE";
const string MOONBEAM_NUI_READY_BIND   = "sbMrR";

const int MOONBEAM_FORM_HUMANOID = 0;
const int MOONBEAM_FORM_ANIMAL   = 1;
const int MOONBEAM_FORM_HYBRID   = 2;
const int MOONBEAM_FORM_OTHER    = 3;

void MoonbeamWatchAnimalForm(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel, string sControllerTag, int nAnimalTicks, int nCountermoonSequence);
void MoonbeamFinishAnimalForm(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel, string sControllerTag, int nResumeTicks, int nWaitTicks, int nCountermoonSequence);

int MoonbeamStartsWith(string sText, string sPrefix)
{
    return GetStringLeft(sText, GetStringLength(sPrefix)) == sPrefix;
}

void MoonbeamRefreshNui(object oCaster)
{
    if(GetIsPC(oCaster)
        && NuiFindWindow(oCaster, MOONBEAM_NUI_WINDOW_ID))
        ExecuteScript("prc_nui_sb_view", oCaster);
}

void MoonbeamSetNuiReady(object oCaster, int bReady)
{
    int nToken = NuiFindWindow(oCaster, MOONBEAM_NUI_WINDOW_ID);
    if(nToken <= 0)
        return;

    NuiSetBind(oCaster, nToken, MOONBEAM_NUI_ENABLED_BIND,
        JsonBool(bReady));
    NuiSetBind(oCaster, nToken, MOONBEAM_NUI_READY_BIND,
        JsonBool(bReady));
}

string MoonbeamCasterKey(object oCaster)
{
    string sKey = GetObjectUUID(oCaster);
    if(sKey != "")
        return sKey;

    return ObjectToString(oCaster);
}

string MoonbeamImmunityTag(object oCaster)
{
    return MOONBEAM_IMMUNITY_PREFIX + MoonbeamCasterKey(oCaster);
}

string MoonbeamWatchLocal(string sControllerTag)
{
    return MOONBEAM_WATCH_PREFIX + sControllerTag;
}


int MoonbeamBlockedByCountermoon(object oTarget)
{
    // The effect owns the duration. A stale local after logout/removal must
    // not leave permanent protection from Moonbeam.
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_RUNSCRIPT
            && MoonbeamStartsWith(GetEffectTag(eTest), "CMC_"))
            return TRUE;
        eTest = GetNextEffect(oTarget);
    }
    return FALSE;
}

int MoonbeamWatchInterrupted(object oTarget, string sControllerTag,
    int nCountermoonSequence)
{
    if(!GetIsObjectValid(oTarget))
        return TRUE;

    // A successful Countermoon cast invalidates queued work even if its
    // effect is removed before the next Moonbeam callback runs.
    if(GetLocalInt(oTarget, "PRC_MOON_COUNTERMOON_SEQUENCE")
            != nCountermoonSequence
        || MoonbeamBlockedByCountermoon(oTarget))
    {
        string sWatchLocal = MoonbeamWatchLocal(sControllerTag);
        // An old callback must not delete a newer watch for the same beam.
        if(GetLocalInt(oTarget, sWatchLocal) == nCountermoonSequence + 1)
            DeleteLocalInt(oTarget, sWatchLocal);
        return TRUE;
    }
    return FALSE;
}

int MoonbeamHasTaggedEffect(object oTarget, string sTag)
{
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectTag(eTest) == sTag)
            return TRUE;

        eTest = GetNextEffect(oTarget);
    }

    return FALSE;
}

int MoonbeamControllerIsActive(object oCaster, string sControllerTag)
{
    return GetIsObjectValid(oCaster)
        && MoonbeamHasTaggedEffect(oCaster, sControllerTag);
}

location MoonbeamCurrentCone(object oCaster)
{
    // SHAPE_SPELLCONE uses lTarget as the end/direction of the cone; its
    // origin is OBJECT_SELF.  A location at the caster with only a facing
    // produces a zero-length direction and finds no targets.
    float fFacing = GetLocalFloat(oCaster, MOONBEAM_FACING_LOCAL);
    vector vEndpoint = GetPosition(oCaster)
        + (9.14f * AngleToVector(fFacing));
    return Location(GetArea(oCaster), vEndpoint, fFacing);
}

float MoonbeamFacingToLocation(object oCaster, location lTarget)
{
    vector vCaster = GetPosition(oCaster);
    vector vTarget = GetPositionFromLocation(lTarget);
    vector vDirection = Vector(vTarget.x - vCaster.x,
        vTarget.y - vCaster.y, 0.0f);

    if(VectorMagnitude(vDirection) > 0.1f)
        return VectorToAngle(vDirection);

    return GetFacingFromLocation(lTarget);
}

void MoonbeamClearRedirectLock(object oCaster, string sControllerTag,
    int nSerial)
{
    if(!GetIsObjectValid(oCaster)
        || GetLocalInt(oCaster, MOONBEAM_REDIRECT_SERIAL) != nSerial
        || !MoonbeamControllerIsActive(oCaster, sControllerTag))
        return;

    DeleteLocalInt(oCaster, MOONBEAM_REDIRECT_ACTIVE);
    MoonbeamSetNuiReady(oCaster, TRUE);
}

void MoonbeamRemoveOldControllers(object oCaster)
{
    // Removal is queued by the engine. Restarting at the first effect can
    // repeatedly queue removal of the same still-visible linked controller.
    // Walk the original list once, saving the next effect before removal.
    int nScanned;
    effect eTest = GetFirstEffect(oCaster);
    while(GetIsEffectValid(eTest) && nScanned < 4096)
    {
        effect eNext = GetNextEffect(oCaster);
        if(MoonbeamStartsWith(GetEffectTag(eTest), MOONBEAM_CONTROLLER_PREFIX))
            RemoveEffect(oCaster, eTest);
        eTest = eNext;
        nScanned++;
    }
}

int MoonbeamIsStockWerewolf(object oTarget)
{
    return MoonSpellHasWerewolfTemplate(oTarget)
        || GetHasFeat(FEAT_PRESTIGE_LYCANTHROPE, oTarget)
        || GetHasFeat(FEAT_TRUE_LYCANTHROPE, oTarget);
}

int MoonbeamIsAnimalPolymorph(int nPoly)
{
    return nPoly == POLYMORPH_TYPE_WOLF_0
        || nPoly == POLYMORPH_TYPE_WOLF_1
        || nPoly == POLYMORPH_TYPE_WOLF_2
        || nPoly == POLYMORPH_TYPE_WOLF_0s
        || nPoly == POLYMORPH_TYPE_WOLF_1s
        || nPoly == POLYMORPH_TYPE_WOLF_2s
        || nPoly == POLYMORPH_TYPE_WOLF_0l
        || nPoly == POLYMORPH_TYPE_WOLF_1l
        || nPoly == POLYMORPH_TYPE_WOLF_2l
        || nPoly == PRC_WW_POLYMORPH_WOLF;
}

int MoonbeamIsHybridPolymorph(int nPoly)
{
    return nPoly == POLYMORPH_TYPE_WEREWOLF_0s
        || nPoly == POLYMORPH_TYPE_WEREWOLF_1s
        || nPoly == POLYMORPH_TYPE_WEREWOLF_2s
        || nPoly == POLYMORPH_TYPE_WEREWOLF_0l
        || nPoly == POLYMORPH_TYPE_WEREWOLF_1l
        || nPoly == POLYMORPH_TYPE_WEREWOLF_2l
        || nPoly == PRC_WW_POLYMORPH_HYBRID;
}

int MoonbeamGetWerewolfForm(object oTarget)
{
    int bOtherPolymorph = FALSE;
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
        {
            int nPoly = GetEffectInteger(eTest, 0);
            if(MoonbeamIsAnimalPolymorph(nPoly))
                return MOONBEAM_FORM_ANIMAL;
            if(MoonbeamIsHybridPolymorph(nPoly))
                return MOONBEAM_FORM_HYBRID;

            bOtherPolymorph = TRUE;
        }

        eTest = GetNextEffect(oTarget);
    }

    // The optional PnP hybrid branch has no engine polymorph effect.
    if(GetLocalInt(oTarget, "WWHybrid")
        && GetPersistantLocalInt(oTarget, "nPCShifted")
        && GetAppearanceType(oTarget) == APPEARANCE_TYPE_WEREWOLF)
        return MOONBEAM_FORM_HYBRID;

    // Appearance is only corroboration. The WWWolf local is reused by other
    // PRC races and can remain stale after Cancel Polymorph.
    if(GetLocalInt(oTarget, "WWWolf")
        && GetAppearanceType(oTarget) == APPEARANCE_TYPE_DOG_WOLF)
        return MOONBEAM_FORM_ANIMAL;

    if(bOtherPolymorph || MoonSpellHasPersistentShift(oTarget))
        return MOONBEAM_FORM_OTHER;

    return MOONBEAM_FORM_HUMANOID;
}

int MoonbeamIsLightSensitive(object oTarget)
{
    return GetHasFeat(FEAT_LTSENSE, oTarget)
        || GetHasFeat(FEAT_LTBLIND, oTarget);
}

int MoonbeamDarknessLevel(effect eTest)
{
    int nSpellID = GetEffectSpellId(eTest);
    string sTag = GetEffectTag(eTest);
    int bDarkness = sTag == "BIO_DARKNESS"
        || sTag == "PNP_DARKNESS"
        || sTag == "PNP35_DARKNESS"
        || nSpellID == 36    // Darkness
        || nSpellID == 345   // Shadow Conjuration: Darkness
        || nSpellID == 606   // Darkness spell-like ability
        || nSpellID == 688   // Drider Darkness
        || nSpellID == 1958  // Racial Darkness
        || nSpellID == 2091  // Blacklight
        || nSpellID == 2535  // Damning Darkness
        || nSpellID == 2592  // Utterdark
        || nSpellID == 3207  // Deeper Darkness
        || nSpellID == 18003 // Darkness invocation
        || nSpellID == 18104 // Hungry Darkness
        || nSpellID == 18583 // Fearful Gloom mystery
        || nSpellID == 18584 // Sickening Shadow mystery
        || nSpellID == 18585 // Deadly Shade (damage reduction) mystery
        || nSpellID == 18586 // Deadly Shade (negative level) mystery
        || (nSpellID >= 0
            && (GetDescriptorFlags(nSpellID) & DESCRIPTOR_DARKNESS));

    if(!bDarkness)
        return 0;

    int nLevel;
    if(nSpellID >= 0)
        nLevel = StringToInt(Get2DACache("spells", "Innate", nSpellID));

    if(nSpellID == 2592)
        nLevel = 9;
    else if(nSpellID == 2535)
        nLevel = 4;
    else if(nSpellID == 2091 || nSpellID == 3207 || nSpellID == 18104)
        nLevel = 3;
    else if(nSpellID == 18583)
        nLevel = 4;
    else if(nSpellID == 18584)
        nLevel = 5;
    else if(nSpellID == 18585 || nSpellID == 18586)
        nLevel = 6;

    // Some SLA and item-property darkness rows have no Innate value.
    if(nLevel <= 0)
        nLevel = 2;

    return nLevel;
}

int MoonbeamBlockedByHigherDarkness(object oTarget)
{
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(MoonbeamDarknessLevel(eTest) > 2)
            return TRUE;

        eTest = GetNextEffect(oTarget);
    }

    return FALSE;
}

int MoonbeamTargetIsInCone(object oCaster, object oTarget)
{
    if(!GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget)
        || GetArea(oCaster) != GetArea(oTarget))
        return FALSE;

    location lCone = MoonbeamCurrentCone(oCaster);
    object oTest = MyFirstObjectInShape(SHAPE_SPELLCONE, 9.14f, lCone,
        TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTest))
    {
        if(oTest == oTarget)
            return TRUE;

        oTest = MyNextObjectInShape(SHAPE_SPELLCONE, 9.14f, lCone,
            TRUE, OBJECT_TYPE_CREATURE);
    }

    return FALSE;
}

int MoonbeamHasImmunity(object oCaster, object oTarget)
{
    string sKey = MoonbeamImmunityTag(oCaster);
    int nExpiry = GetPersistantLocalInt(oTarget, sKey);
    if(!nExpiry)
        return FALSE;

    sqlquery qTime = SqlPrepareQueryObject(GetModule(),
        "SELECT strftime('%s','now');");
    int nNow;
    if(SqlStep(qTime))
        nNow = SqlGetInt(qTime, 0);

    if(nNow && nExpiry > nNow)
        return TRUE;

    DeletePersistantLocalInt(oTarget, sKey);
    return FALSE;
}

void MoonbeamGrantImmunity(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel)
{
    sqlquery qTime = SqlPrepareQueryObject(GetModule(),
        "SELECT strftime('%s','now');");
    int nNow;
    if(SqlStep(qTime))
        nNow = SqlGetInt(qTime, 0);

    if(nNow)
        SetPersistantLocalInt(oTarget, MoonbeamImmunityTag(oCaster),
            nNow + FloatToInt(HoursToSeconds(24)));
}

int MoonbeamWillSave(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel)
{
    MoonSpellSignal(oCaster, oTarget, nSpellID, TRUE);
    int nDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);
    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC,
        SAVING_THROW_TYPE_SPELL, oCaster))
    {
        MoonbeamGrantImmunity(oCaster, oTarget, nSpellID, nCasterLevel);
        return TRUE;
    }

    return FALSE;
}

void MoonbeamBeginAnimalForm(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel, string sControllerTag, int nResumeTicks, int nCountermoonSequence)
{
    if(MoonbeamWatchInterrupted(oTarget, sControllerTag,
        nCountermoonSequence))
        return;

    string sWatchLocal = MoonbeamWatchLocal(sControllerTag);
    SetLocalInt(oTarget, sWatchLocal, nCountermoonSequence + 1);

    int nForm = MoonbeamGetWerewolfForm(oTarget);
    if(nForm != MOONBEAM_FORM_HUMANOID)
        MoonSpellUnshiftWerewolf(oTarget);

    DelayCommand(0.25f, MoonbeamFinishAnimalForm(oCaster, oTarget, nSpellID,
        nCasterLevel, sControllerTag, nResumeTicks, 0, nCountermoonSequence));
}

void MoonbeamFinishAnimalForm(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel, string sControllerTag, int nResumeTicks, int nWaitTicks, int nCountermoonSequence)
{
    string sWatchLocal = MoonbeamWatchLocal(sControllerTag);
    if(MoonbeamWatchInterrupted(oTarget, sControllerTag,
        nCountermoonSequence)
        || GetLocalInt(oTarget, sWatchLocal) != nCountermoonSequence + 1)
        return;

    if(!PRCGetIsAliveCreature(oTarget))
    {
        DeleteLocalInt(oTarget, sWatchLocal);
        return;
    }

    int nForm = MoonbeamGetWerewolfForm(oTarget);
    if(nForm == MOONBEAM_FORM_ANIMAL)
    {
        DelayCommand(0.25f, MoonbeamWatchAnimalForm(oCaster, oTarget, nSpellID,
            nCasterLevel, sControllerTag, nResumeTicks, nCountermoonSequence));
        return;
    }

    if(nWaitTicks >= 40)
    {
        DeleteLocalInt(oTarget, sWatchLocal);
        return;
    }

    if(nForm != MOONBEAM_FORM_HUMANOID)
    {
        if((nWaitTicks % 4) == 0)
            MoonSpellUnshiftWerewolf(oTarget);

        DelayCommand(0.25f, MoonbeamFinishAnimalForm(oCaster, oTarget,
            nSpellID, nCasterLevel, sControllerTag, nResumeTicks,
            nWaitTicks + 1, nCountermoonSequence));
        return;
    }

    // Clear stale stock flags before calling the unmodified stock toggle.
    DeleteLocalInt(oTarget, "WWWolf");
    DeleteLocalInt(oTarget, "WWHybrid");
    MoonSpellForceWerewolfAnimal(oTarget);

    DelayCommand(0.25f, MoonbeamFinishAnimalForm(oCaster, oTarget, nSpellID,
        nCasterLevel, sControllerTag, nResumeTicks, nWaitTicks + 1, nCountermoonSequence));
}

void MoonbeamWatchAnimalForm(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel, string sControllerTag, int nAnimalTicks, int nCountermoonSequence)
{
    string sWatchLocal = MoonbeamWatchLocal(sControllerTag);
    if(MoonbeamWatchInterrupted(oTarget, sControllerTag,
        nCountermoonSequence))
        return;
    if(GetLocalInt(oTarget, sWatchLocal) != nCountermoonSequence + 1)
        return;
    if(!PRCGetIsAliveCreature(oTarget))
    {
        if(GetIsObjectValid(oTarget))
            DeleteLocalInt(oTarget, sWatchLocal);
        return;
    }

    int nForm = MoonbeamGetWerewolfForm(oTarget);

    // A forced lycanthrope must spend one full round in animal form even if
    // the caster turns away or the spell ends during that round.
    if(nAnimalTicks < 24)
    {
        if(nForm != MOONBEAM_FORM_ANIMAL)
        {
            MoonbeamBeginAnimalForm(oCaster, oTarget, nSpellID, nCasterLevel,
                sControllerTag, nAnimalTicks, nCountermoonSequence);
            return;
        }

        DelayCommand(0.25f, MoonbeamWatchAnimalForm(oCaster, oTarget, nSpellID,
            nCasterLevel, sControllerTag, nAnimalTicks + 1, nCountermoonSequence));
        return;
    }

    // Once a round has elapsed, leaving the spell or its light being blocked
    // permits a form change without a save.
    if(!MoonbeamControllerIsActive(oCaster, sControllerTag)
        || !MoonbeamTargetIsInCone(oCaster, oTarget)
        || MoonbeamBlockedByHigherDarkness(oCaster)
        || MoonbeamBlockedByHigherDarkness(oTarget))
    {
        DeleteLocalInt(oTarget, sWatchLocal);
        return;
    }

    if(nForm == MOONBEAM_FORM_ANIMAL)
    {
        DelayCommand(0.25f, MoonbeamWatchAnimalForm(oCaster, oTarget, nSpellID,
            nCasterLevel, sControllerTag, nAnimalTicks + 1, nCountermoonSequence));
        return;
    }

    // Stock PRC has no pre-use hook. Detect the attempted transition quickly;
    // success keeps the chosen form, while failure restores stock wolf form.
    if(MoonbeamWillSave(oCaster, oTarget, nSpellID, nCasterLevel))
    {
        DeleteLocalInt(oTarget, sWatchLocal);
        return;
    }

    MoonbeamBeginAnimalForm(oCaster, oTarget, nSpellID, nCasterLevel,
        sControllerTag, 0, nCountermoonSequence);
}

void MoonbeamStartAnimalWatch(object oCaster, object oTarget, int nSpellID,
    int nCasterLevel, string sControllerTag, int nAnimalTicks, int nCountermoonSequence)
{
    string sWatchLocal = MoonbeamWatchLocal(sControllerTag);
    if(MoonbeamWatchInterrupted(oTarget, sControllerTag,
        nCountermoonSequence)
        || GetLocalInt(oTarget, sWatchLocal) == nCountermoonSequence + 1)
        return;

    SetLocalInt(oTarget, sWatchLocal, nCountermoonSequence + 1);
    DelayCommand(0.25f, MoonbeamWatchAnimalForm(oCaster, oTarget, nSpellID,
        nCasterLevel, sControllerTag, nAnimalTicks, nCountermoonSequence));
}

void MoonbeamPulse(object oCaster, int nSpellID, int nCasterLevel,
    string sControllerTag, location lCone)
{
    if(!GetIsObjectValid(oCaster)
        || MoonbeamBlockedByHigherDarkness(oCaster))
        return;

    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 9.14f, lCone,
        TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oCaster
            && PRCGetIsAliveCreature(oTarget)
            && MoonbeamIsStockWerewolf(oTarget)
            && !MoonbeamBlockedByCountermoon(oTarget)
            && !MoonbeamIsLightSensitive(oTarget)
            && !MoonbeamBlockedByHigherDarkness(oTarget)
            && !MoonbeamHasImmunity(oCaster, oTarget))
        {
            string sWatchLocal = MoonbeamWatchLocal(sControllerTag);
            int nCountermoonSequence = GetLocalInt(oTarget,
                "PRC_MOON_COUNTERMOON_SEQUENCE");
            if(GetLocalInt(oTarget, sWatchLocal) != nCountermoonSequence + 1)
            {
                int nForm = MoonbeamGetWerewolfForm(oTarget);
                if(nForm == MOONBEAM_FORM_HUMANOID)
                {
                    if(!MoonbeamWillSave(oCaster, oTarget, nSpellID,
                        nCasterLevel))
                        MoonbeamBeginAnimalForm(oCaster, oTarget, nSpellID,
                            nCasterLevel, sControllerTag, 0, nCountermoonSequence);
                }
                else if(nForm == MOONBEAM_FORM_ANIMAL)
                {
                    // A werewolf already in animal form has already spent the
                    // required round; monitor only its attempt to leave.
                    MoonbeamStartAnimalWatch(oCaster, oTarget, nSpellID,
                        nCasterLevel, sControllerTag, 24, nCountermoonSequence);
                }
                // The rule names humanoid and animal forms, not hybrid or an
                // unrelated shape, so those forms are intentionally untouched.
            }
        }

        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 9.14f, lCone,
            TRUE, OBJECT_TYPE_CREATURE);
    }
}

void main()
{
    // Dispatch on the native event type, never on the effect's tag/validity.
    // Linked/removing effects can lack that metadata. Falling through from
    // an effect callback into X2PreSpellCastCode would cast another beam.
    int nEvent = GetLastRunScriptEffectScriptType();
    if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
    {
        // Also safely handles controllers saved with the old callback name.
        ExecuteScript("sp_mb_event", OBJECT_SELF);
        return;
    }
    if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED)
        return;

    effect eRun = GetLastRunScriptEffect();
    if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL)
    {
        if(GetIsEffectValid(eRun)
            && MoonbeamStartsWith(GetEffectTag(eRun), MOONBEAM_CONTROLLER_PREFIX)
            && GetLocalString(OBJECT_SELF, MOONBEAM_ACTIVE_CONTROLLER)
                == GetEffectTag(eRun))
        {
            MoonbeamPulse(OBJECT_SELF, GetEffectSpellId(eRun),
                StringToInt(GetEffectString(eRun, 0)), GetEffectTag(eRun),
                MoonbeamCurrentCone(OBJECT_SELF));
        }
        return;
    }

    object oCaster = OBJECT_SELF;

    // Mystara exports PCs before the stock on-leave chain. Strip the linked
    // temporary feat before that export so it can never persist in the BIC.
    if(GetLocalInt(oCaster, MOONBEAM_LOGOUT_CLEANUP))
    {
        MoonbeamRemoveOldControllers(oCaster);
        DeleteLocalString(oCaster, MOONBEAM_ACTIVE_CONTROLLER);
        DeleteLocalFloat(oCaster, MOONBEAM_FACING_LOCAL);
        DeleteLocalInt(oCaster, MOONBEAM_REDIRECT_ACTIVE);
        DeleteLocalInt(oCaster, MOONBEAM_REDIRECT_SERIAL);
        return;
    }

    int nSpellID = PRCGetSpellId();

    // The temporary at-will feat redirects the existing beam without
    // consuming another prepared spell. It may change direction once/round.
    if(nSpellID == MOONBEAM_REDIRECT_SPELL)
    {
        string sControllerTag = GetLocalString(oCaster,
            MOONBEAM_ACTIVE_CONTROLLER);
        effect eController = GetFirstEffect(oCaster);
        while(GetIsEffectValid(eController))
        {
            if(GetEffectType(eController) == EFFECT_TYPE_RUNSCRIPT
                && GetEffectTag(eController) == sControllerTag)
                break;

            eController = GetNextEffect(oCaster);
        }

        if(!GetIsEffectValid(eController)
            || !MoonbeamStartsWith(sControllerTag,
                MOONBEAM_CONTROLLER_PREFIX))
        {
            FloatingTextStringOnCreature("Moonbeam is not active.", oCaster,
                FALSE);
            DelayCommand(0.0f, MoonbeamRefreshNui(oCaster));
            return;
        }

        if(GetLocalInt(oCaster, MOONBEAM_REDIRECT_ACTIVE))
        {
            FloatingTextStringOnCreature(
                "Redirect Moonbeam is usable once per round.", oCaster,
                FALSE);
            return;
        }

        location lRedirect = PRCGetSpellTargetLocation();
        if(GetAreaFromLocation(lRedirect) != GetArea(oCaster))
            return;

        SetLocalFloat(oCaster, MOONBEAM_FACING_LOCAL,
            MoonbeamFacingToLocation(oCaster, lRedirect));

        int nRedirectSerial = GetLocalInt(oCaster,
            MOONBEAM_REDIRECT_SERIAL) + 1;
        SetLocalInt(oCaster, MOONBEAM_REDIRECT_SERIAL, nRedirectSerial);
        SetLocalInt(oCaster, MOONBEAM_REDIRECT_ACTIVE, TRUE);
        MoonbeamSetNuiReady(oCaster, FALSE);
        DelayCommand(RoundsToSeconds(1), MoonbeamClearRedirectLock(oCaster,
            sControllerTag, nRedirectSerial));

        // Ground-targeted bonus feats do not reliably replay their spell-row
        // casting visuals. Fake-cast the redirect spell so every feat use
        // visibly emits the Moonbeam cone without running this script twice or
        // consuming another prepared spell.
        ActionCastFakeSpellAtLocation(MOONBEAM_REDIRECT_SPELL, lRedirect,
            PROJECTILE_PATH_TYPE_DEFAULT);

        MoonbeamPulse(oCaster, GetEffectSpellId(eController),
            StringToInt(GetEffectString(eController, 0)), sControllerTag,
            MoonbeamCurrentCone(oCaster));
        return;
    }

    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    location lCastCone = PRCGetSpellTargetLocation();
    if(GetAreaFromLocation(lCastCone) != GetArea(oCaster))
        lCastCone = GetLocation(oCaster);

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    int nRounds = nCasterLevel * 10;
    if(nMetaMagic & METAMAGIC_EXTEND)
        nRounds *= 2;

    MoonbeamRemoveOldControllers(oCaster);
    int nSerial = GetLocalInt(oCaster, "PRC_MoonbeamSerial") + 1;
    SetLocalInt(oCaster, "PRC_MoonbeamSerial", nSerial);
    string sControllerTag = MOONBEAM_CONTROLLER_PREFIX
        + ObjectToString(oCaster) + "_" + IntToString(nSerial);
    SetLocalString(oCaster, MOONBEAM_ACTIVE_CONTROLLER, sControllerTag);
    SetLocalFloat(oCaster, MOONBEAM_FACING_LOCAL,
        GetFacingFromLocation(lCastCone));
    DeleteLocalInt(oCaster, MOONBEAM_REDIRECT_ACTIVE);
    DeleteLocalInt(oCaster, MOONBEAM_REDIRECT_SERIAL);

    // This no-bonus effect is Moonbeam's dispellable and NUI-dismissible
    // duration controller. Its linked feat redirects the cone while active.
    effect eController = EffectRunScript("", "sp_mb_event", "sp_moonbeam",
        6.0f, IntToString(nCasterLevel));
    // Preserve identity on the RunScript child, not only the linked group.
    eController = TagEffect(eController, sControllerTag);
    eController = EffectLinkEffects(eController,
        EffectBonusFeat(MOONBEAM_REDIRECT_FEAT));
    eController = SetEffectSpellId(eController, nSpellID);
    eController = SetEffectCasterLevel(eController, nCasterLevel);
    eController = SetEffectCreator(eController, oCaster);
    eController = TagEffect(eController, sControllerTag);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eController, oCaster,
        RoundsToSeconds(nRounds), TRUE, nSpellID, nCasterLevel, oCaster);

    // Engine cone spells keep the clicked aim direction in the target
    // location's facing. The caster's actor-facing can still be stale here.
    MoonbeamPulse(oCaster, nSpellID, nCasterLevel, sControllerTag, lCastCone);
    MoonbeamSetNuiReady(oCaster, TRUE);
    DelayCommand(0.1f, MoonbeamRefreshNui(oCaster));

    PRCSetSchool();
}
