local objects = require "scripts/objects"
function player_ball(player, mtv)
    player:move(mtv)
end
function ball_player(ball, mtv)
    ball:setVelocity(mtv * -objects.repulsion_rate)
end