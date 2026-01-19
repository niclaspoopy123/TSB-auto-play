# Combat Enhancement Features - Implementation Guide

## Overview
This document describes the newly implemented combat enhancement features for the TSB Auto-Play AI bot. These features make the bot significantly harder to beat and more intelligent in combat.

## New Features

### 1. CombatConfig Table
Located at the top of the Main script (around line 489), this configuration table allows easy customization of all combat behaviors.

**Configuration Options:**
```lua
CombatConfig = {
    GodMode = false,              -- Instant reaction to dangerous animations
    TechRate = 0.3,               -- Tech execution probability (0.0-1.0)
    Playstyle = "Adaptive",       -- Combat style (see below)
    AutoParry = false,            -- Perfect block system (experimental)
    WinProbabilityEnabled = true, -- Adaptive playstyle based on HP
    WakeUpTechEnabled = true,     -- Anti-Okizeme system
    -- ... and more
}
```

### 2. God Reflex Mode ⚡
**Location:** Lines 593-638 in Main

**What it does:**
- Monitors opponent animations in real-time
- Instantly dodges dangerous moves (Ultimates, Guard Breaks, etc.)
- Bypasses the learning network for 0ms reaction time

**How to enable:**
```lua
CombatConfig.GodMode = true
```

**How to configure dangerous animations:**
```lua
CombatConfig.DangerousAnimations = {
    ["rbxassetid://123456789"] = true, -- Add animation IDs here
}
```

**How it works:**
- Monitors opponent's Animator for playing animation tracks
- Checks animation IDs against DangerousAnimations table
- Also detects animations with "ultimate", "guard", "break", or "finisher" in name
- Triggers instant side dash with 100% probability

### 3. Tech Consistency Sliders 🎯
**Location:** Lines 540, 560

**What it does:**
- Replaces hardcoded 30% tech probability with configurable rate
- Allows 100% perfect tech execution for maximum performance

**How to use:**
```lua
CombatConfig.TechRate = 1.0  -- 100% tech execution
CombatConfig.TechRate = 0.5  -- 50% tech execution
CombatConfig.TechRate = 0.3  -- 30% tech execution (default)
```

**Affects:**
- Dash Tech (attack animation canceling)
- Side Dash Tech (combo repositioning)

### 4. Playstyle Modes 🎮
**Location:** Line 493, implemented in lines 6432-6457

**Available Playstyles:**
- **"Adaptive"** - Automatically adjusts based on Win Probability (default)
- **"Passive"** - Whiff punish only, never attack first
- **"Aggressive"** - Constant pressure and offense
- **"Defensive"** - Focus on blocking and evasion
- **"Chaotic"** - High randomness, unpredictable

**Passive Mode (Whiff Punish):**
When set to "Passive", the bot:
- Holds block or dashes away when enemy attacks
- Only attacks during punish windows (after enemy misses)
- Keeps distance by default
- Makes the bot extremely hard to hit

```lua
CombatConfig.Playstyle = "Passive"
```

### 5. Auto-Parry / Perfect Block System 🛡️
**Location:** Lines 647-703

**What it does:**
- Monitors opponent animations for attack windups
- Calculates optimal parry timing based on move type
- Executes perfect blocks with precise timing

**How to enable:**
```lua
CombatConfig.AutoParry = true
```

**Windup Configuration:**
```lua
CombatConfig.ParryWindupTable = {
    Punch = 0.3,    -- seconds
    Kick = 0.5,
    Special = 0.7,
    Ultimate = 1.0,
}
```

**How it works:**
- Detects attack animations by name pattern matching
- Calculates: `parryTiming = windupTime - 0.15` (accounts for ping)
- Executes block at optimal moment for "Perfect Block"
- Includes cooldown to prevent spam

### 6. Win Probability Meta-Controller 🧠
**Location:** Lines 6388-6429

**What it does:**
- Calculates win probability based on HP ratio
- Automatically adjusts playstyle based on match state
- Makes intelligent risk/reward decisions

**Formula:**
```lua
winProb = myHP / (myHP + enemyHP)
```

**Behavior Modes:**

**Winning (80%+):**
- Switches to Defensive playstyle
- Only attacks during whiff punish opportunities
- Avoids risky moves
- Preserves HP advantage

**Losing (30%-10%):**
- Switches to Aggressive playstyle
- Increases randomness (Boltzmann temperature = 2.0)
- Takes more risks to comeback

**Critical (< 10%):**
- Uses Ultimate immediately if available
- Desperation mode for last-ditch effort

**Configuration:**
```lua
CombatConfig.WinProbabilityEnabled = true
CombatConfig.WinProbHighThreshold = 0.8   -- 80%
CombatConfig.WinProbLowThreshold = 0.3    -- 30%
CombatConfig.WinProbCriticalThreshold = 0.1 -- 10%
```

### 7. Wake-Up Tech (Anti-Okizeme) 🌟
**Location:** Lines 705-756

**What it does:**
- Detects when player wakes up from ragdoll
- Instantly performs defensive tech
- Exploits invulnerability frames

**How to enable:**
```lua
CombatConfig.WakeUpTechEnabled = true
```

**Behavior:**
- 70% chance: Side dash for safety
- 30% chance: Counter attack

**How it works:**
- Monitors HumanoidState for ragdoll transitions
- Detects: Ragdoll → Standing/GettingUp transition
- Executes instant side dash or counter move
- Includes cooldown (2.0s) to prevent spam

### 8. PretrainedData Module 📊
**Location:** PretrainedData.lua (new file)

**What it does:**
- Provides default weights when no save file exists
- Accelerates initial learning
- Contains optimized starting values

**Contents:**
- ActionStats (Q-values for all tactics)
- FeatureWeights (optimal starting weights)
- ZoneAdaptation (default ranges)
- MetaLearning parameters
- Character-specific models

**Integration:**
Automatically loaded when no persistence file exists (line 224-256)

## Usage Examples

### Example 1: Maximum Competitive Setup
```lua
CombatConfig.GodMode = true          -- Instant ultimates dodge
CombatConfig.TechRate = 1.0          -- Perfect tech every time
CombatConfig.AutoParry = true        -- Perfect blocks
CombatConfig.Playstyle = "Adaptive"  -- Smart adaptation
CombatConfig.WinProbabilityEnabled = true
CombatConfig.WakeUpTechEnabled = true
```

### Example 2: Defensive Wall
```lua
CombatConfig.GodMode = false
CombatConfig.TechRate = 0.7
CombatConfig.AutoParry = true
CombatConfig.Playstyle = "Passive"   -- Only whiff punish
CombatConfig.WinProbabilityEnabled = false
```

### Example 3: Aggressive Rushdown
```lua
CombatConfig.GodMode = false
CombatConfig.TechRate = 0.5
CombatConfig.Playstyle = "Aggressive"
CombatConfig.WinProbabilityEnabled = true
```

## Debug Mode
Enable debug output to see the systems in action:
```lua
CONST.DEBUG_MODE = true
```

**Debug messages you'll see:**
- `⚡ GOD MODE: Detected dangerous animation!`
- `🛡️ AUTO-PARRY executed!`
- `🌟 WAKE-UP TECH: Side dash executed!`
- `🎯 META-CONTROLLER: Winning (85%) - Defensive Mode`
- `🎯 PASSIVE WHIFF PUNISH: Attack executed!`
- `💥 META-CONTROLLER: DESPERATION ULTIMATE!`

## Performance Impact
All new features are designed to be lightweight:
- God Mode: Minimal overhead, only active when enabled
- Auto-Parry: Checks only when AutoParry = true
- Wake-Up Tech: Single state check per frame
- Win Probability: Simple calculation once per frame
- Passive Mode: Early return, reduces processing

## Customization Tips

1. **For maximum difficulty:**
   - Enable GodMode and set TechRate to 1.0
   - Use Adaptive playstyle with WinProbability enabled

2. **For human-like behavior:**
   - Keep GodMode disabled
   - Set TechRate between 0.3-0.5
   - Use Adaptive playstyle

3. **For specific scenarios:**
   - Use Passive against aggressive players
   - Use Aggressive when you need quick wins
   - Use Defensive to preserve leads

## Troubleshooting

**Issue:** God Mode not working
- Check that CombatConfig.GodMode = true
- Add specific animation IDs to DangerousAnimations table
- Enable DEBUG_MODE to see detection messages

**Issue:** Auto-Parry timing off
- Adjust ParryWindupTable values for your game
- Account for your ping (reduce windup times if high ping)
- May need per-move calibration

**Issue:** Wake-Up Tech not triggering
- Check that WakeUpTechEnabled = true
- Ensure humanoid object is valid
- Verify ragdoll state detection

## Future Enhancements
Potential additions:
- Animation ID learning system
- Adaptive parry timing based on ping
- Player pattern recognition for counter-play
- Combo prediction system
- Energy management optimization

## Credits
Implemented as requested in GitHub issue for TSB Auto-Play enhancement.
Features based on competitive fighting game mechanics and professional AI techniques.
