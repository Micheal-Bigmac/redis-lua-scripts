local leftSetId = KEYS[1]
local rightSetId = KEYS[2]
local destSetId = KEYS[3]

local data = redis.call('zrange', leftSetId, 0, -1, 'WITHSCORES')
for k, v in pairs(data) do 
    -- values and scores are returned as alternating items in data
    -- where values are at odd indexes and scores are at even indexes
    if k % 2 == 1 then 
        local val  = v
        local leftScore = tonumber(data[k + 1])
        local rightScore = tonumber(redis.call('zscore', denSetId, val))

        if rightScore then
            redis.call('zadd', destSetId, leftScore * rightScore, val)
        end
    end
end
return 'ok'
