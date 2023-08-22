/*
   ----------------
   Energy Ray
   
   race_enray.nss
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   You create a ray of energy of the chosen type that shoots forth from your finger tips,
   doing 1d6+1 elemental damage on a successful ranged touch attack.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6+1. 
*/

const int RACE_POWER_ENERGYRAY_COLD     = 1985;
const int RACE_POWER_ENERGYRAY_ELEC     = 1986;
const int RACE_POWER_ENERGYRAY_FIRE     = 1987;
const int RACE_POWER_ENERGYRAY_SONIC    = 1988;

#include "psi_inc_psifunc"

void main()
{
    int nSpellID = GetSpellId();
    int nPower;
    switch (nSpellID)
    {
    case RACE_POWER_ENERGYRAY_COLD:
        nPower = POWER_ENERGYRAY_COLD;
        break;
    case RACE_POWER_ENERGYRAY_ELEC:
        nPower = POWER_ENERGYRAY_ELEC;
        break;
    case RACE_POWER_ENERGYRAY_FIRE:
        nPower = POWER_ENERGYRAY_FIRE;
        break;
    case RACE_POWER_ENERGYRAY_SONIC:
        nPower = POWER_ENERGYRAY_SONIC;
        break;
    }
    UsePower(nPower, CLASS_TYPE_INVALID, TRUE, GetHitDice(OBJECT_SELF)/2);
}