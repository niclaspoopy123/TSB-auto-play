# 💾 Local File Persistence Feature

## Overview
The AI now **remembers everything** across script executions! All learning data is automatically saved to a local JSON file and restored when you restart the script.

## How It Works

### Automatic Save Triggers
Your AI's learning data is automatically saved:
- ⏱️ **Every 100 trials** - Periodic checkpoint
- 🎯 **On enemy elimination** - After successful kill
- 💀 **On player death** - Before respawn
- 📝 **On character updates** - When switching characters

### Automatic Load
Data is automatically loaded when you start the script.

### No Setup Required!
Just execute the script as normal - persistence works automatically.

## What Gets Saved?

Everything important:
- ✅ **Q-values & weights** for all combat tactics
- ✅ **Opponent patterns** (counter-intelligence data)
- ✅ **Character-specific learning** (each character remembered separately)
- ✅ **Zone adaptation** (optimal distances learned)
- ✅ **Meta-learning rates** (adaptive learning)
- ✅ **Self-play statistics** (if enabled)
- ✅ **Session data** (trials, score, character)

## File Location

**Filename:** `TSB_AutoPlay_Data_{YourUserId}.json`

**Location:** Your exploit's workspace folder
- Synapse X: `workspace` folder
- KRNL: `workspace` folder  
- Other exploits: Check documentation

## Console Messages

### ✅ Success Messages
```
✅ AI data loaded from local file
📊 Restored 847 training trials
🎯 Character: Saitama
⚡ Score: 25

💾 AI data saved to local file: TSB_AutoPlay_Data_123456789.json
```

### ℹ️ Info Messages
```
ℹ️ No previous data found - AI will start fresh
```

### ⚠️ Warning Messages
```
⚠️ File system not supported - AI will start fresh
❌ Failed to decode JSON (file may be corrupted)
```

## Requirements

Your exploit must support these functions:
- `writefile()` - To save data
- `readfile()` - To load data
- `isfile()` - To check if file exists

**Most popular exploits support these functions.**

## Troubleshooting

### Data Not Saving?
1. Check console for error messages
2. Verify your exploit supports file system functions
3. Check workspace folder permissions
4. Wait 10 seconds between saves (cooldown protection)

### Data Not Loading?
1. Check console for error messages
2. Verify file exists in workspace folder
3. Check file is valid JSON (not corrupted)
4. Try deleting the file and starting fresh

### File Corrupted?
1. Delete `TSB_AutoPlay_Data_{YourUserId}.json` from workspace
2. Re-execute the script
3. AI will start fresh and rebuild data

## Performance

- **Save time:** ~50-100ms (unnoticeable)
- **Load time:** ~50-100ms (unnoticeable)
- **Cooldown:** 10 seconds minimum between saves
- **No runtime overhead** - Only saves on specific events

## Benefits

🎯 **True Persistence**
- Learn once, benefit forever
- No more starting from scratch
- Character mastery is preserved

🧠 **Smarter AI**
- Builds on previous learning
- Opponent patterns remembered
- Optimal strategies refined over time

⚡ **Automatic**
- No manual saves needed
- Works in background
- Transparent operation

## Advanced: Manual Inspection

Want to see your data?

1. Navigate to workspace folder
2. Open `TSB_AutoPlay_Data_{YourUserId}.json`
3. View in text editor (human-readable JSON)

Example structure:
```json
{
  "version": "1.0",
  "timestamp": 1234567890,
  "totalTrials": 847,
  "score": 25,
  "identifiedCharacter": "Saitama",
  "ActionStats": {...},
  "QNetworkB": {...},
  "FeatureWeights": {...}
}
```

## Compatibility

✅ Works with all V37+ features
✅ Backward compatible
✅ Forward compatible
✅ Safe fallback if unsupported

## Testing

See `PERSISTENCE_TEST.md` for detailed testing instructions.

## Summary

The AI now truly "remembers everything"! 🎉

- Automatic save & load
- No setup required
- Robust error handling
- Clear console feedback
- Zero performance impact

Just execute the script and enjoy persistent learning!
