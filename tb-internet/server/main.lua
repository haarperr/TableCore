TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

-- Server event met item & price data. Price = geld wat van user af moet, item = item die bij user toegevoegd moet worden. Eerst checken of user genoeg geld bij zich heeft. Amount = hoeveelheid items.


-- Server event die item & price data gebruikt. Price gaat van user bank balance af & item wordt meegestuurd in een triggerevent naar tb-orders. Postkantoor/huis. Amount = hoeveelheid items.