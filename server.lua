RegisterServerEvent("QS_hooker:sendLogToDiscord", function(playerName, animLabel, price, screenshotUrl)
    local logConfig = Config.Logs.Hooker
    local embed = {
        {
            title = logConfig.title,
            description = ("**Player:** %s\n**Service:** %s\n**Paid:** $%s"):format(playerName, animLabel, price),
            color = logConfig.color,
            footer = { text = logConfig.footer },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    if screenshotUrl then
        embed[1].image = { url = screenshotUrl }
    end

    PerformHttpRequest(logConfig.webhook, function(err, text, headers) end, "POST", json.encode({
        username = logConfig.username,
        embeds = embed,
        avatar_url = logConfig.avatar
    }), { ["Content-Type"] = "application/json" })
end)
