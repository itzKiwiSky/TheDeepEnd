# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

# [0.0.2] - 2024-10-10

### Added
- Added in-game achievements
- Added GamejoltAPI integration, now you can sync your achievements with the gamejolt trophies
- Added discordRPC integration, now the it will be displayed on your discord profile
- Added options menu
- Added shop that open every time you beat a level
- Added the utility for pearls across the map. Catch the pearls and use them to buy items on the shop.
- Added Simple transition from menu

### Changed
- Level progression, now you select missions that is level packs
- Items are persisted when change a level
- Pearls are globally persisted

### Fixed
- Fixed DiscordRPC library bug that Linux and Mac users can't run the game.
- (Internal) Save is migrated to a new library with a more robust save system. Your save still be compatible with the old version, when the fisrt save happen all data will be automaticly migrated

---

# [0.0.1] - 2024-10-10
Initial game release