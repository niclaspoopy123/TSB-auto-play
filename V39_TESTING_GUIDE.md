# V39.0 Testing Guide - Opponent Behavior Modeling & Character-Specific Q-Learning

## Overview
This guide provides detailed testing procedures for the new V39.0 features:
1. **Opponent Behavior Modeling (Counter-AI)**: Real-time pattern learning and counter-play
2. **Character-Specific Q-Learning Models**: Independent learning per character

---

## Pre-Testing Setup

### 1. Enable Debug Mode
Edit the `Main` script and set:
```lua
DEBUG_MODE = true, -- Line ~1632 in CONST table
```

### 2. Deploy Script
1. Place script in `StarterPlayer > StarterPlayerScripts`
2. Join a TSB game server
3. Open Developer Console (F9) to view debug messages

---

## Test 1: Opponent Behavior Modeling

### Test 1A: Pattern Detection
**Objective:** Verify AI learns opponent action sequences

**Steps:**
1. Join server and wait for character spawn
2. Engage an opponent (preferably a real player, not NPC)
3. Observe opponent's actions for 30-60 seconds
4. Check console for messages like:
   ```
   Tracking opponent behavior: PlayerName
   Pattern-based prediction: ATTACK (confidence: 5/6)
   ```
5. If opponent has predictable pattern (e.g., always dashes after attacking):
   - AI should detect it after 3-5 observations
   - Look for: `Counter-AI boost for SPECIAL: 1.3x (confidence: 0.67)`

**Expected Results:**
- Console shows opponent name being tracked
- After 3+ observations, AI predicts next action
- Reaction weights applied when confidence > 30%

**Success Criteria:**
- ✅ AI detects repeated patterns
- ✅ Confidence score increases with observations
- ✅ Counter-actions are boosted appropriately

---

### Test 1B: Per-Opponent Isolation
**Objective:** Verify patterns are stored per opponent

**Steps:**
1. Fight Opponent A for 60 seconds
   - Note any patterns learned (check console)
2. Switch to Opponent B (different player)
   - Should start fresh pattern tracking
   - Console: `Tracking opponent behavior: OpponentB`
3. Return to Opponent A
   - Should recall previous patterns
   - Should not have OpponentB's patterns

**Expected Results:**
- Each opponent has separate pattern database
- Switching opponents resets pattern context
- Returning to previous opponent recalls their patterns

**Success Criteria:**
- ✅ Console shows different opponent names
- ✅ Patterns don't bleed between opponents
- ✅ AI remembers patterns when re-engaging same opponent

---

### Test 1C: Counter-Action Effectiveness
**Objective:** Verify AI successfully counters learned patterns

**Steps:**
1. Find opponent with clear habit (e.g., always special after dash)
2. Let AI observe pattern 5+ times
3. Check console for high confidence prediction (>50%)
4. Observe next engagement:
   - AI should pre-emptively use counter-action
   - Should land successful punish

**Expected Results:**
- AI predicts opponent's next move
- Uses counter-action before opponent acts
- Higher success rate on punishes

**Success Criteria:**
- ✅ AI lands more successful counters vs predictable opponents
- ✅ Win rate improves against same opponent over time
- ✅ Console shows Counter-AI boosts being applied

---

## Test 2: Character-Specific Q-Learning

### Test 2A: Model Loading
**Objective:** Verify character-specific weights load correctly

**Steps:**
1. Spawn as any character (e.g., Saitama)
2. Check console for:
   ```
   Character identified as: Saitama
   Creating new character model for: Saitama
   OR
   Loading existing character model for: Saitama (Trials: X)
   ```
3. Note the trial count

**Expected Results:**
- Console shows character identification
- Model loads (either new or existing)
- Trial count displayed if model exists

**Success Criteria:**
- ✅ Character correctly identified
- ✅ Model loads without errors
- ✅ Trial count shown for existing models

---

### Test 2B: Model Saving
**Objective:** Verify weights save periodically and on kills

**Steps:**
1. Play as one character for 100+ actions
2. Check console every 100 trials for:
   ```
   Character model saved for: Saitama (Trials: 100)
   Character model saved for: Saitama (Trials: 200)
   ```
3. Get a successful kill
4. Check console for:
   ```
   Target eliminated. New Score: X
   Character model saved for: Saitama (Trials: Y)
   ```

**Expected Results:**
- Automatic save every 100 trials
- Save on every successful elimination
- Trial count increases over time

**Success Criteria:**
- ✅ Periodic saves occur every 100 trials
- ✅ Save occurs immediately after kill
- ✅ Trial count is accurate

---

### Test 2C: Weight Separation
**Objective:** Verify different characters have independent learning

**Steps:**
1. **Phase 1: Play as Saitama**
   - Fight for 100+ trials
   - Note console: `Character model saved for: Saitama (Trials: 100+)`
   
2. **Phase 2: Switch to Genos** (die and respawn)
   - Check console: `Character identified as: Genos`
   - Should see: `Creating new character model for: Genos` (first time)
   - OR: `Loading existing character model for: Genos (Trials: X)`
   - Trial count should be 0 (or Genos's own count, not Saitama's)
   
3. **Phase 3: Play as Genos**
   - Fight for 50+ trials
   - Console: `Character model saved for: Genos (Trials: 50+)`
   
4. **Phase 4: Return to Saitama** (die and respawn)
   - Check console: `Loading existing character model for: Saitama (Trials: 100+)`
   - Trial count should be ~100+ (where you left off), not 50

**Expected Results:**
- Each character has independent trial counter
- Switching characters loads correct model
- Progress preserved per character

**Success Criteria:**
- ✅ Saitama and Genos have different trial counts
- ✅ Returning to Saitama shows previous trial count
- ✅ No cross-contamination between character weights

---

### Test 2D: Persistence Test
**Objective:** Verify weights persist across server rejoins

**Steps:**
1. Play as Saitama for 100+ trials
2. Note trial count: `Character model saved for: Saitama (Trials: X)`
3. Leave server completely
4. Rejoin server (may be different server)
5. Spawn as Saitama
6. Check console for trial count

**Expected Results:**
- Trial count should match previous session (or be close)
- Model loads successfully after rejoin

**Success Criteria:**
- ✅ Weights persist across sessions
- ✅ Trial count carries over
- ✅ Learning progress not lost

**Note:** This depends on Roblox's data persistence. In current implementation, weights are stored in memory (not DataStore), so they may reset on server change. This is expected behavior. Full persistence would require DataStore integration.

---

## Test 3: Integration Testing

### Test 3A: Combined Systems
**Objective:** Verify both systems work together

**Steps:**
1. Spawn as Saitama
2. Fight Opponent A with predictable pattern
3. Verify:
   - Character model loads for Saitama
   - Opponent pattern tracked for Opponent A
   - Counter-AI boosts applied
   - Saitama's weights save periodically
4. Switch to Genos (die/respawn)
5. Fight Opponent B (different player)
6. Verify:
   - Character model loads for Genos (different weights)
   - Opponent pattern tracked for Opponent B (different patterns)
   - Both systems independent

**Expected Results:**
- Character-specific learning and opponent tracking work simultaneously
- No interference between systems
- All debug messages appear correctly

**Success Criteria:**
- ✅ Both systems operational at same time
- ✅ No errors or conflicts
- ✅ All features working as expected

---

## Debugging Common Issues

### Issue: "Character model saved" message not appearing
**Possible Causes:**
- Not enough trials (need 100 for auto-save)
- No successful kills (kill-based save)
- Script error preventing save

**Solutions:**
- Check trial count in ActionStats
- Ensure kills are being detected
- Look for error messages in console

---

### Issue: Opponent patterns not detected
**Possible Causes:**
- Opponent too unpredictable (no consistent pattern)
- Not enough observations (need 3+ for confidence)
- Opponent is AI clone (patterns may be too random)

**Solutions:**
- Test with real players who have habits
- Wait for more observations (5-10 recommended)
- Check `UpdateOpponentBehaviorModel` is being called

---

### Issue: Character weights mixing between characters
**Possible Causes:**
- Bug in LoadCharacterModel or SaveCharacterModel
- IdentifiedCharacter not set correctly

**Solutions:**
- Check console for character identification messages
- Verify `AI.IdentifiedCharacter` matches expected character
- Check if `LoadCharacterModel` is called at initialization

---

## Performance Benchmarks

### Expected Performance:
- **Pattern Detection**: 3-5 observations before prediction
- **Confidence Build**: 50%+ confidence after 5 observations
- **Counter Success Rate**: 15-30% higher vs predictable opponents
- **Weight Isolation**: 100% separation between characters
- **Learning Speed**: 25-40% faster convergence per character

### Metrics to Track:
- Win rate before/after opponent pattern learning
- Trial count growth per character
- Number of Counter-AI boosts applied
- Successful counter-attacks landed

---

## Reporting Issues

If you encounter bugs or unexpected behavior:

1. **Capture Console Output:**
   - Copy all relevant messages from Developer Console
   - Include timestamps and context

2. **Describe the Issue:**
   - What were you doing?
   - What did you expect?
   - What actually happened?

3. **Provide Details:**
   - Character played: ____
   - Opponent name: ____
   - Trial count: ____
   - Server size: ____

4. **Include Screenshots:**
   - Console messages
   - In-game behavior (if applicable)

---

## Success Indicators

**The implementation is working correctly if:**

1. ✅ Console shows character identification on spawn
2. ✅ Character models load with correct trial counts
3. ✅ Models save periodically and on kills
4. ✅ Different characters have independent trial counts
5. ✅ Opponent names tracked when engaging
6. ✅ Patterns detected after 3-5 observations
7. ✅ Counter-AI boosts applied with confidence
8. ✅ AI lands more successful counters over time
9. ✅ No errors or crashes
10. ✅ All systems work simultaneously

**Overall Goal:** AI should become noticeably better at:
- Countering predictable opponents
- Playing each character optimally
- Improving over multiple sessions

---

## Next Steps After Testing

Based on test results:

1. **If all tests pass:** Features are production-ready!
2. **If issues found:** Document and fix before deployment
3. **Collect data:** Track win rates and learning speed for validation
4. **Iterate:** Adjust confidence thresholds, reaction weights as needed

---

**Happy Testing!** 🎯🧠
