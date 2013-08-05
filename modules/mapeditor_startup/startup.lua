-- Modify this to your liking.
-- Note: The mapeditor modules do NOT include those files by default
--  Therefore you'll need to download them as a "third-party" from
--  various ditros and Tibia versions.


OTB_FILE   = "/data/materials/items.otb"
XML_FILE   = "/data/materials/items.xml"
MON_FILE   = "/data/materials/monster/monsters.xml"
NPC_FOLDER = "/data/materials/npc"
OTBM_FILE  = "/data/materials/map.otbm"
DAT_FILE   = "/data/materials/Tibia.dat"
SPR_FILE   = "/data/materials/Tibia.spr"
VERSION    = 870  -- Most important for loading Tibia files correctly.

-- Nothing beyond here is useful to people who can't code
function startup()
  print("Starting up...")
  -- All of the functions below throw exceptions on failure
  -- not in terms of terminaing the applications, though.
  g_game.setClientVersion(VERSION)
  g_game.setProtocolVersion(VERSION)
  -- Load up dat.
  g_things.loadDat(DAT_FILE)
  -- Load up SPR.
  g_sprites.loadSpr(SPR_FILE)
  -- Load up OTB
  g_things.loadOtb(OTB_FILE)
  -- Load up XML
  g_things.loadXml(XML_FILE)
  -- load up monsters
  --g_creatures.loadMonsters(MON_FILE)
  -- load up npcs (uncomment this if you wanna load NPCs)
 -- g_creatures.loadNpcs(NPC_FOLDER)
  -- load up otbm
  -- g_map.loadOtbm(OTBM_FILE)
end

function shutdown()
  print("Starting down...")
end

