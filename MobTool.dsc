HC_MobTool_script:
  type: world
  debug: false
  events:
    on player right clicks entity with:HC_MobTool:
      - if <player.is_op>:
        - inventory flag slot:hand entity:<player.entity>
        - inventory open d:HC_MobTool_menu

HC_MobTool_menu:
    type: inventory
    inventory: chest
    title: <red><bold>Mob Menu
    procedural items:
    - define list <list>
    - foreach <server.entity_types>:
        - define item "sheep_spawn_egg[display=<[value].replace_text[_].with[ ].is_lowercase>]"
        - define list:->:<[item]>
    - determine <[list]>
    gui: true
    slots:
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []

HC_MobTool:
  type: item
  debug: false
  material: stick
  data:
    discover: false
  flags:
    uuid: <util.random_uuid>
  display name: <reset><blue>MobTool
  lore:
    - <reset><gray>Right click a Mob to adjust its properties
  mechanisms:
    hides:
      - ENCHANTS
  enchantments:
    - luck: 4

HC_MobTool_command:
    type: command
    usage: /mobtool
    name: Mobtool
    permission: builder
    description: Spawns mobs with adjusted properties
    tab completions:
      1: <server.entity_types>
      2: AI
      3: Collidable
      4: Gravity
    script:
      - spawn <context.args.get[1]>[has_ai=<context.args.get[2].if_null[true]>;collidable=<context.args.get[3].if_null[false]>;gravity=<context.args.get[4].if_null[true]>;invulnerable=<context.args.get[5].if_null[true]>;speed=0] <player.location> persistent