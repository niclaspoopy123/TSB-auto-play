# AI Persistence System Testing Guide

## Overview
The AI persistence system saves and loads training data between sessions, allowing the AI to remember everything it learned.

## Features
- **Automatic Loading**: AI state is loaded when the script starts
- **Auto-Save**: AI state is automatically saved every 60 seconds
- **Exit Save**: AI state is saved when the player leaves the game
- **Data Saved**:
  - ActionStats (all Q-learning values and counts)
  - QNetworkB (Double Q-Learning network)
  - FeatureWeights (adaptive feature weights)
  - OpponentModel (opponent pattern tracking)
  - CharacterModels (character-specific learning)
  - MetaLearning (adaptive learning parameters)
  - DeepNetwork weights (neural network layers)
  - Score (persistent score across sessions)

## Testing Procedures

### Test 1: Initial Load (Fresh Start)
**Objective**: Verify system handles missing save file gracefully

**Steps:**
1. Ensure no `TSB_AI_Data_v37.json` file exists in executor's workspace folder
2. Run the script
3. Check console output

**Expected Output:**
```
No saved AI data found. Starting with fresh learning state.
🧠 Starting with fresh AI learning state
```

**Success Criteria:**
- ✅ No errors occur
- ✅ AI starts with fresh/default values
- ✅ Console shows appropriate messages

---

### Test 2: Save Functionality
**Objective**: Verify AI state can be saved successfully

**Steps:**
1. Run the script and let AI train for at least 60 seconds (for auto-save)
2. Perform some actions to generate learning data
3. Check console after 60 seconds

**Expected Output:**
```
✅ AI State saved successfully to TSB_AI_Data_v37.json
```

**Success Criteria:**
- ✅ Save message appears every 60 seconds
- ✅ `TSB_AI_Data_v37.json` file is created in workspace folder
- ✅ File contains valid JSON data

**Manual Verification:**
Open the `TSB_AI_Data_v37.json` file and verify it contains:
- `version: "v37"`
- `timestamp: <unix timestamp>`
- `Score: <number>`
- `ActionStats: { totalTrials, Aggressive, Defensive, ... }`
- `DeepNetwork: { valueNet, advantageNet }`

---

### Test 3: Load Functionality
**Objective**: Verify AI state can be loaded from file

**Steps:**
1. Run the script and train AI for 5+ minutes (to generate meaningful data)
2. Wait for at least one auto-save (60 seconds)
3. Note the current Score and totalTrials count
4. Exit/restart the game or rejoin server
5. Run the script again
6. Check console output

**Expected Output:**
```
✅ AI State loaded successfully from TSB_AI_Data_v37.json
  - Total Trials: 150
  - Score: 20
  - Data timestamp: 2026-01-15 19:30:45
🧠 AI learning data restored from previous session
```

**Success Criteria:**
- ✅ Load message appears with correct values
- ✅ totalTrials matches previous session
- ✅ Score matches previous session
- ✅ AI continues learning from previous progress

---

### Test 4: Exit Save
**Objective**: Verify AI state saves when player leaves

**Steps:**
1. Run the script
2. Let AI train for 2-3 minutes
3. Note current Score and totalTrials
4. Leave the game (disconnect/exit Roblox)
5. Check executor console for save message

**Expected Output:**
```
💾 Saving AI state before exit...
✅ AI State saved successfully to TSB_AI_Data_v37.json
```

**Success Criteria:**
- ✅ Save message appears before exit
- ✅ File is updated with latest data
- ✅ Data persists when rejoining

---

### Test 5: Data Persistence Across Multiple Sessions
**Objective**: Verify learning progress accumulates over multiple sessions

**Steps:**
1. **Session 1:**
   - Start fresh (no save file)
   - Train for 100+ trials
   - Note Score and totalTrials
   - Wait for auto-save
   - Exit

2. **Session 2:**
   - Rejoin/restart
   - Verify previous values loaded
   - Train for 100+ more trials
   - Note new Score and totalTrials
   - Wait for auto-save
   - Exit

3. **Session 3:**
   - Rejoin/restart
   - Verify values from Session 2 loaded
   - Total trials should be ~200+

**Expected Behavior:**
- totalTrials continuously increases across sessions
- Score accumulates (or decreases based on performance)
- Learning improvements persist

**Success Criteria:**
- ✅ Each session starts with previous session's data
- ✅ Learning progress is cumulative
- ✅ No data loss between sessions

---

### Test 6: Neural Network Weight Persistence
**Objective**: Verify deep network weights save and load correctly

**Steps:**
1. Train AI for 10+ minutes to allow neural network to adapt
2. Exit and save
3. Manually inspect `TSB_AI_Data_v37.json` file
4. Verify `DeepNetwork` section exists with:
   - `valueNet.layer1.weights` (array of arrays)
   - `valueNet.layer1.biases` (array)
   - `advantageNet.layer1.weights` (array of arrays)
   - `advantageNet.layer1.biases` (array)
5. Rejoin and verify load succeeds

**Expected Behavior:**
- Neural network weights are properly serialized as nested arrays
- Weights and biases load without errors
- AI performance/behavior is consistent with previous session

**Success Criteria:**
- ✅ DeepNetwork section exists in JSON
- ✅ Weights are valid numbers (not NaN or null)
- ✅ Network loads successfully
- ✅ AI doesn't need to "relearn" from scratch

---

## Troubleshooting

### Issue: "writefile not available"
**Cause**: Executor doesn't support `writefile` function
**Solution**: Use an executor that supports file I/O (e.g., Synapse X, Script-Ware, Krnl)

### Issue: "readfile not available"
**Cause**: Executor doesn't support `readfile` function
**Solution**: Use an executor that supports file I/O

### Issue: "isfile not available"
**Cause**: Executor doesn't support `isfile` function
**Solution**: The LoadAIState function will fail gracefully, starting fresh

### Issue: File saves but doesn't load on rejoin
**Cause**: File might be in wrong location or executor cleared it
**Solution**: 
- Check executor's workspace folder for the file
- Some executors clear files on game exit
- Verify file permissions

### Issue: JSON encoding errors
**Cause**: Circular references or non-serializable data
**Solution**: 
- Check if any tables have circular references
- Ensure all values are numbers, strings, or tables (not functions/userdata)

### Issue: Large file size
**Cause**: Neural network weights create large JSON files
**Expected**: File size may be 100KB-1MB+ depending on training
**Solution**: This is normal. Deep networks have thousands of parameters.

---

## Performance Notes

### File Size
- Fresh save: ~10KB
- After 1 hour: ~100-500KB
- After extensive training: ~1MB+

### Save Time
- Typically <100ms
- May take longer with very large neural networks
- Saving is async (doesn't block game)

### Load Time
- Typically <50ms
- JSON decoding is fast
- Happens before character spawns (no gameplay impact)

---

## Success Indicators

**The persistence system is working correctly if:**

1. ✅ Save messages appear every 60 seconds
2. ✅ Exit save triggers when leaving game
3. ✅ Load succeeds on script startup (if file exists)
4. ✅ Total trials increase across sessions
5. ✅ Score persists across sessions
6. ✅ AI behavior/performance is consistent after reload
7. ✅ No JSON encoding/decoding errors
8. ✅ Neural network weights load successfully
9. ✅ Character-specific models persist
10. ✅ Learning progress is cumulative

---

## Integration with Existing Testing

This persistence system integrates with the V39 testing guide:

- Character-specific models now persist across sessions
- Opponent behavior patterns persist (if saved in OpponentModel)
- Trial counts continue accumulating
- All learning improvements are preserved

**Important**: The persistence system saves data **locally** in the executor's workspace. It does **NOT** use Roblox DataStore, so data is tied to your device/executor, not your Roblox account.

---

## Next Steps

After confirming persistence works:
1. Monitor file size growth over days/weeks
2. Consider implementing compression if files get too large
3. Add versioning migration if data format changes
4. Consider adding backup/restore functionality

---

**Happy Testing!** 💾🧠
