
local mobs = require('defs/mobs.lua')

local Mob = {}
Mob.__index = Mob

Mob.States = {
    FLY = 0,
    DIE = 1
}

function Mob.create(defstr ,x, y, dy)
    local self = {}
    setmetatable(self,Mob)

    self.def = mobs[defstr]

    self.health = self.def.health

    self.ship = Ship.create(self.def.graphics, owner.enemy)
    
    self.ship.x = x
    self.ship.y = y
    
    self.ship.dx = 0
    self.ship.dy = dy
    
    self.ship.speed = self.def.speed
    
    --print("a",self.def.tint)

    for pos,weapon in pairs(self.def.weapons) do
        self.ship:mountWeapon( pos, weapon )
    end

    self.state = Mob.States.FLY
    
    return self
end

function Mob:morph(defstr)
    local oldx,oldy,olddy = self.ship.x, self.ship.y, self.ship.dy
    
    self.def = mobs[defstr]

    self.health = self.def.health

    self.ship = Ship.create(self.def.graphics, owner.enemy)
    
    self.ship.x = oldx
    self.ship.y = oldy
    
    self.ship.dx = 0
    self.ship.dy = olddy
    
    self.ship.speed = self.def.speed
    
    for pos,weapon in pairs(self.def.weapons) do
        self.ship:mountWeapon( pos, weapon )
    end

    self.state = Mob.States.FLY
end

function Mob:update(dt)
    self.ship:update(dt,self.def.flyfn)
    --self.x, self.y = self.flyfn( dt, self.x, self.y, self.dx, self.dy, self.def.speed )

    if self.ship.y > 600 then
        self.state = Mob.States.DIE
    end
end

function Mob:draw()
    self.ship:draw()
    
    if self.def.onAfterDraw then 
        self.def.onAfterDraw(self)
    end
    
end

function Mob:damage(dmg)
    self.health = self.health - dmg
    if self.health <= 0 then
        player.score = player.score + self.def.score

        if self.def.morphTo then
            self:morph(self.def.morphTo)
        else
            self.state = Mob.States.DIE
        end
    end
end

return Mob

