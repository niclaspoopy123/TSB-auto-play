-- =================================================================================
-- PRETRAINED DATA FOR TSB AUTO-PLAY
-- This file contains default weights and statistics for the AI when no save file exists
-- =================================================================================
--[[
    VERSION INFORMATION:
    - Version format: MAJOR.MINOR.PATCH (Semantic Versioning)
    - MAJOR: Incompatible changes (structure changes)
    - MINOR: New features (backward compatible)
    - PATCH: Bug fixes (backward compatible)
    
    Current Version: 1.0.0
    - Initial release with default weights for all tactics
    - Compatible with Main script V37.3+
    
    Future compatibility checking:
    - When loading, Main script can check PretrainedData.Version
    - If major version differs, skip loading and use defaults
    - Log warning if minor/patch version differs
]]

local PretrainedData = {
    -- Version for compatibility checking
    Version = "1.0.0",
    
    -- Default Action Statistics (Q-values for each tactic)
    ActionStats = {
        BaitAndPunish = {
            ATTACK = { weight = 15.0, attempts = 100, success = 60 },
            SPECIAL = { weight = 18.0, attempts = 50, success = 35 },
            EVADE = { weight = 20.0, attempts = 80, success = 55 },
            FEINT = { weight = 16.0, attempts = 40, success = 25 },
            DASH = { weight = 14.0, attempts = 90, success = 70 },
            BLOCK = { weight = 12.0, attempts = 60, success = 40 },
            REPOSITION = { weight = 10.0, attempts = 120, success = 90 },
        },
        Aggressive = {
            ATTACK = { weight = 22.0, attempts = 150, success = 90 },
            SPECIAL = { weight = 20.0, attempts = 80, success = 50 },
            EVADE = { weight = 10.0, attempts = 60, success = 40 },
            FEINT = { weight = 14.0, attempts = 50, success = 30 },
            DASH = { weight = 16.0, attempts = 100, success = 75 },
            BLOCK = { weight = 8.0, attempts = 40, success = 25 },
            REPOSITION = { weight = 7.0, attempts = 80, success = 60 },
        },
        Defensive = {
            ATTACK = { weight = 10.0, attempts = 60, success = 40 },
            SPECIAL = { weight = 12.0, attempts = 30, success = 20 },
            EVADE = { weight = 25.0, attempts = 120, success = 90 },
            FEINT = { weight = 15.0, attempts = 60, success = 40 },
            DASH = { weight = 18.0, attempts = 100, success = 80 },
            BLOCK = { weight = 20.0, attempts = 100, success = 75 },
            REPOSITION = { weight = 16.0, attempts = 140, success = 110 },
        },
        Counter = {
            ATTACK = { weight = 16.0, attempts = 90, success = 60 },
            SPECIAL = { weight = 19.0, attempts = 60, success = 40 },
            EVADE = { weight = 17.0, attempts = 90, success = 65 },
            FEINT = { weight = 20.0, attempts = 70, success = 50 },
            DASH = { weight = 13.0, attempts = 80, success = 60 },
            BLOCK = { weight = 18.0, attempts = 90, success = 70 },
            REPOSITION = { weight = 11.0, attempts = 100, success = 75 },
        },
        Finisher = {
            ATTACK = { weight = 20.0, attempts = 110, success = 75 },
            SPECIAL = { weight = 25.0, attempts = 70, success = 50 },
            EVADE = { weight = 12.0, attempts = 50, success = 35 },
            FEINT = { weight = 10.0, attempts = 30, success = 20 },
            DASH = { weight = 15.0, attempts = 70, success = 55 },
            BLOCK = { weight = 9.0, attempts = 40, success = 28 },
            REPOSITION = { weight = 8.0, attempts = 60, success = 45 },
        },
    },
    
    -- Default Feature Weights
    FeatureWeights = {
        distance = 1.2,
        energy = 1.0,
        healthDiff = 1.0,
        tacticSuccess = 1.0,
        targetVelocity = 0.8,
        comboDensity = 1.1,
        damageOutput = 1.3,
    },
    
    -- Default Zone Adaptation
    ZoneAdaptation = {
        optimalRange = 15.0,
        minEffectiveRange = 5.0,
        maxEffectiveRange = 25.0,
        totalDamageDealt = 0,
        totalDamageTaken = 0,
    },
    
    -- Default Meta Learning
    MetaLearning = {
        adaptiveLearningRate = 0.0012,
        consecutiveImprovements = 0,
        stabilityScore = 0.5,
        recentPerformanceWindow = {},
        adaptiveDecayMultiplier = 0.9995,
    },
    
    -- Default Character Models (basic weights for common characters)
    CharacterModels = {
        Saitama = {
            distance = 1.3,
            energy = 0.9,
            healthDiff = 1.1,
            tacticSuccess = 1.0,
        },
        Genos = {
            distance = 1.0,
            energy = 1.2,
            healthDiff = 1.0,
            tacticSuccess = 1.1,
        },
        Garou = {
            distance = 1.1,
            energy = 1.1,
            healthDiff = 1.0,
            tacticSuccess = 1.2,
        },
    },
    
    -- Training Stats
    TrainingStats = {
        trials = 0,
        totalReward = 0,
        averageReward = 0,
    },
}

return PretrainedData
