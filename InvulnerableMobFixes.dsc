InvulnerableFix:
    type: world
    debug: false
    events:
        on player right clicks entity type:horse|pig|strider:
            - if <player.world.name> == creative and <context.entity.invulnerable> and <player.gamemode> == survival or <player.gamemode> == adventure:
                - determine passively cancelled