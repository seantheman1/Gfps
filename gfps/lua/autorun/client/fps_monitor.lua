-- Code Created By Sean https://steamcommunity.com/id/Seen12/
if CLIENT then
    local fpsHistory = {}
    local fpsSum = 0
    local fpsCount = 0
    local minFPS = math.huge
    local maxFPS = -math.huge
    local lastUpdateTime = 0
    local updateInterval = 10 -- Update every 1 second

    local function updateFPS()
        local currentTime = os.clock()
        if currentTime - lastUpdateTime < updateInterval then
            return
        end
        lastUpdateTime = currentTime
    
        local fps = 1 / FrameTime()
        if fps == math.huge or fps ~= fps then
            return
        end
    
        table.insert(fpsHistory, fps)
        fpsSum = fpsSum + fps
        fpsCount = fpsCount + 1
    
        if fps < minFPS then
            minFPS = fps
        end
    
        if fps > maxFPS then
            maxFPS = fps
        end
    
        if #fpsHistory > 100 then
            fpsSum = fpsSum - table.remove(fpsHistory, 1)
            fpsCount = fpsCount - 1
        end
    end

    local function drawFPSCounter()
        updateFPS()

        local avgFPS = fpsCount > 0 and (fpsSum / fpsCount) or 0
        local currentFPS = fpsHistory[#fpsHistory] or 0

        local screenWidth, screenHeight = ScrW(), ScrH()
        local boxWidth, boxHeight = 300, 200
        local boxX, boxY = 10, 10
        local fontSize = "DermaLarge"

        if screenHeight >= 2160 then -- 4K
            boxWidth, boxHeight = 600, 400
            fontSize = "Trebuchet24"
        elseif screenHeight >= 1440 then -- 1440p
            boxWidth, boxHeight = 450, 300
            fontSize = "Trebuchet24"
        elseif screenHeight >= 1080 then -- 1080p
            boxWidth, boxHeight = 300, 200
            fontSize = "Trebuchet18"
        elseif screenHeight >= 720 then -- 720p
            boxWidth, boxHeight = 200, 150
            fontSize = "Trebuchet18"
        end

        draw.RoundedBox(10, boxX, boxY, boxWidth, boxHeight, Color(0, 0, 0, 150))

        draw.SimpleText("FPS: " .. math.Round(currentFPS), fontSize, boxX + 10, boxY + 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Avg FPS: " .. math.Round(avgFPS), fontSize, boxX + 10, boxY + 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Min FPS: " .. math.Round(minFPS), fontSize, boxX + 10, boxY + 70, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Max FPS: " .. math.Round(maxFPS), fontSize, boxX + 10, boxY + 100, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        local graphWidth = boxWidth - 20
        local graphHeight = 50
        local graphX = boxX + 10
        local graphY = boxY + boxHeight - graphHeight - 20

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
    end

    hook.Add("HUDPaint", "DetailedFPSCounter", drawFPSCounter)
end