// Works on Homecoming: City of Heroes version 27.3.4798.
// Poorly cobbled together and maintained by Bloodom#8540 on discord, let me know if you have questions or tips to improve this!

/* Known Issues: CoT doesn't currently split upon mission complete due to being a timed mission (value prior to mission complete is constantly changing) and not having a reward window pop-up. Missions can fail to split if waypointing to somewhere on the overworld map (causing it to be named in the Navigation
Status window, overriding anything that isn't a mission), since a majority of splits are triggered by the nav. status becoming Return to Contact or blank; a workaround has been implemented for doing this in the Shadow Shard but other zones may need to be looked at if its a common issue. Moreover, if you aren't 
the leader, the autosplitter can fail to split if the leader assigns a mission before you fully load out of a mission (effectively making the mission into an auto-assigned mission for you); many of the common places this occurs have been accounted for, but many still exist. Missions that involve clicking a object 
in an overworld zone have separate MissionSelected values for when you're in that zone and not; this has been accounted for in Faathim, but there may be more instances I haven't thought of. */

state("cityofheroes", "Homecoming")
{
    int MissionSelected: 0xC0F538, 0x50, 0x10; // Navigation Status Window. MissionSelected should be 1068641 on Return to Contact, 16777216 on no mission, and 269502050 when mission is complete but the player is still in the mission (as well as other niche cases).
    int TeamLock: 0xA13DE8, 0x8, 0x58; // Team is locked/unlocked. TeamLock value should be 0 when the team is unlocked, and change to many different non-zero values throughout a TF/SF/Trial.
    int PopUp: 0x9E4048, 0x8DC; // Reward Window Pop-up. This address value will be 4 when no pop-up is visible, and a 2 after the pop-up is visible.
}

state("cityofheroes", "Cryptic")
{
    int MissionSelected: 0xBCF788, 0x50, 0x10; 
    int TeamLock: 0x9DC3E0, 0x8, 0x58; 
    int PopUp: 0x9AC648, 0x8DC; 
}

state("cityofheroes", "Brainstorm")
{
    int MissionSelected: 0xC0E538, 0x50, 0x10; 
    int TeamLock: 0xA12DE8, 0x8, 0x58; 
    int PopUp: 0x9C1AB0, 0x8DC; 
}

startup
{
    // Commonly used static values.
    vars.MissionComplete = 269502050;
    vars.ReturnToContact = 1068641;
    vars.NoMission = 16777216;
    vars.Locked = 0;
    vars.NoPopUp = 4;

    // List of integers associated with the MissionSelected value of a location on the overworld map.
    vars.maplocation = new List<int> 
    {
        /* General */ 2114843905, 336447467,
        /* The Chantry */ 1242344912, -1810884738, 1645105185, 302946588, -569460932, -1089517987, -502286754, 1141865036, -1844622067, 756014409, 1527724109, -1559290020,
        /* Cascade Archipelago */ -1962077182, -871354484, 1007585824, -552667836, 1477371944, 2064676732, 1578003233,
        /* Firebase Zulu */ -1928346032, 1997536852, -485609678, -2129837309, 17742610, 1275983616, -267401633, -1811087100, 302927123, 1393457184, -1794250493, -1861349085, 437070325,
        /* The Storm Palace */ -569475014, -66219493, 1510880042, 1729015338, -1257417970, -1559193475, -334675950
    };

    // List of integers associated with the MissionSelected value of an auto-assigned mission or a sub-objective. 
    vars.autoassigned = new List<int>
    {
        /* Positron pt. 1 */ -1557797646, -517484794, -1842574541,
        /* Positron pt. 2 */ 606728755, -366196208, 1529373685,
        /* Virgil Tarikoss */
        /* Synapse */ -1456986590, -148312007, 1697018688, 1126714614, 875046629, 2032701202,
        /* Silver Mantis */
        /* Penelope Yin */ 1512556418, 590244023, -500204358,
        /* Moonfire */ -954086547, 690467466, 1864490048,
        /* SF Op. Renault */ -1842745962, 2066277709, -1423628856, -534556122, -1993822432,  
        /* Citadel */ -1574452042, 
        /* Ernesto Hess */ -1188651435, -1104796329, 1764164503,
        /* Katie Hannon */
        /* Manticore */ -2044431247, 975869641, 120059257, 1445430688, 1462234495, 
        /* Ice Mistral */ 1193636781,
        /* Numina */ 2512922, -1205218862, 1093289739, 942200110, 657004434, 1395255192, 539539747, 1680538149, -1406485416, -399584077, -1993809850, 1059781897, -366381309, 1965964381, 1798223597, -1238707636,
        /* Mortimer Kal */ 1211125201, -64631546, 1681642647,
        /* Admiral Sutter */ 136712442, -2111601413,
        /* Dr. Aeon */ 1495798634, -1658059990, 1211306078, 925982979, -1959697871,
        /* Dr. Quaterfield */ -1910099413, 925206178,
        /* Sara Moore */
        /* Justin Augustine */ -1306076579, -2144879181,
        /* Faathim the Kind */ -1205297607, 1462304526, -601124419, -1070989381, -1741791731, -1725775181, 1780729061, 1613089470, -1021004653, -1037871066, 472354437, -1255833340, -1255833340,
        /* Imperious */
        /* Lord Recluse */
        /* Ms. Liberty */        
        /* Lady Grey */
        /* Barracuda */ -1205383759, -702365009, -1524487784, -1943289237,
        /* Dr. Kahn */
        /* Tin Mage Mk. II */ -316347995, 1110496666, 1009849786, 1613774055,
        /* Apex */ 1227958122, 137304902, 1865395608, 
        /* Cavern of Transcendence */
        /* Tree of Thorns (1) */
        /* Terror Volta (1) */ 690613405,
        /* Tree of Thorns (2) */
        /* Terror Volta (2) */
        /* Descent to the Hydra */ 2119172230,
        /* Prisoners of Eden */ -48054279, -2075576774,
        /* Market Crash */ -1825859210, -835203351,
        /* Tree of Thorns (3) */
        /* Terror Volta (3) */ -1054439848, 438748461
    };

    // List of integers associated with the MissionSelected value when a contact's name is in the navigation status.
    vars.tfcontact = new List<int>
    {
        /* Virgil Tarikoss */ 1309638721, -1037935653,
        /* Synapse */ 1410119889, -1105228143,
        /* Silver Mantis */ 1913530658, -752699972,
        /* Penelope Yin */ -116583149, -1457304575, 
        /* Moonfire */ -1341374498, -266356050,
        /* SF Op. Renault */ -1139509936, 489284439,
        /* Citadel */ 655135439, -836775518,
        /* Ernesto Hess */ 68044307, 1143065900, 
        /* Katie Hannon */ -519208176, -752884832,
        /* Manticore */ 319644651, 1646316983,
        /* Ice Mistral */ 2114819841, -2044676873,
        /* Numina */ -653578556, -2128546842,
        /* Mortimer Kal */ -133323757, 1495436434,
        /* Dr. Aeon */ -133473323, 1813975217,
        /* Dr. Quaterfield */ -351348679, 86181325,
        /* Sara Moore */ 437089780, 1713587695,
        /* Justin Augustine */ -1022373806, 102993354,
        /* Faathim the Kind */ 303006281, 1428306075,
        /* Imperious */ 772631020, -1994412423,
        /* Lord Recluse */ -183669231, 639734283,
        /* Ms. Liberty */ 1510802687, 170088647,
        /* Lady Grey */ -217212390, 623030419,
        /* Barracuda */ -166981654, 656435630, 
        /* Dr. Kahn */ -150248747, -1625288193, 
        /* Tin Mage Mk. II */ -1827746494, -987618336, 
        /* Apex */ -16098901, 824125305, 
        /* Tree of Thorns (1) */ -284330488, -1826399759,
        /* Terror Volta (1) */ 1108227614, -232533475,
        /* Tree of Thorns (2) */ -284312824, -1826382095, 
        /* Terror Volta (2) */ -1223634036, 1596314062,
        /* Descent to the Hydra */ -770705571, -1641882956,
        /* Market Crash */ -1173454803, 941839322,
        /* Tree of Thorns (3) */ -284343032, -1826412303,
        /* Terror Volta (3) */ 1209028219, -1926890802
    };

    // List of integers associated with the MissionSelected value of a out-of-mission navigation status, following a mission where the team leader is likely to call in the mission before the player can load in.
    vars.aftercalled = new List<int>
    {
        /* Positron pt. 1 */
        /* Positron pt. 2 */
        /* Virgil Tarikoss */
        /* Synapse */
        /* Silver Mantis */
        /* Penelope Yin */
        /* Moonfire */
        /* SF Op. Renault */ 
        /* Citadel */
        /* Ernesto Hess */
        /* Katie Hannon */
        /* Manticore */
        /* Ice Mistral */
        /* Numina */
        /* Mortimer Kal */
        /* Admiral Sutter */
        /* Dr. Aeon */ 1042828100, /* Mission 2 to 3 */ 1479035226, /* Mission 3 to 4 */ 858712818, /* Mission 5 to 6 */
        /* Dr. Quaterfield */
        /* Sara Moore */
        /* Justin Augustine */
        /* Faathim the Kind */
        /* Imperious */
        /* Lord Recluse */ -903477954, /* Mission 2 to 3 */
        /* Ms. Liberty */ -853041477, /* Mission 2 to 3 */
        /* Lady Grey */
        /* Barracuda */
        /* Dr. Kahn */ -1775820126, /* Mission 3 to 4/5 */
        /* Tin Mage Mk. II */ -1792523463, /* Mission 1 to 2 */
        /* Apex */ -1389951275, /* Mission 1 to 2 */
        /* Cavern of Transcendence */
        /* Tree of Thorns (1) */
        /* Terror Volta (1) */
        /* Tree of Thorns (2) */
        /* Terror Volta (2) */
        /* Descent to the Hydra */
        /* Prisoners of Eden */
        /* Market Crash */ -1356282845 /* Mission 2 to 3 */
        /* Tree of Thorns (3) */
        /* Terror Volta (3) */
    };

    // List of integers associated with the MissionSelected value of a TF/SF/Trial's overworld glowies when in the relevant zone.
    vars.clicky = new List<int>
    {
        /* Faathim */ 1579718438, -1138180784, 1512690316, -920107948, 388511491, 86752840,
        /* Justin Augustine */ -752614001, -1742396194, 1344607165, 287718408, -131667870, -1960440777, 958751927, -685423378, -1272623131, 
    };

    // List of integers associated with the MissionSelected value of a TF/SF/Trial's overworld glowies when not in the relevant zone.
    vars.altclicky = new List<int>
    {
        /* Faathim */ -1574812217, 2329579, -1641820387, 220414702, 1528976808, 1227226302,
        /* Justin Augustine */ -1189073654, 2116146512, 908188722, 539097134, 119728509, -1709074857, 522267182, -1121894306, -1709061034,
    };


    // List of integers associated with the MissionSelected value of a TF/SF/Trial's final mission directly before completion, or the MissionSelected value of a mission with irregular values upon mission complete not covered by the general purpose splitter.
    vars.finalmissions = new List<int>
    {
        /* Positron pt. 1 */ 673340304, 220126759, 724059917,
        /* Positron pt. 2 */ 1244497305, -734852121, -717608851,
        /* Virgil Tarikoss */ -970969821, -1524501937,
        /* Synapse */ 941900130,
        /* Silver Mantis */ -1188237810,
        /* Penelope Yin */ 993134880,
        /* Moonfire */ 1478315487,
        /* SF Op. Renault */ -400481922,
        /* Citadel */ 757276148,
        /* Ernesto Hess - Refer to the exceptions split for this TF's completion split condition. */
        /* Katie Hannon */ -1491142062,
        /* Manticore */ 1764427412, 590026053,
        /* Ice Mistral */ 1763561186,
        /* Numina */ -332879788,
        /* Mortimer Kal */ -64631546,
        /* Admiral Sutter */ -1154966475,
        /* Dr. Quaterfield */ 555916427,
        /* Sara Moore */ -802526156,
        /* Justin Augustine */ -2144879181,
        /* Faathim the Kind */ 942145218,
        /* ! Cavern of Transcendence - Timed mission that doesn't end in a reward window pop-up, meaning none of the currently used methods can properly split. */
        /* Market Crash */ -30493455, -835203351, 1177332942
    };
}

init
{
    // Enable below if issues with version occurs after an update.
    //print(modules.First().ModuleMemorySize.ToString());

    // Sets the proper server based on which is open.
    switch (modules.First().ModuleMemorySize)
    {
        case 23912448: version = "Homecoming";
        break;
        case 23425024: version = "Cryptic";
        break;
        case 23908352: version = "Brainstorm";
        break;
        default: version = "Unknown!";
        break;
    }
}

start
{
    // Starts the split once the TF/SF/Trial is started.
    if(old.TeamLock == vars.Locked && current.TeamLock != vars.Locked)
    {
        //print("Run Started");
        return true;
    }
}

split
{
    // Splitter associated with maplocation list, as well as a general purpose splitter. Splits upon exiting a mission and getting vars.ReturnToContact or vars.NoMission value, while accounting for the situation where those values are replaced by a maplocation value.
    // Merged with splitter associated with aftercalled and tfcontact lists. Accounts for when the leader calls in a mission and the team member using LiveSplit isn't loaded out prior to the next mission being set.
    if(old.MissionSelected != vars.NoMission 
        && old.MissionSelected != vars.ReturnToContact 
        && old.MissionSelected != current.MissionSelected
        && ((!vars.maplocation.Contains(old.MissionSelected) && (vars.maplocation.Contains(current.MissionSelected) || current.MissionSelected == vars.NoMission || current.MissionSelected == vars.ReturnToContact) && old.MissionSelected != vars.MissionComplete)
        || (vars.aftercalled.Contains(current.MissionSelected) && !vars.tfcontact.Contains(old.MissionSelected))))
    {
        //print("General & Teammate Loading Split");
        return true;
    }

    // Splitter associated with tfcontact list. Accounts for when the leader is calling in a mission they were not inside of when completed (or just a niche situation where the value outside of the mission is equal to vars.MissionComplete) and calling the contact (i.e. having the contact name appear in the nav. status) would bypass the general split condition.
    else if(old.MissionSelected == vars.MissionComplete 
        && (vars.tfcontact.Contains(current.MissionSelected) || current.MissionSelected == vars.NoMission || current.MissionSelected == vars.ReturnToContact))
    {
        //print("Contact Split");
        return true;
    }

    // Splitter associated with the autoassigned list. Accounts for auto-assigned missions and any sub-objectives players want in the splits on a case-by-case basis.
    else if(vars.autoassigned.Contains(current.MissionSelected) 
        && old.MissionSelected != current.MissionSelected)
    {
        //print("Auto-assigned/Sub-objective Split");
        return true;
    }

    // A few exceptions that need their own splits.
    else if(old.MissionSelected != current.MissionSelected 
        && ((old.MissionSelected == -1876869296 && current.MissionSelected == 1982174151) // Split for the final mission of Ernesto Hess, due to the Find Exit value transition upon completion. This can't be added to the aftercalled list because the current.MissionSelected value is not unique.
        || (old.MissionSelected == -1641398002 && current.MissionSelected != -2092671484)  // Sub-objective for ripples on Mission 5 in Dr. Aeon SF, using the autoassigned list for this particular value was being funky. 
        || ((old.MissionSelected == -1608194966 || old.MissionSelected == -1524487784 || old.MissionSelected == vars.MissionComplete) && current.MissionSelected == -719063020) // Split for final mission of Barracuda, due to the final mission value being a mission with repeated value and an auto-assigned mission.
        || (!vars.altclicky.Contains(old.MissionSelected) && vars.clicky.Contains(current.MissionSelected) || !vars.clicky.Contains(old.MissionSelected) && vars.altclicky.Contains(current.MissionSelected)))) // Splitter to ensure overworld glowies split properly and don't double split if going between zones.
    {
        //print("Exception Split");
        return true;
    }

    // Splitter associated with finalmissions list. Accounts for the final split of a LiveSplit without needing to leave the mission. 
    else if(vars.finalmissions.Contains(old.MissionSelected) 
        && (current.MissionSelected == vars.MissionComplete || current.MissionSelected == vars.NoMission))
    {
        //print("Final Split");
        return true;
    }

    // PopUp completion split for Dr. Aeon, Imperious, Lord Recluse, Ms. Liberty, Lady Grey, Barracuda, Dr. Kahn, Tin Mage Mk. II, Apex, Tree of Thorns (1, 2, & 3), and Terror Volta (1, 2, & 3). Accounts for the final split of a LiveSplit without needing to leave the mission. 
    else if(old.PopUp == vars.NoPopUp && current.PopUp != vars.NoPopUp)
    {
        //print("PopUp Split");
        return true;
    }
}

reset
{
    // Resets the split upon quitting a TF/SF/Trial. 
    if(old.TeamLock != vars.Locked && current.TeamLock == vars.Locked)
    {
        //print("Team Unlocked");
        return true;
    }
}