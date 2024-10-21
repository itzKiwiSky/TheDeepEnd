local image = love.graphics.newImage("assets/images/effects/circle.png")

local ps = love.graphics.newParticleSystem(image, 24)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(4.0972962379456)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(-0.051036551594734, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(50, 50)
ps:setParticleLifetime(2.159866809845, 3.3396687507629)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(-1.9513026475906, -0.93247652053833)
ps:setSizes(0.046992380172014, 0.24551121890545, 0.49272736907005, 0.73408281803131)
ps:setSizeVariation(1)
ps:setSpeed(14.882258415222, 161.70420837402)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0.74799823760986)
ps:setTangentialAcceleration(0, 0)

return ps

-- At start time:
-- ps:start()
-- ps:emit(9)
-- At draw time:
-- love.graphics.setBlendMode("add")
-- love.graphics.draw(ps, 0+0, 0+0)
