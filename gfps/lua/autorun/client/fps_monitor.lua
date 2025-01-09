-- Code Created By Sean https://steamcommunity.com/id/Seen12/
-- Version : v1.0.1
local historySeconds = 1

local frames = { }
local function onFrame()
  local t = SysTime()
  while frames[1] and frames[1] < t - historySeconds do
    table.remove(frames, 1)
  end

  table.insert(frames, t)
end

local fpsSum = 0
local fpsCount = 0
local minFPS = math.huge
local maxFPS = -math.huge

local function drawFPSCounter()
    local screenWidth, screenHeight = ScrW(), ScrH()
    local boxWidth, boxHeight = 200, 160
    local boxX, boxY = 10, 10
    local smallFontSize = "DermaDefault"
    local fontSize = "DermaLarge"
    local graphHeight = 50
    local graphFontSize = "DermaDefault"

    if screenHeight >= 2160 then -- 4K
        boxWidth, boxHeight = 800, 650
        fontSize = "Trebuchet24"
        smallFontSize = "Trebuchet18"
        graphHeight = 300
        graphFontSize = "Trebuchet18"
    elseif screenHeight >= 1440 then -- 1440p
        boxWidth, boxHeight = 600, 800
        fontSize = "Trebuchet24"
        smallFontSize = "Trebuchet18"
        graphHeight = 200
        graphFontSize = "Trebuchet18"
    elseif screenHeight >= 1080 then -- 1080p
        boxWidth, boxHeight = 400, 600
        fontSize = "Trebuchet24"
        smallFontSize = "Trebuchet18"
        graphHeight = 150
        graphFontSize = "Trebuchet12"
    elseif screenHeight >= 720 then -- 720p
        boxWidth, boxHeight = 300, 700
        smallFontSize = "Trebuchet18"
        fontSize = "Trebuchet24"
        graphHeight = 100
        graphFontSize = "Trebuchet12"
    end

    local graphWidth = boxWidth - 20
    local graphX = boxX + 10
    local graphY = boxY + boxHeight - graphHeight - 30
    draw.RoundedBox(10, boxX, boxY, boxWidth, boxHeight, Color(30,30,30,200))

    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawOutlinedRect(graphX, graphY, graphWidth, graphHeight)
    draw.SimpleText("FPS", "DermaDefault", graphX + graphWidth / 2, graphY - 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    local numberOfLines = 5
    local lineSpacing = graphHeight / numberOfLines
    for i = 0, numberOfLines do
        local y = graphY + i * lineSpacing
        draw.RoundedBox(0, graphX, y, graphWidth, 1, Color(255, 255, 255, 255))
        draw.SimpleText(tostring((numberOfLines - i) * 60), "Default", graphX + graphWidth + 10, y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local fpsHistory = {}
    local frametimes = {}
    for i = 2, #frames do
        local frametime = frames[i] - frames[i - 1]
        local fps = 1 / frametime
        table.insert(fpsHistory, fps)
        table.insert(frametimes, frametime)
        fpsSum = fpsSum + fps
        fpsCount = fpsCount + 1
        minFPS = math.min(minFPS, fps)
        maxFPS = math.max(maxFPS, fps)
    end

    if #fpsHistory > 1 then
        for i = 1, #fpsHistory - 1 do
            local x1 = graphX + (i - 1) * (graphWidth / #fpsHistory)
            local y1 = graphY + graphHeight - (fpsHistory[i] / 300 * graphHeight)
            local x2 = graphX + i * (graphWidth / #fpsHistory)
            local y2 = graphY + graphHeight - (fpsHistory[i + 1] / 300 * graphHeight)

            surface.SetDrawColor(0, 255, 0, 255)
            surface.DrawLine(x1, y1, x2, y2)
        end
    end

    local avgFPS = fpsCount > 0 and (fpsSum / fpsCount) or 0
    local currentFPS = #frames > 1 and (1 / (frames[#frames] - frames[#frames -1])) or 0
    local currentFrametime = #frames > 1 and (frames[#frames] - frames[#frames -1]) or 0
    table.sort(fpsHistory)
    local onePercentLow = fpsHistory[math.ceil(#fpsHistory * 0.01)] or 0
    local fivePercentLow = fpsHistory[math.ceil(#fpsHistory * 0.05)] or 0

    draw.SimpleText("FPS: ", fontSize, boxX + 10, boxY + 10, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(string.format("%.2f", currentFPS), smallFontSize, boxX + 70, boxY + 10, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(" FPS", smallFontSize, boxX + 110, boxY + 10, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("Min FPS: ", fontSize, boxX + 10, boxY + 50, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(string.format("%.2f", minFPS), smallFontSize, boxX + 150, boxY + 50, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(" FPS", smallFontSize, boxX + 190, boxY + 50, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("Max FPS: ", fontSize, boxX + 10, boxY + 90, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(string.format("%.2f", maxFPS), smallFontSize, boxX + 150, boxY + 90, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(" FPS", smallFontSize, boxX + 190, boxY + 90, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("Avg FPS: ", fontSize, boxX + 10, boxY + 130, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(string.format("%.2f", avgFPS), smallFontSize, boxX + 150, boxY + 130, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(" FPS", smallFontSize, boxX + 190, boxY + 130, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("1% Low: ", fontSize, boxX + 10, boxY + 170, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(string.format("%.2f", onePercentLow), smallFontSize, boxX + 150, boxY + 170, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(" FPS", smallFontSize, boxX + 190, boxY + 170, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("5% Low: ", fontSize, boxX + 10, boxY + 210, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(string.format("%.2f", fivePercentLow), smallFontSize, boxX + 150, boxY + 210, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(" FPS", smallFontSize, boxX + 190, boxY + 210, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText("Frametime: ", fontSize, boxX + 10, boxY + 250, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(string.format("%.2f ms", currentFrametime * 1000), smallFontSize, boxX + 150, boxY + 250, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

hook.Add("HUDPaint", "DetailedFPSCounter", drawFPSCounter)
hook.Add("Think", "TrackFrameTime", onFrame)