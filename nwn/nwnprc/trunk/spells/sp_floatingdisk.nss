/*
Tenser's Floating Disk script

This spell will conjure a hovering Disk of magical force that will carry items
for the caster.  The Disk cannot be damaged, but will vanish after

Tenser's Floating Disk (3.0 PH) 

Evocation [Force] 
Level:             Sor/Wiz 1
Components:        V, S, M
Casting Time:      1 action
Range:             Close (25' + 5'/2 levels)
Effect:            3 foot diameter disk of force
Duration:          1 hour per caster level
Saving Throw:      None
Spell Resistance:  No

The caster creates a slightly concave circular plane of force that will follow him carrying what is placed upon it. The disk can hold 100 pounds of weight per caster level (if used to transport a liquid, the capacity is 2 gallons). The disk floats approximately 3 feet above the ground and 5 feet behind the caster at all times and remains level. Some adjustment can occur due to stairs or other consideration (concentration necessary for caster to direct disk), but the disk will remain level and cannot change in size, so that tight steep shaft might not be accessibly by the disk.

The disk will wink out of existence when the spell duration expires, dropping what it was holding. The disk moves at 30 feet per round, and the spell also ends if the caster moves away from the disk further than the maximum range of the spell. The caster needs to assure a stable path for the spell, as the disk will wink out if the floor suddenly drops away beneath it.

Material Component: A drop of mercury.

Created by: The Amethyst Dragon (www.amethyst-dragon.com/nwn)
Created: June 18, 2008
*/

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;

    //Enter Metamagic conditions
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (nMetaMagic & METAMAGIC_EXTEND)
       {
           nDuration = nDuration *2; //Duration is +100%
       }

    // Visuals
    int nVisual;
    switch(Random(7))
       {
       case 0: nVisual = VFX_DUR_FLOATING_DISK_BLUE  ; break;
       case 1: nVisual = VFX_DUR_FLOATING_DISK_GREEN ; break;
       case 2: nVisual = VFX_DUR_FLOATING_DISK_YELLOW; break;
       case 3: nVisual = VFX_DUR_FLOATING_DISK_ORANGE; break;
       case 4: nVisual = VFX_DUR_FLOATING_DISK_RED   ; break;
       case 5: nVisual = VFX_DUR_FLOATING_DISK_PURPLE; break;
       case 6: nVisual = VFX_DUR_FLOATING_DISK_GREY  ; break;
       }

    effect eDisk = EffectVisualEffect(nVisual);
    effect eVisual = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual, lTarget);

    // The actual conjuration
    object oDisk = CreateObject(OBJECT_TYPE_CREATURE, "floatingDisk", lTarget);
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eDisk), oDisk);
    SetLocalObject(oDisk, "caster", oCaster);
    SetLocalInt(oDisk, "CasterLevel", nCasterLevel);
    SetLocalInt(oDisk, "nDuration", nDuration);
    SetLocalInt(oDisk, "Weight_Limit", nCasterLevel * 1000);

    //add Disk as henchman
    int nMaxHenchmen = GetMaxHenchmen();
    SetMaxHenchmen(99);
    AddHenchman(oCaster, oDisk);
    SetMaxHenchmen(nMaxHenchmen);

    PRCSetSchool();
}


