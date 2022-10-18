HC_trash_command:
    type: command
    usage: /trash
    name: trash
    permission: hc.user
    description: "trash"
    script:
        - inventory open d:generic[size=27;title=<dark_gray>Trash]

HC_give_customblock_command:
    type: command
    debug: false
    usage: /getblock
    name: getblock
    permission: builder
    description: Grabs a custom block
    tab complete:
        - foreach <util.scripts>:
            - if <[value].contains_text[HC_customblock]> and !<[value].contains_text[_script]>:
                - define item <[value].name.replace_text[HC_customblock_]>
                - define list:->:<[item]>
        - determine <[list]>
    script:
        - if <player.gamemode> == creative:
            - define arg1 HC_customblock_<context.args.get[1]>
            - define arg2 <context.args.get[2]>
            - if <script[<[arg1]>].exists>:
                - give <[arg1]> quantity:<[arg2]>
            - else:
                - narrate "<red>That is not a valid custom item"

        - else:
            - narrate "<red>This command only works in creative mode"


HC_give_customenchantedbook_command:
    type: command
    debug: false
    usage: /getbook
    name: getbook
    permission: builder
    description: Grabs a custom enchanted book
    tab complete:
        - foreach <util.scripts>:
            - if <[value].contains_text[HC_enchantment_]> and !<[value].contains_text[_script]>:
                - define item <[value].name.replace_text[HC_enchantment_]>
                - define list:->:<[item]>
        - determine <[list]>
    script:
        - if <player.gamemode> == creative:
            - define arg1 <context.args.get[1].replace_text[HC_enchantment_]>
            - define arg2 <context.args.get[2]>
            - give enchanted_book[enchantments=<[arg1]>,1;lore=<reset><gray><[arg1]>] quantity:<[arg2].if_null[1]>
        - else:
            - narrate "<red>This command only works in creative mode"

HC_give_customitem_command:
    type: command
    debug: false
    usage: /getitem
    name: getitem
    permission: builder
    description: Grabs a custom item
    tab complete:
        - foreach <util.scripts>:
            - if <script[<[value]>].data_key[type]> == item:
                - define item <[value].name>
                - define list:->:<[item]>
        - determine <[list]>
    script:
        - define item <context.args.get[1]>
        - if <script[<[item]>].exists>:
            - give <[item]> quantity:<context.args.get[2].if_null[1]>

HC_list_custommodeldata_command:
    type: command
    debug: false
    usage: /lcmd
    name: lcmd
    permission: builder
    description: Shows all items with custom model data
    tab complete:
        - foreach <server.material_types.parse[item]>:
            - define item <[value].as[item].material.name>
            - define list:->:<[item]>
        - determine <[list]>
    script:
    - define arg1 <context.args.get[1]>
    - if <server.material_types.parse[item].contains_text[<[arg1]>]>:
        - flag <player> HC_list_custommodeldata_menu_data:<[arg1]>
        - inventory open d:HC_list_custommodeldata_menu

HC_list_custommodeldata_menu:
    debug: false
    type: inventory
    inventory: chest
    title: <reset><bold><green>Custom Model Data
    procedural items:
    - define item <player.flag[HC_list_custommodeldata_menu_data].as[item]>
    - repeat 54:
        - define item2 "<[item].material.name>[custom_model_data=<[value]>;display=<reset><[item].material.name.replace_text[_].with[ ]> <green><[value]>]"
        - define list:->:<[item2]>
    - determine passively <[list]>
    gui: true
    slots:
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []



HC_check_skills:
    type: command
    debug: false
    usage: /skills
    name: skills
    description: Shows all Skills of the chosen user
    tab complete:
        - if <player.is_op>:
            - define list Set|Show
            - if <context.args.get[1].if_null[]> == show:
                - define list:!
                - foreach <server.players>:
                    - define item <[value].name>
                    - define list:->:<[item]>
            - define player <server.match_player[<context.args.get[1].if_null[]>].if_null[<player>]>
            - if <context.args.get[1].if_null[]> == set:
                - define list:!
                - foreach <[player].flag[skills]>:
                    - define list:->:<[key]>
        - determine <[list].if_null[]>
    script:
        - if <context.args.get[1].if_null[show]> == show:
            - define player <server.match_player[<context.args.get[2].if_null[]>].if_null[<player>].if_null[<player>]>
            - if !<player.is_op>:
                - define player <player>
            - narrate "                              "
            - narrate "<green><[player].name>'s <reset>Skills:"
            - narrate ============================
            - foreach <[player].flag[skills].if_null[]>:
                - narrate "     <green><[key]><reset>: <[value].get[lvl].if_null[0]>"
                - narrate "          <green>XP<reset>: <[value].get[xp].if_null[0]>"
                - narrate "                              "
        - if <context.args.get[1].if_null[show]> == set and <player.is_op> and <context.args.get[2].if_null[null]> != null:
            - flag <player> Skills.<context.args.get[2]>.lvl:<context.args.get[3].if_null[1]>