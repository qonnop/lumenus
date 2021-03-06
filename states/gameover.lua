-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local GameOver = {}
GameOver.__index = GameOver

function GameOver.load()
    
    GameOver.normalFont = love.graphics.newFont(12)
    GameOver.font = love.graphics.newFont(48)
    
end

function GameOver.onActivation()
    pcall(function()
        GameOver.musicChannel = TEsound.playLooping("media/music/_GameOver.ogg","gomusic")
    end)
	
end

function GameOver.onDeactivation()
    TEsound.stop("gomusic")
end

function GameOver.draw()

    --gamestate:foreignCall("InGame","draw")

    love.graphics.setColor(255,255,255,255)

    love.graphics.setFont(GameOver.normalFont)
    
    love.graphics.print( "Score: " .. tostring(player.score), 100, 100)
    
    love.graphics.setFont(GameOver.font)
    
    local x = (love.graphics:getWidth()/2) - GameOver.font:getWidth("GAME OVER!")
    
    love.graphics.print( "GAME OVER!", x, love.graphics.getHeight()/2 )
    
    love.graphics.setFont(GameOver.normalFont)
    
    x = (love.graphics:getWidth()/2) - love.graphics:getFont():getWidth("Press Enter to Restart, Press ESC to Quit.")
    
    love.graphics.print( "Press Enter to Restart, Press ESC to Quit.", x, love.graphics:getHeight()/2 + GameOver.font:getHeight() )

end

function GameOver.update(dt)
    --gamestate:foreignCall("InGame","update",dt)
end

function GameOver.keypressed(key)
    if key == "return" then
        gamestate:change("InGame")
    elseif key == "escape" then
        gamestate:change("MainMenu")
        return
    end
end



return GameOver