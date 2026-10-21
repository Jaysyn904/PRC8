//::////////////////////////////////////////////////////////
//::
/*
	Giant Vermin	(sp_giantvermin.nss)
	Transmutation
	Level: 				Cleric 4, Druid 4, Death Master 4, 
						Urban Druid 4, Dread Necromancer 4, 
						Spider 4,
	Components: 		V, S, DF,
	Casting Time: 		1 standard action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Target: 			Up to three vermin, no two of which 
						can be more than 30 ft. apart
	Duration: 			1 min./level
	Saving Throw: 		None
	Spell Resistance:	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	You turn three normal-sized centipedes, two normal-sized 
	spiders, or a single normal-sized scorpion into larger 
	forms.
	Only one type of vermin can be transmuted (so a single 
	casting cannot affect both a centipede and a spider), 
	and all must be grown to the same size.
	The size to which the vermin can be grown depends on 
	your level; see the table below.
	The Monster Manual has game statistics for centipedes, 
	spiders, and scorpions, as well as other kinds of vermin.
	Any giant vermin created by this spell do not attempt 
	to harm you, but your control of such creatures is 
	limited to simple commands ("Attack", "Defend", 
	"Stop", and so forth).
	Orders to attack a certain creature when it appears 
	or guard against a particular occurrence are too 
	complex for the vermin to understand.
	Unless commanded to do otherwise, the giant vermin 
	attack whoever or whatever is near them.
	The DM can extend this spell's effects to other kinds 
	of insects, arachnids, or other vermin, such as ants, 
	bees, beetles, praying mantises, and wasps, if he so 
	chooses.

	PnP size targets (all base blueprints are Medium):  
	CL  9-13 -> Large       (1 step)  
	CL 14-17 -> Huge        (2 steps)  
	CL 18-19 -> Gargantuan  (3 steps)  
	CL 20+   -> Colossal    (4 steps)  
	3 centipedes / 2 spiders / 1 scorpion per casting,  
	chosen via spell radial (GetSpellId).  
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-09 23:10:37
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_inc_size"

void GVEnlargeSummons(object oCaster, string sResRef, int nSteps, float fDur);

//::////////////////////////////////////////////////////////  
//:: EffectCreatureSizeChange  
//:: PnP "Changes to Statistics by Size" table — cumulative  
//:: per boundary crossed, walked from PRCGetCreatureSize.  
//::////////////////////////////////////////////////////////  
effect EffectCreatureSizeChange(object oTarget, int bEnlarge, int nChanges)  
{  
    effect eBlank;  
  
    int nGeneration = PRC_NextGeneration(GetLocalInt(oTarget, "PRC_SIZE_GENERATION"));  
    SetLocalInt(oTarget, "PRC_SIZE_GENERATION", nGeneration);  
  
    if(GetLocalFloat(oTarget, "PRC_ORIGINAL_SIZE") == 0.0f)  
    {  
        float fCurrentScale = GetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE);  
        SetLocalFloat(oTarget, "PRC_ORIGINAL_SIZE", fCurrentScale);  
        SetLocalInt(oTarget, "PRC_SIZE_GENERATION_INIT", TRUE);  
    }  
    float fOriginalSize = GetLocalFloat(oTarget, "PRC_ORIGINAL_SIZE");  
  
    int nSize = PRCGetCreatureSize(oTarget);   // effective current size  
    int nStr = 0, nDex = 0, nCon = 0, nNatAC = 0, nAtk = 0;  
    int i;  
  
    if(bEnlarge)  
    {  
        for(i = 0; i < nChanges; i++)  
        {  
            switch(nSize + i)   // category being stepped OUT of  
            {  
                case CREATURE_SIZE_FINE:                              nDex -= 2; nAtk -= 4; break;  
                case CREATURE_SIZE_DIMINUTIVE: nStr += 2; nDex -= 2;               nAtk -= 2; break;  
                case CREATURE_SIZE_TINY:       nStr += 4; nDex -= 2;               nAtk -= 1; break;  
                case CREATURE_SIZE_SMALL:      nStr += 4; nDex -= 2; nCon += 2;    nAtk -= 1; break;  
                case CREATURE_SIZE_MEDIUM:     nStr += 8; nDex -= 2; nCon += 4; nNatAC += 2; nAtk -= 1; break;  
                case CREATURE_SIZE_LARGE:      nStr += 8; nDex -= 2; nCon += 4; nNatAC += 3; nAtk -= 1; break;  
                case CREATURE_SIZE_HUGE:       nStr += 8;            nCon += 4; nNatAC += 4; nAtk -= 2; break;  
                case CREATURE_SIZE_GARGANTUAN: nStr += 8;            nCon += 4; nNatAC += 5; nAtk -= 4; break;  
            }  
        }  
        DelaySetVisualTransform(0.0f, oTarget, "PRC_SIZE_GENERATION",  
            OBJECT_VISUAL_TRANSFORM_SCALE, fOriginalSize * pow(1.5f, IntToFloat(nChanges)));  
    }  
    else  
    {  
        for(i = 0; i < nChanges; i++)  
        {  
            switch(nSize - i)   // category being stepped OUT of (reverse)  
            {  
                case CREATURE_SIZE_DIMINUTIVE:                       nDex += 2; nAtk += 4; break;  
                case CREATURE_SIZE_TINY:       nStr -= 2; nDex += 2;              nAtk += 2; break;  
                case CREATURE_SIZE_SMALL:      nStr -= 4; nDex += 2;              nAtk += 1; break;  
                case CREATURE_SIZE_MEDIUM:     nStr -= 4; nDex += 2; nCon -= 2;   nAtk += 1; break;  
                case CREATURE_SIZE_LARGE:      nStr -= 8; nDex += 2; nCon -= 4; nNatAC -= 2; nAtk += 1; break;  
                case CREATURE_SIZE_HUGE:       nStr -= 8; nDex += 2; nCon -= 4; nNatAC -= 3; nAtk += 1; break;  
                case CREATURE_SIZE_GARGANTUAN: nStr -= 8;            nCon -= 4; nNatAC -= 4; nAtk += 2; break;  
                case CREATURE_SIZE_COLOSSAL:   nStr -= 8;            nCon -= 4; nNatAC -= 5; nAtk += 4; break;  
            }  
        }  
        DelaySetVisualTransform(0.0f, oTarget, "PRC_SIZE_GENERATION",  
            OBJECT_VISUAL_TRANSFORM_SCALE, fOriginalSize / pow(1.5f, IntToFloat(nChanges)));  
    }  
  
    //:: Compose linked effect  
    effect eLink;  
    if(nStr)   eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH,     abs(nStr)));  
    if(nDex)   eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY,    abs(nDex)));  
    if(nCon)   eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, abs(nCon)));  
    if(nNatAC) eLink = EffectLinkEffects(eLink, EffectACIncrease(nNatAC, AC_NATURAL_BONUS));  
    if(nAtk)   eLink = EffectLinkEffects(eLink, EffectAttackDecrease(abs(nAtk)));  
  
    //:: Shrinking: invert signs  
    if(!bEnlarge)  
    {  
        // For reduce-side, negative deltas mean penalties; rebuild with decreases  
        eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, -nStr),  
                                  EffectAbilityDecrease(ABILITY_CONSTITUTION, -nCon));  
        eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, nDex));  
        eLink = EffectLinkEffects(eLink, EffectACDecrease(-nNatAC, AC_NATURAL_BONUS));  
        eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAtk));  
    }  
  
    SetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease", bEnlarge ? nChanges : -nChanges);  
    return eLink;  
}  
  
void main()  
{  
    if(!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    object oCaster    = OBJECT_SELF;  
    location lTarget  = PRCGetSpellTargetLocation();  
    int nCasterLvl    = PRCGetCasterLevel(oCaster);  
    int nMetaMagic    = PRCGetMetaMagicFeat();  
    int nSpellID      = PRCGetSpellId();  
  
    float fDur = TurnsToSeconds(nCasterLvl);   // 1 min/level  
    if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;  
  
    //:: Steps above Medium  
    int nSteps;  
    if     (nCasterLvl >= 20) nSteps = 4;   // Colossal  
    else if(nCasterLvl >= 18) nSteps = 3;   // Gargantuan  
    else if(nCasterLvl >= 14) nSteps = 2;   // Huge  
    else                      nSteps = 1;   // Large (CL 9-13; spell is level 4+ anyway)  
  
    //:: Radial selects vermin type + count  
    string sResRef;  
    int nCount;  
    if(nSpellID == 777777/* SPELL_GIANT_VERMIN_CENTIPEDE */)	{ sResRef = "prc_gv_centipede"; nCount = 3; }  
    else if(nSpellID == 666666/* SPELL_GIANT_VERMIN_SPIDER */)	{ sResRef = "prc_gv_spider";    nCount = 2; }  
    else /* SPELL_GIANT_VERMIN_SCORPION */						{ sResRef = "prc_gv_scorpion";  nCount = 1; }  
  
    MultisummonPreSummon();  
  
    int i;  
    for(i = 0; i < nCount; i++)  
    {  
        effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_1);  
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDur);  
    }  
  
    //:: Size-change each summon once it spawns  
    DelayCommand(0.5f, GVEnlargeSummons(oCaster, sResRef, nSteps, fDur));  
  
    AugmentSummonedCreature(sResRef);  
  
    PRCSetSchool();  
}  

//:: Apply the creature size effect to each summoned vermin  
void GVEnlargeSummons(object oCaster, string sResRef, int nSteps, float fDur)  
{  
    int i = 1;  
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);  
    while(GetIsObjectValid(oSummon))  
    {  
        if(GetResRef(oSummon) == sResRef && !GetLocalInt(oSummon, "PRC_GV_SIZED"))  
        {  
            SetLocalInt(oSummon, "PRC_GV_SIZED", TRUE);  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                EffectCreatureSizeChange(oSummon, TRUE, nSteps),  
                oSummon, fDur);  
        }  
        i++;  
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);  
    }  
}