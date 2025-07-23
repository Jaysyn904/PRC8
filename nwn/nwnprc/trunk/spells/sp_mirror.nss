//::///////////////////////////////////////////////
//:: Mirror Image
//:: sp_mirror.nss
//:://////////////////////////////////////////////
/*
Caster Level(s): Bard 2, Wizard 2, Sorcerer 2
Innate Level: 2
School: Illusion
Component(s): Verbal, Somatic
Range: Personal
Area of Effect / Target: Self
Duration: 1 min/level
Save: harmless
Spell Resistance: harmless

 Several illusory duplicates of you pop into being, making it
 difficult for enemies to know which target to attack. The
 figments stay near you and disappear when struck.

Mirror image creates 1d4 images plus one image per three
caster levels (maximum eight images total). These figments
separate from you and remain in a cluster, each within 5 feet
of at least one other figment or you. You can move into and
through a mirror image. When you and the mirror image separate,
observers can’t use vision or hearing to tell which one is you
and which the image. The figments may also move through each
other. The figments mimic your actions, pretending to cast spells
when you cast a spell, drink potions when you drink a potion,
levitate when you levitate, and so on.

Enemies attempting to attack you or cast spells at you must
select from among indistinguishable targets. Any successful
attack against an image destroys it. An image’s AC is 10 +
your size modifier + your Dex modifier. Figments seem to react
normally to area spells (such as looking like they’re burned or
dead after being hit by a fireball).

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: August 20, 2004
//:://////////////////////////////////////////////
#include "nw_inc_gff"
#include "prc_inc_spells"

// Validates and tracks mirror image alignment with master
void TrackMirrorImage(object oSummoned)
{
 	DoDebug("sp_mirror >> TrackMirrorImage: Running.");
	
	if (!GetIsObjectValid(oSummoned)) 
	{
		DoDebug("sp_mirror >> TrackMirrorImage: oSummoned invalid.");
		//SendMessageToPC(GetFirstPC(), "TrackMirrorImage >> oSummon or oMaster invalid.");
		return;
	}

	object oMaster = GetLocalObject(oSummoned, "oMaster");
    if (!GetIsObjectValid(oMaster)) 
	{
		DoDebug("sp_mirror >> TrackMirrorImage: oMaster invalid.");
		//SendMessageToPC(GetFirstPC(), "TrackMirrorImage >> oSummon or oMaster invalid.");
		return;
	}	

    float fRelX = GetLocalFloat(oSummoned, "rel_x");
    float fRelY = GetLocalFloat(oSummoned, "rel_y");

    vector vMaster = GetPosition(oMaster);
    float fFacing = GetFacing(oMaster);
    float fRadians = fFacing * 3.14159 / 180.0;

    // Apply facing-based 2D rotation to the stored offset
    float fX = vMaster.x + fRelX * cos(fRadians) - fRelY * sin(fRadians);
    float fY = vMaster.y + fRelX * sin(fRadians) + fRelY * cos(fRadians);

    location lTarget = Location(GetArea(oMaster), Vector(fX, fY, vMaster.z), fFacing);

    // Ensure these commands only execute under needed context
    AssignCommand(oSummoned, ClearAllActions());
    AssignCommand(oSummoned, ActionJumpToLocation(lTarget));

    // Schedule next update in 0.25 seconds
    DelayCommand(0.1, TrackMirrorImage(oSummoned));
}

// Initializes the summoning and tracking system
void StartMirrorImageTracking(object oSummoned, object oMaster)
{
	if (!GetIsObjectValid(oMaster))
	{
		DoDebug("sp_mirror >> StartMirrorImageTracking: oMaster invalid.");
		//SendMessageToPC(GetFirstPC(), "TrackMirrorImage >> oSummon or oMaster invalid.");
		return;
	}	

    vector vMaster = GetPosition(oMaster);
    vector vSummoned = GetPosition(oSummoned);

    float fRelX = vSummoned.x - vMaster.x;
    float fRelY = vSummoned.y - vMaster.y;

    SetLocalFloat(oSummoned, "rel_x", fRelX);
    SetLocalFloat(oSummoned, "rel_y", fRelY);
    SetLocalObject(oSummoned, "summoner", oMaster);
	
	SetLocalObject(oSummoned, "oMaster", oMaster);

	DoDebug("sp_mirror >> StartMirrorImageTracking: Firing TrackMirrorImage().");
    TrackMirrorImage(oSummoned);
}

void SetMirrorImageScripts(object oImage)
{	
	
	string sTag = GetTag(oImage);
	
	if(DEBUG) DoDebug("sp_mirror >> SetMirrorImageScripts: Setting OnSpellCastAt script on "+ sTag +".");
	
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DEATH, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_NOTICE, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_RESTED, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "mirror_image_sa");
	SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "");
}

json JsonModifyRacialType(json jCreature, int nNewRacialType)
{
    if(DEBUG)DoDebug("sp_mirror >> JsonModifyRacialType: Entering function");
	
	// Retrieve the RacialType field
    json jRacialTypeField = JsonObjectGet(jCreature, "Race");

    if (JsonGetType(jRacialTypeField) == JSON_TYPE_NULL)
    {
        DoDebug("sp_mirror >> JsonModifyRacialType: JsonGetType error 1: " + JsonGetError(jRacialTypeField));
		//SpeakString("JsonGetType error 1: " + JsonGetError(jRacialTypeField));
        return JsonNull();
    }

    // Retrieve the value to modify
    json jRacialTypeValue = JsonObjectGet(jRacialTypeField, "value");

    if (JsonGetType(jRacialTypeValue) != JSON_TYPE_INTEGER)
    {
        DoDebug("sp_mirror >> JsonModifyRacialType: JsonGetType error 2: " + JsonGetError(jRacialTypeValue));
		//SpeakString("JsonGetType error 2: " + JsonGetError(jRacialTypeValue));
        return JsonNull();
    }

	jCreature = GffReplaceByte(jCreature, "Race", nNewRacialType);

    // Return the new creature object
    return jCreature;
}

void CleanCopy(object oImage)
{
    SetLootable(oImage, FALSE);
    // remove inventory contents
    object oItem = GetFirstItemInInventory(oImage);
    while(GetIsObjectValid(oItem))
    {
        SetPlotFlag(oItem,FALSE);
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                object oItem3 = GetFirstItemInInventory(oItem2);
                while(GetIsObjectValid(oItem3))
                {
                    SetPlotFlag(oItem3,FALSE);
                    DestroyObject(oItem3);
                    oItem3 = GetNextItemInInventory(oItem2);
                }
                SetPlotFlag(oItem2,FALSE);
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oImage);
    }
    // remove non-visible equipped items
    int i;
    for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
    {
        oItem = GetItemInSlot(i, oImage);
        if(GetIsObjectValid(oItem))
        {
            if(i == INVENTORY_SLOT_HEAD || i == INVENTORY_SLOT_CHEST ||
                i == INVENTORY_SLOT_RIGHTHAND || i == INVENTORY_SLOT_LEFTHAND ||
                i == INVENTORY_SLOT_CLOAK) // visible equipped items
            {
                SetDroppableFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, TRUE);
                // remove all item properties
                itemproperty ipLoop=GetFirstItemProperty(oItem);
                while (GetIsItemPropertyValid(ipLoop))
                {
                    RemoveItemProperty(oItem, ipLoop);
                    ipLoop=GetNextItemProperty(oItem);
                }
            }
            else // can't see it so destroy
            {                
                SetPlotFlag(oItem,FALSE);
                DestroyObject(oItem);
            }
        }
        
    }
    TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void MakeMoreImages(object oImage, int iImages, int nDuration)
{
    string sImage = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";
	
	object oMaster = OBJECT_SELF;

    if (!GetIsObjectValid(oMaster)) 
    {
        DoDebug("sp_mirror >> MakeMoreImages: oMaster invalid.");
        return;
    }

	SetLocalObject(oImage, "oMaster", oMaster);

    effect //eImage = EffectCutsceneParalyze();
           eImage = SupernaturalEffect(eImage);
    effect eGhost = EffectCutsceneGhost();
           eGhost = SupernaturalEffect(eGhost);
    effect eNoSpell = EffectSpellFailure(100);
           eNoSpell = SupernaturalEffect(eNoSpell);
	effect eSpeed = EffectMovementSpeedIncrease(200);
			eSpeed = SupernaturalEffect(eSpeed);
	
    int iPlus;
    for (iPlus = 0; iPlus < iImages; iPlus++)
    {
        object oImage2 = CopyObject(oImage, GetLocation(OBJECT_SELF), OBJECT_INVALID, sImage);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImage, oImage2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoSpell, oImage2);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oImage2);
        ChangeFaction(oImage2, oImage);
        SetIsTemporaryFriend(OBJECT_SELF, oImage2, FALSE);
		DelayCommand(0.0f, SetMirrorImageScripts(oImage2));
        DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oImage2));
		StartMirrorImageTracking(oImage2, OBJECT_SELF);
        DestroyObject(oImage2, TurnsToSeconds(nDuration)); // they dissapear after a minute per level
    }
}

void RemoveExtraImages()
{
    string sImage1 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";
    string sImage2 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
    {
        if(GetTag(oCreature) == sImage1 || GetTag(oCreature) == sImage2)
        {
            DestroyObject(oCreature, 0.0);
        }
        oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
    }
}

void main2()
{
    object oCaster = OBJECT_SELF;
	
	int iLevel = PRCGetCasterLevel(oCaster);
    int iAdd = iLevel/3;
    int iImages = d4(1) + iAdd;
    if(iImages >8)
        iImages = 8;
    int nDuration = iLevel;
    //Enter Metamagic conditions
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }    

    string sImage = "PC_IMAGE"+ObjectToString(oCaster)+"mirror";

    effect //eImage = EffectCutsceneParalyze();
           eImage = SupernaturalEffect(eImage);
    effect eGhost = EffectCutsceneGhost();
           eGhost = SupernaturalEffect(eGhost);
    effect eNoSpell = EffectSpellFailure(100);
           eNoSpell = SupernaturalEffect(eNoSpell);
	effect eSpeed = EffectMovementSpeedIncrease(200);
			eSpeed = SupernaturalEffect(eSpeed);		   

	//:: Convert to a construct. 
	object oImage;	
	json jImage = ObjectToJson(oCaster);
	
	jImage = JsonModifyRacialType(jImage, RACIAL_TYPE_CONSTRUCT);

	oImage = JsonToObject(jImage, GetLocation(oCaster));
	
	if (!GetIsObjectValid(oImage))
	{
		DoDebug("sp_mirror: Image failed to spawn");
		//SpeakString("Image failed to spawn.");
		return;
	}
	
    // make, then clean up, first image and copy it, not the PC for subsequent images
    //object oImage = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, sImage);

	SetTag(oImage, sImage);
	
	CleanCopy(oImage);
    
	// images will have only 1 HP
    int iHP = GetCurrentHitPoints(oImage);
    --iHP;
    effect eDamage = PRCEffectDamage(oImage, iHP); // reduces image to 1 hp	

    // these need to be applied to every image
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImage, oImage);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoSpell, oImage);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oImage);   
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oImage);	
	
	SetMirrorImageScripts(oImage);
	
	DelayCommand(0.0, SetLocalObject(oImage, "oMaster", oCaster));

    if(!GetIsPC(oCaster))
        ChangeFaction(oImage, oCaster);
    else
        ChangeToStandardFaction(oImage, STANDARD_FACTION_DEFENDER);
	
    SetIsTemporaryFriend(oCaster, oImage, FALSE);
    DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oImage));
	StartMirrorImageTracking(oImage, OBJECT_SELF);
    DestroyObject(oImage, TurnsToSeconds(nDuration)); // they dissapear after a minute per level
    
    --iImages; // made one already
    DelayCommand(0.2, MakeMoreImages(oImage, iImages, nDuration));
}

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    DelayCommand(0.0, RemoveExtraImages());
    DelayCommand(0.1, main2());

	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
