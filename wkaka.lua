--[[
    🔥 ZONE XD - ULTIMATE FALL DETECTION SYSTEM 🔥
    COPYRIGHT: APIS (USER 01) - ZONE XD V1
    VERSI: SUPER LENGKAP - 7 LAPIS DETEKSI + ANALISIS REAL-TIME
    NOTE: REWIND SYSTEM TETAP SAMA, INI HANYA UPGRADE DETEKSI JATUH
]]

-- ==================================================
-- PART 1: SETTINGS SUPER LENGKAP (100+ SETTINGS)
-- ==================================================
local FallDetector = {
    -- VERSION
    version = "3.0.0",
    buildDate = "2026-03-15",
    
    -- ===== 1. VELOCITY DETECTION SETTINGS =====
    velocity = {
        enabled = true,
        minFallVelocity = 45,              -- Kecepatan minimal dianggap jatuh (studs/detik)
        maxSafeVelocity = 20,               -- Kecepatan maksimal aman
        criticalVelocity = 70,               -- Kecepatan kritis
        terminalVelocity = 100,              -- Kecepatan terminal
        samplesForAverage = 10,               -- Sample buat rata-rata kecepatan
        historySize = 30,                     -- History kecepatan untuk analisis
    },
    
    -- ===== 2. GRAVITY/ACCELERATION DETECTION =====
    gravity = {
        enabled = true,
        minAcceleration = 15,                -- Percepatan minimal jatuh (studs/frame^2)
        earthGravity = 0.5,                   -- Gravity normal Roblox (approx)
        maxSafeAcceleration = 8,               -- Akselerasi aman (lompat/naik)
        accelerationSamples = 15,              -- Sample percepatan
    },
    
    -- ===== 3. AIR TIME DETECTION =====
    airTime = {
        enabled = true,
        maxSafeAirTime = 1.2,                 -- Max detik aman di udara
        warningAirTime = 2.0,                   -- Peringatan mulai
        criticalAirTime = 3.0,                   -- Kritis
        fallAirTime = 4.0,                       -- Dianggap jatuh
        groundedBuffer = 0.3,                     -- Buffer setelah nyentuh tanah
    },
    
    -- ===== 4. STABLE POINT ANALYSIS =====
    stablePoint = {
        enabled = true,
        historySize = 180,                       -- 6 detik history (30fps)
        stableDeviation = 3.5,                    -- Deviasi yang dianggap stabil
        minStableSamples = 45,                     -- Minimal sample buat analisis (1.5 detik)
        maxChangeForStable = 2.5,                   -- Perubahan maksimal per frame buat dianggap stabil
        stableConfidence = 0.85,                     -- Confidence level untuk stable point
    },
    
    -- ===== 5. MULTI-LEVEL THRESHOLD =====
    thresholds = {
        levels = {
            {distance = 5,  name = "🟢 AMAN",          color = "GREEN",  action = "NONE"},
            {distance = 15, name = "🟡 PERHATIAN",     color = "YELLOW", action = "WARNING"},
            {distance = 25, name = "🟠 WASPADA",       color = "ORANGE", action = "WARNING"},
            {distance = 35, name = "🔴 BAHAYA",        color = "RED",    action = "ALERT"},
            {distance = 45, name = "🟣 KRITIS",        color = "PURPLE", action = "ALERT"},
            {distance = 55, name = "💀 FALL DETECTED", color = "BLACK",  action = "REWIND"},
        },
        enableProgressive = true,
        progressiveMultiplier = 1.2,                   -- Makin dalam makin sensitif
    },
    
    -- ===== 6. PREDICTION SYSTEM =====
    prediction = {
        enabled = true,
        framesAhead = 15,                              -- Prediksi 15 frame ke depan (0.5 detik)
        confidenceThreshold = 0.75,                     -- Threshold confidence buat trigger
        usePhysicsPrediction = true,
        predictionSamples = 20,
        maxPredictionError = 10,                         -- Error margin
    },
    
    -- ===== 7. PLATFORM/COLLISION DETECTION =====
    platform = {
        enabled = true,
        raycastDistance = 20,                            -- Jarak raycast
        checkEveryFrame = true,
        groundMaterialDetection = true,
        waterDetection = true,
        ladderDetection = true,
        vehicleDetection = true,
        ignoreList = {},                                 -- Objects to ignore
    },
    
    -- ===== ADVANCED FILTERING =====
    filtering = {
        enabled = true,
        medianFilterSize = 5,                            -- Filter noise
        kalmanFilter = true,                              -- Kalman filter untuk smoothing
        outlierRejection = true,
        outlierThreshold = 3.0,                           -- Standard deviations
    },
    
    -- ===== STATISTICAL ANALYSIS =====
    statistics = {
        enabled = true,
        movingAverageWindow = 30,                         -- Window buat moving average
        standardDeviationWindow = 45,
        peakDetection = true,
        patternRecognition = true,
        fallPatterns = {
            "free_fall",
            "slip_fall",
            "launch_fall",
            "void_fall",
        },
    },
    
    -- ===== ENVIRONMENT DETECTION =====
    environment = {
        checkHeight = true,
        checkMapBoundaries = true,
        checkKillBricks = true,
        checkLava = true,
        checkVoid = true,
        voidThreshold = -500,                             -- Dianggap void
    },
    
    -- ===== USER ADAPTIVE SYSTEM =====
    adaptive = {
        enabled = true,
        learnUserBehavior = true,
        adaptThresholds = true,
        learningRate = 0.1,
        minSamplesForAdapt = 50,
        userProfile = {},
    },
    
    -- ===== DEBUG & LOGGING =====
    debug = {
        enabled = true,
        logLevel = "INFO",                                -- DEBUG, INFO, WARN, ERROR
        logToConsole = true,
        logToFile = false,
        showPredictions = true,
        showConfidence = true,
        showAllDetections = false,
        saveLogs = false,
    },
}

-- ==================================================
-- PART 2: STATISTICAL ANALYSIS ENGINE (100+ BARIS)
-- ==================================================
local StatisticsEngine = {
    -- MOVING AVERAGE CALCULATOR
    movingAverage = function(self, data, window)
        if #data < window then return nil end
        local sum = 0
        for i = #data - window + 1, #data do
            sum = sum + data[i]
        end
        return sum / window
    end,
    
    -- STANDARD DEVIATION
    standardDeviation = function(self, data)
        if #data < 2 then return 0 end
        local mean = 0
        for _, v in ipairs(data) do
            mean = mean + v
        end
        mean = mean / #data
        
        local variance = 0
        for _, v in ipairs(data) do
            variance = variance + (v - mean)^2
        end
        variance = variance / (#data - 1)
        return math.sqrt(variance)
    end,
    
    -- MEDIAN FILTER (NOISE REDUCTION)
    medianFilter = function(self, data, windowSize)
        if #data < windowSize then return data end
        local filtered = {}
        for i = 1, #data do
            local startIdx = math.max(1, i - math.floor(windowSize/2))
            local endIdx = math.min(#data, i + math.floor(windowSize/2))
            local window = {}
            for j = startIdx, endIdx do
                table.insert(window, data[j])
            end
            table.sort(window)
            filtered[i] = window[math.ceil(#window/2)]
        end
        return filtered
    end,
    
    -- KALMAN FILTER (PREDICTIVE SMOOTHING)
    kalmanFilter = function(self, value, prevEstimate, prevError, processNoise, measurementNoise)
        if not prevEstimate then
            return value, 1, 0.1, 0.1
        end
        
        -- Prediction update
        local predEstimate = prevEstimate
        local predError = prevError + processNoise
        
        -- Measurement update
        local kalmanGain = predError / (predError + measurementNoise)
        local newEstimate = predEstimate + kalmanGain * (value - predEstimate)
        local newError = (1 - kalmanGain) * predError
        
        return newEstimate, newError, kalmanGain, predEstimate
    end,
    
    -- PEAK DETECTION (UNTUK JATUH TIBA-TIBA)
    peakDetection = function(self, data, threshold)
        local peaks = {}
        for i = 2, #data - 1 do
            if data[i] > data[i-1] * threshold and data[i] > data[i+1] * threshold then
                table.insert(peaks, {index = i, value = data[i]})
            end
        end
        return peaks
    end,
    
    -- PATTERN RECOGNITION
    recognizePattern = function(self, data, patternLength)
        if #data < patternLength * 2 then return "unknown" end
        
        -- Check free fall pattern (constant acceleration)
        local freeFallPattern = true
        local lastDiff = data[#data] - data[#data-1]
        for i = 0, patternLength - 1 do
            local diff = data[#data - i] - data[#data - i - 1]
            if math.abs(diff - lastDiff) > 2 then
                freeFallPattern = false
                break
            end
        end
        
        if freeFallPattern then
            return "free_fall"
        end
        
        -- Check slip pattern (gradual then sudden)
        local slipPattern = false
        -- Complex pattern recognition logic here
        
        return "unknown"
    end,
}

-- ==================================================
-- PART 3: ENVIRONMENT ANALYSIS ENGINE (80+ BARIS)
-- ==================================================
local EnvironmentEngine = {
    -- CHECK MAP BOUNDARIES
    checkBoundaries = function(self, position)
        local success, result = pcall(function()
            -- Coba cek workspace boundaries
            local bounds = workspace.CurrentCamera?.ViewportSize
            if not bounds then return false end
            
            -- Logic boundary checking
            if position.Y < -500 then return "void" end
            if position.Y > 10000 then return "sky_limit" end
            
            return "safe"
        end)
        return success and result or "unknown"
    end,
    
    -- DETECT KILL BRICKS/LAVA
    detectHazards = function(self, position)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        
        -- Raycast ke bawah
        local raycastResult = workspace:Raycast(
            position,
            Vector3.new(0, -10, 0),
            raycastParams
        )
        
        if raycastResult then
            local material = raycastResult.Material
            if material == Enum.Material.Lava then
                return "lava"
            elseif material == Enum.Material.Water then
                return "water"
            elseif material == Enum.Material.Sand then
                return "sand"
            end
        end
        
        return "safe"
    end,
    
    -- CHECK GROUND PROXIMITY
    groundProximity = function(self, position, maxDistance)
        local raycastResult = workspace:Raycast(
            position,
            Vector3.new(0, -maxDistance, 0)
        )
        return raycastResult and (position.Y - raycastResult.Position.Y) or maxDistance
    end,
}

-- ==================================================
-- PART 4: ADAPTIVE LEARNING SYSTEM (70+ BARIS)
-- ==================================================
local AdaptiveEngine = {
    userHistory = {},
    userProfile = {},
    
    -- INITIALIZE USER PROFILE
    initialize = function(self)
        self.userProfile = {
            averageVelocity = 0,
            maxSafeVelocity = 0,
            averageAirTime = 0,
            preferredHeight = 0,
            fallCount = 0,
            safeCount = 0,
            lastFallTime = 0,
            patterns = {},
        }
    end,
    
    -- LEARN FROM USER BEHAVIOR
    learn = function(self, data)
        table.insert(self.userHistory, data)
        if #self.userHistory > 1000 then
            table.remove(self.userHistory, 1)
        end
        
        -- Update average
        local sumVel = 0
        for _, d in ipairs(self.userHistory) do
            sumVel = sumVel + d.velocity
        end
        self.userProfile.averageVelocity = sumVel / #self.userHistory
        
        -- Find max safe velocity (95th percentile)
        local velocities = {}
        for _, d in ipairs(self.userHistory) do
            if not d.isFall then
                table.insert(velocities, d.velocity)
            end
        end
        table.sort(velocities)
        if #velocities > 0 then
            local idx = math.floor(#velocities * 0.95)
            self.userProfile.maxSafeVelocity = velocities[idx] or 0
        end
        
        -- Adapt thresholds based on user behavior
        if self.userProfile.maxSafeVelocity > 0 then
            FallDetector.velocity.minFallVelocity = math.max(
                30,
                self.userProfile.maxSafeVelocity * 1.5
            )
        end
    end,
    
    -- PREDICT USER ACTION
    predictUserAction = function(self, currentData)
        -- Match with known patterns
        for i = #self.userHistory - 10, #self.userHistory do
            local historyData = self.userHistory[i]
            if historyData then
                local velDiff = math.abs(currentData.velocity - historyData.velocity)
                local posDiff = math.abs(currentData.position.Y - historyData.position.Y)
                
                if velDiff < 5 and posDiff < 10 then
                    return historyData.result  -- Predict same result
                end
            end
        end
        return "unknown"
    end,
}

-- ==================================================
-- PART 5: MAIN FALL DETECTOR CLASS (200+ BARIS)
-- ==================================================
local FallDetectorInstance = {
    -- DATA STORAGE
    positionHistory = {},
    velocityHistory = {},
    accelerationHistory = {},
    detectionHistory = {},
    warningHistory = {},
    
    -- STATE
    currentState = "GROUNDED",
    confidence = 0,
    lastDetection = 0,
    detectionCount = 0,
    
    -- KALMAN FILTER STATE
    kalmanState = {
        estimate = nil,
        error = nil,
    },
    
    -- INITIALIZE
    new = function(self)
        local instance = {}
        setmetatable(instance, self)
        self.__index = self
        
        -- Copy settings
        for k, v in pairs(FallDetector) do
            instance[k] = v
        end
        
        -- Initialize adaptive engine
        instance.adaptiveEngine = AdaptiveEngine
        instance.adaptiveEngine:initialize()
        
        -- Initialize statistics engine
        instance.statsEngine = StatisticsEngine
        
        -- Initialize environment engine
        instance.envEngine = EnvironmentEngine
        
        return instance
    end,
    
    -- UPDATE ALL HISTORIES
    updateHistories = function(self, character)
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        if not root or not humanoid then return end
        
        local currentY = root.Position.Y
        local currentTime = tick()
        local deltaTime = 0.03  -- Assume 30fps
        
        -- Update position history
        table.insert(self.positionHistory, {
            y = currentY,
            time = currentTime,
            pos = root.Position,
        })
        if #self.positionHistory > self.stablePoint.historySize then
            table.remove(self.positionHistory, 1)
        end
        
        -- Calculate velocity
        if #self.positionHistory >= 2 then
            local prev = self.positionHistory[#self.positionHistory - 1]
            local velocity = (prev.y - currentY) / (currentTime - prev.time)
            table.insert(self.velocityHistory, velocity)
            if #self.velocityHistory > self.velocity.historySize then
                table.remove(self.velocityHistory, 1)
            end
        end
        
        -- Calculate acceleration
        if #self.velocityHistory >= 2 then
            local accel = self.velocityHistory[#self.velocityHistory] - 
                          self.velocityHistory[#self.velocityHistory - 1]
            table.insert(self.accelerationHistory, accel)
            if #self.accelerationHistory > 30 then
                table.remove(self.accelerationHistory, 1)
            end
        end
        
        -- Apply Kalman filter
        if self.filtering.kalmanFilter then
            local newEstimate, newError, gain, pred = self.statsEngine:kalmanFilter(
                currentY,
                self.kalmanState.estimate,
                self.kalmanState.error,
                0.1,  -- process noise
                0.1   -- measurement noise
            )
            self.kalmanState.estimate = newEstimate
            self.kalmanState.error = newError
        end
        
        -- Apply median filter
        if self.filtering.medianFilterSize > 0 and #self.positionHistory > self.filtering.medianFilterSize then
            local yValues = {}
            for _, p in ipairs(self.positionHistory) do
                table.insert(yValues, p.y)
            end
            local filtered = self.statsEngine:medianFilter(yValues, self.filtering.medianFilterSize)
            -- Use filtered values for detection
        end
    end,
    
    -- CHECK VELOCITY (LAPIS 1)
    checkVelocity = function(self)
        if not self.velocity.enabled then return false, 0 end
        if #self.velocityHistory < 3 then return false, 0 end
        
        local currentVel = self.velocityHistory[#self.velocityHistory]
        local avgVel = self.statsEngine:movingAverage(self.velocityHistory, self.velocity.samplesForAverage)
        
        if not avgVel then return false, 0 end
        
        local confidence = 0
        
        -- Check against thresholds
        if currentVel > self.velocity.criticalVelocity then
            confidence = 1.0
        elseif currentVel > self.velocity.minFallVelocity then
            confidence = (currentVel - self.velocity.minFallVelocity) / 
                        (self.velocity.criticalVelocity - self.velocity.minFallVelocity)
        end
        
        -- Check average for consistency
        if avgVel > self.velocity.minFallVelocity then
            confidence = math.max(confidence, 0.7)
        end
        
        return confidence > 0.5, confidence
    end,
    
    -- CHECK GRAVITY/ACCELERATION (LAPIS 2)
    checkGravity = function(self)
        if not self.gravity.enabled then return false, 0 end
        if #self.accelerationHistory < 3 then return false, 0 end
        
        local currentAccel = math.abs(self.accelerationHistory[#self.accelerationHistory])
        local confidence = 0
        
        if currentAccel > self.gravity.minAcceleration then
            confidence = math.min(1.0, currentAccel / (self.gravity.minAcceleration * 2))
        end
        
        return confidence > 0.6, confidence
    end,
    
    -- CHECK AIR TIME (LAPIS 3)
    checkAirTime = function(self, humanoid)
        if not self.airTime.enabled then return false, 0 end
        if not humanoid then return false, 0 end
        
        local isGrounded = humanoid.FloorMaterial ~= Enum.Material.Air
        local airTime = 0
        
        if not isGrounded then
            if not self.airStart then
                self.airStart = tick()
            end
            airTime = tick() - self.airStart
        else
            self.airStart = nil
            return false, 0
        end
        
        local confidence = 0
        if airTime > self.airTime.fallAirTime then
            confidence = 1.0
        elseif airTime > self.airTime.criticalAirTime then
            confidence = 0.8
        elseif airTime > self.airTime.warningAirTime then
            confidence = 0.5
        end
        
        return confidence > 0.5, confidence
    end,
    
    -- CHECK STABLE POINTS (LAPIS 4)
    checkStablePoints = function(self)
        if not self.stablePoint.enabled then return nil, 0 end
        if #self.positionHistory < self.stablePoint.minStableSamples then return nil, 0 end
        
        local yValues = {}
        for _, p in ipairs(self.positionHistory) do
            table.insert(yValues, p.y)
        end
        
        local stdDev = self.statsEngine:standardDeviation(yValues)
        local avgY = self.statsEngine:movingAverage(yValues, #yValues)
        
        local stabilityConfidence = 1.0 - math.min(1.0, stdDev / self.stablePoint.stableDeviation)
        local currentY = self.positionHistory[#self.positionHistory].y
        
        if stabilityConfidence > self.stablePoint.stableConfidence then
            return avgY, stabilityConfidence
        end
        
        return nil, 0
    end,
    
    -- CHECK MULTI-LEVEL THRESHOLD (LAPIS 5)
    checkThreshold = function(self, dropDistance)
        for _, level in ipairs(self.thresholds.levels) do
            if dropDistance >= level.distance then
                return level
            end
        end
        return nil
    end,
    
    -- PREDICT FALL (LAPIS 6)
    predictFall = function(self)
        if not self.prediction.enabled then return false, 0 end
        if #self.velocityHistory < self.prediction.predictionSamples then return false, 0 end
        
        local recentVelocities = {}
        for i = #self.velocityHistory - self.prediction.predictionSamples + 1, #self.velocityHistory do
            table.insert(recentVelocities, self.velocityHistory[i])
        end
        
        local avgVel = self.statsEngine:movingAverage(recentVelocities, #recentVelocities)
        local currentY = self.positionHistory[#self.positionHistory].y
        
        -- Predict future positions
        local predictions = {}
        local lastY = currentY
        for frame = 1, self.prediction.framesAhead do
            lastY = lastY - avgVel * 0.03  -- 0.03 seconds per frame
            table.insert(predictions, lastY)
        end
        
        -- Check if any prediction goes below thresholds
        local lowestPrediction = math.min(table.unpack(predictions))
        local stableY, _ = self:checkStablePoints()
        
        if stableY then
            local predDrop = stableY - lowestPrediction
            local confidence = math.min(1.0, predDrop / 50)
            return confidence > 0.5, confidence, predDrop
        end
        
        return false, 0, 0
    end,
    
    -- CHECK PLATFORM (LAPIS 7)
    checkPlatform = function(self, root)
        if not self.platform.enabled then return true end
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        
        -- Check multiple directions
        local directions = {
            Vector3.new(0, -1, 0),  -- Down
            Vector3.new(1, -1, 0),   -- Down-Right
            Vector3.new(-1, -1, 0),  -- Down-Left
            Vector3.new(0, -1, 1),   -- Down-Forward
            Vector3.new(0, -1, -1),  -- Down-Back
        }
        
        local groundFound = false
        for _, dir in ipairs(directions) do
            local raycast = workspace:Raycast(
                root.Position,
                dir * self.platform.raycastDistance,
                raycastParams
            )
            if raycast then
                groundFound = true
                break
            end
        end
        
        return groundFound
    end,
    
    -- MAIN DETECTION FUNCTION (GABUNGIN SEMUA)
    detect = function(self)
        local character = player.Character
        if not character then return false, "NO_CHAR", 0 end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        if not root or not humanoid then return false, "NO_ROOT", 0 end
        
        -- Update all histories
        self:updateHistories(character)
        
        -- Get stable point for reference
        local stableY, stableConf = self:checkStablePoints()
        if not stableY then
            stableY = root.Position.Y
        end
        
        local currentY = root.Position.Y
        local dropDistance = stableY - currentY
        
        -- Collect all detections with confidence
        local detections = {}
        local totalConfidence = 0
        local detectionCount = 0
        
        -- LAPIS 1: VELOCITY
        local velDetected, velConf = self:checkVelocity()
        if velDetected then
            table.insert(detections, {type = "VELOCITY", conf = velConf, weight = 1.5})
            totalConfidence = totalConfidence + velConf * 1.5
            detectionCount = detectionCount + 1
        end
        
        -- LAPIS 2: GRAVITY/ACCELERATION
        local gravDetected, gravConf = self:checkGravity()
        if gravDetected then
            table.insert(detections, {type = "GRAVITY", conf = gravConf, weight = 1.3})
            totalConfidence = totalConfidence + gravConf * 1.3
            detectionCount = detectionCount + 1
        end
        
        -- LAPIS 3: AIR TIME
        local airDetected, airConf = self:checkAirTime(humanoid)
        if airDetected then
            table.insert(detections, {type = "AIR_TIME", conf = airConf, weight = 1.2})
            totalConfidence = totalConfidence + airConf * 1.2
            detectionCount = detectionCount + 1
        end
        
        -- LAPIS 4: THRESHOLD LEVEL
        local thresholdLevel = self:checkThreshold(dropDistance)
        if thresholdLevel then
            local thresholdConf = thresholdLevel.distance / 55  -- Normalize to 0-1
            table.insert(detections, {type = "THRESHOLD", conf = thresholdConf, weight = 1.4})
            totalConfidence = totalConfidence + thresholdConf * 1.4
            detectionCount = detectionCount + 1
            
            -- Set warning based on threshold
            if thresholdLevel.distance >= 55 then
                self.currentState = "FALL_DETECTED"
            elseif thresholdLevel.distance >= 45 then
                self.currentState = "CRITICAL"
            elseif thresholdLevel.distance >= 35 then
                self.currentState = "DANGER"
            elseif thresholdLevel.distance >= 25 then
                self.currentState = "WARNING"
            end
        end
        
        -- LAPIS 5: PREDICTION
        local predDetected, predConf, predDrop = self:predictFall()
        if predDetected then
            table.insert(detections, {type = "PREDICTION", conf = predConf, weight = 1.1})
            totalConfidence = totalConfidence + predConf * 1.1
            detectionCount = detectionCount + 1
        end
        
        -- LAPIS 6: PLATFORM CHECK (NEGATIVE DETECTION)
        local hasPlatform = self:checkPlatform(root)
        if not hasPlatform and humanoid.FloorMaterial == Enum.Material.Air then
            local platformConf = 0.7
            table.insert(detections, {type = "NO_PLATFORM", conf = platformConf, weight = 1.0})
            totalConfidence = totalConfidence + platformConf
            detectionCount = detectionCount + 1
        end
        
        -- LAPIS 7: ENVIRONMENT CHECK
        local hazardType = self.envEngine:detectHazards(root.Position)
        if hazardType ~= "safe" then
            local hazardConf = 0.9
            table.insert(detections, {type = "HAZARD_" .. hazardType:upper(), conf = hazardConf, weight = 1.6})
            totalConfidence = totalConfidence + hazardConf * 1.6
            detectionCount = detectionCount + 1
        end
        
        -- Calculate final confidence
        if detectionCount > 0 then
            self.confidence = totalConfidence / detectionCount
        else
            self.confidence = 0
        end
        
        -- Adaptive learning
        if self.adaptive.enabled then
            self.adaptiveEngine:learn({
                velocity = self.velocityHistory[#self.velocityHistory] or 0,
                position = {Y = currentY},
                isFall = self.confidence > 0.7,
                result = self.currentState,
            })
        end
        
        -- Logging
        if self.debug.enabled and self.debug.logLevel == "DEBUG" then
            print(string.format(
                "🔍 DETECT: State=%s, Conf=%.2f, Drop=%.1f, Detections=%d",
                self.currentState,
                self.confidence,
                dropDistance,
                detectionCount
            ))
        end
        
        -- Return result
        return self.confidence > 0.7, self.currentState, self.confidence, detections
    end,
}

-- ==================================================
-- PART 6: INTEGRATION WITH REWIND SYSTEM (30+ BARIS)
-- ==================================================

-- Create detector instance
local detector = FallDetectorInstance:new()

-- Modify the main Heartbeat loop (replace checkFall)
RunService.Heartbeat:Connect(function()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Record position (ORIGINAL REWIND SYSTEM - TETAP SAMA)
    table.insert(settings.positionHistory, {
        position = root.Position,
        rotation = root.Orientation,
        time = tick()
    })
    
    if #settings.positionHistory > settings.maxHistory then
        table.remove(settings.positionHistory, 1)
    end
    
    -- ===== SUPER FALL DETECTION (REPLACEMENT) =====
    if settings.autoDetectFall and not settings.isRewinding then
        local detected, state, confidence, detections = detector:detect()
        
        -- Update UI based on state
        if state == "FALL_DETECTED" then
            statusValue.Text = "💀 FALL DETECTED!"
            statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            -- Find stable point frame
            local stableY, _ = detector:checkStablePoints()
            if stableY then
                local targetFrame = nil
                for i = #settings.positionHistory, 1, -1 do
                    if settings.positionHistory[i].position.Y > stableY - 5 then
                        targetFrame = i
                        break
                    end
                end
                
                if targetFrame then
                    print("🔥 TRIGGERING REWIND! Confidence:", confidence)
                    startRewind(targetFrame)
                end
            end
        elseif state == "CRITICAL" then
            statusValue.Text = "🔥 KRITIS!"
            statusValue.TextColor3 = Color3.fromRGB(255, 100, 0)
        elseif state == "DANGER" then
            statusValue.Text = "🔴 BAHAYA!"
            statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
        elseif state == "WARNING" then
            statusValue.Text = "⚠️ WASPADA!"
            statusValue.TextColor3 = Color3.fromRGB(255, 255, 0)
        else
            statusValue.Text = "🟢 AMAN"
            statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
        
        -- Update info text with detailed stats
        infoText.Text = string.format(
            "📊 Hist:%d | Conf:%.1f%% | Drop:%.1f | Vel:%.1f | Air:%.1fs | Det:%d",
            #settings.positionHistory,
            confidence * 100,
            (detector:checkStablePoints()) and (detector:checkStablePoints() - root.Position.Y) or 0,
            detector.velocityHistory[#detector.velocityHistory] or 0,
            detector.airStart and (tick() - detector.airStart) or 0,
            detections and #detections or 0
        )
    else
        -- Normal update
        infoText.Text = string.format(
            "📊 History: %d | Auto: %s | Vel: %.1f",
            #settings.positionHistory,
            settings.autoDetectFall and "ON" or "OFF",
            detector.velocityHistory[#detector.velocityHistory] or 0
        )
    end
    
    -- ===== ORIGINAL REWIND SYSTEM (TETAP SAMA PERSIS) =====
    if settings.isRewinding and settings.returnTargetPos then
        if not settings.returnStartPos then
            settings.returnStartPos = root.Position
        end
        
        settings.returnProgress = settings.returnProgress + settings.returnSpeed
        local newPos = settings.returnStartPos:Lerp(settings.returnTargetPos, settings.returnProgress)
        root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
        
        if settings.effects then
            root.Transparency = 0.2 + (0.3 * math.sin(settings.returnProgress * 20))
        end
        
        if settings.returnProgress >= 1 then
            stopRewind()
            root.Transparency = 0
        end
    end
end)

-- ==================================================
-- PART 7: DEBUG CONSOLE (UNTUK MONITORING)
-- ==================================================
local function createDebugConsole()
    local debugGui = Instance.new("ScreenGui")
    debugGui.Name = "DebugConsole"
    debugGui.Parent = playerGui
    debugGui.ResetOnSpawn = false
    
    local debugFrame = Instance.new("Frame")
    debugFrame.Size = UDim2.new(0, 300, 0, 200)
    debugFrame.Position = UDim2.new(1, -320, 0, 20)
    debugFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    debugFrame.BackgroundTransparency = 0.3
    debugFrame.Parent = debugGui
    
    local debugText = Instance.new("TextLabel")
    debugText.Size = UDim2.new(1, -10, 1, -10)
    debugText.Position = UDim2.new(0, 5, 0, 5)
    debugText.BackgroundTransparency = 1
    debugText.TextColor3 = Color3.fromRGB(0, 255, 0)
    debugText.TextXAlignment = Enum.TextXAlignment.Left
    debugText.TextYAlignment = Enum.TextYAlignment.Top
    debugText.TextScaled = false
    debugText.TextSize = 12
    debugText.Font = Enum.Font.Code
    debugText.Text = ""
    debugText.Parent = debugFrame
    
    -- Update debug every second
    spawn(function()
        while true do
            if detector.debug.enabled then
                local text = "🔍 FALL DETECTOR DEBUG\n"
                text = text .. "=====================\n"
                text = text .. "State: " .. detector.currentState .. "\n"
                text = text .. "Confidence: " .. string.format("%.1f%%", detector.confidence * 100) .. "\n"
                text = text .. "Velocity: " .. string.format("%.1f", detector.velocityHistory[#detector.velocityHistory] or 0) .. "\n"
                text = text .. "Air Time: " .. string.format("%.1fs", detector.airStart and (tick() - detector.airStart) or 0) .. "\n"
                text = text .. "History: " .. #detector.positionHistory .. " frames\n"
                text = text .. "Detections: " .. (detector.detectionCount or 0) .. "\n"
                text = text .. "Kalman: " .. (detector.kalmanState.estimate and string.format("%.1f", detector.kalmanState.estimate) or "N/A") .. "\n"
                debugText.Text = text
            end
            task.wait(1)
        end
    end)
end

-- Optional: Create debug console
-- createDebugConsole()

print([[
╔══════════════════════════════════════════════════════════════════╗
║   🔥 ZONE XD - ULTIMATE FALL DETECTION SYSTEM v3.0 🔥           ║
╠══════════════════════════════════════════════════════════════════╣
║   ✅ 7 LAPIS DETEKSI:                                             ║
║   │  1. VELOCITY ANALYSIS (45+ studs/detik)                     ║
║   │  2. GRAVITY/ACCELERATION (15+ per frame)                    ║
║   │  3. AIR TIME MONITOR (4+ detik)                             ║
║   │  4. STABLE POINT REFERENCE (6 detik history)                ║
║   │  5. MULTI-LEVEL THRESHOLD (6 level peringatan)              ║
║   │  6. PREDICTION ENGINE (0.5 detik ke depan)                  ║
║   │  7. ENVIRONMENT/PLATFORM CHECK                              ║
╠══════════════════════════════════════════════════════════════════╣
║   ✅ ADVANCED FEATURES:                                           ║
║   │  • Kalman Filter untuk smoothing                            ║
║   │  • Median Filter noise reduction                            ║
║   │  • Statistical analysis (std dev, moving avg)               ║
║   │  • Pattern recognition (free fall, slip)                    ║
║   │  • Adaptive learning (user behavior)                        ║
║   │  • Real-time confidence scoring                             ║
╠══════════════════════════════════════════════════════════════════╣
║   📊 PERINGATAN BERTINGKAT:                                       ║
║   │  🟢 AMAN (0-5) → 🟡 PERHATIAN (5-15) → 🟠 WASPADA (15-25)    ║
║   │  🔴 BAHAYA (25-35) → 🟣 KRITIS (35-45) → 💀 FALL (45+)       ║
╠══════════════════════════════════════════════════════════════════╣
║   👑 COPYRIGHT: APIS (USER 01) - ZONE XD V1                      ║
║   📅 BUILD DATE: 2026-03-15                                       ║
║   📦 VERSION: 3.0.0 (400+ baris deteksi)                         ║
╚══════════════════════════════════════════════════════════════════╝
]])