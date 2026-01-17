# Local File Persistence Testing Guide

## Overview
This document provides testing instructions for the new local file persistence feature that allows the AI to save and restore learning data across script executions.

## Feature Description
The AI now uses exploit file system functions (`writefile`, `readfile`, `isfile`) to persist learning data to a local JSON file. This provides true persistence without requiring server-side access.

## What Data is Saved?
- **Core Learning Data**: ActionStats (Q-values), QNetworkB (Double Q-learning), FeatureWeights
- **Opponent Modeling**: TransitionTable, PerOpponentData (counter-intelligence)
- **Character Models**: Character-specific weights for each character played
- **Zone Adaptation**: Damage/death statistics by distance, optimal zone
- **Meta-Learning**: Adaptive learning rate, performance trend
- **Self-Play Statistics**: Win rates vs best weights
- **Session Data**: Total trials, score, identified character

## Save Triggers
Data is automatically saved:
1. **Every 100 trials** - Periodic checkpoint
2. **On enemy elimination** - After successful kill
3. **On player death** - Before respawn
4. **Manual via SaveCharacterModel()** - When character model updates

## Load Trigger
Data is automatically loaded:
- **On script initialization** - After InitializeDeepNetworks()

## File Location
- **Filename**: `TSB_AutoPlay_Data_{YourUserId}.json`
- **Location**: Workspace folder (exploit environment dependent)
  - Synapse X: `workspace` folder
  - KRNL: `workspace` folder
  - Other exploits: Check your exploit's documentation

## Testing Steps

### Test 1: Basic Save/Load
1. **Execute the script** in a fresh session
2. **Observe console output**:
   ```
   No previous data found - AI will start fresh
   Initializing Project Deep Apex Elite (V37.3+Adaptive)...
   ```
3. **Play for a while** - Let AI accumulate some learning (100+ trials)
4. **Check for save message**:
   ```
   Character model saved for: [Character] (Trials: 100)
   💾 AI data saved to local file: TSB_AutoPlay_Data_[YourUserId].json
   ```
5. **Re-execute the script** (close and restart)
6. **Observe console output**:
   ```
   ✅ AI data loaded from local file
   📊 Restored [X] training trials
   🎯 Character: [Character]
   ⚡ Score: [Score]
   ```

### Test 2: File System Support Check
1. **Execute script** in an exploit environment without file system support
2. **Observe warning**:
   ```
   ⚠️ File system not supported - AI will start fresh
   ```
3. Script should continue to work normally without persistence

### Test 3: Save on Kill
1. **Execute script**
2. **Eliminate an enemy**
3. **Check console**:
   ```
   Target eliminated. New Score: [Score]
   Character model saved for: [Character] (Trials: [X])
   💾 AI data saved to local file: TSB_AutoPlay_Data_[YourUserId].json
   ```

### Test 4: Save on Death
1. **Execute script**
2. **Get eliminated by an enemy**
3. **Check console**:
   ```
   Project Apex defeated. New Score: [Score].
   💾 AI data saved to local file: TSB_AutoPlay_Data_[YourUserId].json
   ```

### Test 5: Character-Specific Persistence
1. **Execute script** with Character A (e.g., Saitama)
2. **Let AI train** for 100+ trials
3. **Switch to Character B** (e.g., Genos) in-game
4. **Let AI train** for 100+ trials
5. **Re-execute script**
6. **Verify both characters' data is preserved**

### Test 6: Opponent-Specific Learning
1. **Execute script**
2. **Fight the same opponent multiple times**
3. **Let AI learn opponent patterns** (30+ actions)
4. **Re-execute script**
5. **Fight the same opponent again**
6. **Verify AI uses learned patterns** (check Counter-AI messages)

## Expected Console Output Examples

### Successful Load
```
✅ AI data loaded from local file
📊 Restored 847 training trials
🎯 Character: Saitama
⚡ Score: 25
Initializing Project Deep Apex Elite (V37.3+Adaptive) for Player...
Character identified as: Saitama
Loading existing character model for: Saitama (Trials: 847)
```

### Successful Save
```
Character model saved for: Saitama (Trials: 947)
💾 AI data saved to local file: TSB_AutoPlay_Data_123456789.json
```

### No Previous Data (First Run)
```
No previous data found - AI will start fresh
Initializing Project Deep Apex Elite (V37.3+Adaptive) for Player...
```

### File System Not Supported
```
⚠️ File system not supported - AI will start fresh
Initializing Project Deep Apex Elite (V37.3+Adaptive) for Player...
```

## Troubleshooting

### Data Not Saving
- **Check console** for save messages
- **Verify exploit supports** `writefile`, `readfile`, `isfile`
- **Check file permissions** in workspace folder
- **Verify save cooldown** (10 seconds minimum between saves)

### Data Not Loading
- **Check console** for load messages
- **Verify file exists** in workspace folder
- **Check file is valid JSON** (not corrupted)
- **Verify file permissions** (readable)

### File Corruption
If the data file becomes corrupted:
1. **Delete** `TSB_AutoPlay_Data_[YourUserId].json` from workspace
2. **Re-execute script** - Will start fresh
3. **AI will rebuild** learning data

## Performance Impact
- **Save Operation**: ~50-100ms (depends on data size)
- **Load Operation**: ~50-100ms (depends on data size)
- **Save Cooldown**: 10 seconds minimum between saves
- **No runtime overhead** - Only triggers on specific events

## Compatibility
- ✅ **Works with all V37+ features**
- ✅ **Backward compatible** - Can load older session data
- ✅ **Forward compatible** - New fields added safely
- ✅ **Safe fallback** - Works without file system support

## Known Limitations
1. **Exploit-dependent**: Requires exploit with file system support
2. **Local only**: Data saved to local machine, not cross-device
3. **User-specific**: Each UserId has separate data file
4. **No cloud sync**: Data not backed up automatically
5. **File corruption risk**: Manual file editing can break data

## Advanced: Manual Data Inspection
You can manually inspect the saved data:
1. **Navigate to workspace folder** in your exploit
2. **Open** `TSB_AutoPlay_Data_[YourUserId].json` in a text editor
3. **View JSON data** - human-readable format
4. **Check statistics**: totalTrials, score, character, etc.

Example JSON structure:
```json
{
  "version": "1.0",
  "timestamp": 1234567890,
  "totalTrials": 847,
  "score": 25,
  "identifiedCharacter": "Saitama",
  "ActionStats": {...},
  "QNetworkB": {...},
  "FeatureWeights": {...},
  ...
}
```

## Conclusion
The local file persistence feature provides true cross-session learning without requiring server-side access. The AI now "remembers everything" and continues improving from where it left off!
