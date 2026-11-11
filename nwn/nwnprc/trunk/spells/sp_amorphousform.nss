//::////////////////////////////////////////////////////////  
//::	Name	Amorphous Form  
//::	FileName	sp_amorphousform.nss  
//::////////////////////////////////////////////////////////  
/**@file Amorphous Form
Transmutation
Level: Assassin 3, Sorcerer 3, Wizard 3,
Components: S, M,
Casting Time: 1 standard action
Range: Touch
Target: Willing corporeal creature touched
Duration: 1 round/level (D)
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You dust your ally with gelatin and silently evoke the spell. 
Immediately her bones begin to soften and she and her belongings 
slump, becoming malleable ooze.

The subject and all its gear become amorphous and oozelike. 
This new form is boneless and fluid, enabling the subject to 
pass through holes or narrow openings as small as 2 inches in 
diameter. While amorphous, the subject is immune to poison, 
polymorphing, and stunning, it cannot be flanked, and it is 
not subject to extra damage from critical hits. It gains a 
swim speed (if it does not have one already) equal to its 
land speed. The subject can remain submerged as long as 
desired without breathing.

The subject's armor (including natural armor) becomes 
worthless, though its modifiers for size, Dexterity, and 
deflection still apply to Armor Class, as do armor bonuses 
from force effects (for example, from the mage armor spell). 
While amorphous, the subject can't attack or cast spells 
that require verbal, somatic, material, or focus components. 
(This limitation does not rule out the casting of any spells 
that the subject might have prepared using the metamagic 
feats Eschew Materials, Silent Spell, and Still Spell.) 
The subject loses all supernatural abilities while in 
amorphous form, and its magic items, aside from those bonuses 
noted above, cease functioning as long as it remains amorphous.

Material Component: A pinch of gelatin.
 
*/  
//::////////////////////////////////////////////////////////  
//::	Created by: Jaysyn  
//::	Date:	2026-11-05 10:31:36
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_shifting" 
  
// DelayCommand requires an action (void); UnShift returns int.  
void AmorphousUnshift(object oTarget)  
{  
    UnShift(oTarget);  
}  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    object oCaster    = OBJECT_SELF;  
    object oTarget    = PRCGetSpellTargetObject();  
    int    nCasterLvl = PRCGetCasterLevel(oCaster);  
    int    nMetaMagic = PRCGetMetaMagicFeat();  
    int    nSpellID   = PRCGetSpellId();  
    float  fDur       = RoundsToSeconds(nCasterLvl);  
    if (nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;  
  
    // Willing targets only: must be an ally or associate of the caster  
    if (!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))  
    {  
        FloatingTextStringOnCreature("Target must be a willing ally.", oCaster);  
        PRCSetSchool();  
        return;  
    }  
  
    // Harmless signal for AI  
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));  
  
    if (ShiftIntoResRef(oTarget, SHIFTER_TYPE_POLYMORPH, "your_ooze_resref"))  
    {  
        // Force the casting restriction regardless of the template's CanCast flag.  
        // ShifterCasting() in x2_inc_spellhook honors Still/Silent/auto-still/auto-silent.  
        SetLocalInt(oTarget, SHIFTER_RESTRICT_SPELLS, TRUE);  
  
        // Duration expiry -> unshift  
        DelayCommand(fDur, AmorphousUnshift(oTarget));  
    }  
  
    PRCSetSchool();  
}