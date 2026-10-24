#include "sp_moon_inc"

const int ANIMAL_SHAPES_MASTER = 19402;
const int ANIMAL_SHAPES_BROWN_BEAR = 19404;
const int ANIMAL_SHAPES_PANTHER = 19405;
const int ANIMAL_SHAPES_WOLF = 19406;
const int ANIMAL_SHAPES_BOAR = 19407;
const int ANIMAL_SHAPES_BADGER = 19408;

const string ANIMAL_SHAPES_CONTROLLER_PREFIX = "ASC_";
const string ANIMAL_SHAPES_POLYMORPH_PREFIX = "ASP_";
const string ANIMAL_SHAPES_SERIAL_LOCAL = "PRC_MOON_ANIMAL_SHAPES_SERIAL";

// A 15-foot radius guarantees that no two subjects in the selected cluster
// are more than the rules-required 30 feet apart.
const float ANIMAL_SHAPES_GROUP_RADIUS = 4.57f;

int AnimalShapesStartsWith(string sText, string sPrefix)
{
    return GetStringLeft(sText, GetStringLength(sPrefix)) == sPrefix;
}

string AnimalShapesCasterKey(object oCaster)
{
    string sKey = GetObjectUUID(oCaster);
    if(sKey != "")
        return sKey;

    return ObjectToString(oCaster);
}

string AnimalShapesStateKey(int nSerial)
{
    return "AS" + IntToString(nSerial) + "_";
}

string AnimalShapesPolymorphTag(object oCaster, int nSerial)
{
    return ANIMAL_SHAPES_POLYMORPH_PREFIX
        + AnimalShapesCasterKey(oCaster) + "_" + IntToString(nSerial);
}

int AnimalShapesGetPolymorph(int nSpellID)
{
    switch(nSpellID)
    {
        case ANIMAL_SHAPES_BROWN_BEAR:
            return POLYMORPH_TYPE_BROWN_BEAR;
        case ANIMAL_SHAPES_PANTHER:
            return POLYMORPH_TYPE_PANTHER;
        case ANIMAL_SHAPES_BOAR:
            return POLYMORPH_TYPE_BOAR;
        case ANIMAL_SHAPES_BADGER:
            return POLYMORPH_TYPE_BADGER;
    }

    // The master row is retained as a safe fallback for interfaces that cast
    // it directly instead of first opening its form-selection radial.
    return POLYMORPH_TYPE_WOLF;
}

int AnimalShapesGetFormHitDice(int nSpellID)
{
    switch(nSpellID)
    {
        case ANIMAL_SHAPES_BROWN_BEAR:
            return 6;
        case ANIMAL_SHAPES_PANTHER:
        case ANIMAL_SHAPES_BOAR:
            return 3;
        case ANIMAL_SHAPES_BADGER:
            return 1;
    }

    return 2; // Wolf, including the direct-cast master fallback.
}

void AnimalShapesRemoveTaggedPolymorph(object oTarget, string sTag)
{
    if(!GetIsObjectValid(oTarget))
        return;

    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH
                && GetEffectTag(eTest) == sTag)
            {
                RemoveEffect(oTarget, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oTarget);
        }
    }
}

void AnimalShapesCleanup(object oCaster, int nSerial)
{
    string sKey = AnimalShapesStateKey(nSerial);
    string sTag = GetLocalString(oCaster, sKey + "TAG");
    int nTargets = GetLocalInt(oCaster, sKey + "N");
    int i;

    for(i = 0; i < nTargets; i++)
    {
        object oTarget = GetLocalObject(oCaster, sKey + "T" + IntToString(i));
        AnimalShapesRemoveTaggedPolymorph(oTarget, sTag);
        DeleteLocalObject(oCaster, sKey + "T" + IntToString(i));
    }

    DeleteLocalString(oCaster, sKey + "TAG");
    DeleteLocalInt(oCaster, sKey + "N");
}

void AnimalShapesRemovePriorController(object oCaster, int nSpellID)
{
    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oCaster);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectSpellId(eTest) == nSpellID
                && AnimalShapesStartsWith(GetEffectTag(eTest),
                    ANIMAL_SHAPES_CONTROLLER_PREFIX))
            {
                // Clean the old group synchronously before its replacement is
                // selected; the on-removed callback is intentionally idempotent.
                AnimalShapesCleanup(oCaster,
                    StringToInt(GetEffectString(eTest, 0)));
                RemoveEffect(oCaster, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oCaster);
        }
    }
}

int AnimalShapesCanReceive(object oTarget, int nCasterLevel,
    int nFormHitDice)
{
    // NWN polymorph teardown is asynchronous, so replacing any active form in
    // the same tick is unsafe. A subject must first cancel its existing form.
    if(MoonSpellHasPolymorph(oTarget)
        || MoonSpellHasPersistentShift(oTarget))
        return FALSE;

    // The chosen animal's HD cannot exceed either the caster level or the
    // subject's HD. All supported stock forms are below the overall 20-HD cap.
    if(nFormHitDice > nCasterLevel || nFormHitDice > GetHitDice(oTarget))
        return FALSE;

    return TRUE;
}

int ApplyAnimalShapes(object oCaster, object oTarget, float fDuration,
    int nCasterLevel, int nSpellID, int nForm, string sEffectTag)
{

    MoonSpellSignal(oCaster, oTarget, nSpellID, FALSE);
    // Eligible willing allies accept this harmless spell without an SR check.

    effect ePoly = EffectPolymorph(nForm);
    ePoly = SetEffectSpellId(ePoly, nSpellID);
    ePoly = SetEffectCasterLevel(ePoly, nCasterLevel);
    ePoly = SetEffectCreator(ePoly, oCaster);
    ePoly = TagEffect(ePoly, sEffectTag);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_POLYMORPH), oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget,
        fDuration, TRUE, nSpellID, nCasterLevel, oCaster);
    return TRUE;
}

void main()
{
    // The caster-owned controller makes the spell dismissible as one group.
    // Removing it through expiry, dispel, or the PRC duration NUI restores
    // every subject that has not already ended its own polymorph.
    effect eRun = GetLastRunScriptEffect();
    if(GetIsEffectValid(eRun)
        && AnimalShapesStartsWith(GetEffectTag(eRun),
            ANIMAL_SHAPES_CONTROLLER_PREFIX))
    {
        if(GetLastRunScriptEffectScriptType()
            == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
            AnimalShapesCleanup(OBJECT_SELF,
                StringToInt(GetEffectString(eRun, 0)));
        return;
    }

    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    location lTarget = PRCGetSpellTargetLocation();
    float fDuration = PRCGetMetaMagicDuration(HoursToSeconds(nCasterLevel));
    int nForm = AnimalShapesGetPolymorph(nSpellID);
    int nFormHitDice = AnimalShapesGetFormHitDice(nSpellID);

    // The duration NUI identifies rows by spell ID. Keep one active casting
    // of each selected form per caster so dismissing that row is unambiguous.
    AnimalShapesRemovePriorController(oCaster, nSpellID);

    int nSerial = GetLocalInt(oCaster, ANIMAL_SHAPES_SERIAL_LOCAL) + 1;
    SetLocalInt(oCaster, ANIMAL_SHAPES_SERIAL_LOCAL, nSerial);

    string sKey = AnimalShapesStateKey(nSerial);
    string sEffectTag = AnimalShapesPolymorphTag(oCaster, nSerial);
    int nCandidates = 0;
    int nApplied = 0;

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE,
        ANIMAL_SHAPES_GROUP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCandidates < nCasterLevel)
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)
            && !GetIsDead(oTarget)
            && AnimalShapesCanReceive(oTarget, nCasterLevel,
                nFormHitDice))
        {
            // Keep the limit of one eligible willing subject per caster level.
            nCandidates++;
            if(ApplyAnimalShapes(oCaster, oTarget, fDuration, nCasterLevel,
                nSpellID, nForm, sEffectTag))
            {
                SetLocalObject(oCaster, sKey + "T" + IntToString(nApplied),
                    oTarget);
                nApplied++;
            }
        }

        oTarget = MyNextObjectInShape(SHAPE_SPHERE,
            ANIMAL_SHAPES_GROUP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    if(nApplied > 0)
    {
        SetLocalInt(oCaster, sKey + "N", nApplied);
        SetLocalString(oCaster, sKey + "TAG", sEffectTag);

        string sControllerTag = ANIMAL_SHAPES_CONTROLLER_PREFIX
            + AnimalShapesCasterKey(oCaster) + "_" + IntToString(nSerial);
        effect eController = EffectRunScript("sp_animalshape",
            "sp_animalshape", "", 0.0f, IntToString(nSerial));
        // This is bookkeeping, not an additional spell effect on the caster.
        // Making it extraordinary prevents a dispel aimed at the caster from
        // incorrectly ending the spell on remote subjects; NUI removal still
        // invokes the controller's cleanup callback.
        eController = ExtraordinaryEffect(eController);
        eController = SetEffectSpellId(eController, nSpellID);
        eController = SetEffectCasterLevel(eController, nCasterLevel);
        eController = SetEffectCreator(eController, oCaster);
        eController = TagEffect(eController, sControllerTag);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eController, oCaster,
            fDuration, FALSE, nSpellID, nCasterLevel, oCaster);
    }
    else
    {
        FloatingTextStringOnCreature(
            "Animal Shapes found no eligible willing allies for that form.",
            oCaster, FALSE);
    }

    PRCSetSchool();
}
